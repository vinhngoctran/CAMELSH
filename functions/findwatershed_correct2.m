function [mergedBasin, WaterShedID,upstreamBasins] = findwatershed_correct2(basinAtlas,outletX,outletY,SHAPENAME,GAGESII)

%% Step 1: Collect all sub-basins based on the one containing streamgage
% Create a point object for the outlet
outletPoint = [outletX, outletY];
mergedBasin = 1;
% Find the sub-basin containing the outlet
containingBasinIdx = [];
for i = 1:length(basinAtlas)
    if inpolygon(outletX, outletY, basinAtlas(i).X, basinAtlas(i).Y)
        containingBasinIdx = i;
        HyID = basinAtlas(i).HYBAS_ID;
        break;
    end
end
for i = 1:length(basinAtlas)
    NexDownID(i,1) =  basinAtlas(i).NEXT_DOWN;
end

if ~isempty(containingBasinIdx)
    % Initialize watershed with the containing basin
    watershed = basinAtlas(containingBasinIdx);
    upstreamBasins(1) = watershed;

    % Aggregate upstream basins
    % Assuming 'NEXT_DOWN' is the field indicating the downstream basin ID
    upstreamFound = true;
    k=1;
    while upstreamFound

        CheckBas = containingBasinIdx;

        for j=k:size(CheckBas,1)
            for i = 1:length(basinAtlas)
                if basinAtlas(CheckBas(j)).HYBAS_ID == basinAtlas(i).NEXT_DOWN
                    idx = find(containingBasinIdx==i);
                    % [isOverlapping,intersection,Rarea ]= check_shapefile_overlap(basinAtlas(i),GAGESII);
                    % Rarea
                    if isempty(idx) %&& Rarea>=selectthreshold
                        containingBasinIdx = [containingBasinIdx;i];
                        upstreamFound = true;
                    end
                end
            end
        end
        k=numel(CheckBas)+1;
        %         containingBasinIdx = unique(containingBasinIdx);
        if sum(containingBasinIdx) - sum(CheckBas)==0
            upstreamFound = false;
        end

    end
    % [isOverlapping,intersection,Rarea ]= check_shapefile_overlap(basinAtlas(containingBasinIdx(1)),GAGESII);
    % if Rarea<selectthreshold && numel(containingBasinIdx)>1
    %     containingBasinIdx = containingBasinIdx(2:end);
    % end
    upstreamBasins = basinAtlas(containingBasinIdx);
    [upstreamBasins(1).X, upstreamBasins(1).Y] = correctcontrolledbasin(upstreamBasins(1),GAGESII);
    %% Re-process to find all sub-basin
    % Merge all upstream basins into one
    mergedPolygon = [];
    WaterShedID = [];
    for i = 1:length(upstreamBasins)
        if isempty(mergedPolygon)
            mergedPolygon = polyshape(upstreamBasins(i).X, upstreamBasins(i).Y);
            WaterShedID = [WaterShedID;upstreamBasins(i).HYBAS_ID];
        else
            currentPoly = polyshape(upstreamBasins(i).X, upstreamBasins(i).Y);
            mergedPolygon = union(mergedPolygon, currentPoly);
            WaterShedID = [WaterShedID;upstreamBasins(i).HYBAS_ID];
        end
    end


    % Extract the boundary of the merged polygon
    [mergedX, mergedY] = boundary(mergedPolygon);


    % Create a structure for the merged polygon to save as a shapefile
    mergedBasin = struct('Geometry', 'Polygon', ...
        'X', [mergedX; NaN], ...
        'Y', [mergedY;NaN], ...
        'GAGE_ID', GAGESII.GAGE_ID);
    % Save the watershed boundary as a shapefile
    % shapewrite(mergedBasin, SHAPENAME);
    % save(SHAPENAME,"mergedBasin",'WaterShedID','upstreamBasins')
    idxxx = 1;
else
    idxxx = 0;
    disp('Outlet point not found in any basin');
end