clc; clear; close all;

load('results\R4_HydroAtlast_attributes.mat',"attr_hydatlas","InforAt_s","InforAt","AreaC","shp_hydatlas","varnames","Rarea")
basins_all = shaperead('Data\CAMELSH\shapefiles\CAMELSH_shapefile.shp');
load('results\R2_Basin_info.mat',"DatasetMark","attributes");
%%
close all
figure1 = figure('OuterPosition',[300 50 1300 1000]); 
axes1 = axes('Parent',figure1,...
                'Position',[0.07 0.56 0.4 0.37]);hold on;
for i=1:7211
load(['Data/HydroAtlas/shp/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID','upstreamBasins')
mergedBasin_correct = mergedBasin;
WaterShedID_correct = WaterShedID;
load(['Data/HydroAtlas/shp_v1/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID')
if Rarea(i,2)>0.99 && Rarea(i,1)>0.99
break
end
end

mapshow(basins_all(i),'FaceColor',[0.5 0.5 0.5],FaceAlpha=0.5);

mapshow(upstreamBasins,'FaceColor','none','FaceAlpha',0.2,'EdgeColor','b','LineWidth',1)
xlabel('Longitude [^o]');ylabel('Latitude [^o]')
scatter(attributes(i,5),attributes(i,4),50,"green","filled")
set(axes1,'Linewidth',1,'FontSize',12);
title(['a. ',shp_hydatlas(i).GAGE_ID],'FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';

%------------------------------------------------------------------------------------------------------------
axes1 = axes('Parent',figure1,...
                'Position',[0.54 0.56 0.4 0.37]);hold on;
for i=1:7211
load(['Data/HydroAtlas/shp/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID','upstreamBasins')
mergedBasin_correct = mergedBasin;
WaterShedID_correct = WaterShedID;
load(['Data/HydroAtlas/shp_v1/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID')
if Rarea(i,2)>0.99 && Rarea(i,1)<0.9 && numel(WaterShedID_correct)>2
break
end
end

mapshow(basins_all(i),'FaceColor',[0.5 0.5 0.5],FaceAlpha=0.5);

mapshow(upstreamBasins,'FaceColor','none','FaceAlpha',0.2,'EdgeColor','b','LineWidth',1)
xlabel('Longitude [^o]');ylabel('Latitude [^o]')
scatter(attributes(i,5),attributes(i,4),50,"green","filled")
set(axes1,'Linewidth',1,'FontSize',12);
title(['b. ',shp_hydatlas(i).GAGE_ID],'FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';


%------------------------------------------------------------------------------------------------------------
axes1 = axes('Parent',figure1,...
                'Position',[0.07 0.08 0.4 0.37]);hold on;
for i=501:7211
load(['Data/HydroAtlas/shp/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID','upstreamBasins')
mergedBasin_correct = mergedBasin;
WaterShedID_correct = WaterShedID;
load(['Data/HydroAtlas/shp_v1/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID')
if Rarea(i,2)>0.99 && Rarea(i,1)<0.9 && numel(WaterShedID_correct)>2
break
end
end

mapshow(basins_all(i),'FaceColor',[0.5 0.5 0.5],FaceAlpha=0.5);

mapshow(upstreamBasins,'FaceColor','none','FaceAlpha',0.2,'EdgeColor','b','LineWidth',1)
xlabel('Longitude [^o]');ylabel('Latitude [^o]')
scatter(attributes(i,5),attributes(i,4),50,"green","filled")
set(axes1,'Linewidth',1,'FontSize',12);
title(['c. ',shp_hydatlas(i).GAGE_ID],'FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';


% ------------------------------------------------------------------------------------------------------------
axes1 = axes('Parent',figure1,...
                'Position',[0.54 0.08 0.4 0.37]);hold on;
for i=226:7211
load(['Data/HydroAtlas/shp/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID','upstreamBasins')
mergedBasin_correct = mergedBasin;
WaterShedID_correct = WaterShedID;
load(['Data/HydroAtlas/shp_v1/',shp_hydatlas(i).GAGE_ID,'.mat'],'mergedBasin','WaterShedID')
if Rarea(i,2)<0.4 && Rarea(i,1)>0.9 && numel(WaterShedID_correct)>2
break
end
end

mapshow(basins_all(i),'FaceColor',[0.5 0.5 0.5],FaceAlpha=0.5);
% mapshow(mergedBasin,'FaceColor','none','FaceAlpha',0.2,'EdgeColor','b','LineWidth',1)
mapshow(upstreamBasins,'FaceColor','none','FaceAlpha',0.2,'EdgeColor','b','LineWidth',1)
xlabel('Longitude [^o]');ylabel('Latitude [^o]')
scatter(attributes(i,5),attributes(i,4),50,"green","filled")
set(axes1,'Linewidth',1,'FontSize',12);
title(['d. ',shp_hydatlas(i).GAGE_ID],'FontSize',18,'VerticalAlignment','baseline');axes1.TitleHorizontalAlignment = 'left';



exportgraphics(figure1,"Figures/F5.jpeg",'Resolution',600)  