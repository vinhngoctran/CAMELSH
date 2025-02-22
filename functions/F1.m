clc; clear; close all;
load('results\R5.DataCheck.mat',"avai_year","StaID","datcheck","availableD")
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
% Load U.S. state boundaries
USshape = shaperead("F:\OneDrive - hus.edu.vn\PP\Done_2022_2_ExtrapolationML_RelativeStrength\Model/Data/basin_set_full_res/USborder.shp");
% Initialize arrays for lat/lon

%%
close all
figure1 = figure('OuterPosition',[300 50 1100 550]); 
axes1 = axes('Parent',figure1,...
                'Position',[0.0 0.05 0.9 0.95]);hold on;
mapshow(USshape, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1);
idx =find(availableD==0);nst(1) = numel(idx);
scatter(attributes(idx,5),attributes(idx,4),5,'Marker','o','MarkerEdgeColor',[0.5 0.5 0.5],'MarkerFaceColor',[0.5 0.5 0.5],'DisplayName','Non-obs')
idx =find(availableD>0);nst(2) = numel(idx);
scatter(attributes(idx,5),attributes(idx,4),5,'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','DisplayName','Obs')
legend('Box','off')
set(axes1,'Linewidth',1,'FontName','Calibri Light','FontSize',16,'TickDir','out','Xcolor',[1 1 1],'Ycolor',[1 1 1]);

axes1 = axes('Parent', figure1, ...
             'Position', [0.7 0.15 0.17 0.2]);
hold on;

% Define bar colors
bar_colors = [0.5 0.5 0.5; 0 0 1]; % Gray for "Non-obs", Blue for "Obs"

% Plot the bar graph
b = bar([1, 2], nst); % Assuming nst is a 1x2 array with values for "Non-obs" and "Obs"

% Assign colors to bars
for k = 1:length(b)
    b(k).FaceColor = 'flat'; % Set FaceColor to 'flat' to allow individual bar coloring
    b(k).CData(k, :) = bar_colors(k, :); % Assign color to each bar
end
for i = 1:length(nst)
    text(i, nst(i), num2str(nst(i)), ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', ...
         'FontName', 'Calibri Light', ...
         'FontSize', 14);
end
% Set axes properties
set(axes1, 'LineWidth', 1, ...
           'FontName', 'Calibri Light', ...
           'FontSize', 16, ...
           'TickDir', 'out', ...
           'Ytick',[0:1500:4500],...
           'Xtick',[1, 2],'XTickLabel', {'Non-obs', 'Obs'});xtickangle(15)
exportgraphics(figure1,"Figures/F1.jpeg",'Resolution',600)  