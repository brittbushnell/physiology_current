function [trSpikeCount,noiseSpikeCount,blankSpikeCount,stimSpikeCount] = getGlassTRSpikeCounts(dataT)
% get spike counts for all unique stimuli across all channels

[numOris,numDots,numDxs,numCoh,~,orientations,dots,dxs,coherences,~] = getGlassTRParameters(dataT);

cohNdx = (dataT.coh == 1);
dotNdx = (dataT.numDots == 400);
dxNdx = (dataT.dx == 0.03);
oriNdx = (dataT.rotation == 0);

linearNdx = (dataT.type == 3);
noiseNdx = (dataT.type == 0);
blankNdx = (dataT.numDots == 0);
stimTrials = (dataT.numDots >0);

linTrials = (linearNdx & dotNdx & dxNdx & oriNdx & cohNdx);
noiseTrials = (noiseNdx & dotNdx & dxNdx);


trSpikeCount = nan(numOris, numCoh, numDots, numDxs, 96, sum(linTrials)+5);
noiseSpikeCount = nan(numDots, numDxs, 96, sum(noiseTrials)+5);
%%
for ch = 1:96
    startMean= 5;
    endMean  = 25;
    
    
    blankSpikeCount(ch,:) = sum(dataT.bins(blankNdx, startMean:endMean, ch),2);
    stimSpikeCount(ch,:) = sum(dataT.bins(stimTrials,(startMean:endMean) ,ch),2);
    
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
                    
                    
                    trSpikeCount(or,co,ndot,dx,ch,1:sum(linTrials)) = sum(dataT.bins(linTrials, (startMean:endMean) ,ch),2);
                    
                    if co == 1 && or == 1
                        noiseSpikeCount(ndot,dx,ch,1:sum(noiseTrials)) = sum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                    end
                end
            end
        end
    end
end

%%
dataT.translationalSpikeCount = trSpikeCount;
dataT.stimSpikeCount = stimSpikeCount;
dataT.noiseSpikeCount = noiseSpikeCount;
dataT.blankSpikeCount = blankSpikeCount;