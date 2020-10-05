function [GlassTRZscore,allStimZscore, blankZscore, noiseZscore] = getGlassTRStimZscore(dataT)
% this function uses the spike counts to compute zScored response rates in
% tranlsational Glass experiments.
[numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
GlassTRZscore = nan(numOris, numCoh, numDots, numDxs, 96, size(dataT.GlassTRSpikeCount,6));
noiseZscore = nan(numOris, numCoh,numDots, numDxs, 96, size(dataT.noiseSpikeCount,6));
%%
% (or,co,ndot,dx,ch,:)


for ch = 1:96
    chStimSpikes = squeeze(dataT.allStimSpikeCount(ch,:));
    chBlankSpikes = squeeze(dataT.blankSpikeCount(ch,:));
    chSpikes = [chStimSpikes, chBlankSpikes];
    chMu = nanmean(chSpikes,'all');
    chStd = nanstd(chSpikes,0,'all');
    
    allSpikes = squeeze(dataT.allStimSpikeCount(ch,:));  
    allStimZscore(ch,:) = (allSpikes -  chMu)/chStd;
    
    blankSpikes = squeeze(dataT.blankSpikeCount(ch,:));
    blankZscore(ch,:) = (blankSpikes -  chMu)/chStd;
    

    for dt = 1:numDots
        for dx = 1:numDxs
            for co = 1:numCoh
                for or = 1:numOris
                    spikes = squeeze(dataT.GlassTRSpikeCount(or,co,dt,dx,ch,:));
                    GlassTRZscore(or,co,dt,dx,ch,:) = (spikes -  chMu)/chStd; 
                    
                    if co == 1 && or == 1
                        noiseSpikes = squeeze(dataT.noiseSpikeCount(or,co,dt,dx,ch,:));
                        noiseZscore(or,co,dt,dx,ch,:) = (noiseSpikes -  chMu)/chStd;
                    end
                end
            end
        end
    end
end
%%
figure
subplot(2,2,1)
hold on
allZs = reshape(allStimZscore,1,numel(allStimZscore));
histogram(allZs,30,'Normalization','probability');
title ('z Scores across all stimuli and all chs')
ylim([0 0.5])

subplot(2,2,2)
hold on
allSpikes = reshape(dataT.allStimSpikeCount,1,numel(dataT.allStimSpikeCount));
histogram(allSpikes,30,'Normalization','probability')
title('spike counts across all stimuli and all chs')
ylim([0 0.5])

subplot(2,2,3)
hold on
blankZs = reshape(blankZscore,1,numel(blankZscore));
histogram(blankZs,30,'Normalization','probability');
title ('z Scores for blank screen across all chs')
ylim([0 0.5])

subplot(2,2,4)
hold on
blankSpikes = reshape(dataT.blankSpikeCount,1,numel(dataT.blankSpikeCount));
histogram(blankSpikes,30,'Normalization','probability')
title('spike counts during blank screen across all chs')
ylim([0 0.5])

suptitle({sprintf('%s %s %s %s spike count and zscore distributions',dataT.animal,dataT.eye, dataT.array, dataT.programID);...
    sprintf('%s run %s',dataT.date, dataT.runNum')})
%% 
location = determineComputer;
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/%s/%s/',dataT.animal, dataT.programID, dataT.array,dataT.eye,dataT.date2);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/spikeZscoreDists/%s/%s/',dataT.animal, dataT.programID, dataT.array,dataT.eye,dataT.date2);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)

figName = [dataT.animal,'_',dataT.eye,'_', dataT.array,'_',dataT.programID,'_',dataT.date2,'_spikeZscoreDist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
