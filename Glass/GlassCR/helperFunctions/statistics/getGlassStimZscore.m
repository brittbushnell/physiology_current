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
    for dt = 1:numDots
        for dx = 1:numDxs
            for co = 1:numCoh
                %concentric
                spikes = squeeze(dataT.conSpikeCount(co,dt,dx,ch,:));
                spikes(isnan(spikes)) = [];
                
                conZscore(co,dt,dx,ch,1:length(spikes)) = zscore(spikes);
                
                % radial
                spikes = squeeze(dataT.radSpikeCount(co,dt,dx,ch,:));
                spikes(isnan(spikes)) = [];
                
                radZscore(co,dt,dx,ch,1:length(spikes)) = zscore(spikes);
                
                if co == numCoh
                    % noise
                    spikes = squeeze(dataT.noiseSpikeCount(co,dt,dx,ch,:));
                    spikes(isnan(spikes)) = [];
                    
                    noiseZscore(co,dt,dx,ch,1:length(spikes)) = zscore(spikes);
                end
                
            end
        end
    end
end