function [conZscore, radZscore, noiseZscore, GlassAllStimZscore] = getGlassStimZscore(dataT)    
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
conZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.conSpikeCount,5));
radZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.radSpikeCount,5));
noiseZscore = nan(numCoh, numDots, numDxs, 96, size(dataT.noiseSpikeCount,5));
%%
for ch = 1:96
    allSpikes = squeeze(dataT.AllStimSpikeCount(ch,:));
    GlassAllStimZscore(ch,:) = zscore(allSpikes);
    chMu = nanmean(allSpikes,'all');
    chStd = nanstd(allSpikes,0,'all');
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