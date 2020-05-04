function [dataT] = GlassStimVsBlankPermutations_allStim(dataT, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli (ignoring other coherences).
%
%%
numCh = size(dataT.bins,3);
%% Make matrices of responses
% Initialize matrices
stimBlankDprimePerm = nan(1,96);
stimBlankSDPerm = nan(1,96);
stimBlankDprimeBootPerm = nan(96,numBoot);

realStimBlankDprime = nan(1,96);
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank
startMean = 5;
endMean = 25;
for ch = 1:numCh
  
    stimNdx = (dataT.numDots>0);
    blankNdx = (dataT.numDots == 0);
    stimBlankBoot = nan(1,numBoot);
    
    for nb = 1:numBoot
        stimTrials = (stimNdx);
        blankTrials = blankNdx;
        %trials = 1:size(dataT.bins,1);
        
        if holdout == 0
            numStimTrials = sum(conTrials);
        else
            numStimTrials = round(length(find(stimTrials))*holdout);
            numBlankTrials = round(length(find(blankTrials))*holdout);
        end
        
        % subsample so we can bootstrap and use the same number of stimuli for everything.
        
        blankNdx1 = subsampleBlanks((blankNdx),numBlankTrials);
        blankStim2 = nansum(dataT.bins((blankNdx1, startMean:endMean, ch),2);
        
        stim1 = subsampleStimuli(stimTrials,numStimTrials);
        stim = nansum(dataT.bins(stim1, (startMean:endMean) ,ch),2);
        
        %% d'
        stimBlankBoot(1,nb)  = simpleDiscrim((blankStim2),(stim));
    end
    %% simplified d' code
    stimBlankDprimePerm(1,ch)  = nanmean(stimBlankBoot);
    stimBlankSDPerm(1,ch)  = nanstd(stimBlankBoot);
    stimBlankDprimeBootPerm(ch,:) = stimBlankBoot;
    %%
    blankReal = nansum(dataT.bins(blankTrials, startMean:endMean, ch),2);
    stimReal = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
    
    realStimBlankDprime(1,ch) = simpleDiscrim(blankReal,stimReal);
end

%%
dataT.allStimBlankDprimePerm = stimBlankDprimePerm;
dataT.allStimBlankDprimeBootPerm = stimBlankDprimeBootPerm;
dataT.allStimBlankDprimeSDPerm = stimBlankSDPerm;

dataT.allStimBlankDprime = realStimBlankDprime;


