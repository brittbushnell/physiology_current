clear 
close all
tic
%%
files = {
    'XT_RE_radFreqLowSF_nsp1_20181217_002_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqLowSF_nsp1_20181217_003_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqLowSF_nsp1_20181217_004_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqLowSF_nsp1_20181217_005_thresh35_ogcorrupt_info.mat'; % ONLY 2 REPEATS

    'XT_LE_RadFreqLowSF_nsp1_20181211_001_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSF_nsp1_20181211_002_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSF_nsp1_20181213_001_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSF_nsp1_20181213_002_thresh35_ogcorrupt_info.mat';

    'XT_RE_radFreqHighSF_nsp1_20181227_001_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqHighSF_nsp1_20181228_001_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqHighSF_nsp1_20181228_002_thresh35_ogcorrupt_info.mat';
    'XT_RE_radFreqHighSF_nsp1_20181231_001_thresh35_ogcorrupt_info.mat';

    'XT_LE_radFreqHighSF_nsp1_20190102_001_thresh35_ogcorrupt_info.mat';
    'XT_LE_radFreqHighSF_nsp1_20190102_002_thresh35_ogcorrupt_info.mat';
    'XT_LE_radFreqHighSF_nsp1_20190103_001_thresh35_ogcorrupt_info.mat';
    'XT_LE_radFreqHighSF_nsp1_20190103_002_thresh35_ogcorrupt_info.mat';

    'XT_RE_RadFreqLowSFV4_nsp1_20190301_002_thresh35_ogcorrupt_info.mat';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_001_thresh35_info.mat';
    'XT_RE_RadFreqLowSFV4_nsp1_20190228_002_thresh35_info.mat';
    'XT_RE_RadFreqLowSFV4_nsp1_20190301_001_thresh35_info.mat';

    'XT_LE_RadFreqLowSFV4_nsp1_20190226_002_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSFV4_nsp1_20190226_003_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_001_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_002_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqLowSFV4_nsp1_20190227_003_thresh35_ogcorrupt_info.mat';

    'XT_RE_RadFreqHighSFV4_nsp1_20190304_002_thresh35_info.mat';
    'XT_RE_RadFreqHighSFV4_nsp1_20190305_002_thresh35_info.mat';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_001_thresh35_info.mat';
    'XT_RE_RadFreqHighSFV4_nsp1_20190306_002_thresh35_info.mat';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_002_thresh35_info.mat';

    'XT_LE_RadFreqHighSFV4_nsp1_20190306_003_thresh35_ogcorrupt_info.mat';
    'XT_LE_RadFreqHighSFV4_nsp1_20190307_001_thresh35_ogcorrupt_info.mat';
};
%%
location = determineComputer;
numBoot = 500;
numPerm = 500;
%%
for fi = 1:length(files)
    filename = files{fi};
    load(filename);
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    %% plot PSTHs
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
    fprintf('stim vs Blank permutations done %.2f\n minutes',round(toc/60,2))
    
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
        tmpZs = dataT.RFzScore{ch}(8:end,:)';
        stimZs(:,:,ch) = tmpZs;
        clear tmpZs;
    end

    [dataT.zScoreReliabilityIndex, dataT.zScoreReliabilityPvals,dataT.zScoreSplitHalfSigChs,dataT.zScoreReliabilityIndexPerm]...
        = getHalfCorrPerm(stimZs,filename,numPerm,numBoot);
    %%
    plotResponsePvalsVSreliabilityPvals(dataT)
    fprintf('Split-Half correlations computed and permuted %.2f minutes\n',round(toc/60,2))
    clear stimZs zStim zBlank 
end
