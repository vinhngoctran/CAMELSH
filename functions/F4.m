clc; clear; close all;

load('results\R4_HydroAtlast_attributes.mat',"attr_hydatlas","InforAt_s","InforAt","AreaC","shp_hydatlas","varnames","Rarea")


%%
close all
figure1 = figure('OuterPosition',[300 50 1200 600]); 
axes1 = axes('Parent',figure1,...
                'Position',[0.07 0.15 0.35 0.7]);hold on;
% Extract x and y values
x = AreaC(:,2);
y = AreaC(:,1);

% Compute density estimate
[density, ~] = ksdensity([x y], [x y]);

% Scatter plot with color based on density
scatter(x, y, 20, 'filled','MarkerFaceColor',['k']); % Density determines color
xlim([0 5*10^4]);ylim([0 5*10^4]);

% Adjust aesthetics
xlabel('Area_{GAGES-II} [km^2]');ylabel('Area_{HydroATLAS} [km^2]');
set(axes1, 'LineWidth', 1, 'FontSize', 14, 'TickDir', 'out');
title('a', 'FontSize', 18, 'VerticalAlignment', 'baseline');
axes1.TitleHorizontalAlignment = 'left';


axes1 = axes('Parent', figure1, ...
             'Position', [0.47 0.15 0.37 0.7]); hold on;

FractionA = Rarea;
% Extract x and y values
% Extract x and y values
x = FractionA(:,2); % Gages-ii
y = FractionA(:,1); % Hydroatlas
idx = numel(find(x>=0.90 & y>=0.90))

DiffA = AreaC(:,1) ./ AreaC(:,2);

idy = numel(find(DiffA>1.1))
idy = numel(find(DiffA<0.9))
% Define the number of bins (grid points) for each dimension
numBins = 10;  % Adjust this value to control resolution

% Create a grid of points
[X, Y] = meshgrid(linspace(min(x), max(x), numBins), ...
                  linspace(min(y), max(y), numBins));
XI = [X(:) Y(:)];

% Compute density estimate
[density, ~] = ksdensity([x y], XI);
plot([0 1],[0 1],'Color',[0.5 0.5 0.5],'LineWidth',1.5)
% Interpolate density values back to original data points
F = scatteredInterpolant(XI(:,1), XI(:,2), density);
densityAtPoints = F(x, y);

% Create the scatter plot with color based on interpolated density
scatter(axes1, x, y, 20, densityAtPoints, 'filled');


colormap((jet));
colorbar
% caxis([0 100])
xlim([0 1]);ylim([0 1]);

% Adjust aesthetics
xlabel('Overlap fraction_{GAGES-II} [-]'); 
ylabel('Overlap fraction_{HydroATLAS} [-]');
set(axes1, 'LineWidth', 1, 'FontSize', 14, 'TickDir', 'out');
title('b', 'FontSize', 18, 'VerticalAlignment', 'baseline');
axes1.TitleHorizontalAlignment = 'left';

hold off;
exportgraphics(figure1,"Figures/F4.jpeg",'Resolution',600)  
