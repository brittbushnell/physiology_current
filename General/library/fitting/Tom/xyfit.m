function [a,b,chi2] = xyfit(xIn,sx,yIn,sy,varargin)
%XYFIT fit with two independent variables
%
%   Function that fits a line to data with errors in both coordinates. Does
%   type II regression (errors in X and Y) using the routine based on
%   fitexy from [1].
%
%   [1] Press, W. H. et al. (1992) Numerical Recipes in C: The Art of
%       Scientific Computing, Second Edition. 2 edition. Cambridge?; New
%       York: Cambridge University Press.
%
%   The model
%       y = a + b*x
%   returns estimates of a and b, and Chi-square statistic. 
%
%   Note that this function is not a wrapper, but 100% matlab.
%
%   Input:
%   xyfit(x,sx,y,sy)
%       x,y :   Means of two independent variables
%       xs,xy : standard deviations of x and y.
%
%       Optional input arguments :  These arguments come in pairs
%           'plot': toggle result plotting.
%               Default true
%           'nan': remove NaN
%               Default true
%           'zero': remove zeros from sx and xy
%               Default true
%           'ig': initial guess of a and b
%           'initialguess' equavalent to 'ig'
%               [a0 b0] - a0 guess of offset, b0 guess of slope. Note that
%                   currently a0 guess is ignored because mean is
%                   subtracted.
%               Default [] - estimates guess by doing a linear regression.
%
%   Output:
%   [a,b,chi2] = xyfit(..)
%       a :     offset
%       b :     slope
%       chi2 :  ending value of the error minimization (Chi-square)
%
%
% v0: Christopher Shooner <shooner@nyu.edu>: made everything ML
% v1: TvG June 2015, NYU: added plot. added nan and zero removal
% v2: TvG June 2015, NYU: added initial guess.

%% find number of optional arguments and parse them

% Default values
Default = [
    {1,'plot',true} % plot result
    {2,'nan',true} % remove nan
    {3,'zero',true} % remove zero from sigma's
    {4,'ig',[]} % initial guess
    {4,'initialguess',[]}
    
    ];
[   
    flPlot,...
    flRMnan,...
    flRMzero,...
    IG,...
    ] = parse_optional_arg(Default,varargin{:});

%% Complain about input

% vectorize
xIn = xIn(:);
yIn = yIn(:);
sx = sx(:);
sy = sy(:);

% NaNs and zeros
selNaN      = isnan([xIn,sx,yIn,sy]);
selZero     = [sx,sy]==0; % only in sigmas!
selRowNaN   = any(selNaN,2);
selRowZero  = any(selZero,2);
selColNaN   = any(selNaN,1);
selColZero  = any(selZero,1);
if ismember(1,find(selColNaN));
    fprintf(1,'NaN in [x]\n');
end
if ismember(2,find(selColNaN));
    fprintf(1,'NaN in [sx]\n');
end
if ismember(3,find(selColNaN));
    fprintf(1,'NaN in [y]\n');
end
if ismember(4,find(selColNaN));
    fprintf(1,'NaN in [sy]\n');
end
if ismember(1,find(selColZero));
    fprintf(1,'Zero in [sx]\n');
end
if ismember(2,find(selColZero));
    fprintf(1,'Zero in [sy]\n');
end

% throw error if removal is not set
if any(selRowNaN) && ~flRMnan
    error('xyfit:NAN_in_data','There are NaN values in input. xyfit cannot handle NaN values. Use\n\txyfit(..,''nan'',true)\nto ignore these values.')
end
if any(selRowZero) && ~flRMzero
    error('xyfit:Zero_in_data','There are Zeros in input. xyfit cannot handle sigmas that are zero. Use\n\txyfit(..,''zero'',true)\nto ignore these values.')
end
% stddev cannot be < 0
if any(sx<0) || any(sy<0)
    error('xyfit:negative_s','Standard deviation < 0. xyfit cannot handle negative sigmas.')
end

% remove
selRM = selRowNaN | selRowZero;
if any(selRM)
    xIn=xIn(~selRM);
    sx=sx(~selRM);
    yIn=yIn(~selRM);
    sy=sy(~selRM);
    fprintf(1,'%g/%g data points removed\n',sum(selRM),numel(selRM));
end

%% initial guess: Starting parameters
if isempty(IG)
    IG = regress(yIn,[xIn ones(size(xIn))]);
    IG = fliplr(IG(:)'); % first must be offset, second is slope.
end
% The parameter space searched by the minimization routine is [a atan(b)]
% instead of [a b]. I.e. the slope is converted to its arctangent, which
% has a range [-1 1] instead of [-inf inf]. -CS
% First must be zero, because mean is subtracted.
P0 = [0 atan(IG(2))];
%%
% Center data:
xMean = mean(xIn);
yMean = mean(yIn);
x = xIn - xMean;
y = yIn - yMean;

% Minimization options for fminunc:
opt = optimset('Display','off');
opt = optimset(opt,'LargeScale','off');


% Define error function handle using data:
errFun = @(P) xyfiterr(P,x,sx,y,sy);

% Minimize:
[P,chi2] = fminunc(errFun,P0,opt);

% Return fit parameters (correcting for initial centering):
b = tan(P(2));
a = P(1) + yMean - b.*xMean;

if flPlot
    doPlot(xIn,sx,yIn,sy,a,b)
end

end

%% sub functions
function err = xyfiterr(P,x,sx,y,sy)
% This is the error function to minimize
a = P(1);
phi = mod(P(2)+pi/2,pi)-pi/2;
b = tan(phi);
err = sum( (y-a-b.*x).^2./(sy.^2 + b.^2.*sx.^2) );
end

function doPlot(x,sigx,y,sigy,a,b)
figure, hold on
plot(x,y,'s','markersize',5,'markerfacecolor','k','markeredgecolor','k')
mx = [+1 +1]'*x(:)';
sx = [-1 +1]'*sigx(:)';
my = [+1 +1]'*y(:)';
sy = [-1 +1]'*sigy(:)';
plot(mx+sx,my,'-k')
plot(mx,my+sy,'-k')
fit = @(x) b*x + a;
plot(minmax(x(:)'),fit(minmax(x(:)')),'b-','linewidth',4)

end


