function r = DoubleVonMises(x,varargin)
% r = DoubleVonMises(x,R0,Rmax,mu,sig,w)
% r = DoubleVonMises(x,P)

if nargin==0
    test
else
    if nargin==2
        P = varargin{1};
        R0 = P(1);
        Rmax = P(2);
        mu = P(3);
        sig = P(4);
        w = P(5);
    else
        R0 = varargin{1};
        Rmax = varargin{2};
        mu = varargin{3};
        sig = varargin{4};
        w = varargin{5};
    end
    
    r = R0 + Rmax.*(VonMises(x,mu,sig) + w/2.*(VonMises(x-180,mu,sig)+VonMises(x+180,mu,sig)));
    
end




function test

x = linspace(0,360,60);

R0 = 10;
Rmax = 50;
mu = 90;
sig = 20;
w = 0.5;

r = DoubleVonMises(x,R0,Rmax,mu,sig,w);

figure
plot(x,r)
