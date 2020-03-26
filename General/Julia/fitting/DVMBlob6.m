function [r, vmBlobs, dogBase] = DVMBlob6(x, y, P)
% Input: 
%   x = orientation coordinate plane (in degrees)
%   y = spatial frequency coordinate plane ('fake' log scale, from 0).
%       Note, this should be between 0-13.
%   P = model parameters, from FitDVMBlob6
%           [ 1      2     3      4     5      6    7    8     9   10   ]
%           [ sc1   sc2    mux    muy   kappa  sdy  A1   sdy1  A2  sdy2 ]
%   sc1/sc2 = scale (amplitude) of blobs;
%   mux = peak of blob 1 in ori, muy = peak of blob1 in SF
%   kappa = spread of von Mises, sdy = spread of gaussian
%   A1 = amplitude of center gaussian in DoG. sdy1 = spread of center gauss
%   A2 = amplitude of surround gaussian in DoG. sdy2 = spread of surround gauss

% Create coordinate system in radians
x       = x/180 * pi;
xx      = repmat(x, [length(y) 1]);
yy      = repmat(y', [1 length(x)]);


% Construct the surface.
fnVMBlob = @(mux, muy, kappa, sdy) ...
        fnVonMises(mux,kappa) .* fnGaussian(muy,sdy);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, A1, sdy1, A2, sdy2) ...
        sc1*fnVMBlob(mux, muy, kappa, sdy) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy) + ...
        fnDoG(A1, sdy1, A2, sdy2);
r       = fnDVMBlob(P(1),P(2),P(3),P(4),P(5),P(6),P(7),P(8),P(9),P(10));
vmBlobs = fnDVMBlob(P(1),P(2),P(3),P(4),P(5),P(6),0,   1,  0,   1);
dogBase = fnDVMBlob(0,   0,   P(3),P(4),P(5),P(6),P(7),P(8),P(9),P(10));

% Functions used in inline fitting functions. %%%%%%%%%%%%
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end
function diffOfGauss = fnDoG(A1, sdy1, A2, sdy2)
   diffOfGauss = A1*exp(-(yy.^2)/(2*sdy1^2)) -  A2*exp(-(yy.^2)/(2*sdy2^2));
end

end