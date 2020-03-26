function[chiSquare, normChiSquare] = chiSq(data, model, nParam)
% Computes the chi square value, and a normalized chi-square that takes
% into account the number of parameters (to allow for model comparison).
%
% Inputs:
%       - data = observed responses
%       - model = fitted responses
%       - nParam = number of free parameters in model.

% data        = abs(data);
% model       = abs(model);
k           = 0.01 * max(data(:));      % small value to prevent model fits of 0 from producing infinity errors
chiSquare   = sum(sum( abs((data-model).^2 ./ (model+k)) ));

df          = numel(data) - nParam;
normChiSquare = chiSquare / df;