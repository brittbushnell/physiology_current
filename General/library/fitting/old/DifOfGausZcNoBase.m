function r = DifOfGausZcNoBase(x,varargin)

if nargin==0
    test
else
    if nargin==2
        P = varargin{1};
        Rmax = P(1);
        s1 = P(2);
        s2 = P(3);
        w = P(4);
        p = P(5);
    else
        Rmax = varargin{1}; 
        s1 = varargin{2};
        s2 = varargin{3};
        w = varargin{4};
        p = varargin{5};
    end
    r = Rmax.*( max(0,exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2))) ).^p;
end


function test

x = logspace(-1,1,60);

Rmax = 50;
s1 = 2;
s2 = 0.5;
w = 0.75;
p = 1;

r = DifOfGausZcNoBase(x,Rmax,s1,s2,w,p);

figure
subplot(1,2,1)
plot(x,r)
subplot(1,2,2)
semilogx(x,r)