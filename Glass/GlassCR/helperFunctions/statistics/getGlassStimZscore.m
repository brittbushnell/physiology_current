function [conZscore, radZscore, noiseZscore, allStimZscore,blankZscore] = getGlassStimZscore(dataT)    
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
conZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.conSpikeCount,5));
radZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.radSpikeCount,5));
noiseZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.noiseSpikeCount,5));
%%
for ch = 1:96
    chStimSpikes = squeeze(dataT.allStimSpikeCount(ch,:));
    chBlankSpikes = squeeze(dataT.blankSpikeCount(ch,:));
    chSpikes = [chStimSpikes, chBlankSpikes];
    chMu = nanmean(chSpikes,'all');
    chStd = nanstd(chSpikes,0,'all');
    
    allSpikes = squeeze(dataT.allStimSpikeCount(ch,:));
    allStimZscore(ch,:) = (allSpikes - chMu)/chStd;
    
    blankSpikes = squeeze(dataT.blankSpikeCount(ch,:));
    blankZscore(ch,:) = (blankSpikes - chMu)/chStd;

    for dt = 1:numDots
        for dx = 1:numDxs
            for co = 1:numCoh
                %concentric
                conSpikes = squeeze(dataT.conSpikeCount(co,dt,dx,ch,:));
                conZscore(co,dt,dx,ch,1:length(conSpikes)) =  (conSpikes -  chMu)/chStd; %zscore(spikes);
                
                % radial
                radSpikes = squeeze(dataT.radSpikeCount(co,dt,dx,ch,:));                
                radZscore(co,dt,dx,ch,1:length(radSpikes)) =  (radSpikes -  chMu)/chStd; %zscore(spikes);
                
                if co == numCoh
                    % noise
                    nozSpikes = squeeze(dataT.noiseSpikeCount(co,dt,dx,ch,:));
                    noiseZscore(co,dt,dx,ch,1:length(nozSpikes)) =  (nozSpikes -  chMu)/chStd; %zscore(spikes);
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
