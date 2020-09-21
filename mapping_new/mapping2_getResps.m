clear all
close all
clc
tic
%%
% WU runs on a different program
files = {
    'WV_LE_MapNoise_nsp2_20190130_all_thresh35_info';
    'WV_RE_MapNoise_nsp2_20190130_all_thresh35_info';
    
    'WV_LE_MapNoise_nsp1_20190130_all_thresh35_info';
    'WV_RE_MapNoise_nsp1_20190130_all_thresh35_info';
    
    'XT_LE_mapNoiseRight_nsp2_20181120_all_thresh35_info';
    'XT_RE_mapNoiseRight_nsp2_20181026_all_thresh35_info';
    
    'XT_LE_mapNoiseRight_nsp1_20181120_all_thresh35_info';
    'XT_RE_mapNoiseRight_nsp1_20181026_all_thresh35_info';
    };
nameEnd = 'resps';
%%
numBoot = 200;
numPerm = 2000;
holdout = .90;
plotFlag = 0; % 0 if you don't want to plot anything.
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;

for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    end
    %% do stim vs blank permutation test
    if contains(dataT.animal,'WU')
        stimNdx = (dataT.spatial_frequency > 0);
        blankNdx = (dataT.spatial_frequency == 0);
    else
        stimNdx = (dataT.stimulus == 1);
        blankNdx = (dataT.stimulus == 0);
    end
    
    [dataT] = stimVsBlankPermutations_allStim(dataT, numBoot,holdout,stimNdx,blankNdx);
    fprintf('stimulus vs blank permutaiton test done %.2f hours \n',toc/3600)
    %% determine good channels
    [dataT.stimBlankPval,dataT.goodCh] = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    
    fprintf('determination of visually responsive channels done %.2f hours \n',toc/3600)
    %% plot PSTHs
    if plotFlag == 1
        plotMappingPSTHs_visualResponses(dataT)
    end
    %% get mean responses per location
    dataT = getMapNoiseRespDprime(dataT, numBoot, holdout);
    %% get receptive field centers and boundaries
    dataT = getReceptiveFields(dataT);
    %% plot location specific responses
    % plotMapping_locHeatMapbyCh(dataT)
    % plotMappingPSTHs_visualResponsesChs(dataT,0)
    % dataT = plotArrayReceptiveFields(dataT);
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    end
    %% make structures for each eye and save .mat file
    
    if contains(filename,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n', saveName)
end