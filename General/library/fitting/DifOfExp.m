function r = DifOfExp(x,varargin)

if nargin==0
    test
else
    if nargin==2
        P = varargin{1};
        R0 = P(1);
        Rmax = P(2);
        s1 = P(3);
        pow = P(4);
        wSur = P(5);
        sRat = P(6);
    else
        R0 = varargin{1}; 
        Rmax = varargin{2}; 
        s1 = varargin{3};
        pow = varargin{4};
        wSur = varargin{5};
        sRat = varargin{6};
    end
    r = R0 + Rmax.*(exp(-((x./s1).^pow)) - ...
                wSur.*exp(-((x./(s1.*sRat)).^pow)));
end


function test

x = logspace(-1,1,60);

R0 = 10;
Rmax = 100;
s1 = 1;
pow = 1;
wSur = 1;
sRat = 0.1;

r = DifOfExp(x,[R0,Rmax,s1,pow,wSur,sRat]);

figure
subplot(1,2,1)
plot(x,r)
subplot(1,2,2)
semilogx(x,r)