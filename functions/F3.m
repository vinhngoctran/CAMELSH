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

idx = find(availableD > 0);
scatter(attributes(idx,5),attributes(idx,4),2,availableD(idx,1)/(24*365));
c = colorbar(axes1, 'Position', ...
             [0.410947732389491 0.76994342291372 0.013 0.195190947666197]);
c.Label.String = 'Data availability [yrs]'; % Add title to the colorbar
c.Label.FontName = 'Calibri Light'; % Set font for the colorbar title
c.Label.FontSize = 14; % Set font size for the colorbar title
colormap("jet")
set(axes1,'Linewidth',1,'FontSize',12,'TickDir','out','Xcolor',[1 1 1],'Ycolor',[1 1 1]);
title('a','FontSize',18,'VerticalAlignment','cap','Position',[-124.484052532833,51.32978720630105,0]);



axes1 = axes('Parent',figure1,...
                'Position',[0.53 0.57 0.4 0.39]);hold on;
histogram(availableD(idx,1)/(24*365),'FaceColor',[0.5 0.5 0.5])
xlim([0 45])
    ylabel('Count');xlabel('Hourly streamflow availability [yrs]')

    set(axes1,'Linewidth',1,'FontSize',12,'Ytick',[0:100:400]); grid on
        title('b','FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';



exportgraphics(figure1,"Figures/F3.jpeg",'Resolution',600)  