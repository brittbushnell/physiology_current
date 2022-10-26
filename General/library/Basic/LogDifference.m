function [logDiff] = LogDifference(data1, data2)

% This function takes in two data points and returns the log difference
% between them. 
%
% If amblyope, data 1 should be the amblyopic eye

logDiff  = log(data1./data2);
