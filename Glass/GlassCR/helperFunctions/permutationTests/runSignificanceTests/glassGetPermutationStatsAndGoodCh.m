function [stimBlankPval,gCh] = glassGetPermutationStatsAndGoodCh(realData,permData)
% glassGetPermutationStats(realData,permData)
%
% INPUT:
%  data matrices of glass pattern stimuli responses that are organized by (dt,dx,ch)
%
% OUTPUT:
%  stimBlankPval
%     A (2,2,96) matrix of p-values from the permutation test comparing the
%     real d' against the distribution of permuted d's.
%
%  gCh
%    A (1,96) vector of logicals that indicates if a channel is visually
%    responsive or not.
%    Responsive channel decision is based on a two tailed test of p-value
%    from the permutation test. If the real d' is >0.95 or <0.05, then the
%    channel is called visually responsive. %%
%%
stimBlankPval = zeros(1,96);
gCh = zeros(1,96);
%%
for ch = 1:96
    realDataCh = squeeze(realData(ch));
    permDataCh = squeeze(permData(ch,:));
    high = find(permDataCh>realDataCh);
    stimBlankPval(ch) = round((length(high)+1)/(length(permDataCh)+1),3);
    
    if (stimBlankPval(ch) > 0.95) || (stimBlankPval(ch) < 0.05)
        gCh(ch) = 1;
    end
end
