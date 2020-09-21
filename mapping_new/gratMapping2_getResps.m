clear all
close all
clc
tic
%%
files = {
    'WU_LE_Gratmap_nsp2_20170428_all_thresh35_info';
    'WU_RE_Gratmap_nsp2_20170428_006_thresh35_info';
    
    'WU_LE_Gratmap_nsp1_20170428_all_thresh35_info';
    'WU_RE_Gratmap_nsp1_20170428_006_thresh35_info';
    };
nameEnd ='resps';
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
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GratMapRF/resps/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GratMapRF/resps/',dataT.array);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    end
    %% do stim vs blank permutation test
    stimNdx  = dataT.spatial_frequency ~=0;
    blankNdx = dataT.spatial_frequency == 0;
    
    dataT = stimVsBlankPermutations_allStim(dataT, numBoot,holdout, stimNdx, blankNdx);
    fprintf('stimulus vs blank permutaiton test done %.2f minutes \n',toc/60)
    %% get mean responses for each location
    dataT = getGratMapRespDprime(dataT, numBoot, holdout);
    fprintf('responses by location computed %.2f minutes \n',toc/60)
    %% get receptive field centers and boundaries
    dataT = getReceptiveFields(dataT);
    %% save data
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