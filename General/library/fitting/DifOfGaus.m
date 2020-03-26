function r = DifOfGaus(x,P)
% Difference-of-Gaussians, centered at 0, raised to a power, with optional
% baseline.
%
% r = DifOfGaus(x,P)
% r = R0 + Rmax.*( exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2))) .^p;
%
% P (vector of parameters):
% [Rmax,s1,s2,w,p]
% or 
% [Rmax,s1,s2,w,p,R0]
% Rmax: Maximum possible response (if other parameters were ideal -- not
%       actual height of tuning curve.
% s1, s2: Standard deviations of gaussians. s2 should be smaller than s1.
% w: Relative weight of gaussians (should be 0-1).
% p: Exponent
% R0: Optional baseline.
%
% shooner, june 2017

if nargin==0
    test
else
    
    % parameters:
    Rmax = P(1);
    s1 = P(2);
    s2 = P(3);
    w = P(4);
    p = P(5);
    
    % model response:
    r = Rmax.*( max(0,exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2))) ).^p;
    
    % add baseline, if given:
    if numel(P)==6
        R0 = P(6);
        r = R0 + Rmax.*( max(0,exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2)))) .^p;
    end
    
end


% Function used for testing.
% Call DifOfGaus with no input (or hit F5) to test.
function test

x = logspace(-1,1,60);

Rmax = 50;
s1 = 1;
s2 = 0.5;
w = 0.75;
p = 2;
R0 = 10;

r1 = DifOfGaus(x,[Rmax,s1,s2,w,p]);
r2 = DifOfGaus(x,[Rmax,s1,s2,w,p,R0]);

figure
semilogx(x,r1,x,r2)

set(gcf,'position',[583  641  529  472])