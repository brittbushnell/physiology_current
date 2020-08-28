% First step for all Glass pattern analysis, and run on each individual
% recording file.
%
% This program will:
%  - parse all stimulus information
%  - remove excess trials that weren't run across all animals
%  - determine good channels
%  - get spike counts from 50:250ms for each stimulus
%  - z-score the spike counts
%
% after this step, trials should be able to be combined across days as long
% as they pass some criteria (determined in the next program)
%
% Brittany Bushnell Aug 17, 2020
%%
clear
close all
clc
tic
%%
%cd ~/Dropbox/ArrayData/matFiles/reThreshold/png/WU/V4/Glass/LE/
files = {
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35'
    'WV_RE_glassCoh_nsp2_20190405_001_thresh35';
    };
%%
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
%%
aMap = getBlackrockArrayMap(files(1,:));
location = determineComputer;
failedFiles = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    dataT = load(filename);
    
    nChan = 96;
    tmp = strsplit(filename,'_');
    
    % extract information about what was run from file name.
    if length(tmp) == 6
        [animal, eye, dataT.programID, array, date2,runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        date = convertDate(date2);
    elseif length(tmp) == 7
        [animal, eye, dataT.programID, array, date2,runNum,reThreshold] = deal(tmp{:});
        date = convertDate(date2);
    else
        [animal, eye, dataT.programID, array, date2] = deal(tmp{:});
        date = date2;
    end
    
    if strcmp(array, 'nsp1')
        array = 'V1';
    elseif strcmp(array, 'nsp2')
        array = 'V4';
    end
    
    if contains(animal,'XX')
        dataT.filename = reshape(dataT.filename,[numel(dataT.filename),1]);
        dataT.filename = char(dataT.filename);
    end
    
    ndx = 1;
    for i = 1:size(dataT.filename,1)
        [type, numDots, dx, coh, sample] = parseGlassName(dataT.filename(i,:));
        
        %  type: numeric versions of the first letter of the pattern type
        %     0:  noise
        %     1: concentric
        %     2: radial
        %     3: translational
        %     100:blank
        dataT.type(1,ndx)    = type;
        dataT.numDots(1,ndx) = numDots;
        dataT.dx(1,ndx)      = dx;
        dataT.coh(1,ndx)     = coh;
        dataT.sample(1,ndx)  = sample;
        ndx = ndx+1;
    end
    
    %[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
    

    %%
    if sum(ismember(dataT.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
        if ~contains(dataT.programID,'TR')
            dataT = removeTranslationalStim(dataT); % a small number of experiments were run with all 3 patterns
        end
        
        dataT = GlassRemoveLowDx(dataT);
        dataT = GlassRemoveLowDots(dataT);
    end
       % dataT.stimOrder = getStimPresentationOrder(dataT);
    % add in anything that's missing from the new dataT structure.
    if length(tmp) == 6
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
        dataT.reThreshold = '';
    elseif length(tmp) == 7
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum,dataT.reThreshold] = deal(tmp{:});
        dataT.date = convertDate(dataT.date2);
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
        dataT.reThreshold = '';
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    
    dataT.amap = aMap;
    %% get receptive field parameters
    % RF center is relative to fixation, not center of the monitor.
    dataT = callReceptiveFieldParameters(dataT);
    %% determine reponsive channels
    dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
    [dataT.stimBlankChPvals,dataT.responsiveCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    fprintf('responsive channels defined\n')
    %% find channels whose receptive fields are within the stimulus bounds
    [dataT.rfQuadrant] = getRFsinStim(dataT);
    dataT.inStim = ~isnan(dataT.rfQuadrant); % want all channels whos RF center is within the stimulus bounds to be 1.
    dataT.goodCh = dataT.responsiveCh & dataT.inStim;
    fprintf('%d good channels \n%d responsive channels\n',sum(dataT.responsiveCh), sum(dataT.goodCh))

    %% get spike counts, Zscore, and split half correlations
    if contains(dataT.programID,'TR')
        [dataT.GlassTRSpikeCount,dataT.NoiseTRSpikeCount,dataT.BlankTRSpikeCount,dataT.AllStimTRSpikeCount] = getGlassTRSpikeCounts(dataT);
        [dataT.GlassTRZscore,dataT.GlassAllStimTRZscore] = getGlassStimZscore(dataT);
        [dataT.reliabilityIndex,dataT.splitHalfCorrBoots] = GlassTR_getHalfCorr(dataT);
    else
        [dataT.GlassSpikeCount,dataT.NoiseSpikeCount,dataT.BlankSpikeCount,dataT.AllStimSpikeCount] = getGlassCRSpikeCounts(dataT);
        [dataT.GlassZscore,dataT.GlassAllStimZscore] = getGlassStimZscore(dataT);
        [dataT.reliabilityIndex,dataT.split_half_correlation] = Glass_getHalfCorr(dataT);
        
    end
    fprintf('spike counts done, zscores computed, halves correlated \n')
    %% optional plots
    if plotFlag == 1
        if contains(dataT.programID,'TR')
            plotGlassTR_spikeCounts(dataT)
        else
            
        end
    end
    %% save data
    
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/',dataT.array);
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
    fprintf('%s saved\n', saveName)
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failedFiles{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %     end
end
failedFiles
toc