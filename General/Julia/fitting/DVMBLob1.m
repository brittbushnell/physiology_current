function R = DVMBLob1(x, param)

% Create coordinate system in radians
x = x/180 * pi;
xx = repmat(x, [14 1]);
y = 0:13;
yy = repmat(y', [1 24]);

fnVMBlob = @(mux, muy, kappa, sdy) ...
    fnVonMises(mux,kappa) .* fnGaussian(muy,sdy);
fnDVMBlob = @(sc1, sc2, mux, muy, kappa, sdy) ...
    sc1*fnVMBlob(mux, muy, kappa, sdy) + sc2*fnVMBlob(mux+pi, muy, kappa, sdy);

R = fnDVMBlob(param(1), param(2), param(3), param(4), param(5), param(6));

function vonMises = fnVonMises(mux, kappa)
    vonMises = exp(kappa*cos(xx-mux));
end
function gaussian = fnGaussian(muy, sdy)
    gaussian = exp(-((yy-muy).^2)/(2*sdy^2));
end
end