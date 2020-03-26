function [prefStim, prefStimB] = getPrefGrating(data,ch)

% getPrefGrating [prefStim] = getPrefGrating(data)
% is a function that returns the unique stimulu (orienation and spatial
% frequency) that elicits the greatest response for a given channel
%
%  NOTE: if you want to collapse across all channels, set ch == 99
%
% Output matrix organization
%   preferred spatial frequency
%   preferred orientation
%   mean responses
% November 25, 2017 Brittany Bushnell


sfs = unique(data.spatial_frequency);
sfs = sfs(1,4:end);
oris = unique(data.rotation);

ndx  = 1;
for s = length(sfs)
    for o = 1:length(oris)       
        if isfield(data,'contrast')
            sfOr(1,ndx) = sfs(1,s);
            sfOr(2,ndx) = oris(1,o);
            sfOr(3,ndx) = sum((data.spatial_frequency == sfs(1,s)) .* (data.rotation == oris(1,o)) .* (data.contrast == 1));
            tmpNdx      = find((data.spatial_frequency == sfs(1,s)) .* (data.rotation == oris(1,o)) .* (data.contrast == 1));
            
            if ch == 99
                useRuns     = double(data.bins(tmpNdx,data.latency(1,1):data.latency(2,1),:));
                blank = data.spatialFrequencyResp(3,1);
            else
                useRuns     = double(data.bins(tmpNdx,data.latency(1,ch):data.latency(2,ch),ch));
                blank = data.spatialFrequencyResp{ch}(3,1);
            end
            
            sfOr(4,ndx) = mean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
            sfOr(5,ndx) = sfOr(4,ndx) - blank;
            ndx = ndx+1;
        else
            sfOr(1,ndx) = sfs(1,s);
            sfOr(2,ndx) = oris(1,o);
            sfOr(3,ndx) = sum((data.spatial_frequency == sfs(1,s)) .* (data.rotation == oris(1,o)));
            tmpNdx      = find((data.spatial_frequency == sfs(1,s)) .* (data.rotation == oris(1,o)));
            
            if ch == 99
                useRuns     = double(data.bins(tmpNdx,data.latency(1,1):data.latency(2,1),:));
                blank = data.spatialFrequencyResp(3,1);
            else
                useRuns     = double(data.bins(tmpNdx,data.latency(1,ch):data.latency(2,ch),ch));
                blank = data.spatialFrequencyResp{ch}(3,1);
            end
            
            sfOr(4,ndx) = mean(useRuns(:))./0.010; %dividing the mean by binStimOn/.010 puts the results into spikes/sec
            sfOr(5,ndx) = sfOr(4,ndx) - blank;
            ndx = ndx+1;
        end
    end
end
sfOr;
[maxVal,maxNdx] = max(sfOr(4,:));
prefStim(1,1) = sfOr(1,maxNdx);
prefStim(2,1) = sfOr(2,maxNdx);
prefStim(3,1) = maxVal;

[maxVal,maxNdx] = max(sfOr(5,:));
prefStimB(1,1) = sfOr(1,maxNdx);
prefStimB(2,1) = sfOr(2,maxNdx);
prefStimB(3,1) = maxVal;
