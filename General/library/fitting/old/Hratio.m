function r = Hratio(x,varargin)

if nargin==0
    test
    return
end

if nargin==2
    P = varargin{1};
    base = P(1);
    k = P(2);
    c50 = P(3);
    n = P(4);
else
    base = varargin{1};
    k = varargin{2};
    c50 = varargin{3};
    n = varargin{4};
end

r = base + k.*x.^n./(c50.^n + x.^n);


function test
con = logspace(-2,0,60);
base = -1;
k = 50;
c50 = 1;
n = 10;
r = Hratio(con,base,k,c50,n);

clc, close all
semilogx(con,r)