clear
close all
clc
tic
%%

files = {
    'WU_RE_radFreqLoc1_nsp2_June2017_info';
    'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
    
    'WU_RE_radFreqLoc1_nsp1_June2017_info';
    'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info.mat';
    };
%%
plotHeat = 0; %change to 1 if you do want to do the heatmaps

nameEnd = 'goodCh';
numPerm = 200;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
location = determineComputer;
failedFiles = {};
failNdx = 0;
%%
for fi = 1:length(files)
    %%
    %try
    filename = files{fi};
    fparts = strsplit(filename,'_');
    fprintf('\n *** Analyzing %s file %d/%d ***\n',filename,fi,length(files));
    
    if length(fparts) < 7
        dataT = load(filename);
    else
        load(filename);
        if contains(filename,'RE')
            dataT = data.RE;
        else
            dataT = data.LE;
        end
    end
    %% plot receptive fields relative to stimulus locations
    [stimLoc] = plotRadFreqLoc_relRFs(dataT);
    %% plot PSTH
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/PSTH/',dataT.animal,dataT.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/PSTH/',dataT.animal,dataT.array);
    end
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    
    figure(2);
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1200 900])
    set(gcf,'PaperOrientation','Landscape');
    for ch = 1:96
        
        subplot(dataT.amap,10,10,ch)
        hold on;
        
        blankResp = nanmean(smoothdata(dataT.bins((dataT.rf == 10000), 1:35 ,ch),'gaussian',3))./0.01;
        stimResp = nanmean(smoothdata(dataT.bins((dataT.rf ~= 10000), 1:35 ,ch),'gaussian',3))./0.01;
        plot(1:35,blankResp,'Color',[0.2 0.2 0.2],'LineWidth',0.5);
        plot(1:35,stimResp,'-k','LineWidth',2);
        
        title(ch)
        
        set(gca,'Color','none','tickdir','out','XTickLabel',[],'FontAngle','italic');
        ylim([0 inf])
    end
    
    fname = strrep(filename,'_',' ');
    suptitle({sprintf('%s %s %s %s stim vs blank', dataT.animal, dataT.array, dataT.programID, dataT.eye);...
        sprintf(sprintf('%s',string(fname)))});
    
    fname2 = strrep(filename,'.mat','');
    figName = [fname2,'_PSTHstimVBlank.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
    %% determine visually responsive channels
    % input needs to be (ch x trials)
    zBlank = nan(96,9000);
    zStim = nan(96,9000);
    
    for ch = 1:96
        zStimT = dataT.RFzScore{ch}(8:end,:);
        zBlankT = dataT.blankZscore{ch}(8:end);
        
        zStim(ch,1:numel(zStimT)) = reshape(zStimT,[1,numel(zStimT)]);
        zBlank(ch,1:numel(zBlankT)) = zBlankT;
    end

    [dataT.allStimBlankDprime, dataT.allStimBlankDprimeBootPerm, dataT.stimBlankDprimePerm, dataT.stimBlankSDPerm]...
        = StimVsBlankPermutations_allStim_zScore(zStim,zBlank,1000,0.75);
    fprintf('stim vs Blank permutations done %.2f\n',toc/60)
    
    [dataT.stimBlankChPvals, dataT.responsiveCh]...
        = getPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm,2,1);
    fprintf('responsive channels defined\n')
    
    %% do split half correlations and permutations
    % needs to be (conditions x repeats x channels)
    for ch = 1:96
        stimZs(:,:,ch) = dataT.RFzScore{ch}(8:end,:)';
    end

    [dataT.zScoreReliabilityIndex, dataT.zScoreReliabilityPvals,dataT.zScoreSplitHalfSigChs,dataT.zScoreReliabilityIndexPerm]...
        = getHalfCorrPerm(stimZs,filename);
    plotResponsePvalsVSreliabilityPvals(dataT)
    fprintf('Split-Half correlations computed and permuted %.2f minutes\n',toc/60)
    %% Define truly good channels that pass either the visually responsive OR split-half reliability metric
    dataT.goodCh = logical(dataT.responsiveCh) | logical(dataT.zScoreSplitHalfSigChs);
    fprintf('%d channels passed inclusion criteria\n',sum(dataT.goodCh))
    %% make heatmaps
    if plotHeat == 1
        makeRadfreqHeatmaps(dataT)
    end
    %% save data
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/info/',dataT.array);
    end
    
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
    
    if contains(filename,'LE')
        data.LE = dataT;
        data.RE = [];
    else
        data.RE = dataT;
        data.LE = [];
    end
    
    saveName = [outputDir fname2 '_' nameEnd '.mat'];
    save(saveName,'data');
    fprintf('%s saved\n\n',saveName)
    %% clean up workspace
    clearvars -except files fi nameEnd numPerm failedFiles failNdx numBoot location holdout
end