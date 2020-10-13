clear all
close all
clc
tic
%%
files = {
    'XT_LE_GlassCoh_nsp2_March2019_all_thresh35_info_goodRuns';
    };
%%
nameEnd = '';
numPerm = 200;
numBoot = 20;
subsample = 0;
holdout = .90;
plotFlag = 0;
plotHists = 1;
%%
location = determineComputer;

failedFile= {};
failedME = {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %  try
    filename = files{fi};
    load(filename);
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    %% test figure
    figure(3)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 500 600])
    set(gcf,'PaperOrientation','Landscape');
    
    subplot(4,1,1)
    blank =  reshape(dataT.blankZscore,1,numel(dataT.blankZscore));
    histogram(blank,'BinWidth',0.5,'Normalization','probability','FaceColor',[0.5 0.5 0.5],'FaceAlpha',0.4)
    xlim([-5 5])
    ylim([0 0.3])
    title('blank')
    set(gca,'box','off','tickdir','out')
    
    subplot(4,1,2)
    cons = reshape(dataT.conZscore,1,numel(dataT.conZscore));
    histogram(cons,'BinWidth',0.5,'Normalization','probability','FaceColor',[0.7 0 0.7],'FaceAlpha',0.4)
    xlim([-5 5])
    ylim([0 0.3])
    title('concentric')
    set(gca,'box','off','tickdir','out')
    
    subplot(4,1,3)
    rads = reshape(dataT.radZscore,1,numel(dataT.radZscore));
    histogram(rads,'BinWidth',0.5,'Normalization','probability','FaceColor',[0 0.6 0.2],'FaceAlpha',0.4)
    xlim([-5 5])
    ylim([0 0.3])
    title('radial')
    set(gca,'box','off','tickdir','out')
    
    subplot(4,1,4)
    noise =  reshape(dataT.noiseZscore,1,numel(dataT.noiseZscore));
    histogram(noise,'BinWidth',0.5,'Normalization','probability','FaceColor',[1 0.5 0.1],'FaceAlpha',0.4)
    title('noise')
    xlim([-5 5])
    ylim([0 0.3])
    set(gca,'box','off','tickdir','out')
    
    xlabel('Z score')
    ylabel('probability')
    suptitle('zscore distributions by stimulus type')
    
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
    %% get stim vs blank permutations
    %         dataT = GlassStimVsBlankPermutations_coh(dataT, numPerm, holdout);
    %
    %         fprintf('permuted values for stim vs blank done %.2f hours \n',toc/3600)
    %         %% coherence permutations
    %         dataT = GlassStimVsNoisePermutation_coh(dataT, numBoot, holdout);
    %         fprintf('permuted vaules for stim vs noise done %.2f hours \n',toc/3600)
    %% get latency
    % latency will have to be done on the raw data only, the cleaned data
    % is not reliable enough to do latency measurements on.
    
    %     dataT = getLatencies_Glass(dataT,numPerm,plotFlag,holdout);
    %     dataT = getLatencies_Glass_Permutation(dataT,numPerm,holdout);
    %
    %     dataT = getLatencies_Glass_byStim(dataT,numPerm,holdout);
    %     dataT = getLatencies_Glass_byStimPermutation(dataT,numPerm,holdout);
    %
    %     fprintf('latencies computed %.2f hours \n',toc/3600)
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
    %     catch ME
    %         failedFile{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %         fprintf('file failed \n')
    %     end
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlass2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end
toc/3600
