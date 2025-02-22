function p_seasonality = compute_precip_seasonality(day, prec, temp)
    [~, max_month] = max(splitapply(@mean, prec, month(day)));
s_p_first_guess = mod(90 - max_month * 30, 360);

% Create time vector in Julian days
t_julian = days(day - datetime(year(day(1)), 1, 1)) + 1;

% Fit temperature model
temp_model = @(params, t) mean(temp, 'omitnan') + params(1) * sin(2*pi*(t - params(2))/365.25);
temp_start = [5, -90];
temp_fit = fitnlm(t_julian, temp, temp_model, temp_start);

% Fit precipitation model
prec_model = @(params, t) mean(prec, 'omitnan') * (1 + params(1) * sin(2*pi*(t - params(2))/365.25));
prec_start = [0.4, s_p_first_guess];
prec_fit = fitnlm(t_julian, prec, prec_model, prec_start);

% Extract parameters
s_p = prec_fit.Coefficients.Estimate(2);
delta_p = prec_fit.Coefficients.Estimate(1);
s_t = temp_fit.Coefficients.Estimate(2);
delta_t = temp_fit.Coefficients.Estimate(1);

% Calculate seasonality and timing of precipitation
delta_p_star = delta_p * sign(delta_t) * cos(2*pi*(s_p - s_t)/365.25);

    % Step 8: Return the computed seasonality (p_seasonality)
    p_seasonality = delta_p_star;
end