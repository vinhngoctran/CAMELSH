function findwatershed_par(gtable,varnames,shapena,attributes,basins_gages,i)
FILENAME = ['Data/HydroAtlas/shp/',basins_gages.GAGE_ID,'.mat'];
    if ~exist(FILENAME)
        try
            [mergedBasin, WaterShedID,upstreamBasins] = findwatershed_correct2(shapena,attributes(1,5),attributes(1,4),FILENAME,basins_gages);
            
            % shp_hydatlas = mergedBasin;
            [InforAt,InforAt_s,attr_hydatlas] = computehyd_attributes(WaterShedID,gtable,varnames,upstreamBasins,basins_gages);
            AreaC = [computearea(mergedBasin), computearea(basins_gages)];
            display(['HydroAtlas:  ', num2str(i)])
            Mask_check=1;
        catch
            display(['check:  ', num2str(i)])
            [closestLat, closestLon] = findClosestOut(basins_gages, attributes(1,5),attributes(1,4));
            [mergedBasin, WaterShedID,upstreamBasins] = findwatershed_correct2(shapena,closestLon,closestLat,FILENAME,basins_gages);
            AreaC = [computearea(mergedBasin), computearea(basins_gages)];
            % shp_hydatlas = mergedBasin;
            [InforAt,InforAt_s,attr_hydatlas] = computehyd_attributes(WaterShedID,gtable,varnames,upstreamBasins,basins_gages);
            display(['HydroAtlas:  ', num2str(i)])
            Mask_check=0;
        end
        save(FILENAME,"mergedBasin",'WaterShedID','upstreamBasins','Mask_check','InforAt','InforAt_s','attr_hydatlas','AreaC','basins_gages')
    end
end