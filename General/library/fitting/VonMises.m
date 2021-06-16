function y = VonMises(x,mu,sig)    

xr = x*pi/180;
mur = mu*pi/180;
sigr = sig*pi/180;

kappa = 1./sigr^2;
y = exp(kappa*cos(xr-mur))/(2*pi*besseli(0,kappa)) ./ (exp(kappa)/(2*pi*besseli(0,kappa)));
