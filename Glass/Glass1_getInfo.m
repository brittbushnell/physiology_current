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

'WV_LE_glassCohSmall_nsp1_20190425_002_thresh35_ogcorrupt.mat';
'WV_LE_glassCohSmall_nsp1_20190429_001_thresh35_ogcorrupt.mat';
'WV_LE_glassCohSmall_nsp1_20190429_002_thresh35_ogcorrupt.mat';
'WV_LE_glassCoh_nsp1_20190402_002_thresh35_ogcorrupt.mat';
'WV_LE_glassCoh_nsp1_20190402_003_thresh35_ogcorrupt.mat';
'WV_LE_glassCoh_nsp1_20190403_002_thresh35_ogcorrupt.mat';
'WV_LE_glassCoh_nsp1_20190404_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCohSmall_nsp1_20190429_003_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCohSmall_nsp1_20190429_004_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCohSmall_nsp1_20190430_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCohSmall_nsp1_20190430_002_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCohSmall_nsp1_20190430_003_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190411_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190412_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190415_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190416_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190416_002_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190416_003_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190417_001_thresh35_ogcorrupt.mat';
'WV_LE_glassTRCoh_nsp1_20190417_002_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190405_002_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190408_001_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190409_001_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190409_002_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190410_001_thresh35_ogcorrupt.mat';
'WV_RE_glassTRCoh_nsp2_20190410_002_thresh35_ogcorrupt.mat';
'WV_RE_glassCohSmall_nsp1_20190423_001_thresh35_ogcorrupt.mat';
'WV_RE_glassCohSmall_nsp1_20190423_002_thresh35_ogcorrupt.mat';
'WV_RE_glassCohSmall_nsp1_20190424_001_thresh35_ogcorrupt.mat';
'WV_RE_glassCoh_nsp1_20190404_002_thresh35_ogcorrupt.mat';
'WV_RE_glassCoh_nsp1_20190404_003_thresh35_ogcorrupt.mat';
'WV_RE_glassCoh_nsp1_20190405_001_thresh35_ogcorrupt.mat';
'XT_LE_GlassCoh_nsp2_20190324_005_thresh35_ogcorrupt.mat';
'XT_LE_GlassCoh_nsp2_20190325_001_thresh35_ogcorrupt.mat';
'XT_LE_GlassCoh_nsp2_20190325_002_thresh35_ogcorrupt.mat';
'XT_LE_GlassCoh_nsp2_20190325_004_thresh35_ogcorrupt.mat';
'XT_LE_Glass_nsp2_20190123_001_thresh35_ogcorrupt.mat';
'XT_LE_Glass_nsp2_20190124_001_thresh35_ogcorrupt.mat';
'XT_LE_Glass_nsp2_20190124_002_thresh35_ogcorrupt.mat';
'XT_LE_Glass_nsp2_20190124_003_thresh35_ogcorrupt.mat';
'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt.mat';
'XT_LE_GlassTR_nsp1_20190130_001_thresh35_ogcorrupt.mat';
'XT_LE_GlassTR_nsp1_20190130_002_thresh35_ogcorrupt.mat';
'XT_LE_GlassTR_nsp1_20190130_003_thresh35_ogcorrupt.mat';
'XT_LE_GlassTR_nsp1_20190130_004_thresh35_ogcorrupt.mat';
'XT_RE_GlassCoh_nsp2_20190322_001_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190322_002_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190322_003_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190322_004_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190324_001_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190324_002_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190324_003_thresh35_ogcorrupt.mat';
'XT_RE_GlassTRCoh_nsp2_20190324_004_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190125_001_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190125_002_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190125_003_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190125_004_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190125_005_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190128_001_thresh35_ogcorrupt.mat';
'XT_RE_GlassTR_nsp2_20190128_002_thresh35_ogcorrupt.mat';
'XT_RE_Glass_nsp2_20190123_005_thresh35_ogcorrupt.mat';
'XT_RE_Glass_nsp2_20190123_006_thresh35_ogcorrupt.mat';
'XT_RE_Glass_nsp2_20190123_007_thresh35_ogcorrupt.mat';
'XT_RE_Glass_nsp2_20190123_008_thresh35_ogcorrupt.mat';
'XT_RE_Glass_nsp2_20190124_005_thresh35_ogcorrupt.mat';
'XT_RE_GlassCoh_nsp1_20190321_002_thresh35_ogcorrupt.mat';


'WU_LE_GlassTR_nsp1_20170822_002_thresh35.mat';
'WU_RE_Glass_nsp2_20170817_002_thresh35.mat';
'WU_RE_Glass_nsp1_20170817_002_thresh35.mat';
'WV_LE_glassTRCohSmall_nsp2_20190429_004_thresh35.mat';
'WV_RE_glassTRCoh_nsp1_20190405_002_thresh35.mat';
'WV_RE_glassTRCoh_nsp1_20190408_001_thresh35.mat';
'WV_RE_glassTRCoh_nsp1_20190409_002_thresh35.mat';

'XT_LE_GlassCoh_nsp2_20190325_003_thresh35.mat';
'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35.mat';
'XT_LE_GlassTR_nsp2_20190130_001_thresh35.mat';
'XT_LE_GlassTR_nsp2_20190130_002_thresh35.mat';
'XT_LE_GlassTR_nsp2_20190130_003_thresh35.mat';
'XT_LE_GlassTR_nsp2_20190130_004_thresh35.mat';
'XT_LE_GlassTR_nsp2_20190131_001_thresh35.mat';

'XT_LE_GlassCoh_nsp1_20190324_005_thresh35.mat';
'XT_LE_GlassCoh_nsp1_20190325_003_thresh35.mat';
'XT_LE_GlassTR_nsp1_20190131_001_thresh35.mat';
'XT_LE_Glass_nsp1_20190123_001_thresh35.mat';
'XT_LE_Glass_nsp1_20190123_002_thresh35.mat';
'XT_LE_Glass_nsp1_20190124_001_thresh35.mat';
'XT_LE_Glass_nsp1_20190124_002_thresh35.mat';
'XT_LE_Glass_nsp1_20190124_003_thresh35.mat';

'XT_RE_GlassCoh_nsp2_20190321_003_thresh35.mat';
'XT_RE_Glass_nsp2_20190123_003_thresh35.mat';
'XT_RE_Glass_nsp2_20190123_004_thresh35.mat';
'XT_RE_GlassTRCoh_nsp1_20190322_002_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190125_001_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190125_002_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190125_003_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190125_004_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190125_005_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190128_001_thresh35.mat';
'XT_RE_GlassTR_nsp1_20190128_002_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_003_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_004_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_005_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_006_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_007_thresh35.mat';
'XT_RE_Glass_nsp1_20190123_008_thresh35.mat';
'XT_RE_Glass_nsp1_20190124_005_thresh35.mat'
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
    %% Get basic information about experiments
    try
        filename = files{fi};
        dataT = load(filename);
        
        tmp = strsplit(filename,'_');
        
        aMap = getBlackrockArrayMap(filename);
        animal = tmp{1};  eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4}; date2 = tmp{5};
        runNum = tmp{6}; reThreshold = tmp{7}; date = convertDate(date2);
        
        if strcmp(array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(array, 'nsp2')
            dataT.array = 'V4';
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
        dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4}; dataT.date2 = tmp{5};
        dataT.runNum = tmp{6}; dataT.reThreshold = tmp{7}; dataT.date = convertDate(dataT.date2);
        
        if strcmp(array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(array, 'nsp2')
            dataT.array = 'V4';
        end
        
        if strcmp(dataT.array, 'nsp1')
            dataT.array = 'V1';
        elseif strcmp(dataT.array, 'nsp2')
            dataT.array = 'V4';
        end
        
        dataT.amap = aMap;
        %% plot psths
        plotGlassPSTH_rawVsClean(dataT,filename)
        %% determine reponsive channels
        dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
        [dataT.stimBlankChPvals,dataT.responsiveCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
        fprintf('responsive channels defined\n')
        %% get receptive field parameters
        % RF center is relative to fixation, not center of the monitor.
        dataT = callReceptiveFieldParameters(dataT);
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
            if sum(dataT.responsiveCh) >= 15
                outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
            else
                outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/bad/',dataT.array);
            end
            
            if ~exist(outputDir, 'dir')
                mkdir(outputDir)
            end
        elseif location == 0
            if sum(dataT.responsiveCh) >= 15
                outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
            else
                outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
            end
            if ~exist(outputDir, 'dir')
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
        fprintf('%s saved\n', saveName)
    catch ME
        fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
        failedFiles{failNdx} = filename;
        failedME{failNdx} = ME;
        failNdx = failNdx+1;
    end
end
failedFiles
toc