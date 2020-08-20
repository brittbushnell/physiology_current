
function [param, bhat, funbest] = FitVMBlob_Mwks_NJM(oris, sfs, R, nStarts)
% Inputs:
%   x = axis (orientation -- in degrees)
%   R = values to be fitted (matrix of SF x orientation responses)
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


R = [13.4896   25.1042   25.5208   16.1979   14.0625    9.8799   11.1458;
   13.2292   30.2083   25.6250   14.4792   11.3542   10.5208   13.3333;
   10.5208   33.0208   27.1875   18.0085   11.5625    9.2708   11.9792;
   11.9792   30.3125   28.4375   19.5833   11.8750   12.7083   14.8958;
   13.0208   27.3958   29.5833   20.7292   15.1042   12.8125   16.4583;
   10.0000   24.6875   33.2292   17.8125   14.1667   11.4583    9.6875];

sfs = [0    0.3125    0.6250    1.2500    2.5000    5.0000   10.0000];
oris = [0    30    60    90   120   150];


mm = R;
m = mean(mm,1);
[~, I] = max(mm(:));                                   % find indices of peak response as starts
[maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);
% Create coordinate system in radians



x = oris/180 * pi;
xx = repmat(x',  [1 size(sfs,2)]);     % num oris
y = log10(sfs);
yy = repmat(y,[size(oris,2) 1]);    % num sfs

% sc1 = amplitude first blob
% sc2 = amp of second blob
% mux = x value (SF) of center of first blob
% muy = y val (ori) of center of first blob
% kappa = some kind of variability in x dim
% sdy = variability in y


% 
% fnVMBlob = @(sc1,mux,muy,kappa,sdy) sc1*(exp(kappa*cos(xx-mux)) .* ...
%     exp((-(yy-muy).^2)/(2*sdy^2)));
% 
% fnOptim = @(beta) sum(sum((fnVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5)) - mm).^2 )) + ...
%     fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5));


fnBounds = @(sc1,muy,sdy) double((sc1 < 0) | (sc1 > max(R(:))) |...
    (muy < min(y)) | (muy > max(y)) | (sdy < 0) )* 1/eps;

fnVMBlob = @(sc1,muy,sdy) sc1*exp((-(y(2:end)-muy).^2)/(2*sdy^2));

fnOptim = @(beta) sum(sum((fnVMBlob(beta(1),beta(2),beta(3)) - m(2:end)).^2 )) + ...
    fnBounds(beta(1),beta(2),beta(3));

% Initial parameter guess. Then run the fit.
% Beta = [sc1, mux, muy, kappa, sdy]
% if max(R(:)) > 3
%     BETA0 = [10, maxx, maxy, 2, 1]; 
% else    
%     BETA0 = [0.05, maxx, maxy, 2, 1]; 
% end

BETA0 = [10,y(maxx),1]; 

options = optimset('MaxFunEvals',10000, 'Display', 'off');    % increase max number of function evaluations?
for iistart = 1:nStarts
    %iistart
    this_beta0 = BETA0 + rand(1, size(BETA0,2));         %(-2 + 4*rand(1, size(BETA0,2)));
    %   disp('a')
    % fun = sum of residuals squared
    % check help fminsearch/verify
    [param,fun] = fminsearch(fnOptim, this_beta0, options);
    % disp('b')
    if iistart == 1
        %       disp('c')
        funbest = fun;
        parambest = param;
    end
    if (fun < funbest)
        %       disp('d')
        funbest = fun;
        parambest = param;
    end
    %fprintf('%d', iistart)
    %   disp('e')
end
% disp('f')
param = parambest;
bhat = fnVMBlob(param(1), param(2), param(3), param(4), param(5));

%%
% function [param, bhat, funbest] = FitVMBlob_Mwks_NJM(oris, sfs, R, nStarts)
% % Inputs:
% %   x = axis (orientation -- in degrees)
% %   R = values to be fitted (matrix of SF x orientation responses)
% %   nStarts = number of times to run the fit
% % Outputs:
% %   param = optimum parameters for model, as determined by fmincon
% %   bhat = fitted values
% %   funbest = function value (from fmincon -- lower the better)
% %
% % NOTE: if the number of either SFs or Orientations changes, it may cause
% % an error where matrix dimensions do not match and cannot do matrix
% % multiplication. If that happens, the first thing to check is the
% % dimensions of xx and yy
% 
% if ~exist('nStarts', 'var')
%     nStarts = 200;
% end
% 
% mm = R;
% [~, I] = max(mm(:));                                   % find indices of peak response as starts
% [maxy, maxx] = ind2sub([size(mm,1) size(mm,2)], I);
% % Create coordinate system in radians
% 
% 
% 
% x = oris/180 * pi;
% xx = repmat(x',  [1 size(sfs,2)]);     % num oris
% y = log10(sfs(2:end));
% yy = repmat(y,[size(oris,2) 1]);    % num sfs
% 
% % sc1 = amplitude first blob
% % sc2 = amp of second blob
% % mux = x value (SF) of center of first blob
% % muy = y val (ori) of center of first blob
% % kappa = some kind of variability in x dim
% % sdy = variability in y
% 
% fnBounds = @(sc1,mux,muy,kappa,sdy) double((mux < 0) | (mux > max(R(:))) |...
%     (muy < 0) | (muy > max(y)) | (kappa < 0) | (sdy < 0) )* 1/eps;
% 
% fnVMBlob = @(sc1,mux,muy,kappa,sdy) sc1*(exp(kappa*cos(xx-mux)) .* ...
%     exp((-(yy-muy).^2)/(2*sdy^2)));
% 
% fnOptim = @(beta) sum(sum((fnVMBlob(beta(1),beta(2),beta(3),beta(4),beta(5)) - mm).^2 )) + ...
%     fnBounds(beta(1),beta(2),beta(3),beta(4),beta(5));
% 
% % Initial parameter guess. Then run the fit.
% % Beta = [sc1, mux, muy, kappa, sdy]
% if max(R(:)) > 3
%     BETA0 = [10, x(maxy),y(maxx-1), 2, 1]; 
% else    
%     BETA0 = [0.05, maxx, maxy, 2, 1]; 
% end
% 
% options = optimset('MaxFunEvals',10000, 'Display', 'off');    % increase max number of function evaluations?
% for iistart = 1:nStarts
%     %iistart
%     this_beta0 = BETA0 + rand(1, size(BETA0,2));         %(-2 + 4*rand(1, size(BETA0,2)));
%     %   disp('a')
%     % fun = sum of residuals squared
%     % check help fminsearch/verify
%     [param,fun] = fminsearch(fnOptim, this_beta0, options);
%     % disp('b')
%     if iistart == 1
%         %       disp('c')
%         funbest = fun;
%         parambest = param;
%     end
%     if (fun < funbest)
%         %       disp('d')
%         funbest = fun;
%         parambest = param;
%     end
%     %fprintf('%d', iistart)
%     %   disp('e')
% end
% % disp('f')
% param = parambest;
% bhat = fnVMBlob(param(1), param(2), param(3), param(4), param(5));

