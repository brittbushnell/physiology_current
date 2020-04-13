%INITIALGUESS_CUMGAUSS returns initial guess parameters
%
%   This function return initial guesses of a cummulative normal function.
%
%   Input:
%       [..] = initialguess_cumgauss(x,y)
%
%   Output:
%       b = initialguess_cumgauss(..)
%       b: initial guesses with
%       b(1): lower lapse rate [y-units]
%       b(2): upper lapse rate [y-units]
%       b(3): peak (shift from x=0)
%       b(4): width (standard deviation) 
%
% V0: TvG March 2015, NYU
% TvG Nov 2016, NYU: added dY there was a dimension bug

function B=initialguess_cumgauss(x,y)

% make sure number of data points is in rows
if isvector(x)
    x = x(:);
    y = y(:);
end
[nD,nR] = size(x);
B = nan(nR,4);


%% offset
B(:,1)      = min(y,[],1);
B(:,2)      = 1-diff(minmax(y'),[],2) - B(:,1);

%% peak
dY          = minmax(y');
yHM         = (dY(:,2) - dY(:,1))/2 + min(y,[],1)'; % HM
[~,ixHM]    = min(abs(y-repmat(yHM',nD,1)));    % smallest difference from HM
ixHM        = sub2ind([nD nR],ixHM,[1:nR]);
xHM         = x(ixHM); 

B(:,3)      = xHM;

%% std.dev
ySD         = normcdf([-1 +1],0,1);             % SD
[mSD1,ixSD1]= min(abs(y-repmat(ySD(1),nD,1)));  % smallest difference 
[mSD2,ixSD2]= min(abs(y-repmat(ySD(2),nD,1)));

ixSD = ixSD2.*(mSD1 >= mSD2) + ixSD1.*(mSD1 < mSD2);

ixSD        = sub2ind([nD nR],ixSD,[1:nR]);
xSD         = x(ixSD); 

B(:,4)      = abs(B(:,3)-xSD');

