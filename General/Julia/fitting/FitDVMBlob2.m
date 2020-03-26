function [param, bhat, fval] = FitDVMBlob2(x, R, nStarts,param0);
% Experiment with FitDVMBlob. 2 von Mises x Gaussian blobs allowed to vary
% in amplitude from each other. The Gaussian function is asymmetric; this
% allows for different bandwidths for spatial frequency above and below the
% peak. The gaussians are the same for both peaks.
%
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
%   param0 (optional) -- starting parameters for the fitting function
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%   [ 1      2      3     4    5      6      7 ] 
%   [sc1     sc2    mux   muy  kappa  sdy    A ] 
%   sc1/sc2 = scale (amplitude) of blobs;
%   mux = peak of blob 1 in ori, muy = peak of blob1 in SF
%   kappa = spread of von Mises
%   sdy = spread of one half of asymmetric gaussian, A = scaling factor of
%   other half of asymmetric gaussian
%
%   bhat = fitted values
%   funbest = function value (from fmincon -- lower the better)

mm = R;

% Create coordinate system for fitting
x = x/180 * pi;
xx = repmat(x, [14 1]);
y = [0:13];
yy = repmat(y', [1 24]);

[M, I] = max(mm(:));                                   % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);    
maxx = x(maxx);

%%%%

% Set up fitting functions. 
fnVMBlob = @(mux, muy, kappa, sdy, A) ...
    fnVonMises(mux,kappa) .* fnAsymGauss(muy,sdy,A);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, A) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy, A) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy, A);
fnBounds = @(sc1, sc2, mux, muy, kappa, sdy, A) double(...
    (muy < 0) | (muy > max(y)+2) | ...          
    (kappa <= 0) | (kappa > 20) | (sdy <= 0) | (A < 0)) * 1/eps;
    %(mux < 0) | (mux > max(x)) |               % Direction can't be bounded...just mod 360 it.

% Minimize the squared error.
fnOptim = @(beta) sum(sum(( fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7)) - mm).^2 )) + ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7));
options = optimset('MaxFunEvals',10000, 'Display', 'off'); 

% Initial paramter guess. Then run the fit.

options = optimset('MaxFunEvals',10000, 'Display', 'off'); 
 
for iistart = 1:nStarts
    if iistart < nStarts/2 | isempty(param0)
        %         sc1    sc2    mux    muy  kappa  sdy    A
        BETA0 = [ 0.05   0.05   maxx   maxy  2      1     1  ];
    else
        BETA0 = param0;
    end
    this_beta0 = BETA0 + rand(1,length(BETA0));       
    [param_,fun] = fminsearch(fnOptim, this_beta0, options);
    %[param_,fun] = fminsearch(fnOptim, BETA0,options);
    if iistart == 1
        fval = fun;
        param = param_;
    end
    if (fun < fval)
        fval = fun;
        param = param_;
    end
end

bhat = fnDVMBlob(param(1),param(2),param(3),param(4),param(5),...
    param(6),param(7));

% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function asymGaussian = fnAsymGauss(muy, sdy, A)            % janky but it works...?
    asymGaussian = NaN(size(yy));
    temp = exp((-(yy-muy).^2) / (2*sdy^2));
    temp2 = exp((-(yy-muy).^2) / (2*(sdy*A)^2));
    asymGaussian(find(y<=muy),:) = temp(find(y<=muy),:);
    asymGaussian(find(y>muy),:) = temp2(find(y>muy),:);
end

end