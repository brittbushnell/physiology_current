function [dp] = simpleDiscrim(X1,X2)
% simpleDiscrim is a simplified version of Christopher's discrim code. This
% returns a basic d'.
%  dp = (nanmean(X2) - nanmean(X1)) ./ sqrt( (nanvar(X2) + nanvar(X1))./2 );
%
%  INPUT:
%     X1 and X2: vector of responses to two different stimuli. 
%      Typically, the first input is blank or noise, and the second is the
%      actual stimulus. 
%      Both inputs should be thes same size, if they are not, you will see a warning.
%
%  OUTPUT:
%    d':
%       positive d' indicates that the response, and therefore sensitivity
%       to the second vector (usually the stimulus) is larger.
%
%       negative d' indicates the first stimulus is stronger.  
%
if size(X1) ~= size(X2)
    fprintf('different size inputs to simpleDiscrim\n')
end

dp = (nanmean(X2) - nanmean(X1)) ./ sqrt( (nanvar(X2) + nanvar(X1))./2 );

% change any dp that comes out as nan to 0
dp(isnan(dp)) = 0;
