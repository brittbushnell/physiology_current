function r = DVMBlob(x, param)
% Inputs: 
%   x = axis (orientation)
%   param = parameters

if nargin==0
    test
    return
end

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
muy2 = param(7);
kappa2 = param(8);
sdy2 = param(9);

fnVMBlob = @(mux,muy,kappa,sdy) exp(kappa*cos(xx-mux)) .* ...
            exp((-(yy-muy).^2)/(2*sdy^2));
r = sc1*fnVMBlob(mux,muy,kappa,sdy) + sc2*fnVMBlob(mux + ...
                    pi,muy2,kappa2,sdy2);