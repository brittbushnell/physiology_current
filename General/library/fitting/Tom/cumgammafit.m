%CUMGAMMAFIT fits a cumulative gamma function
%
%   This function fits a gamma c.d. function through the data.
%
%   This function is partly a wrapper for ANYFIT.
%
%   The function is defined as (see also [1]):
%       f(x|bias,gain,k,theta) = bias + gain * \frac{x^{(k-1)} * e^{\frac{x}{-theta}}} {\Gamma(k)*theta^{k}}
%           x: the independent variable (e.g. stimulus)
%           f(x): dependent variable (e.g. response)
%       constants or parameters:
%           bias: offset
%           gain: amplitude. (note that this is the gain of the gamma
%           distribution and not the maximum value.
%           k: shape
%           theta: scale
%
% [1] https://en.wikipedia.org/wiki/Gamma_distribution
%
%   Input:
%   gammafit(x,y)
%       x :	independent variable 
%       y :	dependent variable
%       Optional arguments: These come in pairs
%           'upperbound' , 'ub'
%           'lowerbound' , 'lb': fit restrictions
%               Default [0 -inf 0 -inf] and [+inf +inf +inf +inf]
%           'initialguess', 'ig': initial guess
%               Default uses initialguess_.. routine
%           'silent': Do not output to screen.
%               Default false
%
%   Output:
%   [beta, betavar, function, stat, betacon] = gammafit(..)
%       beta :      fitted parameters
%       betavar :   variance of betas
%       function :  Function handle
%       stat :      Statistical information (see anyfit)
%       betacon :   As beta, but with constrained (fixed) betas excluded.
%
% v1 TvG Oct 2015, NYU: added help.

function [varargout]=cumgammafit(Xdata,Ydata,varargin)

%%
cumgammafun = @(b,x) b(1) + b(2)*gamcdf(x,b(3),b(4));
% actual function
% b(1): offset
% b(2): amplitude
% b(3): shape (k, includes gamma)
% b(4): scale (Theta)

%% input
if isvector(Xdata)
    Xdata = Xdata(:);
    Ydata = Ydata(:);
end

% get some size information
[nDat,nFit] = size(Xdata);

% default guesses and bounds
dLB(:,1)    = 0     .*ones(nFit,1);
dLB(:,2)    = -inf  .*ones(nFit,1);
dLB(:,3)    = 0     .*ones(nFit,1);
dLB(:,4)    = -inf  .*ones(nFit,1);

dUB(:,1)    = +inf  .*ones(nFit,1);
dUB(:,2)    = +inf  .*ones(nFit,1);
dUB(:,3)    = +inf  .*ones(nFit,1);
dUB(:,4)    = +inf  .*ones(nFit,1);

dIG         = initialguess_gamma(Xdata,Ydata);

% parse optional
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
[out,outvar,outfun,stat,outb] = anyfit(cumgammafun,Xdata,Ydata,...
    'ig',IG,'lb',LB,'ub',UB,...
    'silent',flSilent,'plot',~flSilent);

%% output
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