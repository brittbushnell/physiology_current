function p = shuffleTest2Dist(dist1, dist2, nRep)
% Performs a shuffle test to evaluate if two distributions come from the
% same distribution or not. The two distributions do not have to be the
% same size.
%
% Inputs:
%       - dist 1 and dist 2 = vectors of two distributions to be compared.
%       - nRep = number of times to iterate shuffle. Default is 10,000
%       if not supplied.
% Output:
%       - p = significance level; where in the distribution the data lies
%       in comparison to shuffled distribution.
%       (Keep in mind that if you want the test to be two-tailed, p has to
%       be less than 0.025 if you want it to be significant at 0.05, etc)

dataMean = nanmean(dist1) - nanmean(dist2);

nSamp    = min([length(dist1) length(dist2)]);

shuffMean = NaN(nRep, 1);
for iRep = 1:nRep
    dist_   = [randsample(dist1, nSamp,true); randsample(dist2, nSamp, true)]; % Draw equally from og 2 distributions, with replacement
    shufOrder = randperm(2*nSamp);                                             % Create index for shuffling
    dist_   = dist_(shufOrder);                                                % shuffle labels
    dist1_  = dist_(1:nSamp);                                                  % new shuffled distribution 1
    dist2_  = dist_(nSamp+1:end);                                              % new shuffled distribution 2
    shuffMean(iRep)     = nanmean(dist1_) - nanmean(dist2_);                   % add difference of mean of shuffled distributions to bootstrapped dist. 
end 

p = invprctile(shuffMean, dataMean);
p = p/100;
if p > 0.05
    p = p - 0.5;
end
