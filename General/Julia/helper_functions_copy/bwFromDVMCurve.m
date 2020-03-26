function FWHM = bwFromDVMCurve(R);
% R = vector of responses to orientations 1-360

[M,I] = max(R);
R = circshift(R, 180 - I);
R = R(90:270);
halfmax = M /2;

% Find indices closest to half max
[~, I1] = min(abs(R(1:90)-halfmax));
[~, I2] = min(abs(R(91:end)-halfmax));
I2 = I2 + 90;

FWHM = I2 - I1;