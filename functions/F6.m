clc; clear; close all;
% load('results\R5.DataCheck.mat',"avai_year","StaID","datcheck","availableD")
load('results\R2_Basin_info.mat',"DatasetMark","attributes","basins_all")
% Load U.S. state boundaries
USshape = shaperead("F:\OneDrive - hus.edu.vn\PP\Done_2022_2_ExtrapolationML_RelativeStrength\Model/Data/basin_set_full_res/USborder.shp");
Climate = readtable('Data/Attributes-Climate/attribute_climate.csv');
Varsn = Climate.Properties.VariableNames;
Climate = table2array(Climate);
%%

%%

NAMED = ["[mm/day]","[mm/day]","[-]","[-]","[-]","[days/year]","[days]","[days/year]","[days]"];
close all
figure1 = figure('OuterPosition',[300 50 1200 900]); 
k=0;
for i=1:3
    for j=1:3
        k=k+1;
        axes1 = axes('Parent',figure1,...
                'Position',[0.03+(j-1)*0.315 0.67-(i-1)*0.3 0.32 0.27]);hold on;
        scatter(attributes(:,5),attributes(:,4),2,Climate(:,1+k));
        mapshow(USshape, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1);
        c = colorbar(axes1,'Location','southoutside','Position',...
    [0.0641891891891892+(j-1)*0.315 0.717472118959108-(i-1)*0.3 0.0734797297297297 0.0136307311028501]);
        c.Label.String = NAMED{k}; % Add title to the colorbar
        c.Label.FontSize = 14;
        set(axes1,'Linewidth',1,'FontSize',12,'TickDir','out','Xcolor','none','Ycolor','none','Color','none');
        title(strrep(Varsn{k+1}, '_', '-'),'FontSize',18,'VerticalAlignment','cap');axes1.TitleHorizontalAlignment = 'left';

        axes1 = axes('Parent',figure1,...
                'Position',[0.29+(j-1)*0.315 0.7-(i-1)*0.3 0.07 0.05]);hold on;
        histogram(Climate(:,1+k),10)
        set(axes1,'Linewidth',1,'FontSize',10,'TickDir','out','Color','none');
    end
end
exportgraphics(figure1,"Figures/F6.jpeg",'Resolution',600)  
%%
