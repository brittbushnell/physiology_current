function [radSpikeCount,conSpikeCount, noiseSpikeCount,blankSpikeCount,allStimSpikeCount] = getGlassCRSpikeCounts(dataT)
% set goodCh to either dataT.responsiveCh or dataT.goodCh

[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
cohNdx = (dataT.coh == 1);
dotNdx = (dataT.numDots == 400);
dxNdx = (dataT.dx == 0.03);

noiseNdx = (dataT.type == 0);
blankNdx = (dataT.numDots == 0);
stimTrials = (dataT.numDots >0);
conNdx = (dataT.type == 1);
radNdx = (dataT.type == 2);

trials = (conNdx & dotNdx & dxNdx & cohNdx);
noiseTrials = (noiseNdx & dotNdx & dxNdx);


conSpikeCount = nan(numCoh, numDots, numDxs, 96, sum(trials)+5);
radSpikeCount = nan(numCoh, numDots, numDxs, 96, sum(trials)+5);
noiseSpikeCount = nan(numCoh,numDots, numDxs, 96, sum(noiseTrials)+5);
%%
for ch = 1:96
    startMean= 5;
    endMean  = 25;
    
    blankSpikeCount(ch,:) = sum(dataT.bins(blankNdx, startMean:endMean, ch),2);
    allStimSpikeCount(ch,:) = sum(dataT.bins(stimTrials,(startMean:endMean) ,ch),2);
    
    for ndot = 1:numDots
        for dx = 1:numDxs
            for co = 1:numCoh
                cohNdx = (dataT.coh == coherences(co));
                dotNdx = (dataT.numDots == dots(ndot));
                dxNdx = (dataT.dx == dxs(dx));
                
                
                radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                noiseTrials = (noiseNdx & dotNdx & dxNdx);
                
                
                radSpikeCount(co,ndot,dx,ch,1:sum(radTrials)) = sum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                conSpikeCount(co,ndot,dx,ch,1:sum(conTrials)) = sum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                if co == 1
                    noiseSpikeCount(co,ndot,dx,ch,1:sum(noiseTrials)) = sum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                end
            end
        end
    end
end
%%
eachStimSpikeCount = cat(5,conSpikeCount, radSpikeCount, noiseSpikeCount);