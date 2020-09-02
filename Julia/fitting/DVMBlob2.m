function r = DVMBlob2(x, param)
% Input: 
%   x = axis (orientation)
%   param = optimum parameters for model, as determined by fmincon
%   [ 1      2      3     4    5      6      7 ] 
%   [sc1     sc2    mux   muy  kappa  sdy    A ] 

x = x/180 * pi;
xx = repmat(x, [14 1]);
y = 0:13;
yy = repmat(y', [1 size(x,2)]);

sc1 = param(1);
sc2 = param(2);
mux = param(3);
muy = param(4);
kappa = param(5);
sdy = param(6);
A = param(7);

fnVMBlob = @(mux, muy, kappa, sdy, A) ...
    fnVonMises(mux,kappa) .* fnAsymGauss(muy,sdy,A);
r =  sc1*fnVMBlob(mux, muy, kappa, sdy, A) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy, A);

% Functions used in inline fitting functions.
function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function asymGaussian = fnAsymGauss(muy, sdy, A)
    asymGaussian = NaN(size(yy));
    temp = exp((-(yy-muy).^2) / (2*sdy^2));
    temp2 = exp((-(yy-muy).^2) / (2*(sdy*A)^2));
    asymGaussian(find(y<=muy),:) = temp(find(y<=muy),:);
    asymGaussian(find(y>muy),:) = temp2(find(y>muy),:);
end

end