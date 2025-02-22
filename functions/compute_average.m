function attr_hydatlas = compute_average(InforAt_s,TotalAtribute)

for i=1:numel(InforAt_s)
TotalA(i) = InforAt_s(i)*TotalAtribute(i);
end
attr_hydatlas = sum(TotalA)/sum(InforAt_s);
end