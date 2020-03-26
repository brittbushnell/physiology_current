function [param, bhat, funbest] = FitDVMBlob6(x, R, nStarts, param0)
% VER. 6 %%%%%%%%
% 2 vonMises*Gaussian blobs + 'baseline' 3rd function -- difference of
% Gaussians (centered at '0' spatial frequency)
% Blobs are identical but allowed to vary in amplitude (direction
% selective).
%
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%           [ 1      2     3      4     5      6    7    8     9   10   ]
%           [ sc1   sc2    mux    muy   kappa  sdy  A1   sdy1  A2  sdy2 ]
%   sc1/sc2 = scale (amplitude) of blobs;
%   mux = peak of blob 1 in ori, muy = peak of blob1 in SF
%   kappa = spread of von Mises, sdy = spread of gaussian
%   A1 = amplitude of center gaussian in DoG. sdy1 = spread of center gauss
%   A2 = amplitude of surround gaussian in DoG. sdy2 = spread of surround gauss
%
%   bhat = fitted values
%   funbest = sum residuals squared.

if ~exist('nStarts', 'var')
    nStarts = 200;
end

% Create coordinate system in radians
x       = x/180 * pi;
xx      = repmat(x, [14 1]);
y       = 0:13;
yy      = repmat(y', [1 24]);

mm = R;
[M, I]  = max(mm(:));                                   % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);    
maxx    = maxx/180 * pi;

% A1 = 444.4100; sdy1 = 2.8633; A2 = 424.9400; sdy2 = 2.5819;
% y = 0:13;
% yy = repmat(y', [1 24]);
% diffOfGauss = A1*exp(-(yy.^2)/(2*sdy1^2)) -  A2*exp(-(yy.^2)/(2*sdy2^2));
% figure; 
% nsubplot(3, 1, 1, 1); plot(0:13, nanmean(A1*exp(-(yy.^2)/(2*sdy1^2)),2))
% nsubplot(3, 1, 2, 1); plot(0:13, nanmean(-A2*exp(-(yy.^2)/(2*sdy2^2)),2))
% nsubplot(3, 1, 3, 1); plot(0:13, nanmean(diffOfGauss,2));
% suptitle(sprintf('A1 = %0.2f, sdy1 = %0.2f -- A2 = %0.2f, sdy2 = %0.2f', A1, sdy1, A2, sdy2))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set up fitting functions. 
fnVMBlob = @(mux, muy, kappa, sdy) ...
    fnVonMises(mux,kappa) .* fnGaussian(muy,sdy);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, A1, sdy1, A2, sdy2) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy) + ...
    fnDoG(A1, sdy1, A2, sdy2);
fnBounds = @(sc1, sc2, mux, muy, kappa, sdy, A1, sdy1, A2, sdy2) double(...
    (muy < 0) | (muy > max(y)) | ...
    (kappa <= 0) | (kappa > 30) | (sdy <= 0)  | ...
    (A1 <= 0) | (A2 <= 0) | ...                                            % Constrain center to be positive relative to surrounding gaussian.
    (sdy2 > sdy1) | (sdy1 < 0.3) | (sdy2 < 0.3) ) * 1/eps;  
% Minimize the squared error.
fnOptim = @(beta) sum(sum( (fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9),beta(10)) - mm).^2 ))+ ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9),beta(10));


% Run the fit iteratively.
options = optimset('MaxFunEvals',10000, 'Display', 'off'); 

for iistart = 1:nStarts
    % Initial parameter guess
    if iistart < nStarts/2 | isempty(param0)
        %         sc1    sc2   mux    muy   kappa  sdy  A1   sdy1  A2  sdy2         
        BETA0 = [ 0.05   0.05  maxx   maxy  2      1    1    2     0.5 1  ];
    else 
        BETA0 = param0;
    end
    this_beta0 = BETA0 + rand(1, size(BETA0,2));  
    [param_,fun] = fminsearch(fnOptim, this_beta0, options);
    %[param_,fun] = fmincon(fnOptim, this_beta0, [],[],[],[],lb, ub, [], opt);
    if iistart == 1
        funbest = fun;
        param = param_;
    end
    if (fun < funbest)
        funbest = fun;
        param = param_;
    end
end

bhat = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9), param(10));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions used in inline fitting functions.
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