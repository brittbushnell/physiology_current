function r = SizeModel(x,varargin)

if nargin==0
    test
    return
end

if nargin==2
    P = varargin{1};
    R0 = P(1);
    sig1 = P(2);
    sig2 = P(3);
    k1 = P(4);
    k2 = P(5);
    p = P(6);
else
    R0 = varargin{1};
    sig1 = varargin{2};
    sig2 = varargin{3}; 
    k1 = varargin{4};
    k2 = varargin{5};
    p = varargin{6};
end

Lc = normcdf(x,0,sig1)-0.5;
Ls = normcdf(x,0,sig2)-0.5;
r = R0 + k1.*Lc.^p./(1+k2.*Ls.^p);    



function test
R0 = 5;
sig1 = 0.5;
sig2 = 3;
k1 = 100;
k2 = 4;
p = 2;

x = logspace(-2,1,10);
r = SizeModel(x,R0,sig1,sig2,k1,k2,p);
close all
semilogx(x,r,'ko-')

