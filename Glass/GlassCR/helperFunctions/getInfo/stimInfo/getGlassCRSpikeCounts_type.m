function [radSpikeCount,conSpikeCount, noiseSpikeCount,blankSpikeCount,allStimSpikeCount, glassSpikeCount] = getGlassCRSpikeCounts_type(dataT)
% radSpikeCount:  spike count for radial stimuli (coh,dots,dx,ch,repeats)
% conSpikeCount:  spike count for concentric stimuli (coh,dots,dx,ch,repeats)
% noiseSpikeCount: spike count for noise stimuli (coh,dots,dx,ch,repeats)
% blankSpikeCount: spike count for blank screen (ch,repeats)
% allStimSpikeCount: spike count for all stimuli combined (ch,repeats)
% glassSpikeCount: spike count for all glass pattern stimuli (type,coh,dots,dx,ch,repeats)

[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
types = [0, 1, 2]; % 0 = noise, 1 = con 2 = rad

cohNdx = (dataT.coh == 1);
dotNdx = (dataT.numDots == 400);
dxNdx = (dataT.dx == 0.03);

noiseNdx = (dataT.type == 0);
blankNdx = (dataT.numDots == 0);
allStimTrials = (dataT.numDots > 0);
conNdx = (dataT.type == 1);
radNdx = (dataT.type == 2);

trials = (conNdx & dotNdx & dxNdx & cohNdx);
noiseTrials = (noiseNdx & dotNdx & dxNdx);

conSpikeCount = nan(numCoh, numDots, numDxs, 96, sum(trials)+5);
radSpikeCount = nan(numCoh, numDots, numDxs, 96, sum(trials)+5);
noiseSpikeCount = nan(numCoh,numDots, numDxs, 96, sum(noiseTrials)+5);
glassSpikeCount = nan(3,numCoh,numDots, numDxs, 96, sum(noiseTrials)+5);
%%
for ch = 1:96
    startMean= 5;
    endMean  = 25;
    
    blankSpikeCount(ch,:) = sum(dataT.bins(blankNdx, startMean:endMean, ch),2);
    allStimSpikeCount(ch,:) = sum(dataT.bins(allStimTrials,(startMean:endMean) ,ch),2);
    for tp = 1:length(types)
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    cohNdx = (dataT.coh == coherences(co));
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx = (dataT.dx == dxs(dx));
                    tpNdx = (dataT.type == types(tp));
                    
                    radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                    conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                    noiseTrials = (noiseNdx & dotNdx & dxNdx);
                    
                    stimTrials = (tpNdx & dotNdx & dxNdx & cohNdx);
                    
                    glassSpikeCount(tp,co,ndot,dx,ch,1:sum(conTrials)) = sum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                    if tp == 3
                    radSpikeCount(co,ndot,dx,ch,1:sum(radTrials)) = sum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                    elseif tp == 2
                    conSpikeCount(co,ndot,dx,ch,1:sum(conTrials)) = sum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                    else
                    if co == 1
                        noiseSpikeCount(co,ndot,dx,ch,1:sum(noiseTrials)) = sum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                    end
                    end
                end
            end
        end
    end
end
%%
