function [sfs, maxSF] = getMwksSFResponses(data,sfs,ch)
% getMwksSFResponses is a function that returns a matrix of responses for a
% single channel to one spatial frequency collapsed across all other parameters
% shown.
% [sfs, maxSF] = getMwksSFResponses(data,sfs)
%
%   NOTE: if you want to collapse  across all channels, set ch = 99.
%
% OUTPUT MATRIX ORGANIZATION
%  1) Spatial frequencies shown
%          note: 0 sf is a blank screen
%                0.003 is a white luminance flash
%                0.006 is a black luminance flash
%  2) Number of times that sf was shown (repeat counter)
%  3) Mean response
%  4) Baseline subtracted mean response
%  5) Standard error upper bound
%  6) Standard error lower bound
%  7) Standard error
%
% Written Nov 8, 2017 Brittany Bushnell
% Edited Dec 6, 2017 to allow for collapsing across all channels
if ch == 99
    latency = data.latency(1,1);
    endBin = data.latency(2,1);
else
    latency = data.latency(1,ch);
    endBin = data.latency(2,ch);
end

for i = 1:length(sfs)
    if isfield(data, 'contrast')
        highCon = max(data.contrast);
        sfs(2,i) = sum(data.spatial_frequency == (sfs(1,i)) .* (data.contrast == highCon));
        tmpNdx   = find(data.spatial_frequency == (sfs(1,i)).* (data.contrast == highCon));
    else
        sfs(2,i) = sum(data.spatial_frequency == (sfs(1,i)));
        tmpNdx   = find(data.spatial_frequency == (sfs(1,i)));
    end
    
    if ch == 99
        useRuns  = double(data.bins(tmpNdx,latency:endBin,:));
    else
        useRuns  = double(data.bins(tmpNdx,latency:endBin,ch));
    end
    sfs(3,i) = mean(useRuns(:))./0.010;
    blank    = sfs(3,1);
    % subtract baseline response rate
    sfs(4,i) = sfs(3,i) - blank;
    
    %error bars
    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
    sfs(5,i) = sfs(3,i) - stErr;
    sfs(6,i) = sfs(3,i) + stErr;
    sfs(7,i) = stErr;
end
% SF with maximum response
[maxSFval, maxSFndx] = max(abs(sfs(4,4:end)));  % excluding stimuli with no orientation content - blanks and lum flashes. using absolute value of baseline subtracted responses, so it returns the stimulus with the largest effect on the baseline responses, regardless of sign.
maxSF = sfs(1,maxSFndx+3);