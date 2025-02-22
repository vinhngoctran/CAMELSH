function [closestLat, closestLon] = findClosestOut(S, queryX, queryY)
% Extract all points from the shapefile
allPoints = [];
for i = 1:length(S)
    allPoints = [allPoints; S(i).X' S(i).Y'];
end

% Define the query point
queryPoint = [queryX queryY];

% Find the index of the closest point
[idx, ~] = dsearchn(allPoints, queryPoint);

% Get the closest point's coordinates
closestPoint = allPoints(idx, :);

% Extract latitude and longitude of the closest point
closestLon = closestPoint(1);
closestLat = closestPoint(2);

end
