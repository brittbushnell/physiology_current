clear
close all
clc
tic
%% To do
% heatmaps:
% 1) organize data so you have a 2-d matrix for each channel where
% each row is a different RF and orientation, and columns are
% modulations.
% 2) Those matrices need to be done for each location separately
% 3) normalize by response to a circle
% 4) Plot all channels, not just those that pass inclusion criteria
% 5) use blue-red colorscale so blue is suppression and red is
% excitation. Scale each channel separately.

% - make a plot that shows stimulus locations relative to receptive field
% locations.
%%

files = {
'WU_RE_radFreqLoc1_nsp2_June2017_info';
'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
'WU_RE_radFreqLoc1_nsp1_June2017_info';
'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info.mat';
};
%%
nameEnd = 'goodRuns';
numPerm = 200;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    %%
    %try
        filename = files{fi};
        fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
        
        if contains(filename,'all') % data has been merged across sessions
            dataT = load(filename);
        else
            load(filename);
            if contains(filename,'RE')
                dataT = data.RE;
            else
                dataT = data.LE;
            end
        end
        %%
        figure(1)
        clf
        pos = get(gca,'Position');
        set(gca,'Position',[pos(1), pos(2), 1200, 900])
        for ch = 1:96
            
        end
end