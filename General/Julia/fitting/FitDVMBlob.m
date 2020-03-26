function [param, bhat, funbest] = FitDVMBlob(x, R, nStarts)
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%   bhat = fitted values
%   funbest = function value (from fmincon -- lower the better)

if ~exist('nStarts', 'var')
    nStarts = 200;
end

mm = R;
[M, I] = max(mm(:));                                   % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);   

% Create coordinate system in radians
x = x/180 * pi;
xx = repmat(x, [14 1]);                         %%%% Adjust these values for however densely sampled your stimulus space is!
y = 0:13;
yy = repmat(y', [1 24]);
    
% sc1 = amplitude first blob
% sc2 = amp of second blob
% mux = x value (ori) of center of first blob
% muy = y val (SF) of center of first blob
% kappa = some kind of variability in x dim
% sdy = variability in y 

fnBounds = @(sc1,sc2,mux,muy,kappa,sdy,muy2,kappa2,sdy2) double((mux < 0) | (mux > 24) |...
        (muy < 0) | (muy > max(y)) | (kappa <= 0) | (sdy <= 0) | ...
        (muy2 < 0) | (muy2 > max(y)) | (kappa2 <= 0) | (sdy2 <= 0))* 1/eps;
% if fitting just one blob, then incorporate amplitude parameter directly
% below vv
fnVMBlob = @(mux,muy,kappa,sdy) exp(kappa*cos(xx-mux)) .* ...
    exp((-(yy-muy).^2)/(2*sdy^2));
fnDVMBlob = @(sc1,sc2,mux,muy,kappa,sdy,muy2,kappa2,sdy2) ...
            sc1*fnVMBlob(mux,muy,kappa,sdy) + sc2*fnVMBlob(mux + ...
            pi,muy2,kappa2,sdy2);
fnOptim = @(beta) sum(sum((fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9)) - mm).^2 )) + ...
        fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5), beta(6),beta(7),beta(8),beta(9));

% Initial parameter guess. Then run the fit.
% Beta = [sc1, sc2, mux, muy, kappa, sdy]
BETA0 = [0.05, 0.05, maxx, maxy, 2, 1, maxy, 2, 1];
          
options = optimset('MaxFunEvals',10000, 'Display', 'off');    % increase max number of function evaluations?  
for iistart = 1:nStarts
  this_beta0 = BETA0 + rand(1, size(BETA0,2));         %(-2 + 4*rand(1, size(BETA0,2)));   
  [param,fun] = fminsearch(fnOptim, this_beta0, options);

  if iistart == 1
    funbest = fun;
    parambest = param;
  end
  if (fun < funbest)
    funbest = fun;
    parambest = param;
  end
  %fprintf('%d', iistart)
end

param = parambest;   
bhat = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6), param(7), param(8), param(9));