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

%%
clear all
close all
clc
tic
%%
files = {
    'WU_LE_Glass_nsp2_20170817_001_thresh35';
    };
%%
nameEnd = 'info';
numPerm = 2000;
holdout = 0.9;
%%
aMap = getBlackrockArrayMap(files(1,:));
location = determineComputer;
failedFiles = {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    dataT = load(filename);
    
    nChan = 96;
    dataT.amap = aMap;
    tmp = strsplit(filename,'_');
    
    % extract information about what was run from file name.
    if length(tmp) == 6
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum] = deal(tmp{:});
        % get date in a format that's useable in figure titles (ex: 09/1/2019 vs 20190901)
        dataT.date = convertDate(dataT.date2);
    elseif length(tmp) == 7
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2,dataT.runNum,ign] = deal(tmp{:});
        dataT.date = convertDate(dataT.date2);
    else
        [dataT.animal, dataT.eye, dataT.programID, dataT.array, dataT.date2] = deal(tmp{:});
        dataT.date = dataT.date2;
    end
    
    if strcmp(dataT.array, 'nsp1')
        dataT.array = 'V1';
    elseif strcmp(dataT.array, 'nsp2')
        dataT.array = 'V4';
    end
    
    if contains(dataT.animal,'XX')
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
    
    [numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
    
    dataT.stimOrder = getStimPresentationOrder(dataT);
    %%
    if sum(ismember(dataT.numDots,100)) ~=0 % if 100 and 0.01 were run, remove them.
        if ~contains(dataT.programID,'TR')
            dataT = removeTranslationalStim(dataT); % a small number of experiments were run with all 3 patterns
        end
        
        dataT = GlassRemoveLowDx(dataT);
        dataT = GlassRemoveLowDots(dataT);
    end
    
    % add in anything that's missing from the new cleanData structure.
    dataT.amap = aMap;
    dataT.date2 = dataT.date2;
    %% get receptive field parameters
    %RF center is relative to fixation, not center of the monitor.
    dataT = callReceptiveFieldParameters(dataT);
    %% determine good channels
    dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
    [dataT.stimBlankChPvals,dataT.goodCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
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
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failedFiles{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %     end
end
failedFiles
toc