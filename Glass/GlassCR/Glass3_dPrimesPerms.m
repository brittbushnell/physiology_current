clear
close all
clc
tic
%%
files = {

    'XT_LE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns';
    'XT_LE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns';
    'XT_RE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns';
    'XT_RE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns';
    
    'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns';
    'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns';
    'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info3_goodRuns';
    'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns';
    
    'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns';
    'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns';
    'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns';
    'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns';
    };
%%
nameEnd = 'dPrime';
numPerm = 2000;
numBoot = 200;
subsample = 0;
holdout = .90;
plotFlag = 0;
plotHists = 0;
%%
location = determineComputer;

failedFile= {};
failedME = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %      try
    filename = files{fi};
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    
    
    %% test figure
    figure(3)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 500 600])
    set(gcf,'PaperOrientation','Landscape');
    
    subplot(4,1,1)
    hold on
    blank =  reshape(dataT.blankZscore,1,numel(dataT.blankZscore));
    histogram(blank,'BinWidth',0.5,'Normalization','probability','FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.4)
    bMed = nanmedian(blank);
    plot([bMed, bMed],[0,0.28],'k')
    xlim([-5 5])
    ylim([0 0.3])
    title('blank')
    set(gca,'box','off','tickdir','out')
    
    subplot(4,1,2)
    hold on
    cons = reshape(dataT.conZscore,1,numel(dataT.conZscore));
    histogram(cons,'BinWidth',0.5,'Normalization','probability','FaceColor',[0.7 0 0.7],'FaceAlpha',0.4)
    cMed = nanmedian(cons);
    plot([cMed, cMed],[0,0.28],'k')
    xlim([-5 5])
    ylim([0 0.3])
    title('concentric')
    set(gca,'box','off','tickdir','out')
    
    subplot(4,1,3)
    hold on
    rads = reshape(dataT.radZscore,1,numel(dataT.radZscore));
    histogram(rads,'BinWidth',0.5,'Normalization','probability','FaceColor',[0 0.6 0.2],'FaceAlpha',0.4)
    rMed = nanmedian(rads);
    plot([rMed, rMed],[0,0.28],'k')
    xlim([-5 5])
    ylim([0 0.3])
    title('radial')
    set(gca,'box','off','tickdir','out')
    
    clear t
    subplot(4,1,4)
    hold on
    noise =  reshape(dataT.noiseZscore(1,:,:,:,:),1,numel(dataT.noiseZscore(1,:,:,:,:)));
    histogram(noise,'BinWidth',0.5,'Normalization','probability','FaceColor',[1 0.5 0.1],'FaceAlpha',0.4)
    nMed = nanmedian(noise);
    plot([nMed, nMed],[0,0.28],'k')
     title('noise');
%     t.Position(3) = t.Position(3) - 0.005;
    xlim([-5 5])
    ylim([0 0.3])
    set(gca,'box','off','tickdir','out')
    
    xlabel('Z score')
    ylabel('probability')
    suptitle(sprintf('%s %s %s zscore distributions by stimulus type',dataT.animal, dataT.eye, dataT.array))
    
    %%
    if location == 0
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/',dataT.animal, dataT.programID, dataT.array);
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
    else
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/',dataT.animal, dataT.programID, dataT.array);
        if ~exist(figDir,'dir')
            mkdir(figDir)
        end
    end
    cd(figDir)
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_zScoresByStim_',dataT.programID,'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
    %% get real and permuted stimulus d's
    [dataT.conBlankDprime,dataT.radBlankDprime, dataT.noiseBlankDprime] = GlassVsBlankDPrimes_zscore(dataT,numBoot, holdout);
    dataT = GlassVsBlankDPrimes_zscore_perm(dataT,numBoot, holdout);
    
    fprintf('real dPrimes computed %.2f hours \n',toc/3600)
    %% do stim blank permutation tests
    [dataT.radBlankDprimePvals,dataT.radBlankDprimeSig] = glassGetPermutationStats_coh(dataT.radBlankDprime,dataT.radBlankDprimeBootPerm,dataT,'radial vs blank permutation test',plotHists);
    [dataT.conBlankDprimePvals,dataT.conBlankDprimeSig] = glassGetPermutationStats_coh(dataT.conBlankDprime,dataT.conBlankDprimeBootPerm,dataT,'concentric vs blank permutation test',plotHists);
    [dataT.noiseBlankDprimePvals,dataT.noiseBlankDprimeSig] = glassGetPermutationStats_coh(dataT.noiseBlankDprime,dataT.noiseBlankDprimeBootPerm,dataT,'noise vs blank permutation test',plotHists);
    
    fprintf('stim vs blank tests done %d  hours \n',toc/3600)
    %% coherence permutations
    [dataT.conNoiseDprime,dataT.radNoiseDprime,dataT.conRadDprime] = GlassVsNoiseDPrimes_zscore(dataT,numBoot, holdout);
    [dataT] = GlassVsNoiseDPrimes_zscore_perm(dataT,numBoot, holdout);
    
    fprintf('permuted vaules for stim vs noise done %.2f hours \n',toc/3600)
    %% pattern vs noise and con vs rad permutation tests
    if contains(filename,'XT')
    [dataT.radNoiseDprimePvals,dataT.radNoiseDprimeSig] = glassGetPermutationStats(squeeze(dataT.radNoiseDprime),squeeze(dataT.radNoiseDprimeBootPerm),dataT,'radial vs noise permutation test',plotHists);
    [dataT.conNoiseDprimePvals,dataT.conNoiseDprimeSig] = glassGetPermutationStats(squeeze(dataT.conNoiseDprime),squeeze(dataT.conNoiseDprimeBootPerm),dataT,'concentric vs noise permutation test',plotHists);
    [dataT.conRadDprimePvals,  dataT.conRadDprimeSig]   = glassGetPermutationStats(squeeze(dataT.conRadDprime),  squeeze(dataT.conRadDprimeBootPerm),dataT,'concentric vs radial permutation test',plotHists);     
    else
    [dataT.radNoiseDprimePvals,dataT.radNoiseDprimeSig] = glassGetPermutationStats_coh(dataT.radNoiseDprime,dataT.radNoiseDprimeBootPerm,dataT,'radial vs noise permutation test',plotHists);
    [dataT.conNoiseDprimePvals,dataT.conNoiseDprimeSig] = glassGetPermutationStats_coh(dataT.conNoiseDprime,dataT.conNoiseDprimeBootPerm,dataT,'concentric vs noise permutation test',plotHists);
    [dataT.conRadDprimePvals,  dataT.conRadDprimeSig]   = glassGetPermutationStats_coh(dataT.conRadDprime,  dataT.conRadDprimeBootPerm,dataT,'concentric vs radial permutation test',plotHists);
    end
    fprintf('stim vs noise and con vs rad tests done %d  hours \n',toc/3600)
    %% get homogeneity
    dataT = ChiSquareHomogeneity(dataT,0.1);
    %% rank order of stim responses
    dataT = rankGlassSelectivitiesBlank(dataT);
    %    dataT = numSigGlassComparisons(dataT);
    %% plot
    %     close all
    %     clc
    %     if plotOther == 1
    plotGlass_GlassRankingsDistBlank(dataT) % figure 1 and 2
    plotGlassPSTHs_stimParams_allCh(dataT)
    plotGlass_callTriplotGray(dataT)
    plotGlass_CoherenceResps(dataT)
    %plotGlass3D_dPrimesVblank_grayScale(dataT) %figure 8
    %     end
    %% save data
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/dPrimePerm/%s/',dataT.array,dataT.animal);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/dPrimePerm/%s/',dataT.array,dataT.animal);
        if ~exist(outputDir,'dir')
            mkdir(outputDir)
        end
    end
    
    cd(outputDir)
    
    if contains(filename,'RE')
        data.RE = dataT;
    else
        data.LE = dataT;
    end
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data','-v7.3');
    fprintf('%s saved\n', saveName)
    %%
    clear dataT
    fprintf('file %s done %.2f hours \n',filename, toc/3600)
    %         catch ME
    %             failedFile{failNdx} = filename;
    %             failedME{failNdx} = ME;
    %             failNdx = failNdx+1;
    %             fprintf('file failed \n')
    %         end
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlass2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end
toc/3600
