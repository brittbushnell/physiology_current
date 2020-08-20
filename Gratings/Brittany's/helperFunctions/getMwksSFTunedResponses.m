function [sfTune, maxSF] = getMwksSFTunedResponses(data,sfs,maxOri,ch)
% getMwksSFTunedResponses [sfTune, maxSF] = getMwksSFTunedResponses(data,sfs,maxOri,ch)
% is a function that returns a matrix of responses for a
% single channel to spatial frequencies shown at the preferred orientation 
% but collapsed across all other parameters used.
%
% 
% OUTPUT MATRIX ORGANIZATION
%  1) spatial frequencies shown
%  2) Number of times that SF was shown (repeat counter)
%  3) Mean response
%  4) Baseline subtracted mean response
%  5) Standard error upper bound
%  6) Standard error lower bound
%  7) Standard error
%
% Written Nov 9, 2017 Brittany Bushnell

latency = data.latency(1,ch);
endBin  = data.latency(2,ch);
blank   = data.spatialFrequencyResp{ch}(3,1);

for l = 1:size(sfs,2)
    sfTune(1,:) = sfs(1,:);
    sfTune(2,l) = sum((data.rotation == maxOri(1,1)) .* (data.spatial_frequency == (sfs(1,l))));
    tmpNdx = find((data.rotation == maxOri(1,1)) .* (data.spatial_frequency == (sfs(1,l))));
    
    useRuns   = double(data.bins(tmpNdx,latency:endBin,ch));
    sfTune(3,l) = mean(useRuns(:))./0.010; %dividing the mean by binStimOn/100 puts the results into spikes/sec
    sfTune(4,l) = sfTune(3,l) - blank;
    
    %error bars
    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
    sfTune(5,l) = sfTune(3,l) - stErr;
    sfTune(6,l) = sfTune(3,l) + stErr;
    sfTune(7,l) = stErr;
end

[maxSFVal, maxSFndx] = max(abs(sfTune(4,:)));
maxSF = sfTune(1,maxSFndx);