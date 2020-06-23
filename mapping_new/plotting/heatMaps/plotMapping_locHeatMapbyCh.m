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

folder = 'dPrime';
mkdir(folder)
cd(sprintf('%s',folder))
%%
ypos = unique(dataT.pos_y);
xpos = unique(dataT.pos_x);

cmap = gray(20);
cmap = flipud(cmap);
%%
for ch = 1:96
figure(4)
clf
hold on
chResp = flipud(dataT.locDprime(:,:,ch)); 
imagesc(chResp)
plot(find(xpos == dataT.fixX),find(ypos == dataT.fixY),'ro','MarkerFaceColor','r','MarkerSize',10)
colormap(cmap)
c = colorbar;
c.FontAngle = 'italic'; c.FontSize = 10;
c.Label.String = 'dPrime vs blank'; c.Label.FontSize = 12; c.Label.FontAngle = 'italic';

axis square
title(sprintf('%s %s %s dPrimes by location ch %d',dataT.animal, dataT.eye, dataT.array,ch))
set(gca,'XTick',1:1:length(xpos),'XTickLabel',(xpos),'YTick',1:1:length(ypos),'YTickLabel',(ypos))
%
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_locHeatMap_ch',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
end
%% 
cd ..

figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 800])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    subplot(dataT.amap,10,10,ch)
    hold on;
    dPrimes = flipud(dataT.locDprime(:,:,ch));
    imagesc(dPrimes)
    plot(find(xpos == dataT.fixX),find(ypos == dataT.fixY),'ro','MarkerFaceColor','r','MarkerSize',4)
    colormap(cmap)
    axis square
    axis off
    title(ch)
    set(gca,'XTick',1:1:length(xpos),'XTickLabel',[],'YTick',1:1:length(ypos),'YTickLabel',[])
end
suptitle({sprintf('%s %s %s dPrimes by location',dataT.animal, dataT.eye, dataT.array);...
    sprintf('%s',dataT.date)})
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_locHeatMap_allchs_grid',num2str(dataT.date2),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
cd ../../..
%%

figure(6)
clf
pos = get(gcf,'Position');
%set(gcf,'Position',[pos(1) pos(2) 1200 800])
set(gcf,'PaperOrientation','Landscape');


hold on;
dPrimes = flipud(mean(dataT.locDprime(:,:,:),3));
imagesc(dPrimes)
plot(find(xpos == dataT.fixX),find(ypos == dataT.fixX),'ro','MarkerFaceColor','r','MarkerSize',4)
viscircles([dataT.stimX,dataT.stimY],4);
colormap(cmap)
c = colorbar;
c.FontAngle = 'italic'; c.FontSize = 10;
c.Label.String = 'dPrime vs blank'; c.Label.FontSize = 12; c.Label.FontAngle = 'italic';

axis square
axis off

set(gca,'XTick',1:1:length(xpos),'XTickLabel',(xpos),'YTick',1:1:length(ypos),'YTickLabel',(ypos))

title({sprintf('%s %s %s dPrimes by location',dataT.animal, dataT.eye, dataT.array);...
    sprintf('%s',dataT.date)},'FontSize',14,'FontAngle','italic')
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_locHeatMap_allchs_',num2str(dataT.date2),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')

