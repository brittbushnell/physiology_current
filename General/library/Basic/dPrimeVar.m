function [dPrime] = dPrimeVar(stimResp, otherResp, useMean)
% basic way to compute d'. Inputs are vectors of responses to a stimulus
% and whatever you want to compare against (blank, noise, etc).
%
% Written March 4, 2019 BNB

if useMean == 1
    muResp  = mean(stimResp(:));
    muOther = mean(otherResp(:));
else
    muResp  = sum(stimResp(:));
    muOther = sum(otherResp(:));
end

varResp = std(stimResp(:));
varOther= std(otherResp(:));

dPrime = (muResp - muOther) / sqrt((varResp + varOther)./2);