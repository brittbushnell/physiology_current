function [latencyBin, latencyTime] = getLatencyMwks(spikes, numBins, binSize, channel)

% [latencyBin, latencyTime] = getLatencyMwks(spikes, numBins, binSize, channel)
% This function returns the latency of a neuron based on the maximum
% variance to a set of stimuli (see Smith et al, 2005 [Nature Neurosci 8,220-228]).
%
% INPUT
%
% SPIKES is the binned spike counts for a stimulus presentation
% NUMBINS the number of bins you want to evaluate
% BINSIZE number of ms included in the bin (ex, 10ms bins = 10)
% CHANNEL array channel number
%        NOTE: if you want to collapse across all channels, then set
%        channel to 99.
%
% OUTPUT
% LATENCYBIN the bin with the higest variance
% LATENCYTIME is the actual latency
%
% Written: March 9, 2017  Brittany Bushnell
% Updated Dec 6, 2017 to allow for collapsing across all channels

% Get out the responses that occur within numBins, which should be from stim
% on until the end of the following ISI.
if channel == 99
    resps   = spikes(:,1:numBins,:);
else
    resps   = spikes(:,1:numBins,channel);
end

resps   =  double(resps);
respVar = var(resps,0,1);  % get the variance of the responses at each bin.
%mxVars = max(respVar,[],3);

latencies = find(respVar == max(respVar)); % Find where the variance is the largest.
%latencies = find(mxVars == max(mxVars)); % Find where the variance is the largest.

if length(latencies) > 1
    latencies
end

latencyBin = latencies(1,1); % If there are two points that give the same max response, only return the first one.
latencyTime = latencyBin*binSize;
