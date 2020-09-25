function [GlassEachStimZscore,GlassAllStimZscore] = getGlassStimZscore(dataT)
% This code will work for either Concentric/radial patterns or
% translational.

% (or,co,ndot,dx,ch,:)
if contains(dataT.programID,'TR')
    [numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
    
    for ch = 1:96
        allSpikes = squeeze(dataT.AllStimTRSpikeCount(ch,:));
        GlassAllStimZscore(ch,:) = zscore(allSpikes);
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        spikes = squeeze(dataT.GlassTRSpikeCount(or,co,dt,dx,ch,:));
                        spikes(isnan(spikes)) = [];
                        GlassEachStimZscore(or,co,dt,dx,ch,:) = zscore(spikes);
                    end
                end
            end
        end
    end
    
else
    [~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
    for ch = 1:96
        allSpikes = squeeze(dataT.AllStimSpikeCount(ch,:));
        GlassAllStimZscore(ch,:) = zscore(allSpikes);
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    spikes = squeeze(dataT.GlassSpikeCount(co,dt,dx,ch,:));
                    spikes(isnan(spikes)) = [];
                    GlassEachStimZscore(co,dt,dx,ch,:) = zscore(spikes);
                end
            end
        end
    end
end

