function [] = plotMapping_locHeatMapbyCh(dataT)
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Mapping/%s/heatMap/%s/byCh',dataT.animal,dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/Mapping/%s/heatMap/%s/byCh',dataT.animal,dataT.array,dataT.eye);
end
cd(figDir)

% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%%
ypos = unique(dataT.pos_y);
xpos = unique(dataT.pos_x);

cmap = gray(20);
cmap = flipud(cmap);

for ch = 1:96
figure(3)
clf
hold on
imagesc(dataT.locRespsBaseSub(:,:,ch))
plot(find(xpos == 0),find(ypos == 0),'ro','MarkerFaceColor','r','MarkerSize',10)
colormap(cmap)
colorbar
axis square
title(sprintf('%s %s %s baseline subtracted responses to pink noise stimuli by location ch %d',dataT.animal, dataT.eye, dataT.array,ch))
set(gca,'XTick',1:1:length(xpos),'XTickLabel',(xpos),'YTick',1:1:length(ypos),'YTickLabel',(ypos))
%
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_locHeatMap_ch',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
end
%% 
cd ..

figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 800])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    subplot(dataT.amap,10,10,ch)
    hold on;
    imagesc(dataT.locRespsBaseSub(:,:,ch))
    plot(find(xpos == 0),find(ypos == 0),'ro','MarkerFaceColor','r','MarkerSize',4)
    colormap(cmap)
    axis square
    axis off
    title(ch)
    set(gca,'XTick',1:1:length(xpos),'XTickLabel',[],'YTick',1:1:length(ypos),'YTickLabel',[])
end
suptitle(sprintf('%s %s %s baseline subtracted responses to pink noise stimuli by location ch %d',dataT.animal, dataT.eye, dataT.array,ch))
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_locHeatMap_allchs','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
