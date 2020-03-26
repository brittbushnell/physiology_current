function [param, bhat, funbest] = FitVMBlob(R, nStarts)
% Fit a von Mises x gaussian blob to a 2-dimensional matrix of responses to
% grating stimuli (range of spatial frequencies and orientations). 
% ASSUMING NO SF OF 0.
%
% Inputs:
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fitting function
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%   bhat = fitted values
%   funbest = function value (mean squared error)

if ~exist('nStarts', 'var')
    nStarts = 200;
end

[M, I] = max(R(:));                                                        % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(R,1) size(R,2)], I);    
maxx = maxx/180 * pi;

% Create coordinate system for fitting
nSf = size(R,1);
nOri = size(R,2);
x = linspace(0, 180, nOri+1);
x = x(1:end-1);
x = x/180 * pi;                                                            % convert to radians
xx = repmat(x, [nSf 1]);
y = 1:nSf;
yy = repmat(y', [1 nOri]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up fitting functions. 
fnVMBlob = @(sc1, mux, muy, kappa, sdy) ...
    sc1 * (fnVonMises(mux,kappa) .* fnGaussian(muy,sdy));
fnBounds = @(sc1, mux, muy, kappa, sdy) double(...
    (muy < 0) | (muy > max(y)) | ...
    (kappa <= 0) | (kappa > 20) | (sdy <= 0) ) * 1/eps;
fnOptim = @(beta) ...
    sum(sum(( fnVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5)) - R).^2 )) + ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5));

% Run the fit.
options = optimset('MaxFunEvals',10000, 'Display', 'off'); 
for iistart = 1:nStarts
    % Initial parameter guess
    %         sc1    mux    muy   kappa  sdy
    BETA0 = [ 0.05   maxx   maxy  2      1 ];
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

bhat = fnVMBlob(param(1), param(2), param(3), param(4), param(5));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end

end %function