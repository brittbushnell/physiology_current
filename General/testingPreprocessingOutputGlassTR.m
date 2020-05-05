%%
clear all
close all
clc
tic
%%
location = determineComputer;
if location == 1
    figDir =  '~/bushnell-local/Dropbox/Figures/WU/';
elseif location == 0
    figDir =  '~/Dropbox/Figures/WU/';
end
cd(figDir)

folder = 'thresholdTests/';
mkdir(folder)
cd(sprintf('%s',folder))

folder = 'PSTH/';
mkdir(folder)
cd(sprintf('%s',folder))
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
    % if manu30.goodCh(ch) == 1
    lin0Resp = nanmean(smoothdata(manu30.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(manu30.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(manu30.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(manu30.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(manu30.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(manu30.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
    
    subplot(manu30.amap,10,10,ch)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    title(ch)
    
    set(gca,'XTickLabel',[])
end
suptitle('WU LE V4 translational Glass PSTHs thresholds -3.0')
figName = 'WU_LE_GlassTR_PSTH_thresh3.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%% PSTH for -3.5

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

linNdx = (manu35.type == 3);
blankNdx = (manu35.numDots == 0);
dotNdx = (manu35.numDots == 400);
cohNdx = (manu35.coh == 1);
dxNdx = (manu35.dx == 0.03);
noiseNdx = (manu35.coh == 0 & dotNdx & dxNdx);

ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (manu35.rotation == 0));
ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (manu35.rotation == 45));
ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (manu35.rotation == 90));
ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (manu35.rotation == 135));

for ch = 1:96
    % if manu35.goodCh(ch) == 1
    lin0Resp = nanmean(smoothdata(manu35.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(manu35.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(manu35.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(manu35.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(manu35.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(manu35.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
    
    subplot(manu35.amap,10,10,ch)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    title(ch)
    
    set(gca,'XTickLabel',[])
end
suptitle('WU LE V4 translational Glass PSTHs thresholds -3.5')
figName = 'WU_LE_GlassTR_PSTH_thresh35.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%% PSTH for -4.0

figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

linNdx = (manu40.type == 3);
blankNdx = (manu40.numDots == 0);
dotNdx = (manu40.numDots == 400);
cohNdx = (manu40.coh == 1);
dxNdx = (manu40.dx == 0.03);
noiseNdx = (manu40.coh == 0 & dotNdx & dxNdx);

ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (manu40.rotation == 0));
ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (manu40.rotation == 45));
ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (manu40.rotation == 90));
ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (manu40.rotation == 135));

for ch = 1:96
    % if manu40.goodCh(ch) == 1
    lin0Resp = nanmean(smoothdata(manu40.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(manu40.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(manu40.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(manu40.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(manu40.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(manu40.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
    
    subplot(manu40.amap,10,10,ch)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    title(ch)
    
    set(gca,'XTickLabel',[])
end
suptitle('WU LE V4 translational Glass PSTHs thresholds -4.0')
figName = 'WU_LE_GlassTR_PSTH_thresh4.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%% PSTH for -3.5

figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

linNdx = (manu45.type == 3);
blankNdx = (manu45.numDots == 0);
dotNdx = (manu45.numDots == 400);
cohNdx = (manu45.coh == 1);
dxNdx = (manu45.dx == 0.03);
noiseNdx = (manu45.coh == 0 & dotNdx & dxNdx);

ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (manu45.rotation == 0));
ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (manu45.rotation == 45));
ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (manu45.rotation == 90));
ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (manu45.rotation == 135));

for ch = 1:96
    % if manu45.goodCh(ch) == 1
    lin0Resp = nanmean(smoothdata(manu45.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(manu45.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(manu45.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(manu45.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(manu45.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(manu45.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
    
    subplot(manu45.amap,10,10,ch)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    title(ch)
    
    set(gca,'XTickLabel',[])
end
suptitle('WU LE V4 translational Glass PSTHs thresholds -4.5')
figName = 'WU_LE_GlassTR_PSTH_thresh45.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%% 
cd ..
folder = 'channels/';
mkdir(folder)
cd(sprintf('%s',folder))

threshs = {manu30; manu35; manu40; manu45}; 
threshVal = 3:0.5:4.5;
%ndx = 1;
figure(5)
clf
for ndx = 1:8
    if ndx <5
        th = ndx;
        ch = 37;
    else
        th = ndx-4;
        ch = 71;
    end
    
    linNdx = (threshs{th}.type == 3);
    blankNdx = (threshs{th}.numDots == 0);
    dotNdx = (threshs{th}.numDots == 400);
    cohNdx = (threshs{th}.coh == 1);
    dxNdx = (threshs{th}.dx == 0.03);
    noiseNdx = (threshs{th}.coh == 0 & dotNdx & dxNdx);
    
    ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (threshs{th}.rotation == 0));
    ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (threshs{th}.rotation == 45));
    ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (threshs{th}.rotation == 90));
    ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (threshs{th}.rotation == 135));

    lin0Resp = nanmean(smoothdata(threshs{th}.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(threshs{th}.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(threshs{th}.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(threshs{th}.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(threshs{th}.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(threshs{th}.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;   
   
    subplot(2,4,ndx)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    
    title({sprintf('Threshold %.1f',-1*threshVal(th)); sprintf('ch %d',ch)} )
    
    ylim([0 350])
    set(gca,'tickdir','out')
    
    if ndx == 8
        legend('bipole','blank','0','45','90','135','Location','northeast')
    end
    
end

suptitle('WU LE V4 translational Glass PSTHs across Thresholds')
figName = 'WU_LE_GlassTR_PSTH_thresh_ch3771.pdf';
print(gcf, figName,'-dpdf','-fillpage')

%%
%% PSTH for -3.5
load WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k;
dataT = data.LE;
cd ../PSTH

figure(6)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1500 1200])
set(gcf,'PaperOrientation','Landscape');

linNdx = (dataT.type == 3);
blankNdx = (dataT.numDots == 0);
dotNdx = (dataT.numDots == 400);
cohNdx = (dataT.coh == 1);
dxNdx = (dataT.dx == 0.03);
noiseNdx = (dataT.coh == 0 & dotNdx & dxNdx);

ndx0 = (linNdx & dotNdx & cohNdx & dxNdx & (dataT.rotation == 0));
ndx45 = (linNdx & dotNdx & cohNdx & dxNdx & (dataT.rotation == 45));
ndx90 = (linNdx & dotNdx & cohNdx & dxNdx & (dataT.rotation == 90));
ndx135 = (linNdx & dotNdx & cohNdx & dxNdx & (dataT.rotation == 135));

for ch = 1:96
    % if dataT.goodCh(ch) == 1
    lin0Resp = nanmean(smoothdata(dataT.bins((ndx0), 1:35 ,ch),'gaussian',3))./0.01;
    lin45Resp = nanmean(smoothdata(dataT.bins((ndx45), 1:35 ,ch),'gaussian',3))./0.01;
    lin90Resp = nanmean(smoothdata(dataT.bins((ndx90), 1:35 ,ch),'gaussian',3))./0.01;
    lin135Resp = nanmean(smoothdata(dataT.bins((ndx135), 1:35 ,ch),'gaussian',3))./0.01;
    
    blankResp = nanmean(smoothdata(dataT.bins((blankNdx), 1:35 ,ch),'gaussian',3))./0.01;
    noiseResp = nanmean(smoothdata(dataT.bins((noiseNdx), 1:35 ,ch),'gaussian',3))./0.01;
    
    subplot(dataT.amap,10,10,ch)
    hold on
    plot(1:35,noiseResp,'color',[0.8 0.4 0 0.7],'LineWidth',0.75);
    plot(1:35,blankResp,'color',[0 0 0 0.7],'LineWidth',0.75);
    
    plot(1:35,lin0Resp,'color',[1 0 0 0.7],'LineWidth',0.75);
    plot(1:35,lin45Resp,'color',[0 0 1 0.7],'LineWidth',0.75);
    plot(1:35,lin90Resp,'color',[0 0.6 0.2 0.7],'LineWidth',0.75);
    plot(1:35,lin135Resp,'color',[0.7 0 0.7 0.7],'LineWidth',0.75);
    title(ch)
    
    set(gca,'XTickLabel',[])
end
suptitle('WU LE V4 translational Glass PSTHs raw data')
figName = 'WU_LE_GlassTR_PSTH_RAW.pdf';
print(gcf, figName,'-dpdf','-fillpage')






