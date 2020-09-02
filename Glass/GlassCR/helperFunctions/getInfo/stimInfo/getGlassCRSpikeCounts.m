function [radSpikeCount,conSpikeCount, noiseSpikeCount,blankSpikeCount,stimSpikeCount] = getGlassCRSpikeCounts(dataT)
% set goodCh to either dataT.responsiveCh or dataT.goodCh

[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
% trSpikeCount = nan(numOris,numCoh,numDots,numDots,96,30);
% noiseSpikeCount = nan(numDots,numDxs,96,:);
% blankSpikeCount = nan(96,:);
% stimSpikeCount = nan(96,:);
%%
radSpikeCount = [];
conSpikeCount = [];

for ch = 1:96
    startMean= 5;
    endMean  = 25;
    
    noiseNdx = (dataT.type == 0);
    linearNdx = (dataT.type == 3);
    blankNdx = (dataT.numDots == 0);
    stimTrials = (dataT.numDots >0);
    
    blankSpikeCount(ch,:) = sum(dataT.bins(blankNdx, startMean:endMean, ch),2);
    stimSpikeCount(ch,:) = sum(dataT.bins(stimTrials,(startMean:endMean) ,ch),2);
    
    for ndot = 1:numDots
        for dx = 1:numDxs
            for co = 1:numCoh
                cohNdx = (dataT.coh == coherences(co));
                dotNdx = (dataT.numDots == dots(ndot));
                dxNdx = (dataT.dx == dxs(dx));
                conNdx = dataT.type == 1;
                radNdx = dataT.type == 2;
                
                radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                noiseTrials = (noiseNdx & dotNdx & dxNdx);
                
                
                radSpikeCount(co,ndot,dx,ch,:) = sum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                conSpikeCount(co,ndot,dx,ch,:) = sum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                if co == 1
                    noiseSpikeCount(ndot,dx,ch,:) = sum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                end
            end
        end
    end
end


dataT.radSpikeCount = radSpikeCount;
dataT.conSpikeCount = conSpikeCount;
dataT.stimSpikeCount = stimSpikeCount;
dataT.noiseSpikeCount = noiseSpikeCount;
dataT.blankSpikeCount = blankSpikeCount;