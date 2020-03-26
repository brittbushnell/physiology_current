function [degArc] = convertWF(radius,weberFraction) 
%
% Function to convert from weber fraction to degrees and arc seconds
%
% INPUT
% RADIUS in deg
% WEBERFRACTION from Radial 1000
%
% OUTPUT
% degArc matrix of values with the first column converted to degrees, and
% the second is converted to arc seconds. 

%%

reducedWF   = weberFraction./1000;
degArc(:,1) = reducedWF.*radius;
degArc(:,2) = degArc(:,1).*3600;
