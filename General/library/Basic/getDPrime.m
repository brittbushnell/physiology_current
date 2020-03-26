function out = getDPrime(param1,param2)
% Computes d' using ROC curves 
% param1 should be the responses to the stimulus, param2 should be responses
% to noise.
%
% Written by Corey Ziemba

%%

decCrit = min([param1(:); param2(:)]) -1:max([param1(:); param2(:)]) +1;

for iR = 1:length(decCrit)
   hitRateIO(iR)    = nanmean(param1 >= decCrit(iR));
   faRateIO(iR)     = nanmean(param2 >= decCrit(iR));
end

%%

idealObs = sum((hitRateIO(:,1:end-1) + diff(hitRateIO)/2) .* diff(faRateIO));

out = sqrt(2) * norminv(idealObs);