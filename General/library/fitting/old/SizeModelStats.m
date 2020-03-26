function [prefSize,ssi] = SizeModelStats(P)

if nargin==0
    test;
    return
end

nX = 1000;
x = logspace(-2,1,nX);
y = SizeModel(x,P);
y0 = SizeModel(0,P);
yInf = SizeModel(inf,P);
y = y-y0;
yInf = yInf-y0;

if sum(y)==0;
    prefSize = nan;
    ssi = nan;
    return
end
yMax = max(y);
indPref = find(y>yMax*0.999,1,'first');
if indPref==nX
    prefSize = inf;
    ssi = nan;
else
    prefSize= x(indPref);
    ssi = (yMax-yInf)./yMax;
end

function test
close all

R0 = 5;
sig1 = 0.5;
sig2 = 3;
k1 = 100;
k2 = 4;
p = 2;
P = [R0,sig1,sig2,k1,k2,p];
x = logspace(-2,1,14);
r = round(SizeModel(x,P) + 0.3*rand(1,numel(x)));
[~,rHat] = FitSizeModel(x,r,3);
semilogx(x,r,'k.-'), hold on
semilogx(x,rHat,'b-')
[prefSize,ssi] = SizeModelStats(P)