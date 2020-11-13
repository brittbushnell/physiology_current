clear all
close all
clc
tic
%%
% WU runs on a different program
files = {
    %     'WV_LE_MapNoise_nsp2_20190130_all_thresh35_info';
    %     'WV_RE_MapNoise_nsp2_20190130_all_thresh35_info';
    %
    %     'WV_LE_MapNoise_nsp1_20190130_all_thresh35_info';
    %     'WV_RE_MapNoise_nsp1_20190130_all_thresh35_info';
    %
    %     'XT_LE_mapNoiseRight_nsp2_20181120_all_thresh35_info';
    %     'XT_RE_mapNoiseRight_nsp2_20181026_all_thresh35_info';
    %
    %     'XT_LE_mapNoiseRight_nsp1_20181120_all_thresh35_info';
    %     'XT_RE_mapNoiseRight_nsp1_20181026_all_thresh35_info';
    
    'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info';
    };
nameEnd = 'resps';
%%
numPerm = 2000;
numBoot = 200;
holdout = .90;
plotFlag = 0; % 0 if you don't want to plot anything.
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    fprintf('\n*** analyzing %s *** \n file %d/%d \n', filename,fi,size(files,1))
    
    if ~contains(filename,'all')
        load(filename);
        if contains(filename,'RE')
            dataT = data.RE;
        else
            dataT = data.LE;
        end
    else
        dataT =load(filename);
    end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/%s/',dataT.array,dataT.programID);
    end
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    %% do stim vs blank permutation test
    if contains(dataT.animal,'WU')
        error('ya gotta enter the correct info for what is the stim and blank mtx, silly Billy')
        %         stimMtx = [];
        %         blankMtx = [];
    else
        stimMtx = dataT.stimZscoreAllLoc';
        blankMtx = dataT.blankZscore';
    end
%     [dataT.allStimBlankDprime ,dataT.allStimBlankDprimePermBoot, dataT.allStimBlankDprimeMuPerm,dataT.allStimBlankSDPerm] = stimVsBlankPerm_allStim_zScore(blankMtx,stimMtx, numBoot,holdout);
%     fprintf('stimulus vs blank permutaiton test done %.2f hours \n',toc/3600)
%     %% plot PSTHs
%     if plotFlag == 1
%         plotMappingPSTHs_visualResponses(dataT)
%     end
    %% get mean responses per location
    % If I still need this, update to work from the zscores, not mean
    % responses.
    % dataT = getMapNoiseRespDprime(dataT, numBoot, holdout);
    %% get receptive field centers and boundaries
    % verify 1) using z-scores  2)  using (y,x) for mapping receptive
    % fields.
    dataT = getReceptiveFields_zScore(dataT);
    %% plot location specific responses
    % plotMapping_locHeatMapbyCh(dataT)
    % plotMappingPSTHs_visualResponsesChs(dataT,0)
    % dataT = plotArrayReceptiveFields(dataT);
    %%
    location = determineComputer;
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal,V1data.programID, V1data.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal, V1data.programID, V1data.eye);
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
        
        scatter(dataT.chReceptiveFieldParams{ch}(1),dataT.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
        
        grid on;
        xlim([-10,10])
        ylim([-10,10])
        set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
            'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
        axis square
    end
    
    plot(fixX, fixY,'ok','MarkerFaceColor','k','MarkerSize',9)
    title(sprintf('%s %s %s recepive field centers',dataT.animal, dataT.array, dataT.eye),'FontSize',14,'FontWeight','Bold')
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