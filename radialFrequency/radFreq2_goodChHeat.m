clear
close all
clc
tic
%%

files = {
%     % WU loc1
%     'WU_RE_radFreqLoc1_nsp2_June2017_info';
%     'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
    
    'WU_RE_radFreqLoc1_nsp1_June2017_info';
    'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info.mat';
    % WU loc 2
%     'WU_RE_RadFreqLoc2_nsp1_July2017_info';
%     'WU_RE_RadFreqLoc2_nsp2_July2017_info';
%     
%     'WU_LE_RadFreqLoc2_nsp1_July2017_info';
%     'WU_LE_RadFreqLoc2_nsp2_July2017_info';
%     
%     % WV
%     'WV_LE_RadFreqHighSF_nsp2_March2019';
%     'WV_LE_RadFreqHighSF_nsp1_March2019';
%     
%     'WV_RE_RadFreqHighSF_nsp1_March2019';
%     'WV_RE_RadFreqHighSF_nsp2_March2019';
%     
%     'WV_LE_RadFreqLowSF_nsp2_March2019';
%     'WV_LE_RadFreqLowSF_nsp1_March2019';
%     
%     'WV_RE_RadFreqLowSF_nsp2_March2019';
%     'WV_RE_RadFreqLowSF_nsp1_March2019';
%     
%     % XT
%     'XT_RE_radFreqLowSF_nsp2_Dec2019_info';
%     'XT_RE_radFreqLowSF_nsp1_Dec2019_info';
%     
%     'XT_LE_RadFreqLowSF_nsp2_Dec2018_info';
%     'XT_LE_RadFreqLowSF_nsp1_Dec2018_info';
%     
%     'XT_RE_radFreqHighSF_nsp2_Dec2018_info';
%     'XT_RE_radFreqHighSF_nsp1_Dec2018_info';
%     
%     'XT_LE_radFreqHighSF_nsp2_Jan2019_info';
%     'XT_LE_radFreqHighSF_nsp1_Jan2019_info';
%     
%     'XT_RE_RadFreqLowSFV4_nsp2_Feb2019_info';
%     'XT_RE_RadFreqLowSFV4_nsp1_Feb2019_info';
%     
%     'XT_LE_RadFreqLowSFV4_nsp2_Feb2019_info';
%     'XT_LE_RadFreqLowSFV4_nsp1_Feb2019_info';
%     
%     'XT_LE_RadFreqHighSFV4_nsp2_March2019_info';
%     'XT_LE_RadFreqHighSFV4_nsp1_March2019_info';
%     
%     'XT_RE_RadFreqHighSFV4_nsp2_March2019_info';
%     'XT_RE_RadFreqHighSFV4_nsp1_March2019_info';
    };
%%
plotHeat = 1; %change to 1 if you do want to do the heatmaps

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
    dataT.amap = getBlackrockArrayMap(filename);
    %% plot receptive fields relative to stimulus locations
    [stimLoc] = plotRadFreqLoc_relRFs(dataT);
    %% plot PSTH
    
    if location == 1
        if contains(dataT.animal,'WU')
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/PSTH/',dataT.animal,dataT.array);
        elseif contains(dataT.programID,'low','IgnoreCase')
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/PSTH/',dataT.animal,dataT.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/PSTH/',dataT.animal,dataT.array);
        end
        
    elseif location == 0        
        if contains(dataT.animal,'WU')
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/PSTH/',dataT.animal,dataT.array);
        elseif contains(dataT.programID,'low','IgnoreCase')
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/PSTH/',dataT.animal,dataT.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/PSTH/',dataT.animal,dataT.array);
        end
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
    fprintf('%d responsive channels defined\n', sum(dataT.responsiveCh))
    
    if sum(dataT.responsiveCh) == 0
        fprintf('There were no responsive channels found, something''s funky')
        keyboard
    end
    
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
        makeRadfreqHeatmaps(dataT,stimLoc)
    end
    %% save data
    if location == 1
        outputDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/ArrayData/matFiles/%s/radialFrequency/goodCh/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/radialFrequency/goodCh/',dataT.array);
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
    clearvars -except files fi nameEnd numPerm failedFiles failNdx numBoot location holdout plotHeat
end