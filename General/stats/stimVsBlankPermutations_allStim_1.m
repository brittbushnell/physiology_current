function [dataT] = stimVsBlankPermutations_allStim(dataT,stimNdx,blankNdx, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen, it may then
% be used to determine visually resposive channels in later analysis steps
%
%  INPUT
%  DATAT:full data structure, will be returned with new matrices/vectors included  
%   STIMNDX: vector of the indices for what trials should be included as
%    stimulus trials
%   BLANKNDX: vector of the indices for what trials should be included as
%    blank trials
%   NUMBOOT: number of permutations/bootstraps of the data to do
%   HOLDOUT: what fraction of the data should be used to do the boostraps.
%   Enter the number as a decimal point. For example, if you want to use
%   90% of the data, holdout should be 0.9.
%
% Created June 12, 2020 Brittany Bushnell, NYU
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
  
%     stimNdx = (dataT.stimulus == 1);
%     blankNdx = (dataT.stimulus == 0);
    stimBlankBoot = nan(1,numBoot);
    
    for nb = 1:numBoot
        stimTrials = (stimNdx);
        blankTrials = blankNdx;
        trials = 1:size(dataT.bins,1);
        
        if holdout == 0
            numStimTrials = sum(conTrials);
        else
            numStimTrials = round(length(find(stimTrials))*holdout);
            numBlankTrials = round(length(find(blankTrials))*holdout);
        end
        
        % subsample so we can bootstrap and use the same number of stimuli for everything.
        
        blankNdx1 = subsampleBlanks((trials),numBlankTrials);
        blankStim2 = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
        
        stim1 = subsampleStimuli(trials,numStimTrials);
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