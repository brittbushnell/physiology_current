function [GlassZscore] = getGlassStimZscore(dataT)
% (or,co,ndot,dx,ch,:)
if contains(dataT.programID,'TR')
    [numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
    
    for ch = 1:96
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        spikes = squeeze(dataT.RFinStimGlassTRSpikeCount(or,co,dt,dx,ch,:));
                        GlassZscore(or,co,dt,dx,ch,:) = zscore(spikes);
                    end
                end
            end
        end
    end
    
else
    [~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
    for ch = 1:96
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    spikes = squeeze(dataT.RFinStimGlassSpikeCount(co,dt,dx,ch,:));
                    GlassZscore(co,dt,dx,ch,:) = zscore(spikes);
                end
            end
        end
    end
end

