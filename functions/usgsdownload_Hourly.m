function [SelectedStreamflow] = usgsdownload_Hourly(ID_USGS,StartDate,Enddate, TimeZone)
FinalDate = [datetime(StartDate):days(1):datetime(Enddate)]';
LinkName = ['https://nwis.waterservices.usgs.gov/nwis/iv/?sites=',ID_USGS,'&agencyCd=USGS&startDT=1980-01-01T00:00:00.000-06:00&endDT=2024-12-31T23:59:00.000-06:00&parameterCd=00060&format=rdb'];

% pause
try
    outfilename = websave('Data/Temp/test.txt',LinkName);
    % pause
    data = readtable('Data/Temp/test.txt');
    DATED = datetime(data.datetime);
    Tz= cell2table(data.tz_cd);
    Tz_A=unique(Tz);
    for i=1:numel(Tz_A)
        ifxx=find(strcmp(Tz{:,:}, Tz_A.Var1{i}));
        idx2 = find(strcmp(TimeZone{1}, Tz_A.Var1{i}));
        DATED(ifxx) = DATED(ifxx) - hours(TimeZone{2}(idx2(1)));            % convert to UTC zone
    end
    Streamflow = table2array(data(:,5));
    hourlyDates = dateshift(DATED, 'start', 'hour');
    
    % Group the data by hourly timestamps and calculate mean streamflow
    [uniqueHours, ~, idx] = unique(hourlyDates);
    hourlyStreamflow = accumarray(idx, Streamflow, [], @mean);

    % Create a new table with hourly data
    SelectedStreamflow = table(uniqueHours, hourlyStreamflow, 'VariableNames', {'DateTime', 'Streamflow'});
  
catch
    SelectedStreamflow = [];
end
delete 'Data/Temp/test.txt'
end