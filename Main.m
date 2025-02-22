clear all; close all; clc
addpath(genpath('functions'));
addpath(genpath('G:\My Drive\VinhShared\Library_vinhtn'))
%% Read NWM output (discharge) and USGS data from GAGES-II
% https://waterdata.usgs.gov
% https://www.usgs.gov/data/national-water-model-v21-retrospective-selected-nwis-gage-locations-1979-2020
load('D:\Model\CONUS\Data\R1_SelectedGage_2.mat')% Reag GAGE-II dataset
load Data\TZ.mat
StartDate = '1979-02-01';
Endate = '2024-12-31';

for i=1:size(Watershed0,1)
    i
    % Download USGS data
    data = usgsdownload_Hourly(Watershed0(i).GAGE_ID,StartDate,Endate,TimeZone);
    if isempty(data)
        CheckGage(i)=0;
    else
        CheckGage(i)=1;
        % pause
        save(['Data/usgs2/',num2str(i),'.mat'],'data');
    end
end
save("results\R1_ID.mat","CheckGage")

%% Download NLDAS-2
clear all; clc

% base_url = 'https://hydro1.gesdisc.eosdis.nasa.gov/data/NLDAS/NLDAS_FORA0125_H.002/';
base_url = 'https://hydro1.gesdisc.eosdis.nasa.gov/data/NLDAS/NLDAS_FORA0125_H.2.0/';
username = '...';
password = '...';
start_date = datetime(1980, 1, 1);
end_date = datetime(2024, 12, 31);

current_date = start_date;
while current_date <= end_date
    year_value = year(current_date);
    month_value = month(current_date);
    day_value = day(current_date);
    day_of_year = day(current_date, 'dayofyear');

    for hour = 0:23 % Data is hourly

        file_name = sprintf('NLDAS_FORA0125_H.A%04d%02d%02d.%02d00.020.nc', ...
            year_value, month_value, day_value, hour);

        file_url = sprintf('%s%04d/%03d/%s', base_url, year_value, day_of_year, file_name);
        output_file = fullfile([pwd,'/Data/NLDAS2'], file_name);
        if ~exist(output_file)
            options = weboptions('Username', username, 'Password', password, 'Timeout', 60);
            try
                fprintf('Downloading: %s\n', file_url);
                websave(output_file, file_url, options);
            catch ME
                fprintf('Failed to download %s. Error: %s\n', file_url, ME.message);
            end
        end

    end
    current_date = current_date + days(1);
end
%% Extract forcing to Basin averaged data
clear all; clc;
load('D:\Model\CONUS\Data\R1_SelectedGage_2.mat')% Read GAGE-II dataset
Watershed0 = shaperead('Data/All_GAGES-II.shp');
% % Export data mark
% lat = ncread('D:\Model\CONUS\Data\NLDAS2\NLDAS_FORA0125_H.A19800101.0000.020.nc','lat');
% lon = ncread('D:\Model\CONUS\Data\NLDAS2\NLDAS_FORA0125_H.A19800101.0000.020.nc','lon');
% [LAT, LON] = meshgrid(lat, lon);
% lat_1D = reshape(LAT, [], 1);
% lon_1D = reshape(LON, [], 1);
%
% for i=1:size(Watershed0,1)
%     mask{i,1} = inpolygon(lon_1D,lat_1D, Watershed0(i).X(1:end-1), Watershed0(i).Y(1:end-1));
%     mask{i,1}=find(mask{i,1}==1);
%     if isempty(mask)
%         [mask{i,1}, ~] = findclosestpoint(lon_1D, lat_1D, Watershed0(i).X(1:end-1), Watershed0(i).Y(1:end-1));
%     end
% end
% save Data\ForcingMask.mat mask

start_date = datetime(1980, 1, 1);
end_date = datetime(2024, 12, 31);
load Data\ForcingMask.mat mask


current_date = start_date;
while current_date <= end_date
    current_date
    year_value = year(current_date);
    month_value = month(current_date);
    day_value = day(current_date);
    day_of_year = day(current_date, 'dayofyear');
    parfor hour = 0:23 % Data is hourly
        readNLDAS(Watershed0,mask,year_value, month_value, day_value, hour);
    end
    current_date = current_date + days(1);
    % save current_date.mat current_date
end


%% Final Data formation
clear; clc
load("results\R1_ID.mat","CheckGage")
load('D:\Model\CONUS\Data\R1_SelectedGage_2.mat')% Reag GAGE-II dataset
start_date = datetime(1980, 1, 1);
end_date = datetime(2024, 12, 31,23,0,0);
DT=[start_date:hours(1):end_date]';
BasinAtt = readtable('Data\GAGESII\All_Attribute.xlsx');
BasinAtt = table2array(BasinAtt);

for i=1:size(Watershed0,1)
    i
    extractFinal(i,DT,Watershed0(i).GAGE_ID);
end

%%
k=0;
load('D:\Model\CONUS\Data\forcing\1980010105.mat')

WGS84_shp = shaperead('Data/All_GAGES-II.shp');
for i=1:size(Watershed0,1)
    if ~isnan(Dat_sta(i,1))
        k=k+1
        basins_all(k,1)=WGS84_shp(i);
        idx = find(BasinAtt(:,1)==str2num(WGS84_shp(i).GAGE_ID));
        attributes(k,:)= BasinAtt(idx,:);
        if CheckGage(i) ==1
            DatasetMark(k) = 1;
        else
            DatasetMark(k) = 0;
        end
    end
end

BasinAtt = readtable('Data\GAGESII\All_Attribute.xlsx');
BasinAtt(1:height(BasinAtt), :) = [];
attributesTable = array2table(attributes, 'VariableNames', BasinAtt.Properties.VariableNames);
BasinAtt = [BasinAtt; attributesTable];
save('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
shapewrite(basins_all, 'Data/CAMELSH/shapefiles/CAMELSH_shapefile.shp');
%% Transform data to standard unit
clear all; close all; clc
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
for i=1:size(basins_all,1)
    i
    datatransform(basins_all(i).GAGE_ID);
end

%% Check dataaset
clear all; close all; clc
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")

for i=1:size(basins_all,1)
    i
    [datcheck(i,1), availableD(i,1),avai_year(:,i)] = checkdataset(basins_all(i).GAGE_ID);
    StaID(i,1) = string(basins_all(i).GAGE_ID);
end

output_table = table(StaID,availableD, ...
    'VariableNames', {'STAID','data_availability [hrs]'});
years = [1980:1:2024];
avai_year_table = array2table(avai_year');
avai_year_table.Properties.VariableNames = cellstr(string(years));
output_table = [output_table, avai_year_table];
writetable(output_table, 'Data/CAMELSH/info.csv');
save('results\R5.DataCheck.mat',"avai_year","StaID","datcheck","availableD")

%% Convert to netcdf file
clear all; clc
!ConvertCSVtoNC.py

%% Move file
clear all; close all; clc
load('results\R5.DataCheck.mat',"avai_year","StaID","datcheck","availableD")
for i=1:length(StaID)
    i
    if availableD(i)==0
        OutputFile = ['Data/CAMELSH/timeseries_nonobs/', StaID{i}, '.nc'];
        status = movefile(OutputFile, 'Data/CAMELSH/timeseries/');
    end
end
%% Export Attributes from GAGES-II
clear all; close all; clc
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
filename = 'Data/GAGESII/gagesII_sept30_2011_conterm.xlsx';
[~, sheets] = xlsfinfo(filename);
all_data = cell(1, numel(sheets));
for i = 1:numel(sheets)
    all_tables{i} = readtable(filename, 'Sheet', sheets{i});
    fprintf('Sheet %d: %s - %d rows, %d columns\n', ...
        i, sheets{i}, height(all_tables{i}), width(all_tables{i}));
end
for i = 1:numel(sheets)-1
    OGsheet = all_tables{i};
    clearvars STAID
    for j=1:size(OGsheet,1)
        STAID(j,1) = str2num(OGsheet.STAID{j});
    end
    [~, idx] = ismember(attributes(:,1),STAID);
    Data = OGsheet(idx,:);
    OutputFile = ['Data/Attributes-GAGESII/',sheets{i},'.csv'];
    writetable(Data, OutputFile);
end

%% Compute Climate Attributes
clear all; close all; clc
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")

for i=1:size(basins_all,1)
    i
    ClimAtributes(i,:) = computeClimate(basins_all(i).GAGE_ID);
    GageID(i,1) = string(basins_all(i).GAGE_ID);
end

output_table = table(GageID,ClimAtributes(:,1), ClimAtributes(:,2), ClimAtributes(:,3), ...
    ClimAtributes(:,4), ClimAtributes(:,5), ...
    ClimAtributes(:,6), ClimAtributes(:,7),ClimAtributes(:,8),ClimAtributes(:,9), ...
    'VariableNames', {'STAID','p_mean', 'pet_mean', 'aridity_index','p_seasonality', 'frac_snow', ...
    'high_prec_freq', 'high_prec_dur', ...
    'low_prec_freq', 'low_prec_dur'});
writetable(output_table, 'Data/Attributes-Climate/attribute_climate.csv');
%% Attribute export from HydroAtlas
clear all; clc
load('results\R2_Basin_info.mat',"DatasetMark","attributes");
shapena = shaperead('E:\PUB_realistic/Data\HydroATLAS\hybas_na_lev12_v1c.shp');
gtable = readgeotable('Data/HydroAtlas/BasinATLAS_Data_v10_shp/BasinATLAS_v10_shp/BasinATLAS_v10_lev12.shp');
% shpriver = shaperead("Data\HydroAtlas\HydroRIVERS_v10_na_shp\HydroRIVERS_v10_na_shp\HydroRIVERS_v10_na.shp");
load('results\R4_HydroAtlast_attributes_varname.mat')
basins_all = shaperead('Data\CAMELSH\shapefiles\CAMELSH_shapefile.shp');
%%
MISSINGBasin(1:size(basins_all,1),1) = 1;
selectthreshold = 0.5;
parfor i=1:size(basins_all,1)
    i
    findwatershed_par(gtable,varnames,shapena,attributes(i,:),basins_all(i),i);
end

for i=1:size(basins_all,1)
    i
    FILENAME = ['Data/HydroAtlas/shp/',basins_all(i).GAGE_ID,'.mat'];
    load(FILENAME,'mergedBasin');
    [AreaC(i,:),shp_hydatlas(i),InforAt(i,1),InforAt_s{i,1},attr_hydatlas(i,:),Mask_check(i,1)] = loadreadhydroatlas(FILENAME);
    [~,~,Rarea(i,1),Rarea(i,2)]= check_shapefile_overlap(mergedBasin,basins_all(i));
end

save('results\R4_HydroAtlast_attributes.mat',"attr_hydatlas","InforAt_s","InforAt","AreaC","shp_hydatlas","varnames","Rarea")
shapewrite(shp_hydatlas, 'Data\CAMELSH\shapefiles\CAMELSH_shapefile_hydroATLAS.shp');

%% VISUALIZATION
F1;
F2;
F3;
F4;
F5;
F6 ;
