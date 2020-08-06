function [paramOut, bhat, funbest] = FitVMBlob_Mwks_ASYM(oris, sfs, respMat, nStarts)
% Inputs:
%   oris = orientations used (in degrees)
%   sfs  = spatial frequencies
%   respMat = values to be fitted (matrix of SF x orientation responses, include blank and lum flashes)
%   nStarts = number of times to run the fit
% Outputs:
%   param = optimum parameters for model, as determined by fmincon
%       1: amplitude (gain)
%       2: mu_or
%       3: mu_sf
%       4: kappa_or
%       5: kappa_sf
%       6: asymmetry
%   bhat = fitted values
%   funbest = function value (from fmincon -- lower the better)
%


if ~exist('nStarts', 'var')
    nStarts = 200;
end
base = mean(respMat(:,1));

sfs = sort(sfs);
if sfs(1) == 0
    sfs = sfs(:,4:end); %get rid of sf0 and lum flashes
end

respMat2 = respMat(:,4:end);
[~, I] = max(respMat2(:));
[maxRow, maxCol] = ind2sub([size(respMat2,1) size(respMat2,2)], I); % find (row,col) of peak response to use as starting values

% or = linspace(0,360,length(oris));
% or = deg2rad(or);
or  = deg2rad(oris);
or2 = repmat(or',  [1 size(sfs,2)]);     % num oris

sf = log10(sfs);
sf2 = repmat(sf,[size(oris,2) 1]);    % num sfs

% amp = amplitude first blob
% mu_or = mean response for orientation
% mu_sf = mean response for spatial frequency
% kappa_or = some kind of variability in x dim
% kappa_sf = variability in y

% fnBounds = @(sc1,mux,muy,kappa,sdy)double((mux < 0) |   (mux > 24) | (muy < 0) | (muy > max(y)) | (kappa <= 0))* 1/eps;

% fnBounds = @(amp,mu_or,mu_sf,kappa_or,kappa_sf) double((mu_or < 0) |...
%     (mu_sf > 1) | ...
%     (kappa_or <= 0)* 1/eps);% | ...
% (kappa_sf <= 0) ) * 1/eps;

fnVMBlob = @(amp,mu_or,mu_sf,kappa_or,kappa_sf,A) base + amp .* (exp((cos(or2-mu_or)./kappa_or)) .* ...
    fnAsymGaussian(mu_sf,kappa_sf,A,sf,sf2) .*exp(mu_sf));
%     exp((-(sf2-mu_sf).^2)/(2*kappa_sf^2)))...
%     .* exp(mu_sf); % added by momo who loves you

% want to minimize the sum of squared errors
fnOptim = @(beta) sum(sum((fnVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5), beta(6)) - respMat2).^2 )); % + ...
% fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5));

if max(respMat(:)) > 3
    % amp, mu_or, mu_sf, kappa_or, kapppa_sf, A
    BETA0 = [10, maxRow, sf(maxCol), 2, 1, 1];
else
    BETA0 = [0.05,maxRow, sf(maxCol), 2, 1, 1];
end

options = optimset('MaxFunEvals',10000, 'Display', 'off');
for iistart = 1:nStarts
    %iistart
    this_beta0 = BETA0 + rand(1, size(BETA0,2));
    %   disp('a')
    % fun = sum of residuals squared
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
paramOut = param;

paramOut(2) = rad2deg(param(2));
% paramOut(2) = mod(paramOut(2),360);  % this will make the number between 0 and 360
% if paramOut(2) >180
%     paramOut(2) = paramOut(2) - 180;
% end

paramOut(3) = 10.^(param(3));

bhat = fnVMBlob(param(1), param(2), param(3), param(4), param(5), param(6));
%%
function asymGaussian = fnAsymGaussian(mu_sf, kappa_sf, A, sf, sf2)
%     if yy <= muy
%         asymGaussian = exp((-(yy-muy).^2) / (2*sdy^2));
%     else
%         asymGaussian = exp((-(yy-muy).^2) / (2*(sdy*A)^2));
%     end

% Not the most elegant solution but at least it works.
asymGaussian = NaN(size(sf2));
temp = exp((-(sf2-mu_sf).^2) / (2*kappa_sf^2));
temp2 = exp((-(sf2-mu_sf).^2) / (2*(kappa_sf*A)^2));
asymGaussian(find(sf<=mu_sf),:) = temp(find(sf<=mu_sf),:);
asymGaussian(find(sf>mu_sf),:) = temp2(find(sf>mu_sf),:);
%end