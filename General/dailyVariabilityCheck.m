clear all
close all
clc
%%
cd '/Users/brittany/Dropbox/Figures/dailyComps'

%% XT
% load('XT_RE_mapNoiseRight_nsp2_nov2018_all_thresh35_info');
%  files = {
% 'XT_RE_mapNoiseLeft_nsp2_20181026_001_thresh35_info.mat';
% 'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35_info.mat';
% 'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35_info.mat';
% 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info.mat';
% 'XT_RE_mapNoise_nsp2_20181024_001_thresh35_info.mat';
% 'XT_RE_mapNoise_nsp2_20181024_002_thresh35_info.mat';
% 'XT_RE_mapNoise_nsp2_20181024_003_thresh35_info.mat';
% };
% dataT = data.RE;

% load('XT_LE_mapNoiseRight_nsp2_nov2018_all_thresh35_info');
%  files = {
%     'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35_info.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35_info.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35_info.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35_info.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35_info.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35_info.mat';
%      'XT_LE_mapNoise_nsp2_20181023_002_thresh35_info.mat';
%      'XT_LE_mapNoise_nsp2_20181025_001_thresh35_info.mat';
%  };
% dataT = data.LE;
%% WV
load('WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info');
files = {
    'WV_LE_MapNoise_nsp2_20190122_003_thresh35';
    'WV_LE_MapNoise_nsp2_20190130_001_thresh35';
    'WV_LE_MapNoise_nsp2_20190130_002_thresh35';
    };
dataT = data.LE;

% load('WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info');
% files = {
%     'WV_RE_MapNoise_nsp2_20190130_003_thresh35';
%      'WV_RE_MapNoise_nsp2_20190130_004_thresh35';
%     };
% dataT = data.RE;

%%
blankTrials = dataT.bins(dataT.stimulus == 0,:,:);
blanks = squeeze(mean(blankTrials,3));
resps = reshape(blankTrials,[size(blankTrials,1)*96,size(blankTrials,2)]);
%%
figure
imagesc(resps)
%imagesc(blanks)
colorbar
xlabel('time (10ms)')
ylabel('trial number')
title(sprintf('%s %s %s all sessions, all channels',dataT.animal, dataT.eye, dataT.array),'FontSize',14,'FontAngle','italic')

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_allChAllSessions.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure
imagesc(blanks)%,[0 0.8])
colorbar
xlabel('time (10ms)')
ylabel('trial number')

if contains(files{1},'thresh')
    title(sprintf('%s %s %s all sessions, mean counts for all channels cleaned data',dataT.animal, dataT.eye, dataT.array),'FontSize',14,'FontAngle','italic')
else
    title(sprintf('%s %s %s all sessions, mean counts for all channels raw data',dataT.animal, dataT.eye, dataT.array),'FontSize',14,'FontAngle','italic')
end

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_allChMeanSessions.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
% figure
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1000 1000])
% set(gcf,'PaperOrientation','Landscape');
%
% for fi = 1:length(files)
%     fname = files{fi};
%     load(fname)
%     if contains(fname,'RE')
%         dataT = data.RE;
%     else
%         dataT = data.LE;
%     end
%
%     blankTrials = dataT.bins(dataT.stimulus == 0,:,:);
%     resps = reshape(blankTrials,[size(blankTrials,1)*96,size(blankTrials,2)]);
%     if size(files,1)< 7
%         subplot(1,3,fi)
%     else
%         subplot(4,2,fi)
%     end
%     imagesc(resps,[0 4])
%     title(fname,'Interpreter','none','FontSize',11)
%     colorbar
%
%     ylabel('trial number')
%     if fi >= 7
%         xlabel('time (10ms)')
%     end
% end
% suptitle(sprintf('%s %s %s all ch and all stimuli',dataT.animal,dataT.eye,dataT.array))
%
% figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_bySession.pdf'];
% print(gcf, figName,'-dpdf','-fillpage')
%%
clear dataT;
figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 1000])
set(gcf,'PaperOrientation','Landscape');

for fi = 1:length(files)
    fname = files{fi};
    load(fname)
    if contains(fname,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    blanks = squeeze(mean(dataT.bins(dataT.stimulus == 0,:,:),3));
    %resps = reshape(dataT.bins,[size(dataT.bins,1)*96,size(dataT.bins,2)]);
    if size(files,1)< 7
        subplot(1,3,fi)
    else
        subplot(4,2,fi)
    end
    %imagesc(resps,[0 4])
    imagesc(blanks,[0 3.4])
    title(fname,'Interpreter','none','FontSize',11)
    colorbar
    
    ylabel('trial number')
    if fi >= 7
        xlabel('time (10ms)')
    end
end
if contains(fname,'thresh')
    suptitle(sprintf('%s %s %s mean spike count across ch and all stimuli cleaned data',dataT.animal,dataT.eye,dataT.array))
else
    suptitle(sprintf('%s %s %s mean spike count across ch and all stimuli raw data',dataT.animal,dataT.eye,dataT.array))
end
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_meanSession.pdf'];
print(gcf, figName,'-dpdf','-fillpage')