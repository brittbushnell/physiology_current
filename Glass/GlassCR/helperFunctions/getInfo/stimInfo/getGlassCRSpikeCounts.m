function [conSpikeCount,radSpikeCount,noiseSpikeCount,blankSpikeCount,stimSpikeCount] = getGlassCRSpikeCounts(dataT,goodCh,holdout, numBoot)
% set goodCh to either dataT.responsiveCh or dataT.goodCh

[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
for ch = 1:96
    if goodCh(ch) == 1
        startMean = 5;
        endMean = 25;
        
        noiseNdx = (dataT.type == 0);
        conNdx = (dataT.type == 1);
        radNdx = (dataT.type == 2);
        blankNdx = (dataT.numDots == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx  = (dataT.dx == dxs(dx));
                    cohNdx = (dataT.coh == coherences(co));
                    
                    conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                    radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                    noiseTrials = (noiseNdx & dotNdx & dxNdx);
                    stimTrials  = (dotNdx & dxNdx);
                    if holdout == 0
                        noiseSpikeCount(ndot,dx,ch) = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                        blankSpikeCount(ndot,dx,ch) = nansum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                        radSpikeCount(co,ndot,dx,ch) = nansum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                        conSpikeCount(co,ndot,dx,ch) = nansum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                        stimSpikeCount(co,ndot,dx,ch) = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                    else
                        numConTrials = round(length(find(conTrials))*holdout);
                        numRadTrials = round(length(find(radTrials))*holdout);
                        numNoiseTrials = round(length(find(noiseTrials))*holdout);
                        numBlankTrials = round(length(find(blankNdx))*holdout);
                        numStimTrials  = round(length(find(stimTrials))*holdout);
                        
                        conSpikeCountBoot   = nan(numBoot,1);
                        radSpikeCountBoot   = nan(numBoot,1);
                        noiseSpikeCountBoot = nan(numBoot,1);
                        stimSpikeCountBoot  = nan(numBoot,1);
                        blankSpikeCountBoot = nan(numBoot,1);
                        
                        for nb = 1:numBoot
                            % subsample stimuli
                            radNdx1 = subsampleStimuli(radTrials, numRadTrials);
                            radSpikeCountBoot = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                            
                            conNdx1 = subsampleStimuli(conTrials, numConTrials);
                            conSpikeCountBoot = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                            
                            nosNdx1 = subsampleStimuli(noiseTrials, numNoiseTrials);
                            noiseSpikeCountBoot = nansum(dataT.bins(nosNdx1, (startMean:endMean) ,ch),2);
                            
                            blkNdx1 = subsampleStimuli(blankNdx, numBlankTrials);
                            blankSpikeCountBoot = nansum(dataT.bins(blkNdx1, (startMean:endMean) ,ch),2);
                            
                            stmNdx1 = subsampleStimuli(stimTrials, numStimTrials);
                            stimSpikeCountBoot = nansum(dataT.bins(stmNdx1, (startMean:endMean) ,ch),2);
                        end
                        conSpikeCount(co,ndot,dx,ch) = nanmean(conSpikeCountBoot);
                        radSpikeCount(co,ndot,dx,ch) = nanmean(radSpikeCountBoot);
                        noiseSpikeCount(ndot,dx,ch)  = nanmean(noiseSpikeCountBoot);
                        stimSpikeCount(co,ndot,dx,ch)= nanmean(stimSpikeCountBoot);
                        blankSpikeCount(ndot,dx,ch)  = nanmean(blankSpikeCountBoot);
                    end
                end
            end
        end
    end
end
conSpikeCount = conSpikeCount;
radSpikeCount = radSpikeCount;
stimSpikeCount = stimSpikeCount;
noiseSpikeCount = noiseSpikeCount;
noiseSpikeCount = blankSpikeCount;