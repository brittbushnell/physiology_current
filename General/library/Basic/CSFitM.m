function [final_params, final_error] = CSFit(data) 

% This function finds the parameters (a,b,c) to fit the contrast 
% sensitivity curve to the equation from Kiorpes et al 1998:
% Sw = a(w^b)(e^-cw)

xdata = data(:,1);
ydata = data(:,2);

[final_params, final_error] = fminsearch(@(params) sum((ydata -(params(1).*(xdata.^(params(2))).*(exp(-(params(3)).*xdata)))).^2), [min(xdata),max(ydata),max(xdata)],optimset('MaxFunEvals',1000));
%[final_params, final_error] = fminsearch(@(params) sum((ydata -(params(1).*(xdata.^(params(2))).*(exp(-(params(3)).*xdata)))).^2), [2,.35,.11],optimset('MaxFunEvals',1000));