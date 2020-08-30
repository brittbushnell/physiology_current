% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.

clear
close all
clc
%%
load 'XT_RE_GlassTRCoh_nsp2_20190324_001_cleaned35ogcorrupt_info';
cleanData = data.RE;

load 'XT_RE_GlassTRCoh_nsp2_20190324_001_info';
rawData = data.RE;
%%

figure;
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1200])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    
    subplot(cleanData.amap,10,10,ch)
    hold on;
    
    REcoh = (cleanData.coh == 1);
    REnoiseCoh = (cleanData.coh == 0);
    REcohNdx = logical(REcoh + REnoiseCoh);
    
    blankResp = sum(smoothdata(cleanData.bins((cleanData.numDots == 0), 1:35 ,ch),'gaussian',3));
    stimResp = sum(smoothdata(cleanData.bins((REcohNdx), 1:35 ,ch),'gaussian',3));
%     plot(1:35,blankResp,'b','LineWidth',0.5);
%     plot(1:35,stimResp,'b','LineWidth',2);
    
    
    blankResp = sum(smoothdata(rawData.bins((rawData.numDots == 0), 1:35 ,ch),'gaussian',3));
    stimResp = sum(smoothdata(rawData.bins((REcohNdx), 1:35 ,ch),'gaussian',3));
    plot(1:35,blankResp,'r','LineWidth',0.5);
    plot(1:35,stimResp,'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','tickdir','out','FontAngle','italic','FontSize',10,'XTick',[]);
%     ylim([0 inf])
end

suptitle('Red: raw data, Blue: cleaned and repaired data')
