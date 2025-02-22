function results=computeClimate(GAGE_ID)
OutputFile = ['Data/CAMELS_Final/',GAGE_ID,'.csv'];
data = readtable(OutputFile);
precip_hourly = data.Rainf;
pet_hourly = data.PotEvap;
temp_hourly = data.Tair; % Column for hourly temperature
daily_dates = dateshift(data.DateTime, 'start', 'day');

% Remove duplicates to get unique daily dates
daily_dates = unique(daily_dates);
    % Convert hourly data to daily data
    num_hours_per_day = 24;
    num_days = floor(length(precip_hourly) / num_hours_per_day);

    % Reshape data into daily aggregates
    precip_daily = reshape(precip_hourly(1:num_days*num_hours_per_day), num_hours_per_day, num_days);
    pet_daily = reshape(pet_hourly(1:num_days*num_hours_per_day), num_hours_per_day, num_days);
    temp_daily = reshape(temp_hourly(1:num_days*num_hours_per_day), num_hours_per_day, num_days);

    % Compute daily sums and means while handling NaNs
    precip_daily = sum(precip_daily, 1, 'omitnan')';
    pet_daily = sum(pet_daily, 1, 'omitnan')';
temp_daily = mean(temp_daily, 1, 'omitnan')';

    % Compute the number of years in the dataset
    num_years = num_days / 365;

    % Mean daily precipitation and potential evaporation
    mean_precip = mean(precip_daily, 'omitnan');
    mean_pet = mean(pet_daily, 'omitnan');

    % Aridity index (ratio of mean PET to mean precipitation)
    aridity_index = mean_pet / mean_precip;

    % Threshold for high precipitation days
    high_precip_threshold = 5 * mean_precip;

    % Frequency of high precipitation days (days/year)
    high_precip_days = sum(precip_daily >= high_precip_threshold, 'omitnan') / num_years;

    % Compute average duration of high precipitation events
    high_precip_events = precip_daily >= high_precip_threshold;
    high_precip_durations = regionprops(bwlabel(high_precip_events), 'Area');
    high_precip_durations = [high_precip_durations.Area];
    avg_high_precip_duration = mean(high_precip_durations, 'omitnan');

    % Threshold for low precipitation days
    low_precip_threshold = 1; % mm/day

    % Frequency of low precipitation days (days/year)
    low_precip_days = sum(precip_daily < low_precip_threshold, 'omitnan') / num_years;

    % Compute average duration of low precipitation events
    low_precip_events = precip_daily < low_precip_threshold;
    low_precip_durations = regionprops(bwlabel(low_precip_events), 'Area');
    low_precip_durations = [low_precip_durations.Area];
    avg_low_precip_duration = mean(low_precip_durations, 'omitnan');

    % **Compute p_seasonality using sine curve fit**
    p_seasonality = compute_precip_seasonality(daily_dates, precip_daily, temp_daily);
    % p_seasonality = rad2deg(p_seasonality); % Convert to degrees for interpretation

    % **Compute frac_snow (Fraction of precipitation falling as snow)**
    % Define snow days as those with temperature below 0°C
    snow_days = temp_daily < 0;
    
    % Compute fraction of total precipitation that occurs on snow days
    snow_precip = sum(precip_daily(snow_days), 'omitnan');
    total_precip = sum(precip_daily, 'omitnan');
    frac_snow = snow_precip / total_precip;

    results = [mean_precip, ...
    mean_pet, ...
    aridity_index, ...
    p_seasonality, frac_snow,...
    high_precip_days, ...
    avg_high_precip_duration, ...
    low_precip_days, ...
    avg_low_precip_duration];

end

