function fwhh = DoubleVonMisesStats(P)

if nargin==0
    test;
    return
end

nX = 1000;
x = linspace(P(2),P(2)+180,nX);
r = DoubleVonMises(x,P);

rHh = min(r) + (max(r)-min(r))/2;
ind = find(r<rHh,1);
fwhh = 2*(x(ind)-P(2));





function test

Rmax = 50;
mu = 60;
sig = 30;
w = 0.5;
R0 = 20;
P = [Rmax,mu,sig,w,R0];

nX = 1000;
x = linspace(0,360,nX);
r = DoubleVonMises(x,P);

fwhh = DoubleVonMisesStats(P)

close all
figure, hold on
plot(x,r)
plot( mu + fwhh/2*[-1,1], min(r)+(max(r)-min(r))/2*[1,1],'r-');