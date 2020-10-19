clear all
close all
clc
tic
%%
files = {
    % XT
    %     'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35_info';
    %     'XT_LE_GlassCoh_nsp2_March2019_all_thresh35_info';
    %     'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt_info';
    %     'XT_LE_GlassCoh_nsp1_March2019_all_thresh35_info';
    %
    %     'XT_RE_GlassTRCoh_nsp2_March2019_all_cleaned35_info';
    %     'XT_RE_GlassCoh_nsp2_March2019_all_thresh35_info';
    %     'XT_RE_GlassCoh_nsp1_March2019_all_thresh35_info';
    %     'XT_RE_GlassTRCoh_nsp1_March2019_all_thresh35_info';
    %
    %     % WV
    %     'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info';
    %     'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info';
    %     'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info';
    %     'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info';
    
    %     'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info';
    %     'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info';
    %     'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info';
    %     'WV_RE_glassCoh_nsp2_April2019_all_thresh35_info';
    %
    %     % WU
    %     'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info';
    %     'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info';
    %     'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info';
    %     'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info';
    %
    %     'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info';
    %     'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info';
    %     'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info';
    %     'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info';
   % 'XT_LE_GlassCoh_nsp1_20190324_005_thresh35_info';
    'XT_LE_GlassCoh_nsp1_20190325_001_thresh35_info';
    'XT_LE_GlassCoh_nsp1_20190325_002_thresh35_info';
    'XT_LE_GlassCoh_nsp1_20190325_004_thresh35_info';
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
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
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
    %dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
    [dataT.allStimBlankDprime, dataT.allStimBlankDprimeBootPerm, dataT.stimBlankDprimePerm, dataT.stimBlankSDPerm] = StimVsBlankPermutations_allStim_zScore(dataT.allStimZscore,dataT.blankZscore);
    [dataT.stimBlankChPvals, dataT.responsiveCh] = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    fprintf('responsive channels defined\n')
    %% setup for split-half
    if contains(dataT.programID,'TR')
        GlassChLast = permute(dataT.GlassTRZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
        numRepeats = size(dataT.GlassTRZscore,6);
        GlassReshape = reshape(GlassChLast,64,numRepeats,96); % reshape 64 = number of conditions.
        
        nozChLast = permute(dataT.noiseZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
        numRepeats = size(dataT.noiseZscore,6);
        nozReshape = reshape(nozChLast,64,numRepeats,96); % reshape 64 = number of conditions.
        
        zScoreReshape = cat(2,GlassReshape,nozReshape); % reshape 64 = number of conditions.
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
    %% do split half correlations and permutations
    [dataT.zScoreReliabilityIndex, dataT.zScoreReliabilityPvals,dataT.zScoreSplitHalfSigChs,dataT.zScoreReliabilityIndexPerm] = getHalfCorrPerm(zScoreReshape,filename);
    plotResponsePvalsVSreliabilityPvals_inStim(dataT)
    fprintf('Split-Half correlations computed and permuted %.2f minutes\n',toc/60)
    %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
    dataT.goodCh = logical(dataT.responsiveCh) | logical(dataT.zScoreSplitHalfSigChs);
    %% plot PSTHs
    if length(dataT.inStim) > 96 % running on a single session rather than merged data
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/singleSession/',dataT.animal,dataT.programID,dataT.array);
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%/%s/PSTH/',dataT.animal,dataT.programID,dataT.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/%/%s/PSTH/',dataT.animal,dataT.programID,dataT.array);
        end
    end
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    %% plot LE
    figure;
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 800])
    set(gcf,'PaperOrientation','Landscape');
    for ch = 1:96
        
        subplot(dataT.amap,10,10,ch)
        hold on;
        dataT.goodCh(ch);
        
        LEcoh = (dataT.coh == 1);
        LEnoiseCoh = (dataT.coh == 0);
        LEcohNdx = logical(LEcoh + LEnoiseCoh);
        
        if dataT.goodCh(ch) == 1
            
            blankResp = nanmean(smoothdata(dataT.bins((dataT.numDots == 0), 1:35 ,ch),'gaussian',3))./0.01;
            stimResp = nanmean(smoothdata(dataT.bins((LEcohNdx), 1:35 ,ch),'gaussian',3))./0.01;
            plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
            plot(1:35,stimResp,'-k','LineWidth',2);
            
            title(ch)
        else
            axis off
        end
        set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
        ylim([0 inf])
    end
    
    suptitle({sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye);...
        sprintf(sprintf('%s run %s', dataT.date, dataT.runNum))});
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_PSTHstimVBlank'];
    print(gcf, figName,'-dpdf','-fillpage')
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
    %% clean up workspace
    clearvars -except files fi nameEnd numPerm failedFiles failNdx numBoot location holdout
end