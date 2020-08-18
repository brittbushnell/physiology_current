function [dataT] = getStimVsBlankDPrimes_GlassTR_coh(dataT,subsample)
% This function will compute d' for stimulus vs  blank screen with an option to subsample the
% stimuli or not.
%
% edited 10/30 to use the best time window for each channel.
%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linBlankDprime = nan(numOris,numCoh,numDots,numDxs,96);
stimBlankDprime = nan(numDots,numDxs,96);
noiseBlankDprime = nan(numDots,numDxs,96);
%% mean responses and d' to each stimulus
% type codes 1=lincentric  2=radial 0=noise  100=blank

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
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
                        
                        % subsample so we can bootstrap and use the same number of stimuli for everything.
                        if subsample == 1
                            noiseNdx1  = subsampleStimuli((noiseTrials),numTrials);
                            noiseStim2 = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                            
                            blankNdx1 = subsampleBlanks((blankNdx),numTrials);
                            blankStim2 = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                            
                            linNdx1 = subsampleStimuli(linTrials, numTrials);
                            linStim = nansum(dataT.bins(linNdx1, (startMean:endMean) ,ch),2);
                            
                            stim1 = subsampleStimuli(stimTrials,numTrials);
                            stim = nansum(dataT.bins(stim1, (startMean:endMean) ,ch),2);
                            
                        else  % use all of the trials for each stimulus type without subsampling.
                            noiseStim2 = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                            blankStim2 = nansum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                            linStim = nansum(dataT.bins(linTrials, (startMean:endMean) ,ch),2);
                            stim = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                        end
                        
                        %% d'
                        % get d' the simple way just using the equation without
                        % Christopher's projection process.
                        
                        linBlankDprime(or,co,ndot,dx,ch)= simpleDiscrim((blankStim2),(linStim));   
                        if or == 1 && coherences(co) == 1
                            stimBlankDprime(ndot,dx,ch)  = simpleDiscrim((blankStim2),(stim));
                            noiseBlankDprime(ndot,dx,ch) = simpleDiscrim((blankStim2),(noiseStim2));
                        end
                    end
                end
            end
        end
    end
end

dataT.linBlankDprime = linBlankDprime;
dataT.stimBlankDprime = stimBlankDprime;
dataT.noiseBlankDprime = noiseBlankDprime;

