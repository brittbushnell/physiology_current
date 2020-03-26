function r = DoubleVonMises(x,P)

if nargin==0
    test
    return
end

Rmax = P(1);
mu = P(2);
sig = P(3);
w = P(4);
R0 = P(5);
    
r = R0 + Rmax.*(VonMises(x,mu,sig) + w/2.*(VonMises(x-180,mu,sig)+VonMises(x+180,mu,sig)));
    


function test

x = linspace(0,360,200);

Rmax = 50;
mu = 45;
sig = 20;
w = 0.5;
R0 = 5;

r = DoubleVonMises(x,[Rmax,mu,sig,w,R0]);

figure
plot(x,r)
