function [Latency,varargout] = GetLatency(ExpoXMLimport,Latencies,SampleBlockIDs,Duration)
%   function [Latency,Tuning,varTuning] = GetLatency(ExpoXMLimport,Latencies,SampleBlockIDs,Duration)
%
%   This Expo utility returns the latency of a neuron based on the maximum
%   variance to a set of stimuli (see Smith et al, 2005 [Nature Neurosci 8,220-228]).
%
%   Input Variables
%   -----------------------------------------------------------------------
%   ExpoXMLimport is the structure returned by ReadExpoXML
%   Latencies is the range of latencies to test in milliseconds (e.g. 40:120)
%   SampleBlockIDs is the range of blockIDs to test over. 
%   - Default is all the block IDs if the program contains only states
%   - Default is the matrix block IDs if the program contains a matrix
%   - To speed up the calculating you can use the blockIDs of only those
%     blocks assocated with a tuning curve. The paper suggests
%     using all blockIDs regardless of stimuli type.
%   Duration is the time in milliseconds over which to examine spikes.
%   - Default is the duration of the each block/state.
%   - If this is defined, then it MUST be a subset of the total duration time of the stimulus.
%   - This parameter is optional and can be left out for most programs.
%   - Use a small values if you believe the transient neural response 
%     is more tuned than the sustained response.
%
%   Output Variables
%   -----------------------------------------------------------------------
%   Latency is the latency of the neuron in milliseconds
%   Tuning is the matrix of responses at the input latencies
%   varTuning is a vector that stores the variance in the tuning matrix
%             as a function latency
%
%   See also ReadExpoXML, GetPasses, GetEvents, GetSpikeTimes, GetAnalog,
%   GetPSTH, PlotPSTH, GetWaveforms, GetStartTimes, GetEndTimes, GetDurations,
%   GetConversionFactor, MergeExpoDataSets, GetTransitionProbabilities.
%
%     Author:      Romesh Kumbhani
%     Version:     1.2
%     Last updated:  2011-03-30
%     E-mail:      romesh.kumbhani@nyu.edu
%
%

%%
uLatency = Latencies*10; % Convert Latencies into 1/10 ms units.

if ~exist('SampleBlockIDs','var')
    SampleBlockIDs = [];
end
if isempty(SampleBlockIDs)
    if ExpoXMLimport.matrix.NumOfBlocks > 0
        SampleBlockIDs = double(ExpoXMLimport.matrix.MatrixBaseID:ExpoXMLimport.matrix.MatrixBaseID+ExpoXMLimport.matrix.NumOfBlocks-1);
    else
        SampleBlockIDs = double(ExpoXMLimport.blocks.IDs);
    end
end
nSampleBlocks = size(SampleBlockIDs,2);

ValidPassNDXs = find(ismember(ExpoXMLimport.passes.BlockIDs,SampleBlockIDs));
nLantencies   = size(uLatency,2);
nValidPasses  = size(ValidPassNDXs,2);
SpikeCount    = zeros(nLantencies,nValidPasses);  % each row is a latency, each column is a pass
Tuning        = zeros(nLantencies,nSampleBlocks); % each row is a latency, each column is a stimulus condition

StartTimes    = double(ExpoXMLimport.passes.StartTimes(ValidPassNDXs));
if exist('Duration','var')
    EndTimes  = StartTimes + Duration*10;
else
    EndTimes  = double(ExpoXMLimport.passes.EndTimes(ValidPassNDXs));
end

TimeVector    = reshape([StartTimes; EndTimes],1,size(StartTimes,2)*2);
SpikeTimes    = ExpoXMLimport.spiketimes.Times{1};

for i=1:nLantencies
    try
        temp=histc(SpikeTimes,TimeVector+uLatency(i));
    catch me
        error('ExpoMatlab:GetLatency','Could not bin data into stimulus epochs at latency = %.1f',uLatency(i));
    end
    SpikeCount(i,:) = temp(1:2:end);
end

for i=1:nSampleBlocks
    Tuning(:,i) = mean(SpikeCount(:,ExpoXMLimport.passes.BlockIDs(ValidPassNDXs)==SampleBlockIDs(i)),2);
end
varTuning = var(Tuning,0,2);
Latency = Latencies(find(varTuning==max(varTuning),1,'last'));

nout = max(nargout,1)-1;
for k=1:nout
    switch k
        case 1
            varargout(k) = {Tuning};
        case 2
            varargout(k) = {varTuning};
    end
end

% Uncomment for plotting
%
% subplot(2,1,1);
% contourf(Latencies,1:size(Tuning,2),Tuning',10);
% axis ij;
% colormap(gray);
% subplot(2,1,2);
% plot(Latencies,varTuning);
% fprintf('Latency = %.1f ms\n',Latency);


