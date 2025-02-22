function datatransform(GAGE_ID)
OutputFile = ['Data/CAMELS_Final/',GAGE_ID,'.csv'];
if ~exist(OutputFile)
    Data = readtable(['Data/CAMELS+/',GAGE_ID,'.csv']);
    Data.CAPE = Data.CAPE;                              % J kg-1 to J kg-1
    Data.CRainf_frac = Data.CRainf_frac;                % Fraction to Fration
    Data.LWdown = Data.LWdown;                          % W m-2 to W m-2
    Data.SWdown = Data.SWdown;                          % W m-2 to W m-2
    Data.PotEvap = Data.PotEvap;                        % kg m-2  to mm/h   
    Data.Tair = Data.Tair - 273.15;                     % K to C degree
    Data.PSurf = Data.PSurf;                            % Pa to Pa
    Data.Qair = Data.Qair;                              % kg kg-1 to kg kg-1
    Data.Rainf = Data.Rainf;                            % kg m-2 to mm/h
    Data.Wind_E = Data.Wind_E;                          % m s-1 to m s-1
    Data.Wind_N = Data.Wind_N;                          % m s-1 to m s-1
    Data.Streamflow = Data.Streamflow * 0.0283168;      % cfs to cms
    writetable(Data, OutputFile);
end
end