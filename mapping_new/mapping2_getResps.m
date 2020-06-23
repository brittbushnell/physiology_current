clear all
close all
clc
tic
%%

files = {
%     'WV_LE_MapNoiseRight_nsp2_20190121_all_raw';
%     'WV_LE_MapNoiseRightWide_nsp2_20190122_002_raw';
%     'WV_RE_MapNoiseRightWide_nsp2_20190122_001_raw';
    
    'WV_LE_MapNoise_nsp2_20190204_all_raw';
%     'WV_RE_MapNoise_nsp2_20190205_001_raw';
%     
%     'WV_LE_MapNoise_nsp1_20190204_all_raw';
%     'WV_RE_MapNoise_nsp1_20190205_001_raw';
    };
nameEnd = 'perm';
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
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    end
    %% do stim vs blank permutation test
    stimNdx = (dataT.stimulus == 1);
    blankNdx = (dataT.stimulus == 0);
    
    [dataT] = stimVsBlankPermutations_allStim(dataT,stimNdx,blankNdx, numBoot,holdout);
    
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
    plotMapping_locHeatMapbyCh(dataT)
    plotMappingPSTHs_visualResponsesChs(dataT)
       %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/',dataT.array);
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