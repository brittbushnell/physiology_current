function r = VMBlob(x, y, param)
% Inputs: 
%   x = axis (orientation) -- in degrees
%   y = axis (log spatial frequency) -- 
%   param = parameters 
%           1      2      3     4      5
%           sc1    mux    muy   kappa  sdy
% Output
%   r = von mises blob

nOri    = 6;
nSf     = 6;
nOriUp  = length(x);
nSfUp   = length(y);

x       = x/180 * pi;           % convert to radians
xx      = repmat(x, [nSfUp 1]);
y       = linspace(1, nSf, nSfUp);
yy      = repmat(y', [1 nOriUp]);

sc1     = param(1);
mux     = param(2);
muy     = param(3);
kappa   = param(4);
sdy     = param(5);

fnVMBlob = @(mux,muy,kappa,sdy) exp(kappa*cos(xx-mux)) .* ...
            exp((-(yy-muy).^2)/(2*sdy^2));
r       = sc1*fnVMBlob(mux,muy,kappa,sdy);