function extractFinal(idx,DT,GAGEID)
Filename = ['Data/forcing/',datestr(DT(1),'yyyymmddhh'),'.mat'];load(Filename)
Data = Dat_sta(idx,:);
if isnan(Data(1))
    Forcing = NaN;
    checkip = 0;
    checkobs = 0;
else
    OutputFile = ['Data/CAMELS+/',GAGEID,'.csv'];
    if ~exist(OutputFile)
        f1 = fopen(OutputFile, 'w');  % Use fopen instead of open
        fprintf(f1, 'DateTime,Tair,Qair,PSurf,Wind_E,Wind_N,LWdown,CRainf_frac,CAPE,PotEvap,Rainf,SWdown,Streamflow\n');  % Write header
        Forcing = nan(numel(DT), 1);
        try
            load(['Data/usgs2/',num2str(idx),'.mat'],'data'); %read streamflow
            [~, idt] = ismember(data.DateTime, DT);
            valid_idx = idt ~= 0;
            Forcing(idt(valid_idx), 1) = data.Streamflow(valid_idx);
            checkobs=1;
        catch
            checkobs=0;
        end
        checkip = 1;
        for ifc=1:numel(DT)
            % ifc
            Filename = ['Data/forcing/',datestr(DT(ifc),'yyyymmddhh'),'.mat'];load(Filename)
            Writedata = [Dat_sta(idx,:), Forcing(ifc,1)];
            fprintf(f1, '%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n', ...
                datestr(DT(ifc), 'yyyy-mm-dd HH:MM:SS'), Writedata);
        end
        fclose(f1);  % Close the file
    end
end
end