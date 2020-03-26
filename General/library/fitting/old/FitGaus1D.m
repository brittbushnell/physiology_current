function [mu,sig,amp,yHat] = FitGaus1D(x,y,amp0,mu0,sig0)

x = x(:); y = y(:);
errFun = @(P,x,y) sum(( y - P(1).*exp(-(x-P(2)).^2/(2*P(3)^2)) ).^2);

P0 = [amp0,mu0,sig0];
P = fminsearch( @(P) errFun(P,x,y) , P0 );
amp = P(1);
mu = P(2);
sig = P(3);

yHat = amp.*exp(-(x-mu).^2./(2*sig^2));

