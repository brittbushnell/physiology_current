function [xvals, yvals] = CSCurves(params)

xvals = (0.5:.1:18);
yvals = ((params(1)).*(xvals.^(params(2))).*(exp(-(params(3)).*xvals)));