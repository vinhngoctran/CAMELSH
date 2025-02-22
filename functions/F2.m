clc; clear; close all;
load('results\R5.DataCheck.mat',"avai_year","StaID","datcheck","availableD")
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
% Load U.S. state boundaries
USshape = shaperead("F:\OneDrive - hus.edu.vn\PP\Done_2022_2_ExtrapolationML_RelativeStrength\Model/Data/basin_set_full_res/USborder.shp");
% Initialize arrays for lat/lon
%%
Data = readtable('Data/CAMELSH/attributes/Attributes-GAGESII/Bas_Classif.csv');
AllDat = Data.HYDRO_DISTURB_INDX; % 
REfnonREF = Data.CLASS; %Clas
REfnonREF = string(REfnonREF);
ECOregion = Data.AGGECOREGION; % Ecoregion
ECOregion = string(ECOregion);
Data = readtable('Data/CAMELSH/attributes/Attributes-GAGESII/BasinID.csv');
AllDat(:,2) = Data.DRAIN_SQKM; % Area
Data = readtable('Data/CAMELSH/attributes/Attributes-GAGESII/Geology.csv');
Geology = Data.GEOL_REEDBUSH_DOM; % Geology
Geology = string(Geology);

%%
close all
figure1 = figure('OuterPosition',[300 50 1200 800]); 
axes1 = axes('Parent',figure1,...
                'Position',[0.0 0.57 0.45 0.4]);hold on;
mapshow(USshape, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1);

scatter(attributes(:,5),attributes(:,4),2,AllDat(:,1));
c = colorbar(axes1, 'Position', ...
             [0.410947732389491 0.76994342291372 0.013 0.195190947666197]);
c.Label.String = 'disturb index [-]'; % Add title to the colorbar
c.Label.FontName = 'Calibri Light'; % Set font for the colorbar title
c.Label.FontSize = 14; % Set font size for the colorbar title
colormap("jet")
set(axes1,'Linewidth',1,'FontSize',12,'TickDir','out','Xcolor',[1 1 1],'Ycolor',[1 1 1]);
title('a','FontSize',18,'VerticalAlignment','cap','Position',[-124.484052532833,51.32978720630105,0]);

axes1 = axes('Parent', figure1, 'Position', [0.356250000000003 0.594554455445546 0.0837837837837824 0.0891089108910891]);
hold on;

% Compute bar data
idx = find(REfnonREF == "Non-ref" & availableD == 0); nst(1,1) = numel(idx);
idx = find(REfnonREF == "Non-ref" & availableD > 0); nst(2,1) = numel(idx);
idx = find(REfnonREF == "Ref" & availableD == 0); nst(1,2) = numel(idx);
idx = find(REfnonREF == "Ref" & availableD > 0); nst(2,2) = numel(idx);

% Define colors for groups (Gray for "Non-obs", Blue for "Obs")
bar_colors = [0.5 0.5 0.5; 0 0 1];

% Plot bar graph
b = bar([1, 2], nst'); % Transpose `nst` to match bar() input format

% Assign colors to each group
for k = 1:length(b)
    b(k).FaceColor = bar_colors(k, :); % Assign colors consistently
end

% Add text labels above bars
dt = [-0.2, 0.2];
for i = 1:size(nst, 2) % Loop through category indices (Non-ref, Ref)
    for j = 1:size(nst, 1) % Loop through bar groups (Non-obs, Obs)
        y_val = sum(nst(j, i)); % Get cumulative height for stacked bars
        text(i+dt(j), y_val, num2str(nst(j, i)), ...
             'HorizontalAlignment', 'center', ...
             'VerticalAlignment', 'bottom', ...
             'FontSize', 10);
    end
end
% Format axes
set(axes1, 'LineWidth', 1, ...
           'FontSize', 12, ...
           'TickDir', 'out', ...
           'YTick', 0:1500:4500, ...
           'XTick', [1, 2], ...
           'XTickLabel', {'Non-ref', 'Ref'});
xtickangle(15);
legend({'Non-obs', 'Obs'}, 'Box', 'off','Position',[0.383364392650449 0.671807250303522 0.0853040527955101 0.0629420068004343]);


axes1 = axes('Parent',figure1,...
                'Position',[0.53 0.57 0.4 0.4]);hold on;
xxx = [min(AllDat(:,2)):(max(AllDat(:,2))-min(AllDat(:,2)))/100:max(AllDat(:,2))];
idx = find(availableD == 0); 
Data = AllDat(idx,2);
    Are_cdf = computecdf(xxx,Data);
    ll{1}= area(xxx,Are_cdf,'LineWidth',1.5,'DisplayName','Non-obs','FaceColor',[0.5 0.5 0.5],'EdgeColor','k');

    idx = find(availableD > 0); 
Data = AllDat(idx,2);
    Are_cdf = computecdf(xxx,Data);
    ll{2}= area(xxx,Are_cdf,'LineWidth',1.5,'DisplayName','Obs','FaceColor','b','EdgeColor','b','FaceAlpha',0.5);
    xlim([min(AllDat(idx,2)) max(AllDat(idx,2))])
    ylabel('CDF [-]');xlabel('Area [km^2]')
    legend([ll{1}, ll{2}],'Box','off','Location','northwest')
    set(axes1,'Linewidth',1,'FontSize',12,'XScale','log'); grid on
        title('b','FontSize',18,'VerticalAlignment','cap');axes1.TitleHorizontalAlignment = 'left';



axes1 = axes('Parent',figure1,...
                'Position',[0.055 0.1 0.4 0.37]);hold on;

Climr = unique(ECOregion);
for i=1:numel(Climr)
    nm(i,1) = numel(find(ECOregion==Climr{i}));
    nob(i,1) = numel(find(ECOregion==Climr{i} & availableD > 0));
end
bar(nm,'FaceColor',[0.5 0.5 0.5],'DisplayName','Non-obs');
bar(nob,'FaceColor','b','DisplayName','Oobs');
xlim([0.5 numel(nm)+0.5])
ylabel('Count','VerticalAlignment','baseline')
set(axes1, 'LineWidth', 1, ...
           'FontSize', 12, ...
           'TickDir', 'out', ...
           'XTick', [1:1:numel(nm)], ...
           'XTickLabel', Climr,'Ytick',[0:500:2000]);grid on
title('c','FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';
axes1 = axes('Parent',figure1,...
                'Position',[0.53 0.1 0.4 0.37]);hold on;

Climr = unique(Geology);
clearvars  nob nm
for i=1:numel(Climr)
    nm(i,1) = numel(find(Geology==Climr{i}));
    nob(i,1) = numel(find(Geology==Climr{i} & availableD > 0));
end
bar(nm,'FaceColor',[0.5 0.5 0.5],'DisplayName','Non-obs');
bar(nob,'FaceColor','b','DisplayName','Oobs');
xlim([0.5 numel(nm)+0.5])
ylabel('Count','VerticalAlignment','baseline')
set(axes1, 'LineWidth', 1, ...
           'FontSize', 12, ...
           'TickDir', 'out', ...
           'XTick', [1:1:numel(nm)], ...
           'XTickLabel', Climr,'YScale','log');grid on
title('d','FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';
exportgraphics(figure1,"Figures/F2.jpeg",'Resolution',600)  