function [param, bhat, funbest] = FitDVMBlob5(x, R, nStarts, param0)
% VER. 5 %%%%%%%%
% 2 vonMises*Gaussian blobs + 'baseline' 3rd function that is gaussian in spatial frequency. 
% This gaussian is centered at 0.
% Blobs are identical but allowed to vary in amplitude (direction
% selective).
%
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%           [ 1      2     3      4     5      6    7    8   ]
%           [ sc1    sc2   mux    muy   kappa  sdy  scb  sdb ]
%   sc1/sc2 = scale (amplitude) of blobs;
%   mux = peak of blob 1 in ori, muy = peak of blob1 in SF
%   kappa = spread of von Mises, sdy = spread of gaussian
%   scb = scale of 'baseline' gaussian
%   sdb = spread of baseline gaussian
%
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
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, scb, sdb) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy) + ...
    scb*fnGaussian(0, sdb);
fnBounds = @(sc1, sc2, mux, muy, kappa, sdy, scb, sdb) double(...
    (mux < 0) | (mux > max(x)) | (muy < 0) | (muy > max(y)) | ...
    (kappa <= 0) | (kappa > 20) | (sdy <= 0) |...
    (sdb <= 0) ) * 1/eps;

% Minimize the squared error.
fnOptim = @(beta) sum(sum( (fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8)) - mm).^2 ))+ ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8));


% upper and lower bounds. 
% %     sc1    sc2    mux  muy  kappa  sdy  
% lb = [-inf   -inf   0    0    0      0   ];
% ub = [ inf    inf   24   13   20    inf ];
% opt.Algorithm = 'interior-point';
% opt.Display = 'none';


options = optimset('MaxFunEvals',10000, 'Display', 'off'); 

for iistart = 1:nStarts
    % Initial parameter guess
    if iistart < nStarts/2 | isempty(param0)
        %         sc1    sc2   mux    muy   kappa  sdy  scb  sdb
        BETA0 = [ 0.05   0.05  maxx   maxy  2      1    0    1  ];
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

bhat = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end

end