function [blankNdx1,blankNdx2] = subsampleBlanks(blankNdx, numTrials)
%
% INPUTS:
%   BlankNdx: Matrix of blank responses from data.bins
%   numTrials: the number of trials you want to subsample down to.
%
% OUTPUTS:
%   blankNdx1: logical vector with a random number of trials 
%   blankNdx2: logical vector with the other trials not in blankNdx1. 



blanks = find(blankNdx);  % get the actual index numbers of the blank trials
if length(blanks)>numTrials
    randBlank = randsample(blanks, numTrials);
    randBlank2 = blanks(~ismember(blanks,randBlank)); % find the trials that are not included in randBlank.
    
    if length(randBlank2)>numTrials % if you were choosing less than half of the trials 
        randBlank2 = randsample(randBlank2,numTrials);
    end
    
    %randBlank = randsample((length(blankStim1)), length(conStim));
    
    blankNdx1 = zeros(size(blankNdx,1), size(blankNdx,2));
    blankNdx2 = zeros(size(blankNdx,1), size(blankNdx,2));
    
    for i = 1:length(randBlank)
        blankNdx1(randBlank(i)) = 1;
    end
    
    for l = 1:length(randBlank2)
        blankNdx2(randBlank2(l)) = 1;
    end
    
    blankNdx1 = logical(blankNdx1);
    blankNdx2 = logical(blankNdx2);
else
    blankNdx1 = blankNdx;
end
