function [dataT] = getStimVsBlankDPrimes_Glass_coh(dataT,subsample)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli, and gives an option to subsample the
% stimuli or not.
%
% edited 10/30 to use the best time window for each channel.
%%
[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

noiseBlankDprime = nan(numDots, numDxs, numCh);
stimBlankDprime = nan(numDots, numDxs, numCh);
radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank
for ch = 1:numCh
    if dataT.goodCh(ch) == 1
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
                    dxNdx = (dataT.dx == dxs(dx));
                    cohNdx = (dataT.coh == coherences(co));
                    
                    conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                    radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                    noiseTrials = (noiseNdx & dotNdx & dxNdx);
                    stimTrials = (dotNdx & dxNdx);
                    
                    numTrials = length(conTrials);
                    
                    % subsample so we can bootstrap and use the same number of stimuli for everything.
                    if subsample == 1
                        noiseNdx1  = subsampleStimuli((noiseTrials),numTrials);
                        noiseStim2 = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                        
                        blankNdx1 = subsampleBlanks((blankNdx),numTrials);
                        blankStim2 = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                        
                        radNdx1 = subsampleStimuli(radTrials, numTrials);
                        radStim = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                        
                        conNdx1 = subsampleStimuli(conTrials, numTrials);
                        conStim = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                        
                        stim1 = subsampleStimuli(stimTrials,numTrials);
                        stim = nansum(dataT.bins(stim1, (startMean:endMean) ,ch),2);
                        
                    else  % use all of the trials for each stimulus type without subsampling.
                        noiseStim2 = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                        blankStim2 = nansum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                        radStim = nansum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                        conStim = nansum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                        stim = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                    end
                    %% d'
                    % get d' the simple way just using the equation without
                    % Christopher's projection process.
                    
                    conBlankDprime(co,ndot,dx,ch)  = simpleDiscrim((blankStim2),(conStim));
                    radBlankDprime(co,ndot,dx,ch)  = simpleDiscrim((blankStim2),(radStim));
                    stimBlankDprime(ndot,dx,ch)  = simpleDiscrim((blankStim2),(stim));
                    noiseBlankDprime(ndot,dx,ch) = simpleDiscrim((blankStim2),(noiseStim2));
                end
            end
        end
    end
end
dataT.conBlankDprime = conBlankDprime;
dataT.radBlankDprime = radBlankDprime;
dataT.stimBlankDprime = stimBlankDprime;
dataT.noiseBlankDprime = noiseBlankDprime;
