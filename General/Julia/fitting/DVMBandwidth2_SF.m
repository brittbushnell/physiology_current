function [FWHM_octaves, FWHM_cycs, HWHM_low, HWHM_high] = DVMBandwidth2_SF(param)
% 
% Spatial frequency Bandwidth IN OCTAVE UNITS at peak spatial frequency as in full width @two=thirds max. 
% For parameters output by FitDVMBlob2 (von Mises x asymmetric Gaussian).
%
% Finds the full width at TWO THIRDS MAX. two thirds max is defined as the distance
% between the max  value and 0 of the tuning curve at the peak
% orientation (as determined by FitDVMBlob2 fits). 
%
%   Inputs:
%     param = optimum parameters for model, as determined by fmincon
%     [ 1      2      3     4    5      6      7 ] 
%     [sc1     sc2    mux   muy  kappa  sdy    A ]
% Outputs:
%   FWHM_octaves
%       - full width at half max, in log units. AKA the octave bandwidth. 
%       - If lowpass, FWHM is returned as -1000. If highpass, FWHM is
%       returned as 1000.
%   FWHM_cycs
%       - full width at half max in cycles/degree.
%   HWHM_low
%       - half width at half max of the tuning curve below peak SF.
%   HWHM_high
%       - half width at half max of the tuning curve above peak SF.
%

chanFitUp = DVMBlob2([1:360], param);
y = linspace(0, 13, 100);                   % Upsample the asymmetric Gaussian as parameterized by model fit

% sfs = [2.^[-2:0.5:4]];
sfsUp = 2 .^ linspace(-2, 4, sum(y>=1));
logsUp = linspace(-2, 4, sum(y>=1));

gaussUp = max(chanFitUp(:)) * fnAsymGauss(y, param(4), param(6), param(7));
gaussUp = gaussUp(find(y>=1));
[M, I] = max(gaussUp(:));
halfmax = M / 2;

% Find indices closest to half max
[~, I1] = min(abs(gaussUp(1:I) - halfmax));
[~, I2] = min(abs(gaussUp(I:end) - halfmax));
I2 = I2+I;

if I >= length(gaussUp)                         % Highpass....
    FWHM_octaves = 1000;
    FWHM_cycs = 1000;
    HWHM_low = NaN;
    HWHM_high = 1000;
elseif I <= 1                                   % Lowpass...
    FWHM_octaves = -1000; 
    FWHM_cycs = -1000;
    HWHM_low = 1000;
    HWHM_high = NaN;
else
    try
    FWHM_octaves = logsUp(I2) - logsUp(I1);
    FWHM_cycs = sfsUp(I2) - sfsUp(I1);
    HWHM_low = logsUp(I) - logsUp(I1);
    HWHM_high = logsUp(I2) - logsUp(I);
    catch
    FWHM_octaves = NaN;
    FWHM_cycs = NaN;
    HWHM_low = NaN;
    HWHM_high = NaN;
    end
end

%octaveBW = log2(sfsUp(I2)/sfsUp(I1));      % wait...this is the same thign

function asymGaussian = fnAsymGauss(y, muy, sdy, A)
    asymGaussian = NaN(size(y));
    temp = exp((-(y-muy).^2) ./ (2*sdy^2));
    temp2 = exp((-(y-muy).^2) ./ (2*(sdy*A)^2));
    asymGaussian(find(y<=muy)) = temp(find(y<=muy));
    asymGaussian(find(y>muy)) = temp2(find(y>muy));
end

end