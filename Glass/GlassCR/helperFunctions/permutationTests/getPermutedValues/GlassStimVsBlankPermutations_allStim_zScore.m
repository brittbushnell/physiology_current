function [dataT] = GlassStimVsBlankPermutations_allStim_zScore(varargin)
% This function will compute d' for stimulus vs  blank screen using
% whatever you indicate as stimulus and blank.  This is a generalized
% version of GlassStimVsBlankPermutations_allStim function that does this
% but only for Glass patterns. This function uses a 50:250ms time window to
% compute d' from the time the stimulus comes on.
%
% INPUTS:
%   DATAT:  Data structure with vectors for stimulus specific information
%   NUMBOOT:  Number of times to permute the data (usually 2,000)
%   HOLDOUT:  Proportion of the data to include in the permutation draw
%   (usually using 0.9 so 90% of the data is used and 10% is held out.
%   Yes, I know I named this variable backwards, but I did it across all of
%   the programs so it's at least consistently wrong.)
%   STIMNDX:  Logical vector for what trials a stimulus was shown
%   BLANKNDX: Logical vector for what trials a blank screen was shown
%
%
% OUTPUT:
%   DATAT: same data structure updated to now have:
%     dataT.allStimBlankDprimePerm 
%     dataT.allStimBlankDprimeBootPerm 
%     dataT.allStimBlankDprimeSDPerm 
%     dataT.allStimBlankDprime 
% 
% Brittany Bushnell September 8, 2020
%
%  October 1, 2020
%    Edited and renamed to work using the zscores rather than spike counts
%    computed from dataT.bins.
%% 
switch nargin
    case 0
        error('Must pass in at least the stimulus and blank z scores')
    case 1
        error('Must pass in at least the stimulus and blank z scores')
    case 2
        stimZscores = varargin{1};
        blankZscores = varargin{2};
        numBoot = 1000;
        holdout = 0.9;
    case 3
        stimZscores = varargin{1};
        blankZscores = varargin{2};
        numBoot = varargin{3};
        holdout = 0.9;
    case 4
        stimZscores = varargin{1};
        blankZscores = varargin{2};
        numBoot = varargin{3};
        holdout = varargin{4};
end
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
for ch = 1:96
    stimBlankBoot = nan(1,numBoot);
    
    for nb = 1:numBoot
        stimTrials = (stimZscores);
        blankTrials = blankZscores;
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