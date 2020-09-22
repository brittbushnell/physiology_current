function [stimBlankPval,gCh] = glassGetPermutationStatsAndGoodCh(varargin)
% glassGetPermutationStats(realData,permData)
%
% INPUT:
%  realData: 96 element vector of measured values
%  permData: 96xboot matrix where the columns are the bootstrapped values
%  numTails: optional input that specifies if you want to run a one or two tailed significance test.  
%     The default is two-tailed.
% 
% OUTPUT:
%  stimBlankPval
%     A vector of p-values from the permutation test comparing the
%     real value against the distribution of permuted va;ues.
%
%  gCh
%    A (1,96) vector of logicals that indicates if a channel is visually
%    responsive or not.
%    Responsive channel decision is based on a two tailed test of p-value
%    from the permutation test. If the real d' is >0.95 or <0.05, then the
%    channel is called visually responsive. %%
%%
switch nargin
    case 0
        error ('Must pass in at least the real and permuted data')
    case 1
        error ('Must pass in at least the real and permuted data')
    case 2
        realData = varargin{1};
        permData = varargin{2};
        numTails = 2;
    case 3
        realData = varargin{1};
        permData = varargin{2};
        numTails = varargin{3};
end
%%
stimBlankPval = zeros(1,96);
gCh = zeros(1,96);
%%
for ch = 1:96
    realDataCh = squeeze(realData(ch));
    permDataCh = squeeze(permData(ch,:));
    high = find(permDataCh>realDataCh);
    stimBlankPval(ch) = round((length(high)+1)/(length(permDataCh)+1),3);
    
    if numTails == 2
        if (stimBlankPval(ch) > 0.95) || (stimBlankPval(ch) < 0.05) % two tailed test
            gCh(ch) = 1;
        end
    else
        if (stimBlankPval(ch) < 0.05) % one tailed test
            gCh(ch) = 1;
        end
    end
end
