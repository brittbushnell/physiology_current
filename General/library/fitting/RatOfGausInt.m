function r = RatOfGausInt(x,P)

if nargin==0
    test
    return
end

k = P(1);
c = P(2);
s1 = P(3);
s2 = P(4);
p = P(5);

Lc = 2*(normcdf(x,0,s1)-0.5);
Ls = 2*(normcdf(x,0,s2)-0.5);
r = k.*Lc.^p./(c + Ls.^p);


function test

k = 10;
c = 0.5;
s1 = 0.6;
s2 = 5;
p = 2;

x = logspace(-2,1,16);
r = RatOfGausInt(x,[k,c,s1,s2,p]);
close all
semilogx(x,r,'ko-')

