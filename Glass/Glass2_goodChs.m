clear all
close all
clc
tic
%%
files = {
    'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info';
    'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info';
    };
%%
nameEnd = 'goodRuns';
numPerm = 2000;
numBoot = 1000;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    %%
    %     try
    filename = files{fi};
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
    %% determine reponsive channels
    dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
    [dataT.stimBlankChPvals,dataT.responsiveCh] = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    fprintf('responsive channels defined\n')
    %% do split half correlations and permutations
        if contains(dataT.programID,'TR')
            zScored_chLast = permute(dataT.GlassTRZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
            numRepeats = size(dataT.GlassTRZscore,6);
            zScoreReshape = reshape(zScored_chLast,64,numRepeats,96); % reshape 64 = number of conditions.
        else
            conZchLast = permute(dataT.conZscore,[1 2 3 5 4]);
            numRepeats = size(dataT.conZscore,5);
            conReshape = reshape(conZchLast,16,numRepeats,96);
            
            radZchLast = permute(dataT.radZscore,[1 2 3 5 4]);
            numRepeats = size(dataT.radZscore,5);
            radReshape = reshape(radZchLast,16,numRepeats,96);            
            
            nozZchLast = permute(dataT.noiseZscore,[1 2 3 5 4]);
            numRepeats = size(dataT.noiseZscore,5);
            nozReshape = reshape(nozZchLast,16,numRepeats,96);
            
            zScoreReshape = cat(2,conReshape,radReshape,nozReshape);
        end
   % version using spike counts instead of zscore 
    if contains(dataT.programID,'TR')
        spikeCount_chLast = permute(dataT.GlassTRSpikeCount,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
        numRepeats = size(dataT.GlassTRSpikeCount,6);
        spikeCountReshape = reshape(spikeCount_chLast,64,numRepeats,96); % reshape into a vector. 64 = number of conditions.
    else
        % fill this in with the appropriately named things
        conSCchLast = permute(dataT.con,[1 2 3 5 4]);
        numRepeats = size(dataT.conZscore,5);
        conSCReshape = reshape(conZchLast,16,numRepeats,96);
        
        radZchLast = permute(dataT.radZscore,[1 2 3 5 4]);
        numRepeats = size(dataT.radZscore,5);
        radReshape = reshape(radZchLast,16,numRepeats,96);
        
        nozZchLast = permute(dataT.noiseZscore,[1 2 3 5 4]);
        numRepeats = size(dataT.noiseZscore,5);
        nozReshape = reshape(nozZchLast,16,numRepeats,96);
        
        zScoreReshape = cat(2,conReshape,radReshape,nozReshape);
    end
    %%
    [dataT.zScoreReliabilityIndex, dataT.zScoreReliabilityPvals,dataT.zScoreSplitHalfSigChs,dataT.zScoreReliabilityIndexPerm] = getHalfCorrPerm(zScoreReshape);
    [dataT.spikeCountReliabilityIndex, dataT.spikeCountReliabilityPvals,dataT.spikeCountSplitHalfSigChs,dataT.spikeCountReliabilityIndexPerm] = getHalfCorrPerm(spikeCountReshape);
    
    % 
    plotResponsePvalsVSreliabilityPvals(dataT.stimBlankChPvals, dataT.zScoreReliabilityPvals)
    plotResponsePvalsVSreliabilityPvals(dataT.stimBlankChPvals, dataT.spikeCountReliabilityPvals)
    fprintf('Split-Half correlations computed and permuted %.2f minutes',toc/60)
    %%
    if location == 0
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal, dataT.programID, dataT.array);
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
    else
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal, dataT.programID, dataT.array);
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
    end
    cd(figDir)
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_HalfSplitPermTest_',dataT.date2,'_',dataT.runNum,'.pdf'];
    print(figure(2), figName,'-dpdf','-fillpage')
    %% plot PSTH showing what chns are included and what isn't
%    plotGlassPSTH_inclusionMet(dataT)
    %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
    dataT.goodCh = logical(dataT.responsiveCh) | logical(dataT.splitHalfSigChs);
    %% save good data
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/goodChs/',dataT.array);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/goodChs/',dataT.array);
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
    
    shortName = strrep(filename,'.mat','');
    saveName = [outputDir shortName '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n  run time: %.2f minutes\n\n', saveName, toc/60)
    
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failNdx = failNdx+1;
    %         failedFiles{failNdx,1} = filename;
    %         failedME{failNdx,1} = ME;
    %     end
    
    clear dataT
end