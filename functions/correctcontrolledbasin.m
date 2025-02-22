function [X, Y] = correctcontrolledbasin(upstreamBasins,GAGESII)

[isOverlapping,intersection,Rarea ]= check_shapefile_overlap(upstreamBasins,GAGESII);

X = [intersection.Vertices(:,1);NaN]';
Y = [intersection.Vertices(:,2);NaN]';
end