%INITIALGUESS_GAUSS returns initial guess parameters
%
%   This function return initial guesses of a normal function.
%
%   Input:
%       [..] = initialguess_gauss(x,y)
%
%   Output:
%       b = initialguess_gauss(..)
%       b: initial guesses with
%       b(1): offset [y-units]
%       b(2): ampl [y-units]
%       b(3): peak (shift from x=0)
%       b(4): width (standard deviation) 
%
% V0: TvG March 2015, NYU

function B=initialguess_gauss(x,y)

% make sure number of data points is in rows
if isvector(x)
    x = x(:);
    y = y(:);
end
[nD,nR] = size(x);
B = nan(nR,4);

%% peak up?
%flUp = sum(y<mean(y))/numel(y) > 0.5;

%% offset
B(:,1)      =  median(y,1);

%% amplitude
[B(:,2),ix]	= max(y-repmat(B(:,1)',nD,1));

%% peak
ix          = sub2ind([nD nR],ix,[1:nR]);
B(:,3)      = x(ix);

%% std.dev
HWHM        = @(B4) sqrt(2*log(2)) * B4;    % Half width at half max.
yHM         = B(:,1) + B(:,2)/2;            % HM
[~,ixHM]    = min(abs(y-repmat(yHM',nD,1)));              % smallest difference from HM
ixHM        = sub2ind([nD nR],ixHM,[1:nR]);
xHM         = x(ixHM); 
B(:,4)      = abs(xHM - B(:,3)')/HWHM(1);      % inverse of HWHM

