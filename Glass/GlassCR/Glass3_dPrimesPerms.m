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
numPerm = 2000;
numBoot = 200;
subsample = 0;
holdout = .90;
plotFlag = 0;
%%
location = determineComputer;

failedFile= {};
failedME = {};
failNdx = 1;
%%
for fi = 1:size(files,1)
    %% Get basic information about experiments
    % try
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
    %% get stimulus d'
    [dataT.conBlankDprime,dataT.radBlankDprime,dataT.noiseBlankDprime] = GlassVsBlankDPrimes_zscore(dataT,numBoot, holdout);
    
    %% get stimVs blank permutations
    
    %% coherence permutations
    
    %%
    %%
    %     catch ME
    %         fprintf('%s did not work. \nError message: %s \n',filename,ME.message)
    %         failNdx = failNdx+1;
    %         failedFiles{failNdx,1} = filename;
    %         failedME{failNdx,1} = ME;
    %     end
end