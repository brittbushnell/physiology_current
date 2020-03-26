%GET_RSQ_FROM_FIT computes r square
%
%   This function computes the r-square after a fit was performed. It
%   computes the sum of squares according to [1]. 
%       R^2 = 1 - {SS_{\rm res}\over SS_{\rm tot}}
%
%   Input:
%       get_rsq_from_fit(Xdata,Ydata,fitfun,betas)
%       Xdata,Ydata: data points
%           Mx1 sized matrix, meaning data points are multiple rows in a
%           single column. In the future the second dimension (columns)
%           might become useful for multi dimensional fits.
%       fitfun: fitting function. 
%           Note that this is not the function for fminsearch or so. It
%           is the actual fitting function.
%       betas: fitting parameters
%
%       get_rsq_from_fit(Xdata,Ydata,Res)
%       Res: residuals from fit
%
%   Output:
%       Rsq = get_rsq_from_fit(..)
%       Rsq: R-square
%
% [1] http://en.wikipedia.org/wiki/Coefficient_of_determination#Definitions
%
% V0 TvG Apr 2015, NYU: outsourced from fitting functions

%TODO: multiple dimensions for Xdata,Ydata

function Rsq = get_rsq_from_fit(Xdata,Ydata,FitFun,betas)

% residuals as the third argument or compute it.
if nargin < 4 && ~isa(FitFun,'function_handle')
    Res = FitFun;
else
    Res = Ydata-FitFun(betas,Xdata);
end

% n data points
if size(Xdata,1) ~= size(Ydata,1) || size(Xdata,1) ~= size(Res,1) || size(Xdata,2) ~= size(Ydata,2) || size(Xdata,2) ~= size(Res,2)
    error('fit:rsq:input','Input [Xdata] and [Ydata] (and [Res]) need to be the same size')
else
    nDat = size(Xdata,1);
end

% ss : sum of squares
% SSres : SS of the residuals
% SStot : SS between the data points and their mean
SSres   = sum(Res.^2,1);
SStot   = sum((Ydata-repmat(mean(Ydata,1),nDat,1)).^2,1);
% SSres expressed as fraction of residue from mean
Rsq     = 1-(SSres./SStot);


%%
return

figure
hold on
fplot(@(x) FitFun(betas,x),[0 40])
plot(Xdata,Ydata,'x')
plot(Xdata,FitFun(betas,Xdata),'s')
plot(Xdata,repmat(mean(Ydata,1),nDat,1),'d')