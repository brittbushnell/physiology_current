function [oris] = getMwksOriResponses(data,oris,ch)
% getMwksSFResponses is a function that returns a matrix of responses for a
% single channel to one orientation collapsed across all other parameters
% shown.
% [oris] = getMwksOriResponses(data,oris,ch)
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

latency = data.latency(1,ch);
endBin = data.latency(2,ch);
blank = data.spatialFrequencyResp{ch}(3,1);

for l = 1:length(oris)
    % collapsed across all SFs
    oris(2,l) = sum(data.rotation == (oris(1,l)));
    tmpNdx    = find(data.rotation == (oris(1,l)));
    
    useRuns   = double(data.bins(tmpNdx,latency:endBin,ch));
    oris(3,l) = mean(useRuns(:))./0.010;
    oris(4,l) = oris(3,l) - blank;
    
    %error bars
    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
    oris(5,l) = oris(3,l) - stErr;
    oris(6,l) = oris(3,l) + stErr;
    oris(7,l) = stErr;
end

