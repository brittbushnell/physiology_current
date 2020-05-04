%%
clear all
close all
clc
tic
%%
load('WU_LE_GlassTR_nsp2_20170825_002_thresh30_tests_perm2k');
manu30 = data.LE;

load('WU_LE_GlassTR_nsp2_20170825_002_thresh35_tests_perm2k');
manu35 = data.LE;

load('WU_LE_GlassTR_nsp2_20170825_002_thresh40_tests_perm2k');
manu40 = data.LE;

load('WU_LE_GlassTR_nsp2_20170825_002_thresh45_tests_perm2k');
manu45 = data.LE;
%% PSTH for -3.0

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

linNdx = (manu30.type == 3);
blankNdx = (manu30.numDots == 0);
dotNdx = (manu30.numDots == 400);
cohNdx = (manu30.coh == 1);
dxNdx = (manu30.dx == 0.03);
noiseNdx = (manu30.coh == 0 & dotNdx & dxNdx);

ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (manu30.rotation == 0));
ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (manu30.rotation == 45));
ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (manu30.rotation == 90));
ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (manu30.rotation == 135));

for ch = 1:96
    if manu30.goodCh(ch) == 1
        lin0Resp = nanmean(smoothdata(manu30.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
        lin45Resp = nanmean(smoothdata(manu30.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
        lin90Resp = nanmean(smoothdata(manu30.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
        lin135Resp = nanmean(smoothdata(manu30.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
        
        blankResp = nanmean(smoothdata(manu30.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
        noiseResp = nanmean(smoothdata(manu30.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
        
        subplot(manu30.amap,10,10,ch)
        hold on
        plot(1:35,noiseResp,'color',[0 0 0 0.7],'LineWidth',1);
        plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.7);
        
        plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',1);
        plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',1);
        plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',1);
        plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',1);
        title(ch)
        
        set(gca,'XTickLabel',[])
    end
%     if ch == 1
%         suptitle('WU LE V4 translational Glass PSTHs thresholds -3.0')
%     end
end
