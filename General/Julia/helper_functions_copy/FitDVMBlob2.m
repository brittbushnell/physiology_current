function [param, bhat, funbest] = FitDVMBlob2(x, R, nStarts);
% VER. 2 %%%%%%%%
% 2 vonMises*Gaussian blobs. Same standard deviation (sigma) for both blobs
% in Gaussian (SF), but kappa allowed to vary (width of orientation
% tuning).
%
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%   bhat = fitted values
%   funbest = sum residuals squared.

if ~exist('nStarts', 'var')
    nStarts = 200;
end

mm = R;
[M, I] = max(mm(:));                                   % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);    
maxx = maxx/180 * pi;

% Create coordinate system in radians
x = x/180 * pi;
xx = repmat(x, [14 1]);
y = 0:13;
yy = repmat(y', [1 24]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up fitting functions. 
fnVMBlob = @(mux, muy, kappa, sdy) ...
    fnVonMises(mux,kappa) .* fnGaussian(muy,sdy);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, kappa2) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy) + sc2*fnVMBlob(mux+pi, muy, kappa2, sdy);
% Function to minimize.
% Minimize the squared error.
fnOptim = @(beta) sum(sum(( fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7)) - mm).^2 ));

% upper and lower bounds. 
%     sc1    sc2    mux  muy  kappa  sdy  kappa2
lb = [-inf   -inf   0    0    0      0    0    ];
ub = [ inf    inf   24   13   20    inf   20   ];

opt.Algorithm = 'interior-point';
opt.Display = 'none';

% Initial paramter guess. Then run the fit.
%         sc1    sc2    mux    muy  kappa  sdy  kappa2
BETA0 = [ 0.05   0.05   maxx   maxy  2     1    2    ];

for iistart = 1:nStarts
  this_beta0 = BETA0 + rand(1, size(BETA0,2));        
  [param_,fun] = fmincon(fnOptim, this_beta0, [],[],[],[],lb, ub, [], opt);
  if iistart == 1
    funbest = fun;
    param = param_;
  end
  if (fun < funbest)
    funbest = fun;
    param = param_;
  end
end

bhat = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6),param(7));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end

end
