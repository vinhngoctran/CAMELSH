function attr_hydatlas = compute_class(InforAt_s,TotalAtribute)

if max(TotalAtribute) == -999
    attr_hydatlas = -999;
else
    TotalA(1:max(TotalAtribute)) = 0;
    for i=1:numel(InforAt_s)
        if TotalAtribute ~= -999
            TotalA(TotalAtribute(i)) = TotalA(TotalAtribute(i))+ InforAt_s(i);
        end
    end
    idx = find(TotalA == max(TotalA));
    attr_hydatlas = idx(1);
end
end