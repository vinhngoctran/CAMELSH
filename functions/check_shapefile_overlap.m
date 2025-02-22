function [isOverlapping, intersection,Rarea1,Rarea2,area3]= check_shapefile_overlap(shape1, shape2)

    % Convert selected polygons to polyshape
    poly1 = polyshape(shape1.X, shape1.Y);
    poly2 = polyshape(shape2.X, shape2.Y);
    
    % Check for intersection
    intersection = intersect(poly1, poly2);
    
    % Determine if they overlap
    isOverlapping = ~isempty(intersection) && area(intersection) > 0;
    Rarea1 = area(intersection)/area(poly1);
    Rarea2 = area(intersection)/area(poly2);
    
    lon = intersection.Vertices(:,2);
    lat = intersection.Vertices(:,1);
    wgs84 = wgs84Ellipsoid('km');    
    area3 = sum(areaint(lat, lon, wgs84));
end
