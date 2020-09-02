function [oriResps360, maxOri, minOri] = getMwksOri360Responses(oriTune)
% getMwksOri360Responses is a function that  replicates the oriTune data so 
% orientations go from 0:360 rather than 0:180. 
% INPUT
% OriTune is a matrix of responses for a single channel to one orientation 
% at the spatial frequency with the highest response, but collapsed across 
% all other parameters used.
%
% [oriTune] = getMwksOriTunedResponses(data,oris,maxSF)
%
% OUTPUT MATRIX ORGANIZATION
%  1) Orientations shown
%  2) Number of times that orientation was shown (repeat counter)
%  3) Mean response
%  4) Baseline subtracted mean response
%  5) Standard error upper bound
%  6) Standard error lower bound
%  7) Standard error
%
% Written Nov 8, 2017 Brittany Bushnell


numOris = size(oriTune,2);
F0 = mean([oriTune(3,1),oriTune(3,end)]);
F0b = mean([oriTune(4,1),oriTune(4,end)]);
oriResps360(1,:)  = 0:30:360;
oriResps360(2,1) =  F0;
oriResps360(2,7) =  F0;
oriResps360(2,end) =  F0;
oriResps360(2,2:numOris-1) = oriTune(3,2:end-1);
oriResps360(2,numOris+1:end-1) = oriTune(3,2:end-1);

oriResps360(3,1) = F0b;
oriResps360(3,7) = F0b;
oriResps360(3,end) = F0b;
oriResps360(3,2:numOris-1) = oriTune(4,2:end-1);
oriResps360(3,numOris+1:end-1) = oriTune(4,2:end-1);


[maxOriVal, maxOrindx] = max(abs(oriResps360(3,:)));
maxOri(1,1) = oriResps360(1,maxOrindx);
maxOri(2,1) = maxOriVal;

[minOriVal, minOrindx] = min(abs(oriResps360(3,:)));
minOri(1,1) = oriResps360(1,minOrindx);
minOri(2,1) = minOriVal;
