function [prefSize,ssi] = RatOfGausIntStats(P)

if nargin==0
    test;
    return
end

nX = 1000;
x = logspace(-2,1,nX);
y = RatOfGausInt(x,P);
yInf = RatOfGausInt(inf,P);

if sum(y)==0
    prefSize = nan;
    ssi = nan;
    return
end

yMax = max(y);
indPref = find(y>yMax*0.99,1,'first');
if indPref==nX
    prefSize = inf;
    ssi = nan;
else
    prefSize= x(indPref);
    ssi = (yMax-yInf)./yMax;
end

function test
close all

k = 10;
c = 1;
s1 = 0.3;
s2 = 3;
p = 2;

x = logspace(-2,1,16);

r = RatOfGausInt(x,[k,c,s1,s2,p]) + rand(1,16)-0.5;
[P,rHat] = FitRatOfGausInt(x,r,3);

semilogx(x,r,'k.-'), hold on
semilogx(x,rHat,'b-')

[prefSize,ssi] = RatOfGausIntStats(P)