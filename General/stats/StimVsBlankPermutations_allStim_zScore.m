function [realStimBlankDprime,stimBlankDprimeBootPerm,stimBlankDprimePerm, stimBlankSDPerm] = StimVsBlankPermutations_allStim_zScore(varargin)
% This function is a modified version of 
%
% REQUIRED INPUTS:
%  1) matrix of zscores to all stimuli that is organized as (ch x trials)
%  2) matrix of zscores for blank activity organized as (ch x trials)
%  
% OPTIONAL INPUTS:
%  3) Number of bootstraps to run (default is 1,000)
%  4) precentage of the data to use for bootstraps (default is 0.9)
%
%
% OUTPUT:
%     allStimBlankDprimePerm 
%     allStimBlankDprimeBootPerm 
%     allStimBlankDprimeSDPerm 
%     allStimBlankDprime 
% 
% Brittany Bushnell  October 1, 2020
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
%% concatenate zscore matrices so one big data matrix
allZscores = [stimZscores,blankZscores];
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank
startMean = 5;
endMean = 25;
for ch = 1:96
    stimBlankBoot = nan(1,numBoot);
    
    for nb = 1:numBoot
        stimTrials = length(stimZscores); % assuming there will be more than 96 trials
        blankTrials = length(blankZscores);
        
        numStimTrials = round(stimTrials*holdout);
        numBlankTrials = round(blankTrials*holdout);

        % subsample so we can bootstrap and use the same number of stimuli for everything.
        stim = randperm(size(allZscores,2),numStimTrials);
        blank = datasample(setdiff([1:size(allZscores,2)]',stim),numBlankTrials,1);
        %% d'
        stimBlankBoot(1,nb)  = simpleDiscrim((blank),(stim));
    end
    %% simplified d' code
    stimBlankDprimePerm(1,ch)  = nanmean(stimBlankBoot);
    stimBlankSDPerm(1,ch)  = nanstd(stimBlankBoot);
    stimBlankDprimeBootPerm(ch,:) = stimBlankBoot;
    %%
    blankReal = blankZscores(ch,:);
    stimReal = stimZscores(ch,:);
    
    realStimBlankDprime(1,ch) = simpleDiscrim(blankReal,stimReal);
end

%%
dataT.allStimBlankDprimePerm = stimBlankDprimePerm;
dataT.allStimBlankDprimeBootPerm = stimBlankDprimeBootPerm;
dataT.allStimBlankDprimeSDPerm = stimBlankSDPerm;

dataT.allStimBlankDprime = realStimBlankDprime;