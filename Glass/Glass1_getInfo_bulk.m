% First step for all Glass pattern analysis, and run on each individual
% recording file.
%
% This program will go through the rethresholded data folder and run
% analysis on every file contained within,
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
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for an = 1:3
    if an == 1
        monk = 'WU';
    elseif an == 2
        monk = 'WV';
    else
        monk = 'XT';
    end
    for ey = 1:2
        if ey == 1
            eye = 'LE';
        else
            eye = 'RE';
        end
        for ar = 1:2
            if ar == 1
                area = 'V4';
            else
                area = 'V1';
            end
            %%
            if location == 0
                dataDir = sprintf('~/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            else
                dataDir = sprintf('/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/png/%s/%s/Glass/%s/',monk,area,eye);
            end
            cd(dataDir);
            
            tmp = dir;
            ndx = 1;
            corNdx = 1;
            filesT = {};
            filesC = {};
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'.mat')
                    if strcmp(tmp(t).name,'WU_LE_GlassTR_nsp2_20170822_002_thresh35.mat')
                    elseif contains(tmp(t).name,'_og')
                        % make a list of all of the files that have
                        % been realigned
                        filesC{corNdx,1} = tmp(t).name;
                        corNdx = corNdx+1;
                    else
                        % list of un-aligned files
                        filesT{ndx,1} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
            end
            
            for c = 1:length(filesC)
                shortName = strrep(filesC{c,1},'_ogcorrupt','');
                %remove from the list any _thresh35 files that were
                %later realigned.  No reason to run through everything
                %on all of them.
                filesT(strcmp(shortName,filesT)) = [];
            end
            
            
            files = cat(1,filesC,filesT);
            
            if location == 0
                listDir ='~/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/';
            else
                listDir = '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/';
            end
            
            mtxSaveName = [listDir,monk,'_',eye,'_',area,'FileList.mat'];
            save(mtxSaveName,'files')
            
            clear tmp
            clear ndx
            %%
            for fi = 1:length(files)
                %% Get basic information about experiments
              %  try
                    
                    filename = files{fi};
                    
                    dataT = load(filename);
                    
                    aMap = getBlackrockArrayMap(filename);
                    
                    tmp = strsplit(filename,'_');
                    dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4};
                    dataT.date2 = tmp{5}; dataT.runNum = tmp{6}; dataT.reThreshold = tmp{7}; dataT.date = convertDate(dataT.date2);
                    
                    if strcmp(array, 'nsp1')
                        dataT.array = 'V1';
                    elseif strcmp(array, 'nsp2')
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
                    tmp = strsplit(filename,'_');
                    dataT.animal = tmp{1};  dataT.eye = tmp{2}; dataT.programID = tmp{3}; array = tmp{4};
                    dataT.date2 = tmp{5}; dataT.runNum = tmp{6}; dataT.reThreshold = tmp{7}; dataT.date = convertDate(dataT.date2);
                    
                    if strcmp(array, 'nsp1')
                        dataT.array = 'V1';
                    elseif strcmp(array, 'nsp2')
                        dataT.array = 'V4';
                    end
                    
                    dataT.amap = aMap;
                    %% convert dx to a meaningful measurement
                    dataT.dxDeg = 8.*dataT.dx;
                    %% determine reponsive channels
                    dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
                    [dataT.stimBlankChPvals,dataT.responsiveCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
                    
                    if sum(dataT.responsiveCh) >= 15
                        goodFlag = 1;
                    else
                        goodFlag = 0;
                        fprintf('%s only has %d responsive channels',filename, sum(dataT.responsiveCh))
                    end
                    fprintf('responsive channels defined\n')                    
                    %% plot stim vs blank PSTH to look for timing funkiness
                    if location == 1
                        plotGlassPSTH_rawVsClean(dataT,filename,goodFlag) % only run on Laca b/c she has all of the raw files
                    end
                    %% if there are not more than 15 responsive channels, save the file and move on
                    if goodFlag == 0
                        if location == 1
                            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/bad/',dataT.array);
                            if ~exist(outputDir, 'dir')
                                mkdir(outputDir)
                            end
                        elseif location == 0
                            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
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
                        
                        saveName = [outputDir filename '_' nameEnd '_bad' '.mat'];
                        save(saveName,'data');
                        fprintf('%s saved\n  run time: %.2f minutes', saveName, toc/60)
                        
                    else
                        %% get receptive field parameters
                        % RF center is relative to fixation, not center of the monitor.
                        dataT = callReceptiveFieldParameters(dataT);
                        %% find channels whose receptive fields are within the stimulus bounds
                        [dataT.rfQuadrant] = getRFsinStim(dataT);
                        dataT.inStim = ~isnan(dataT.rfQuadrant); % want all channels whos RF center is within the stimulus bounds to be 1.
                        dataT.goodCh = dataT.responsiveCh & dataT.inStim;
                        fprintf('%d channels in the stimulus bounds \n%d responsive channels\n',sum(dataT.goodCh),sum(dataT.responsiveCh))
                        %% get spike counts, Zscore, and split half correlations
                        if contains(dataT.programID,'TR')
                            [dataT.GlassTRSpikeCount,dataT.NoiseTRSpikeCount,dataT.BlankTRSpikeCount,dataT.AllStimTRSpikeCount] = getGlassTRSpikeCounts(dataT);
                            [dataT.GlassTRZscore,dataT.GlassAllStimTRZscore] = getGlassStimZscore(dataT);
                            %[dataT.reliabilityIndex,dataT.splitHalfCorrBoots] = GlassTR_getHalfCorr(dataT);
                            dataT = GlassTR_getHalfCorrPerm(dataT);
                        else
                            [dataT.GlassSpikeCount,dataT.NoiseSpikeCount,dataT.BlankSpikeCount,dataT.AllStimSpikeCount] = getGlassCRSpikeCounts(dataT);
                            [dataT.GlassZscore,dataT.GlassAllStimZscore] = getGlassStimZscore(dataT);
                            [dataT.reliabilityIndex,dataT.split_half_correlation] = Glass_getHalfCorr(dataT);
                            dataT = Glass_getHalfCorrPerm(dataT);
                        end
                        fprintf('spike counts done, zscores computed, split-halves correlated \n')
                        %% plot PSTH showing what chns are included and what isn't
                        plotGlassPSTH_inclusionMet(dataT)
                        %% optional plots
                        if plotFlag == 1
                            if contains(dataT.programID,'TR')
                                plotGlassTR_spikeCounts(dataT)
                            else
                                
                            end
                        end
                        %% save good data
                        if location == 1
                            outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
                            if ~exist(outputDir, 'dir')
                                mkdir(outputDir)
                            end
                        elseif location == 0
                            outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/info/good/',dataT.array);
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
                        fprintf('%s saved\n  run time: %.2f minutes\n', saveName, toc/60)
                    end
%                 catch ME
%                     fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
%                     failNdx = failNdx+1;
%                     failedFiles{failNdx,1} = filename;
%                     failedME{failNdx,1} = ME;
%                 end
                clear dataT
            end
        end
    end
end



fprintf('\n####### %d files failed at some point #######\n',failNdx)
toc