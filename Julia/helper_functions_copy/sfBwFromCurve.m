function [FWHM_octaves, FWHM_cycs, HWHM_low, HWHM_high] = sfBwFromCurve(R, y)
% inputs:
%   - R = spatial frequency tuning curve to derive bandwidth from.
%   - y = coordinate system for sf values. here, values below 1 are 'fake
%   SF' values (in dir24_sf14 experiments, where there were 13 'real'
%   spatial frequencies and SF of 0 referred to a white flash, coordinates
%   range from 0-13).
% outputs:
%   - FWHM_octaves = full width at half max in octaves (logs.)
%   - FWHM_cycs    = full width at half max in cycles/deg.
%   - HWHM_low     = half width at half max in octaves, low frequency
%   - HWHM_high    = half width at half max in octaves, high frequency

R = abs(R);

% sfs = [2.^[-2:0.5:4]];
sfsUp = 2 .^ linspace(-2, 4, sum(y>=1));
logsUp = linspace(-2, 4, sum(y>=1));

gaussUp = R;
gaussUp = gaussUp(find(y>=1));
[M, I] = max(gaussUp(:));
halfmax = M / 2;

% Find indices closest to half max
[~, I1] = min(abs(gaussUp(1:I) - halfmax));
[~, I2] = min(abs(gaussUp(I+1:end) - halfmax));
I2      = I2 + I;

hm1     = gaussUp(I1);
hm2     = gaussUp(I2);

if I >= length(gaussUp)                                                 % Highpass.... high freq half amplitude never reaches half max.
    FWHM_octaves    = 1000;
    FWHM_cycs       = 1000;
    HWHM_low        = logsUp(I) - logsUp(I1);
    HWHM_high       = 1000;
elseif I <= 1                                                           % Lowpass... low freq half amplitude never reaches half max.
    FWHM_octaves    = -1000; 
    FWHM_cycs       = -1000;
    HWHM_low        = 1000;
    HWHM_high       = logsUp(I2) - logsUp(I);
% elseif hm1 > halfmax & hm2 > halfmax                                    % If there is no true FWHM, bc values never go below half max
%     FWHM_octaves    = NaN;                                               
%     FWHM_cycs       = NaN;
%     HWHM_low        = NaN;
%     HWHM_high       = NaN;
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

end