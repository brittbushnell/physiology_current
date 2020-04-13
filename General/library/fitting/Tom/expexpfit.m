%EXPEXPFIT fits a double exponential function
%
%   This function fits a double exponential function [1-3].
%
%   This routine is based on JAM's c-code 'csf.c' as described in:
%       /users/tony/src/src.Darwin/stepfit/foo/Readme
%   There the fit parameters were:
%       f(x|a,b,c,d) = a*((x*b)^d)*exp(-c*b*x)
%           x: spatial frequency
%           a: amplitude
%           b: peak sf (inversely related)
%           c: low-freq shape
%           d: high-freq shape
%
%
%   Minimization of standard error of sensitivity are in logarithmic
%   coordinates. [TODO].
%
%
%   This function is partly a wrapper for ANYFIT.
%
%   The function is defined as (see also [1]):
%       f(x|gain,n,m) = gain \cdot x^{n} \cdot e^{-m \cdot sf}
%           x: the independent variable (e.g. spatial frequency)
%           f(x): dependent variable (e.g. sensitivity)
%       constants or parameters:
%           gain: amplitude
%           n: first exponent
%           m: second exponent
%
%   The equation defining the fits is the function described in [2]:
%
%       S = 100 . W^A/(C.EXP[B(W-W')])
%
%   contrast sensitivity: S
%   parameters: A,B,C, W'
%   A: Steepness low freq. fall-off
%   B: Steepness high freq. fall-off
%   C: absolute Sensitivity level
%   W': peak SF
%       "The smooth curves drawn through the data points in Fig. 3 are
%       exponential functions of the form S = 100. CV?,/(C.EXP[B( W-W?)])
%       where S = contrast sensitivity, and A, B, C, and W? are parameters
%       corresponding, respectively, to steepness of the low and high
%       frequency fall-off. the absolute sensitivity level, and the peak
%       spatial frequency. This curve is similar to the one suggested by
%       Wilson (1978) on the basis of measurements of line spread functions
%       of the human visual system"
%   
%   This equation is adapted from [3]:
%
%       C(w,w0) = A . w0 . exp(-a.w0) . exp(-((w-w0)/s)^2)
%
%   w: SF
%   w0: optimal SF at optimal sensitivity
%   s: bandwidth parameter
%
%   [1] Kiorpes, L. et al. (1998) Neuronal correlates of amblyopia in the
%   visual cortex of macaque monkeys with experimental strabismus and
%   anisometropia, The Journal of neuroscience: the official journal of the
%   Society for Neuroscience, 18(16), pp. 6411-6424.
%
%   [2] Williams, R. A. et al. (1981) Oblique effects in normally reared
%   monkeys (Macaca nemestrina): meridional variations in contrast
%   sensitivity measured with operant techniques, Vision research, 21(8),
%   pp. 1253?1266.
%
%   [3] Wilson, H. R. (1978) Quantitative prediction of line spread
%   function measurements: implications for channel bandwidths, Vision
%   Research, 18(4), pp. 493?496.
%
%
%   Input:
%   expexpfit(x,y)
%       x :	independent variable 
%       y :	dependent variable
%       Optional arguments: These come in pairs
%           'upperbound' , 'ub'
%           'lowerbound' , 'lb': fit restrictions
%               Default [0 0 -inf 0] and [+inf +inf +inf +inf]
%           'initialguess', 'ig': initial guess
%               Default uses initialguess_.. routine
%           'silent': Do not output to screen.
%               Default false
%
%   Output:
%   [beta, betavar, function, stat, betacon] = expexpfit(..)
%       beta :      fitted parameters
%       betavar :   variance of betas
%       function :  Function handle
%       stat :      Statistical information
%       betacon :   As beta, but with constrained (fixed) betas excluded.
%
% v1 TvG Aug 2017, NYU: template from gaussfit

function [varargout]=expexpfit(Xdata,Ydata,varargin)

%%
expexpfun = @(b,x) b(1) .* (x.^b(2)) .* exp(-b(3) .* x);
% actual function
% b(1): amplitude
% b(2): exp 1
% b(3): exp 2

%% input
if isvector(Xdata)
    Xdata = Xdata(:);
    Ydata = Ydata(:);
end

% get some size information
[nDat,nFit] = size(Xdata);

% default guesses and bounds
%   from /users/tony/src/src.Darwin/stepfit/csf/csfe.c
%       or
%   from /users/tony/src/src.Darwin/stepfit/csf/csf.c
dLB(:,1)    = 0     .*ones(nFit,1);
dLB(:,2)    = 0     .*ones(nFit,1);
dLB(:,3)    = 0     .*ones(nFit,1);

dUB(:,1)    = +inf     .*ones(nFit,1);
dUB(:,2)    = 50       .*ones(nFit,1);
dUB(:,3)    = 50       .*ones(nFit,1);

dIG(:,1)    = max(Ydata)./(max(Xdata) + 0.1);
dIG(:,2)    = 1.5       ./(max(Xdata) + 0.1);
dIG(:,3)    = 0.8   .*ones(nFit,1);

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
[out,outvar,outfun,stat,outb] = anyfit(expexpfun,Xdata,Ydata,...
    'ig',IG,'lb',LB,'ub',UB,...
    'fitmethod','fmincon',...
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
