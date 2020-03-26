function r = DifOfGaus(x,varargin)

if nargin==0
    test
else
    if nargin==2
        P = varargin{1};
        Rmax = P(1);
        m1 = P(2);
        m2 = P(3);
        s1 = P(4);
        s2 = P(5);
        w = P(6);
        p = P(7);
    else
        Rmax = varargin{1}; 
        m1 = varargin{2};
        m2 = varargin{3};
        s1 = varargin{4};
        s2 = varargin{5};
        w = varargin{6};
        p = varargin{7};
    end
    r = Rmax.*( max(0,exp(-(x-m1).^2./(2*s1.^2)) - w.*exp(-(x-m2).^2./(2*s2.^2))) ).^p;
end


function test

x = logspace(-1,1,60);

Rmax = 50;
m1 = 2;
m2 = 0;
s1 = 2;
s2 = 2;
w = 0.5;
p = 2;

r = DifOfGaus(x,Rmax,m1,m2,s1,s2,w,p);

figure
subplot(1,2,1)
plot(x,r)
subplot(1,2,2)
semilogx(x,r)