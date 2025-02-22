function [InforAt,InforAt_s,attr_hydatlas, idx] = computehyd_attributes(WaterShedID,gtable,varnames,upstreamBasins,basins_all)

for j=1:numel(varnames)
    for i=1:numel(WaterShedID)
        idx = find(gtable.HYBAS_ID ==WaterShedID(i));
        if i==1
            InforAt_s(i,1) = computearea(upstreamBasins(i));
            InforAt_s(i,2) = gtable.UP_AREA(idx) - gtable.SUB_AREA(idx)+InforAt_s(i,1);
            InforAt_s(i,3) = gtable.UP_AREA(idx);
        else
            InforAt_s(i,:) = [gtable.SUB_AREA(idx),gtable.UP_AREA(idx),gtable.UP_AREA(idx)];
        end
        Cmt = ['TotalAtribute(i,j) = gtable.',varnames{j},'(idx);'];
       eval(Cmt);
    end
    if contains(varnames{j}, '_usu') || contains(varnames{j}, '_use') || contains(varnames{j}, '_uav') || contains(varnames{j}, '_pc_u') || contains(varnames{j}, '_ix_u')
        attr_hydatlas(j) = TotalAtribute(1,j)/InforAt_s(1,3)*InforAt_s(1,2);
    elseif contains(varnames{j}, '_smj')
        attr_hydatlas(j) = compute_class(InforAt_s(:,1),TotalAtribute(:,j));
    else
        attr_hydatlas(j) = compute_average(InforAt_s(:,1),TotalAtribute(:,j));
    end
end
InforAt = sum(InforAt_s(:,1));
end