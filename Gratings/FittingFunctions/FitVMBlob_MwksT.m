function [param, bhat, funbest] = FitVMBlob_MwksT(oris, sfs, respMat, nStarts)
% Inputs:
%   x = axis (orientation -- in degrees)
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
[maxRow, maxCol] = ind2sub([size(respMat,1) size(respMat,2)], I); % find (row,col) of peak response to use as starting values

or = oris/180 * pi;
or2 = repmat(or',  [1 size(sfs,2)]);     % num oris
sf = log10(sfs);
sf2 = repmat(sf,[size(oris,2) 1]);    % num sfs

% amp = amplitude first blob
% mu_or = mean response for orientation
% mu_sf = mean response for spatial frequency
% kappa_or = some kind of variability in x dim
% kappa_sf = variability in y

% fnBounds = @(sc1,mux,muy,kappa,sdy)           double((mux < 0) |   (mux > 24) | (muy < 0) | (muy > max(y)) | (kappa <= 0))* 1/eps;
fnBounds = @(amp,mu_or,mu_sf,kappa_or,kappa_sf) double((mu_or < 0) | (mu_or <= max(or)) |...
    (mu_sf < 0) | (mu_sf > max(sf)) | (kappa_or <= 1) | (kappa_sf < 1) )* 1/eps;

% fnVMBlob = @(amp,mu_or,mu_sf,kappa_or,kappa_sf) amp*(exp(kappa_or*cos(or2-mu_or)) .* ...
%     exp((-(sf2-mu_sf).^2)/(2*kappa_sf^2)));

fnVMBlob = @(amp,mu_or,mu_sf,kappa_or,kappa_sf) amp.* (exp(kappa_or + cos(or2 - mu_or)) / (pi * besseli(0,kappa_or)) .* ...
    exp((-(sf2-mu_sf).^2)/(2*kappa_sf^2)));

fnOptim = @(beta) sum(sum((fnVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5)) - respMat).^2 )) + ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5));

% Initial parameter guess. Then run the fit.
% Beta = [amp, mu_or, mu_sf, kappa_or, kappa_sf]
if max(respMat(:)) > 3
    BETA0 = [10, maxCol, maxRow, 2, 1]; 
else    
    BETA0 = [0.05, maxCol, maxRow, 2, 1]; 
end

options = optimset('MaxFunEvals',10000, 'Display', 'off');  
for iistart = 1:nStarts
    %iistart
    this_beta0 = BETA0 + rand(1, size(BETA0,2));         
    %   disp('a')
    % fun = sum of residuals squared
    % check help fminsearch/verify
    [param,fun] = fminsearch(fnOptim, this_beta0, options);
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
bhat = fnVMBlob(param(1), param(2), param(3), param(4), param(5));