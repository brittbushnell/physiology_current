function [oriTune, maxOri, minOri, nullOri] = getMwksOriTunedResponses(data,oris,maxSF,ch)
% getMwksOriTunedResponses[oriTune, maxOri] = getMwksOriTunedResponses(data,oris,maxSF,ch)
% is a function that returns a matrix of responses for a
% single channel to one orientation at the spatial frequency with the highest
% response, but collapsed across all other parameters used.
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
%
% Written Nov 8, 2017 Brittany Bushnell
% Nov 24, 2017 edited to add min and null orientation outputs

latency = data.latency(1,ch);
endBin = data.latency(2,ch);
blank = data.spatialFrequencyResp{ch}(3,1);

for l = 1:length(oris)
    oriTune(1,:) = oris(1,:);
    oriTune(2,l) = sum((data.rotation == (oris(1,l))) .* (data.spatial_frequency == maxSF));
    tmpNdx = find((data.rotation == (oris(1,l))) .* (data.spatial_frequency == maxSF));
    
    useRuns   = double(data.bins(tmpNdx,latency:endBin,ch));
    oriTune(3,l) = mean(useRuns(:))./0.010; %dividing the mean by binStimOn/100 puts the results into spikes/sec
    oriTune(4,l) = oriTune(3,l) - blank;
    
    %error bars
    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
    oriTune(5,l) = oriTune(3,l) - stErr;
    oriTune(6,l) = oriTune(3,l) + stErr;
    oriTune(7,l) = stErr;
    
%    oriTuneBS
end

[maxOriVal, maxOriNdx] = max(abs(oriTune(4,:)));
maxOri(1,1) = oriTune(1,maxOriNdx);
maxOri(2,1) = maxOriVal;

[minOriVal, minOrindx] = min(abs(oriTune(4,:)));
minOri(1,1) = oriTune(1,minOrindx);
minOri(2,1) = minOriVal;

if  maxOriNdx <= 3
    nullOriNdx   = maxOriNdx+3;
else
    nullOriNdx   = maxOriNdx-3;
end
nullOri(1,1) = oriTune(1,nullOriNdx);
nullOri(2,1) = oriTune(4,nullOriNdx);




