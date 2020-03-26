function FWHM = DVMBandwidth2_OLD(param)
% Bandwidth as in full width @half height. For the double vonMises function
% used in FitDVMBlob2. Seems like bandwidth does not naturally fall out of
% the vonMises when two are added together...

% Finds the full width at half max. Half max is defined as the distance
% between the max and min values of the orientation tuning curve averaged
% across spatial frequencies (fitted by FitDVMBlob2). 
chanFitUp = DVMBlob2([1:360], param);
chanFitUp_ = nanmean(chanFitUp);

[M,I] = max(chanFitUp_);
R = circshift(chanFitUp_, 180 - I);
R = R(90:270);
halfmax = M - ((M-min(R))/2);

% Find indices closest to half max
[~, I1] = min(abs(R(1:90)-halfmax));
[~, I2] = min(abs(R(91:end)-halfmax));
I2 = I2 + 90;

FWHM = I2 - I1;