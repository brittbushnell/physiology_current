clear 
close all
clc
tic
%%
files = {
    'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35'
};
%%
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
%%
location = determineComputer;
failedFiles = {};
failNdx = 1;
%%
for fi = 1:length(files)
    %% get basic information about what was run overall, and for each trial.
    filename = files{fi};
    dataT = load(filename);
    
    tmp = strsplit(filename,'_');
    dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; dataT.array = tmp{4}; dataT.date2 = tmp{5};
    dataT.runNum = tmp{6}; dataT.reThreshold = tmp{7}; dataT.date = convertDate(dataT.date2);
    
    if strcmp(dataT.array, 'nsp1')
        array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        array = 'V4';
    end
        
    % all of the other unique parameters are stored in the file name and need
    % to be parsed out.
    for i = 1:length(dataT.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(dataT.filename(i,:));
        
        dataT.rf(i,1)  = rf;
        dataT.amplitude(i,1) = mod;
        dataT.orientation(i,1) = ori;
        dataT.spatialFrequency(i,1) = sf;
        dataT.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
        name  = char(name);
        dataT.name{i,1} = name;
    end
    numCh = size(dataT.bins,3);
    
    % Make all of the vectors the same dimensions
    dataT.pos_x = dataT.pos_x';
    dataT.pos_y = dataT.pos_y';
    dataT.size_x = dataT.size_x';

    dataT.amap = getBlackrockArrayMap(files(1,:));
    %% Plot clean vs raw PSTH to check for misalignments  
    plotRadialPSTH_rawVsClean(dataT,filename) % need to send in filename as well so it can find the raw file
    %% Find visually responisve channels
    stimNdx = dataT.rf ~= 10000;
    blankNdx = dataT.rf == 10000;
    dataT = stimVsBlankPermutations_allStim(dataT, numBoot, holdout, stimNdx, blankNdx);
    [dataT.stimBlankPval,dataT.responsiveChannels] = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    fprintf('responsive channel permutations done in %.2f minutes\n',toc/60)
    %% get mean response, spike count, and zscore to each stimulus
    % Calling the desired values: RFspikeCount{ch}(desired meausre,stim#)
    %  If you want to get the spike counts or zscores, then the desired
    %  measure is 9:end. If you want overall mean response to descriptive
    %  statistics based on response rate then:
    %        end-3 mean response
    %        end-2 median response
    %        end-1 standard error

    [RFStimResps,blankResps,stimResps] = parseRadFreqStimResp(dataT);
    [RFspikeCount,blankSpikeCount,RFzScore,blankZscore] = getRadFreqSpikeCountZscore(dataT, stimResps);
    
        %% save data
        
        if location == 1
            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
            if ~exist(outputDir,'dir')
                mkdir(outputDir)
            end
        elseif location == 0
            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
            if ~exist(outputDir,'dir')
                mkdir(outputDir)
            end
        end
    
    if contains(filename,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n\n',saveName)
end