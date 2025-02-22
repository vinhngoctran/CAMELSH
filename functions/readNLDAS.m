function readNLDAS(Watershed0,mask,year_value, month_value, day_value, hour)
%%
try
    file_name = sprintf('NLDAS_FORA0125_H.A%04d%02d%02d.%02d00.020.nc', ...
        year_value, month_value, day_value, hour);
    output_file = fullfile([pwd,'/Data/NLDAS2'], file_name);

    % infoF = ncinfo(output_file);
    timed = datetime(1979,1,1,0,0,0,"Format","dd-MMM-uuuu HH:mm:ss")+hours(ncread(output_file,'time'));
    Filename = ['Data/forcing/',datestr(timed,'yyyymmddhh'),'.mat'];
    if ~exist(Filename,"file")
        VariablesN = ["Tair"
            "Qair"
            "PSurf"
            "Wind_E"
            "Wind_N"
            "LWdown"
            "CRainf_frac"
            "CAPE"
            "PotEvap"
            "Rainf"
            "SWdown"];
        lat = ncread(output_file,'lat');
        lon = ncread(output_file,'lon');
        for i=1:numel(VariablesN)
            Data(:,:,i) = ncread(output_file,VariablesN{i});
        end
        [nlat, nlon, nvar] = size(Data);
        % ntime = length(timed);
        Data_1D = reshape(Data, nlat*nlon, nvar);
        [LAT, LON] = meshgrid(lat, lon);
        lat_1D = reshape(LAT, [], 1);
        lon_1D = reshape(LON, [], 1);
        % latlon_1D = [lat_1D, lon_1D];


        for i=1:numel(mask)
            Dat_sta(i,:) = mean(Data_1D(mask{i},:),1,'omitnan');
        end
        save(Filename,'timed',"Dat_sta");
    end
catch
    % pause
    delete(output_file)
    % readNLDAS(output_file,Watershed0,CheckGage,mask);
end
end

%%


%%
% variable_index = 1;
% data_to_plot = Data_1D(:, variable_index);
%
% % Create the plot
% figure;
% scatter(lon_1D, lat_1D, 20, data_to_plot, 'filled');
% colorbar;
% colormap('jet');
%
% % Add labels and title
% xlabel('Longitude');
% ylabel('Latitude');
% title(['Distribution of ', VariablesN{variable_index}]);
%
% % Adjust the plot appearance
% axis equal;
% xlim([min(lon) max(lon)]);
% ylim([min(lat) max(lat)]);