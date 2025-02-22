function [datcheck, availableD, avai_year] = checkdataset(GAGE_ID)
    % Define the path to the CSV file
    OutputFile = ['Data/CAMELS_Final/', GAGE_ID, '.csv'];
    
    % Read the data
    data = readtable(OutputFile);
    
    % Check if the dataset spans from 1980-01-01 to 2024-12-31
    if data.DateTime(1) == datetime(1980,1,1,0,0,0) && data.DateTime(end) == datetime(2024,12,31,23,0,0)
        datcheck = 1;
    else
        datcheck = 0;
    end
    
    % Extract streamflow data
    streamflow = data.Streamflow;
    
    % Count the total number of non-NaN streamflow data points
    availableD = sum(~isnan(streamflow));
    
    % Find available data for each year
    years = unique(year(data.DateTime));  % Get unique years in the dataset
    avai_year = zeros(length(years), 1);  % Initialize an array to store year and available data count
    
    for i = 1:length(years)
        % Extract data for the current year
        yearData = data(data.DateTime.Year == years(i), :);
        
        % Count the non-NaN streamflow data for that year
        % avai_year(i, 1) = years(i);
        avai_year(i, 1) = sum(~isnan(yearData.Streamflow));
    end
end
