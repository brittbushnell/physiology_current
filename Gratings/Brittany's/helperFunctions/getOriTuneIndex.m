function [oriNdx] = getOriTuneIndex(maxOri,minOri)
% GETORITUNEINDEX [oriNdx] = getOriTuneIndex(maxOri,numOris) is a function
% to compute an orientation tuning index.
%
% computation: MaxOrientation - minOrientation / MaxOrientation + minOrientation
%
% Written November 8, 2017 Brittany Bushnell

oriNdx = (maxOri(2,1) - minOri(2,1)) / (maxOri(2,1) + minOri(2,1));
