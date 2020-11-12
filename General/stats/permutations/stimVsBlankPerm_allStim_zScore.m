function [realStimBlankDprime ,stimBlankDprimePermBoot, stimBlankDprimeMuPerm,stimBlankSDPerm] = stimVsBlankPerm_allStim_zScore(blankMtx,stimMtx, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using
% the all stimulus and blank z score matrices
%
% INPUTS:
%   BLANK MTX: matrix of zscores for blank stimuli that is organized (repeats x 96)
%   STIM MTX: matrix of zscores for all stimuli that's organized
%   (conditions x repeats x 96)
%   NUMBOOT:  Number of times to permute the data (usually 2,000)
%   HOLDOUT:  Proportion of the data to include in the permutation draw
%   (usually using 0.9 so 90% of the data is used and 10% is held out.
%   Yes, I know I named this variable backwards, but I did it across all of
%   the programs so it's at least consistently wrong.)

%
%
% OUTPUT:
%     allStimBlankDprimePerm
%     allStimBlankDprimeBootPerm
%     allStimBlankDprimeSDPerm
%     allStimBlankDprime
%
% Brittany Bushnell November 11, 2020
%% Make matrices of responses
% Initialize matrices

stimBlankDprimePermBoot = nan(96,numBoot);

realStimBlankDprime = nan(1,96);
%% d' for each stimulus
numStimTrials = round(length(stimMtx)*holdout);
numBlankTrials = round(length(blankMtx)*holdout);


stimBlankBoot = nan(96,numBoot);
for nb = 1:numBoot
    % subsample so we can bootstrap and use the same number of stimuli for everything.
    blankStim = datasample(blankMtx,numBlankTrials,1);
    stim = datasample(stimMtx,numStimTrials,1);
    %% d'
    for ch = 1:96
        stimBlankBoot(nb,ch)  = simpleDiscrim((blankStim(:,ch)),(stim(:,ch)));
        realStimBlankDprime(1,ch) = simpleDiscrim((blankMtx(:,ch)),(stimMtx(:,ch)));
    end
end
%% mean, sd of permutations
stimBlankDprimeMuPerm  = nanmean(stimBlankBoot,1);
stimBlankSDPerm = nanstd(stimBlankBoot,1);

