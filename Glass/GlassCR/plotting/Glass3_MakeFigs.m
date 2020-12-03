% Glass3f_MakeFigs
% Once everything has gone through Glass3 and statistics are done, this is
% just fidgeting with the resulting figures.
clear
close all
clc
location = determineComputer;
%%
files = {
    
'XT_LE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
'XT_LE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';
'XT_RE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
'XT_RE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';

'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info3_goodRuns_dPrime';
'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';

'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
};
%%
for fi = 1:length(files)
    fname = files{fi};
    load(fname);
    
    if contains(fname,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    %%
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
    
    if location == 0
        figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/',dataT.animal, dataT.programID, dataT.array);
    else
        figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/',dataT.animal, dataT.programID, dataT.array);
    end
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_zScoresByStim_',dataT.programID,'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
    %%
    plotResponsePvalsVSreliabilityPvals(dataT)
    plotGlass_GlassRankingsDistBlank(dataT) % figure 1 and 2
    plotGlassPSTHs_stimParams_allCh(dataT)
    plotGlass_callTriplotGray(dataT)
    if ~contains(fname,'XT')
        plotGlass_CoherenceResps(dataT)
    end
end