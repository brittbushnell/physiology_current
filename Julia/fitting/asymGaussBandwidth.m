function [FWHM1, FWHM2] = asymGaussBandwidth(sdy, A)
% Asymmetric gaussian used in FitDVMBlob2 has two bandwidths. 
% sdy = bandwidth of the spatial frequency tuning curve below the peak SF
% sdy * A = bandwidth of the SF tuning curve above peak SF

FWHM1 = 2.355 * sdy;

FWHM2 = 2.355 * (sdy*A);