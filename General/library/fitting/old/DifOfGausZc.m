function r = DifOfGausZc(x,varargin)

if nargin==0
    test
else
    if nargin==2
        P = varargin{1};
        R0 = P(1);
        Rmax = P(2);
        s1 = P(3);
        s2 = P(4);
        w = P(5);
        p = P(6);
    else
        R0 = varargin{1}; 
        Rmax = varargin{2}; 
        s1 = varargin{3};
        s2 = varargin{4};
        w = varargin{5};
        p = varargin{6};
    end
    r = R0 + Rmax.*( max(0,exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2))) ).^p;
end


function test

x = logspace(-1,1,60);

R0 = 10;
Rmax = 50;
s1 = 2;
s2 = 0.5;
w = 0.75;
p = 1;

r = DifOfGausZc(x,R0,Rmax,s1,s2,w,p);

figure
subplot(1,2,1)
plot(x,r)
subplot(1,2,2)
semilogx(x,r)