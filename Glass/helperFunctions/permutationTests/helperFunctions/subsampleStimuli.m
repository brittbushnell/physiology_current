function [stimNdx2,unusedNdxs] = subsampleStimuli(stimNdx, numTrials)
%
% INPUTS:
%   stimNdx: Matrix of responses from data.bins
%   numTrials: the number of trials you want to subsample down to.
%
% OUTPUTS:
%   stimNdx2: new randomly subselected trials.
%   unusedNdxs: trials not included in stimNdx2, but were in stimNdx.



stim = find(stimNdx);  % get the actual index numbers of the blank trials
if length(stim)>= numTrials
    randStim = randsample(stim, numTrials);
    
    %randBlank = randsample((length(blankStim1)), length(conStim));
    
    stimNdx2 = zeros(size(stimNdx,1), size(stimNdx,2));
    
    for i = 1:length(randStim)
        stimNdx2(randStim(i)) = 1;
    end
    
    stimNdx2 = logical(stimNdx2);
else
    stimNdx2 = stimNdx;
end

unusedNdxs = (stimNdx2 == 0);