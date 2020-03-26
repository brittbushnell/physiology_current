%INITIALGUESS_VONMISES returns initial guess parameters
%
%   This function return initial guesses of a Von Mises function.
%
%   Input:
%   initialguess_vonmises(x,y)
%       x,y : data
%
%   Output:
%   b = initialguess_vonmises(..)
%       b: initial guesses
%       b(1): offset [y-units]
%       b(2): gain, amplification
%       b(3): peak [x-units]
%       b(4): k; shape parameter (assumes 2, which roughly corresponds to
%       30 deg)
%
% V0: TvG July 2015, NYU : adapted from ig_nr

function B=initialguess_vonmises(x,y,varargin)

% make sure number of data points is in rows
if isvector(x)
    x = x(:);
    y = y(:);
end
[nDat,nFit] = size(x);
B = nan(nFit,4);
%% optional inputs
Def = [
    {1,'offsetmethod','min'}     % can be "last" or "min" 
    ];
[
    B1method, ...
    ] = parse_optional_arg(Def,varargin{:});

%% offset
switch B1method
    case 'min'
        B(:,1)      =  min(y,[],1);
    otherwise
        error('ig:input','[%s] not recognized as offset method.',B1method)
end
%% amplification
[mx,ind]    = max(y,[],1);
B(:,2) = mx'./2; % max(k=10) ~ 2
%% location
B(:,3)      = x(ind);
%% shape: assume 2
B(:,4)      = 2*ones(nFit,1);


