% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.

clear
close all
clc
%%
load XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_info.mat
cleanData = data.RE;

load XT_RE_GlassTRCoh_nsp2_20190324_001_info.mat
rawData = data.RE;
%%


figure;
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1200])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(dataT.amap,10,10,ch)
    hold on;
    
    REcoh = (dataT.coh == 1);
    REnoiseCoh = (dataT.coh == 0);
    REcohNdx = logical(REcoh + REnoiseCoh);
    
    blankResp = sum(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
    stimResp = sum(smoothdata(dataT.bins((REcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[],'YTick',[]);
    ylim([0 inf])
end


cd ~/Desktop/PSTHChecks/

if isempty(dataT.reThreshold)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.date2,'_',dataT.runNum,'PSTH_raw.pdf'];
    suptitle({(sprintf('%s %s %s %s run %s', dataT.animal, dataT.array, dataT.programID,dataT.date,dataT.runNum));...
        'raw data, Python parser'})
else
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.date2,'_',dataT.runNum,'PSTH_cleaned.pdf'];
    suptitle({(sprintf('%s %s %s %s run %s', dataT.animal, dataT.array, dataT.programID,dataT.date,dataT.runNum));...
        'clean data, Matlab parser'})
end
print(gcf, figName,'-dpdf','-fillpage')