function [param, bhat, funbest] = FitDVMBlob4(x, R, nStarts, param0);
% VER. 4 %%%%%%%%
% 2 vonMises*Gaussian blobs. Each blob is composed of vonMises and
% asymmetric Gaussian with kappa and sdy allowed to vary independently for
% each blob.
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
fnVMBlob = @(mux, muy, kappa, sdy, A) ...
    fnVonMises(mux,kappa) .* fnAsymGaussian(muy,sdy,A);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy, A, kappa2, sdy2, A2) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy, A) + sc2*fnVMBlob(mux+pi, muy, kappa2, sdy2, A2);
fnBounds = @(sc1, sc2, mux, muy, kappa, sdy, A, kappa2, sdy2, A2) double(...
    (mux < 0) | (mux > max(x)) | (muy < 0) | (muy > max(y)) | ...
    (kappa <= 0) | (kappa > 20) | (sdy <= 0) | (A < 0) | ...
    (kappa2 <= 0) | (kappa2 > 20)| (sdy2 <= 0) | (A2 < 0)) * 1/eps;

% Function to minimize -- squared error.
fnOptim = @(beta) ...
    sum(sum(( fnDVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9),beta(10)) - mm).^2 )) + ...
    fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5),beta(6),beta(7),beta(8),beta(9),beta(10));

% % upper and lower bounds. 
% %     sc1    sc2    mux  muy  kappa  sdy  A     kappa2   sdy2   A2
% lb = [-inf   -inf   0    0    0      0    0     0        0      0   ];
% ub = [ inf    inf   24   13   20    inf   inf   20       inf    inf ];
% opt.Algorithm = 'interior-point';
% opt.Display = 'none';

options = optimset('MaxFunEvals',10000, 'Display', 'off'); 

for iistart = 1:nStarts
    if iistart < nStarts/2 | isempty(param0)
        %         sc1    sc2    mux  muy  kappa  sdy    A    kappa2   sdy2   A2
        BETA0 = [ 0.05   0.05   maxx   maxy  2     1    1    2        1      1 ];
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

bhat = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6),param(7),param(8),param(9),param(10));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function asymGaussian = fnAsymGaussian(muy, sdy, A)
%     if yy <= muy
%         asymGaussian = exp((-(yy-muy).^2) / (2*sdy^2));
%     else
%         asymGaussian = exp((-(yy-muy).^2) / (2*(sdy*A)^2));
%     end

    % Not the most elegant solution but at least it works.
    asymGaussian = NaN(size(yy));
    temp = exp((-(yy-muy).^2) / (2*sdy^2));
    temp2 = exp((-(yy-muy).^2) / (2*(sdy*A)^2));
    asymGaussian(find(y<=muy),:) = temp(find(y<=muy),:);
    asymGaussian(find(y>muy),:) = temp2(find(y>muy),:);
end

end