function [dp,d] = discrim(X1_,X2_,fracHold)
% [dp,d] = discrim(X1_,X2_,fracHold)
%
% Linear discriminant with optional cross-validated d-prime.
%
% Inputs:
%   X1, X2: Response matrices for 2 conditions to be discriminated. 
%         size [#observations x #neurons]
%   fracHold: Optional. Fraction of observations held out (not used in
%           computing discriminat vector). 
% Outputs:
%   dp: Scalar d-prime computed by projecting observations onto the
%       discriminant vector and comparing the 2 resulting 1D distributions
%       (from X1 and X2).
%       If fracHold=0, all observations contribute to the discriminant and to the d-prime.
%       If observations are held, only the hold-out data is projected to
%       compute d-prime.
%   d: Discriminant vector (size [1 x #neurons]


if nargin==0
    test();
    return
end

doHold = 1;
if ~exist('fracHold','var') || fracHold==0
    doHold = 0;
end

if doHold
    N1 = size(X1_,1);
    N2 = size(X2_,1);
    nHold1 = round(fracHold*N1);
    nHold2 = round(fracHold*N2);
    indHold1 = randsample(N1,nHold1);
    indHold2 = randsample(N2,nHold2);
    indTrain1 = setdiff(1:N1,indHold1);
    indTrain2 = setdiff(1:N2,indHold2);
    X1 = X1_(indTrain1,:);
    X2 = X2_(indTrain2,:);
    X1test = X1_(indHold1,:);
    X2test = X2_(indHold2,:);
else
    X1 = X1_;
    X2 = X2_;
    X1test = X1_;
    X2test = X2_;
end
    
X1mean = nanmean(X1);
X2mean = nanmean(X2);

C1 = nancov(X1);
C2 = nancov(X2);    
d = pinv( (C1+C2)/2 ) * (X2mean-X1mean)';

d  = d./norm(d);
X1p = X1test*d;
X2p = X2test*d;

dp = (nanmean(X2p) - nanmean(X1p)) ./ sqrt( (nanvar(X2p) + nanvar(X1p))./2 );



function test

N = 1000;
mu1 = [0,0];
sig1 = 0.5*[1 1];
mu2 = [2,0];
sig2 = 0.5*[1 1];
k1 = -1;
k2 = -1;

x11 = mu1(1) + sig1(1).*randn(N,1);
x12 = mu1(2) + sig1(2).*randn(N,1) + k1.*x11;
x21 = mu2(1) + sig2(1).*randn(N,1);
x22 = mu2(2) + sig2(2).*randn(N,1) + k2.*x21;

X1 = [x11,x12];
X2 = [x21,x22];
[dp,d] = discrim(X1,X2,0)

xC = mean(x11) + 0.5.*(mean(x21)-mean(x11));
yC = mean(x12) + 0.5.*(mean(x22)-mean(x12));

xPlot = xC + d(1)*10.*[-1,1];
yPlot = yC + d(2)*10.*[-1,1];


figure, hold on
plot(x11,x12,'b.','markersize',10)
plot(x21,x22,'r.','markersize',10)

plot(xPlot,yPlot,'k-')





































