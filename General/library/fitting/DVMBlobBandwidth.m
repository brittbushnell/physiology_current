function FHHW = DVMBlobBandwidth(param);
% Bandwidth as in full width @half height.
% There has to be a better way to do this, but can't figure out how to
% derive this directly from the parameters (kappa is influenced by addition
% of the second von Mises)
chanFitUp = DVMBlob([0:360], param);
chanFitUp_ = nanmean(chanFitUp);

% [param2, ~] = FitVM([0:360], chanFitUp_);
% kappa = param2(2);
% FHHW = acos(1 - log(2)/kappa)
% 
% FHHW * length(rhat)/(2*pi)

[M,I] = max(chanFitUp_);
R = circshift(chanFitUp_, 180 - I);
R = R(90:270);
halfmax = M - (M-min(R))/2;

% Find indices closest to half max
[~, I1] = min(abs(R(1:90)-halfmax));
[~, I2] = min(abs(R(91:end)-halfmax));
I2 = I2 + 90;

FHHW = I2 - I1;