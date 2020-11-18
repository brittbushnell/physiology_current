clear all
close all
clc
tic
%%

% LE = 'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info3_resps';
% RE = 'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info3_resps';

% LE = 'WV_LE_MapNoise_nsp1_Jan2019_all_thresh35_info3_resps';
% RE = 'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info3_resps';
 
% LE = 'XT_LE_mapNoiseRight_nsp2_Nov2018_all_thresh35_resps';
% RE = 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3_resps';

% LE = 'XT_LE_mapNoise_nsp1_Oct2018_all_thresh35_resps';
% RE = 'XT_RE_mapNoise_nsp1_Oct2018_all_thresh35_resps';

% LE = 'WU_LE_GratmapRF_nsp2_April2017_all_thresh35_resps';
% RE = 'WU_RE_GratmapRF_nsp2_April2017_all_thresh35_resps';
 
% LE = 'WU_LE_GratmapRF_nsp1_April2017_all_thresh35_resps';
% RE = 'WU_RE_GratmapRF_nsp1_April2017_all_thresh35_resps';

% LE = 'WU_LE_GratingsMapRF_nsp1_20170814_003_thresh35_info3_resps';
% RE = 'WU_RE_GratmapRF_nsp1_Aug2017_all_thresh35_resps';

LE = 'WU_LE_GratingsMapRF_nsp2_20170814_003_thresh35_info3_resps';
RE = 'WU_RE_GratmapRF_nsp2_Aug2017_all_thresh35_resps';
%%
load(LE);
dataLE = data.LE;
clear data;

load(RE);
dataRE = data.RE;
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/',dataRE.animal,dataRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/',dataRE.animal, dataRE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%%
figure(6)
clf
hold on
for ch = 1:96 
    scatter(dataRE.chReceptiveFieldParams{ch}(1),dataRE.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
    scatter(dataLE.chReceptiveFieldParams{ch}(1),dataLE.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end
if contains(dataRE.animal,'WU')
    viscircles([0,0],1.5, 'color',[0.2 0.2 0.2]);
else
    viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
end
plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',8)
text(10,10,'RE','Color',[0.8 0 0.4],'FontWeight','bold','FontSize',12)
text(10,11,'LE','Color',[0.2 0.4 1],'FontWeight','bold','FontSize',12)

title(sprintf('%s %s recepive field centers',dataRE.animal, dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = [dataRE.animal,'_',dataRE.array,'_LEvRE','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')












