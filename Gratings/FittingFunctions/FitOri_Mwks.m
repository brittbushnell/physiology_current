function [param, bhat, funbest,this_beta0] = FitOri_Mwks(oris, respMat, nStarts)
% Inputs:
%   oris = orientations used (in degrees)
%   sfs  = spatial frequencies 
%   respMat = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%   bhat = fitted values
%   funbest = function value (from fmincon -- lower the better)
%
% NOTE: if the number of either SFs or Orientations changes, it may cause
% an error where matrix dimensions do not match and cannot do matrix
% multiplication. If that happens, the first thing to check is the
% dimensions of xx and yy

if ~exist('nStarts', 'var')
    nStarts = 200;
end

[~, I] = max(respMat(:));                                   
[maxRow] = ind2sub([size(respMat,1) size(respMat,2)], I); % find (row,col) of peak response to use as starting values

or = linspace(0,360,length(oris));
or = deg2rad(or);
%or =  oris/180 * pi;
%or2 = repmat(or',  [1 size(sfs,2)]);     % num oris

% amp = amplitude first blob
% mu_or = mean response for orientation
% kappa_or = some kind of variability in x dim
% fnOrBounds = @(amp,mu_or,kappa_or) double((amp > 0) | (amp <= max(respMat(:))) |...
%     (mu_or > 0) | (mu_or <= max(or)) |...
%     (kappa_or > 0)) * 1/eps;
fnOrBounds = @(amp,mu_or,kappa_or) double((amp < 0) | (amp >= max(respMat(:))) |...
    (mu_or < 0) | (mu_or >= max(or)) |...
    (kappa_or < 0)) * 1/eps;

fnVM = @(amp,mu_or,kappa_or) amp .* (exp(kappa_or*cos(or-mu_or)));

fnOrOptim = @(beta) sum(sum((fnVM(beta(1),beta(2),beta(3)) - respMat).^2 )) + ...
   fnOrBounds(beta(1),beta(2),beta(3));

% fnOrOptim = @(beta) sum(sum((fnVM(beta(1),beta(2),beta(3)) - respMat).^2 ));

% Initial parameter guess. Then run the fit.
% Beta = [amp, mu_or, kappa_or]
if max(respMat(:)) > 3
    BETA0 = [10, or(maxRow), 2]; 
else    
    BETA0 = [0.05, or(maxRow), 2]; 
end

options = optimset('MaxFunEvals',10000, 'Display', 'on');  
for iistart = 1:nStarts
    %iistart
    this_beta0 = BETA0 + rand(1, size(BETA0,2));         
    %   disp('a')
    % fun = sum of residuals squared
    % check help fminsearch/verify
    [param,fun] = fminsearch(fnOrOptim, this_beta0, options);
    % disp('b')
    if iistart == 1
     %          disp('c')
        funbest = fun;
        parambest = param;
    end
    if (fun < funbest)
      %         disp('d')
        funbest = fun;
        parambest = param;
    end
    %fprintf('%d', iistart)
    %   disp('e')
end
% disp('f')
param = parambest;
bhat = fnVM(param(1), param(2), param(3));
