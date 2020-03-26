%VONMISESFIT fits a Von Mises function
%
%   This function fits a circular Gaussian or Von Mises function through
%   the data.
%
%   This function is partly a wrapper for ANYFIT.
%
%   The function is defined as (see also [1]):
%       f(x|m,k) = exp(k*cos(x-m)) / 2*pi*I0(k)
%           x: the independent variable (motion direction)
%           f(x): dependent variable (firing rate)
%       constants or parameters:
%           m: mu, mean, "location"
%           k: shape, "concentration"
%           I0(k): modified Bessel function of order 0 (see BESSELI) 
%       Not in the definition, but the function also fits an offset and gain.
%
% [1] https://en.wikipedia.org/wiki/Von_Mises_distribution#Definition
%
%
%   Input:
%   vonmisesfit(x,y)
%       x :	independent variable 
%       y :	dependent variable
%       Optional arguments: These come in pairs
%           'lowerbound' , 'lb': fit restrictions
%           'upperbound' , 'ub': fit restrictions
%               Default [0 -inf 0 0] and [+inf +inf 360 +inf]
%           'initialguess', 'ig': initial guess
%               Default uses initialguess_.. routine
%           'silent': Do not output to screen.
%               Default false
%
%   Output:
%   [beta, betavar, function, stat, betacon] = vonmisesfit(..)
%       beta :      fitted parameters
%       betavar :   variance of betas
%       function :  Function handle
%       stat :      Statistical information
%       betacon :   As beta, but with constrained (fixed) betas excluded.
%
% V0: TvG July,2015, NYU: used old routine and wrapped anyfit inside.
% v1: TvG Aug, 2015, NYU: improved help

function varargout = vonmisesfit(Xdata,Ydata,varargin)

%%
vonmisesfun = @(b,x) b(1) + b(2) .* exp(b(4)*cosd(x-b(3))) / (2*pi*besseli(0,b(4)));
% actual function.
%b(1):offset
%b(2):gain
%b(3):mu, mean 0-360 deg
%b(4):k, shape. 0: uniform

%% input
if isvector(Xdata)
    Xdata = Xdata(:);
    Ydata = Ydata(:);
end

% get some size information
[nDat,nFit] = size(Xdata);

% optional arguments
dLB(:,1)     = 0     .*ones(nFit,1);
dLB(:,2)     = -inf  .*ones(nFit,1);
dLB(:,3)     = 0     .*ones(nFit,1);
dLB(:,4)     = 0     .*ones(nFit,1);

dUB(:,1)     = +inf  .*ones(nFit,1);
dUB(:,2)     = +inf  .*ones(nFit,1);
dUB(:,3)     = 360   .*ones(nFit,1);
dUB(:,4)     = +inf  .*ones(nFit,1);

dIG          = initialguess_vonmises(Xdata,Ydata);

Default = [
    {1,'silent',false}
    {2,'lowerbound',dLB}
    {2,'lb',dLB}
    {3,'upperbound',dUB}
    {3,'ub',dUB}
    {4,'initialguess',dIG}
    {4,'ig',dIG}
    ];
[
    flSilent,...
    LB,...
    UB,...
    IG,...
    ] = parse_optional_arg(Default,varargin{:});

%% guesses and bounds

% When IG is out of bounds add small value. Otherwise it breaks on
% "undefined values at initial point"
% or at
% "Input must be real and full"
% the latter needs addition/subtraction of > 1e-3
MatchUB     = IG >= UB;
MatchLB     = IG <= LB;
IG(MatchUB) = UB(MatchUB)-1e-3;
IG(MatchLB) = LB(MatchLB)+1e-3;

%% do non linear fit
[out,outvar,outfun,stat,outb] = anyfit(vonmisesfun,Xdata,Ydata,...
    'ig',IG,'lb',LB,'ub',UB,...
    'silent',flSilent,'plot',~flSilent);

%%
c=0;
if nargout > c
    c=c+1;
    varargout{c} = out;
end
if nargout > c
    c=c+1;
    varargout{c} = outvar;
end
if nargout > c
    c=c+1;
    varargout{c} = outfun;
end
if nargout > c
    c=c+1;
    varargout{c} = stat;
end
if nargout > c
    c=c+1;
    varargout{c} = outb;
end
