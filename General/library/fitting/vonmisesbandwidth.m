%VONMISESBANDWITH calculate FWHM for a von mises function
%
%   This function return the bandwidth (Full-width at Half-max) based on
%   the von mises parameters
%
%   Input
%   vonmisesbandwidth(b)
%       b :     Fit parameters (see VONMISESFIT)
%
%   Output
%   fullbw = vonmisesbandwidth(..)
%       fullbw :    FWHM
%
% V0 TvG July 2015 : outsourced from old vonmises fit.

function fullbw = vonmisesbandwidth(b)

% calculate half the amplitude of the vonmises at its peak
halfheight = b(:,2) .* exp(b(:,4)) ./ (2.0*pi*besseli(0,b(:,4))) / 2 ;

% make a function that returns the difference between the vonmises equation
% and a particular y value (in this case, halfheight).
errfun = @(b,h,x) abs(b(2).*exp(b(4)*cosd(x))/(2.0*pi*besseli(0,b(4))) - h);

% use fminsearch to find the x location when the above equation is
% minimized.
halfbw = nan(size(b,1),1);
for iF = 1:size(b,1)
    halfbw(iF) = fminsearch(@(x) errfun(b(iF,:),halfheight(iF),x),0);
end
% convert the halfbandwidth into a fullbandwidth by doubling! Halfbandwidth
% is symmetrical around zero (so we use the absolute value).
fullbw = 2*abs(halfbw);

% display full bandwidth at half maximum
%fprintf('full bandwidth at half maximum\nbandwidth = %.1f deg\n',fullbw);
