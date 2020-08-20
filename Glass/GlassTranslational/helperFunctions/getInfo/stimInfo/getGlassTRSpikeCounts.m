function [trSpikeCount,noiseSpikeCount,blankSpikeCount,stimSpikeCount] = getGlassTRSpikeCounts(dataT, goodCh)
% set goodCh to either dataT.responsiveCh or dataT.goodCh

[numOris,numDots,numDxs,numCoh,~,orientations,dots,dxs,coherences,~] = getGlassTRParameters(dataT);

% trSpikeCount = nan(numOris,numCoh,numDots,numDxs,96);
% stimSpikeCount = nan(numDots,numDxs,96);
% noiseSpikeCount = nan(numDots,numDxs,96);
% blankSpikeCount = nan(numDots,numDxs,96);
%%
for ch = 1:96
    if goodCh(ch) == 1
        startMean= 5;
        endMean  = 25;
        
        noiseNdx = (dataT.type == 0);
        linearNdx = (dataT.type == 3);
        blankNdx = (dataT.numDots == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for or = 1:numOris
                    for co = 1:numCoh
                        cohNdx = (dataT.coh == coherences(co));
                        dotNdx = (dataT.numDots == dots(ndot));
                        dxNdx = (dataT.dx == dxs(dx));
                        oriNdx = (dataT.rotation == orientations(or));
                        
                        linTrials = (linearNdx & dotNdx & dxNdx & oriNdx & cohNdx);
                        noiseTrials = (noiseNdx & dotNdx & dxNdx);
                        stimTrials = (dotNdx & dxNdx);
                        
                        trSpikeCount(or,co,ndot,dx,ch,:) = sum(dataT.bins(linTrials, (startMean:endMean) ,ch),2);
                        
                        if co == 1 && or == 1
                            noiseSpikeCount(ndot,dx,ch,:) = sum(dataT.bins(noiseTrials, startMean:endMean, ch),2);  
                            blankSpikeCount(ndot,dx,ch,:) = sum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                            stimSpikeCount(ndot,dx,ch,:) = sum(dataT.bins(stimTrials,(startMean:endMean) ,ch),2);
                        end
                    end
                end
            end
        end
    end
end


dataT.translationalSpikeCount = trSpikeCount;
dataT.stimSpikeCount = stimSpikeCount;
dataT.noiseSpikeCount = noiseSpikeCount;
dataT.noiseSpikeCount = blankSpikeCount;