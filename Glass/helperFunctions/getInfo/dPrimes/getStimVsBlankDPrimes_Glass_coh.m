function [dataT] = getStimVsBlankDPrimes_Glass_coh(dataT,numBoot,subsample, holdout)
% This function will compute d' for stimulus vs  blank screen
% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
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
                    dxNdx  = (dataT.dx == dxs(dx));
                    cohNdx = (dataT.coh == coherences(co));
                    
                    conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                    radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                    noiseTrials = (noiseNdx & dotNdx & dxNdx);
                    stimTrials  = (dotNdx & dxNdx);
                    %%
                    %                     numTrials = length(conTrials);
                    
                    % subsample so we can bootstrap and use the same number of stimuli for everything.
                    if subsample == 0
                        noiseStim2 = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                        blankStim2 = nansum(dataT.bins(blankNdx, startMean:endMean, ch),2);
                        radStim = nansum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                        conStim = nansum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                        stim = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                        %% d'
                        % get d' the simple way just using the equation without
                        % Christopher's projection process.
                        
                        conBlankDprime(co,ndot,dx,ch)  = simpleDiscrim((blankStim2),(conStim));
                        radBlankDprime(co,ndot,dx,ch)  = simpleDiscrim((blankStim2),(radStim));
                        stimBlankDprime(ndot,dx,ch)  = simpleDiscrim((blankStim2),(stim));
                        noiseBlankDprime(ndot,dx,ch) = simpleDiscrim((blankStim2),(noiseStim2));
                        %%
                    else
                        numConTrials = round(length(find(conTrials))*holdout);
                        numRadTrials = round(length(find(radTrials))*holdout);
                        numNoiseTrials = round(length(find(noiseTrials))*holdout);
                        numBlankTrials = round(length(find(blankNdx))*holdout);
                        numStimTrials  = round(length(find(stimTrials))*holdout);
                        
                        conBlankDprimeBoot   = nan(numBoot,1);
                        radBlankDprimeBoot   = nan(numBoot,1);
                        noiseBlankDprimeBoot = nan(numBoot,1);
                        stimBlankDprimeBoot  = nan(numBoot,1);
                        
                        for nb = 1:numBoot
                            % subsample stimuli
                            radNdx1 = subsampleStimuli(radTrials, numRadTrials);
                            radStim = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                            
                            conNdx1 = subsampleStimuli(conTrials, numConTrials);
                            conStim = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                            
                            nosNdx1 = subsampleStimuli(noiseTrials, numNoiseTrials);
                            nosStim = nansum(dataT.bins(nosNdx1, (startMean:endMean) ,ch),2);
                            
                            blkNdx1 = subsampleStimuli(blankNdx, numBlankTrials);
                            blankStim = nansum(dataT.bins(blkNdx1, (startMean:endMean) ,ch),2);
                            
                            stmNdx1 = subsampleStimuli(stimTrials, numStimTrials);
                            stim = nansum(dataT.bins(stmNdx1, (startMean:endMean) ,ch),2);
                            %% d'
                            conBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(conStim));
                            radBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(radStim));
                            noiseBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(nosStim));
                            stimBlankDprimeBoot(nb,1)  = simpleDiscrim((blankStim),(stim));
                        end
                        
                        conBlankDprime(co,ndot,dx,ch) = nanmean(conBlankDprimeBoot);
                        radBlankDprime(co,ndot,dx,ch) = nanmean(radBlankDprimeBoot);
                        noiseBlankDprime(ndot,dx,ch) = nanmean(noiseBlankDprimeBoot);
                        stimBlankDprime(co,ndot,dx,ch)  = nanmean(stimBlankDprimeBoot);
                    end
                end
            end
        end
    end
end
dataT.conBlankDprime = conBlankDprime;
dataT.radBlankDprime = radBlankDprime;
dataT.stimBlankDprime = stimBlankDprime;
dataT.noiseBlankDprime = noiseBlankDprime;
