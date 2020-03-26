function v = vaf(x, xhat)

% From Mazer et al, 2002: "Separability was quant. for each cell by computing the squared
% correlation (r^2) between measured and predicted separable SF-orientation
% tuning."
%
% variance accounted for.
% inputs:
%       - x = measured responses
%       - xhat = predicted response

fnPick21 = @(x) x(2,1);
v = fnPick21(100*power(corrcoef(x, xhat),2));