function [dataT] = radFreq_getStimVsCircleDprime(dataT)
%%
numBoot = 100;
holdout = 0.8;
%%
rfSpikes = dataT.rfSpikeCountMtx;
circSpikes = dataT.circSpikeCountMtx;
blankSpikes = dataT.blankSpikeCountMtx;
%% get real d'
% (repeats, RF, ori, amp, sf, radius, location, ch)
for ch = 1%:96
    if dataT.goodCh(ch) == 1
        blankSc = squeeze(blankSpikes(:,ch));
        for loc = 1%:size(rfSpikes,7)
            for sf = 1%:size(rfSpikes,5)
                for rad = 1%:size(rfSpikes,6)
                    % (sf,radius,location, ch)
                    circleSc = squeeze(circSpikes(:,sf,rad,loc,ch));
                    for rf = 1%:size(rfSpikes,2)
                        for ori = 1%:size(rfSpikes,3)
                            for amp = 1%:size(rfSpikes,4)
                                %(RF,ori,amp,sf,radius,location, ch)
                                radFreqSc = squeeze(rfSpikes(:,rf,ori,amp,sf,rad,loc,ch));
                                
                                numRFtrials   = round(length(radFreqSc)*holdout);
                                numCircTrials = round(length(circleSc)*holdout);
                                numBlankTrials= round(length(blankSc)*holdout);
                                
                                rfBlankBoot = nan(numBoot,1);
                                rfCircBoot  = nan(numBoot,1);
                                cirBlankBoot= nan(numBoot,1);
                                
                                for nb = 1:numBoot
                                    blankNdx = subsampleStimuli(blankSc,numBlankTrials);
                                    rfNdx    = subsampleStimuli(radFreqSc,numRFtrials);
                                    circNdx  = subsampleStimuli(circleSc, numCircTrials);
                                    
                                
                                    blankStim   = nansum(blankSc(blankNdx));
                                    circleStim  = nansum(circleSc(circNdx));
                                    radFreqStim = nansum(radFreqSc(rfNdx));
                                    
                                    rfBlankBoot(nb,1) = simpleDiscrim(blankStim,radFreqStim);
                                    rfCircBoot(nb,1)  = simpleDiscrim(circleStim,radFreqStim);
                                    cirBlankBoot(nb,1)= simpleDiscrim(blankStim, circleStim);
                                end
                                
                                
                            end
                        end
                    end
                end
            end
        end
    end
end