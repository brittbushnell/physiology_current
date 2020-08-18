function [trSpikeCount,noiseSpikeCount,blankSpikeCount,stimSpikeCount] = getGlassTRSpikeCounts(dataT, goodCh, holdout, numBoot)
% set goodCh to either dataT.responsiveCh or dataT.goodCh

[numOris,numDots,numDxs,numCoh,oris,~,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
trSpikeCount = nan(numOris,numCoh,numDots,numDxs,96);
stimSpikeCount = nan(numDots,numDxs,96);
noiseSpikeCount = nan(numDots,numDxs,96);
blankSpikeCount = nan(numDots,numDxs,96);
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
                        oriNdx = (dataT.rotation == oris(or));
                        
                        linTrials = (linearNdx & dotNdx & dxNdx & oriNdx & cohNdx);
                        noiseTrials = (noiseNdx & dotNdx & dxNdx);
                        stimTrials = (dotNdx & dxNdx);
                        
                        numTrials = length(linTrials);
                        
                        noiseStimBoot = nan(1,numBoot);
                        linStimBoot   = nan(1,numBoot);
                        blankBoot = nan(1,numBoot);
                        stimBoot  = nan(1,numBoot);

                        if holdout == 0
                            linNdx1 = subsampleStimuli(linTrials, numTrials);
                            trSpikeCount(or,co,ndot,dx,ch) = nansum(dataT.bins(linNdx1, (startMean:endMean) ,ch),2);
                            
                            if co == 1 && or == 1
                                noiseNdx1  = subsampleStimuli((noiseTrials),numTrials);
                                noiseSpikeCount(ndot,dx,ch) = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                                
                                blankNdx1 = subsampleBlanks((blankNdx),numTrials);
                                blankSpikeCount(ndot,dx,ch) = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                                
                                stim1 = subsampleStimuli(stimTrials,numTrials);
                                stimSpikeCount(ndot,dx,ch) = nansum(dataT.bins(stim1, (startMean:endMean) ,ch),2);
                            end
                            
                        else  % use all of the trials for each stimulus type without subsampling.
                            for nb = 1:numBoot
                                linStimBoot(1,nb) = nansum(dataT.bins(linTrials, (startMean:endMean) ,ch),2);
                                
                                if co == 1 && or == 1
                                    noiseStimBoot(1,nb) = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                                    blankBoot(1,nb) = nansum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                                    stimBoot(1,nb)    = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                                end
                            end
                            
                            trSpikeCount(or,co,ndot,dx,ch) = mean(linStimBoot);
                            if co == 1 && or == 1 % don't need to run this on every iteration, just on the ones where these values are actually being computed
                                blankSpikeCount(ndot,dx,ch) = mean(blankBoot);
                                noiseSpikeCount(ndot,dx,ch) = mean(noiseStimBoot);
                                stimSpikeCount(ndot,dx,ch) = mean(stimBoot);
                            end
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