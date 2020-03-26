function [FWHM, halfmax] = DVMBandwidth2(param)
% orientation Bandwidth at peak spatial frequency as in full width @two=thirds max. 
%
% Note, in a true von Mises the lowest kappa value is 0, and the highest bandwidth is 90 degrees. 
%
% Finds the full width at TWO THIRDS MAX. two thirds max is defined as the distance
% between the max  value and 0 of the orientation tuning curve at the peak
% spatial frequency (as determined by FitDVMBlob2 fits). 
chanFitUp = DVMBlob2([1:360], param);
[M, I] = max(chanFitUp(:));
[prefSf, prefOri] = ind2sub(size(chanFitUp), I);
chanFitUp_ = chanFitUp(prefSf,:);

[M,I] = max(chanFitUp_);
R = circshift(chanFitUp_, 180 - I);
R = R(90:270);
halfmax = M /2;

% Find indices closest to half max
[~, I1] = min(abs(R(1:90)-halfmax));
[~, I2] = min(abs(R(91:end)-halfmax));
I2 = I2 + 90;

FWHM = I2 - I1;