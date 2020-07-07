function binsFinal = nev_bin_spikes_verRatePerChannel(t_spikes_in, t_stim_in, POINTS_KEEP, T_PER_POINT, metaData)

t_spikesFinal = t_spikes_in;

n_stim = length(t_stim_in);
n_spikes = length(t_spikes_in);

dims(1) = n_stim;
dims(2) = POINTS_KEEP;

subsampleFreq = 1/0.01;

binsFinal = zeros(dims);

% Converts spike times into a continuous spike rate:
spikeEvents = t_spikes_in;
        
% spikeEvents{nn} = (1e6).*double(NEV.Data.Spikes.TimeStamp(NEV.Data.Spikes.Electrode == nn))./sampleFreq; % Makes it in micro seconds
aux = find(diff(spikeEvents) < 0);
if ~isempty(aux)
    if length(aux) > 1
        spikeEvents = spikeEvents(aux(end)+1:end);
    else
        spikeEvents = spikeEvents(aux+1:end);
    end
    minTimeBtwSpikes_msec = min(abs(diff(spikeEvents)))./1000;
end

spikeCountMatrix = zeros(1, ceil(metaData.DataDurationSec/subsampleFreq));

%% Trying to break the bsxfun into steps:
auxUniqueInSteps = [];
auxCountsInSteps = [];
maxSizeDoBulk = 10000;
if size(spikeEvents, 2) > maxSizeDoBulk
    startIndex = 1;
    endIndex = maxSizeDoBulk;
    maxIterations1 = 0;
    reachEnd = 0;
    while endIndex <= size(spikeEvents, 2) && maxIterations1 < 100 && reachEnd == 0
        if startIndex >= endIndex
            reachEnd = 1;
        end
        nonMatchingSamples = 0;
        maxIterations2 = 0;
        if endIndex < size(spikeEvents, 2)
            while nonMatchingSamples == 0 && maxIterations2 < 15
                comparison1 = round((spikeEvents(1, endIndex)+1)./(1e6/subsampleFreq));
                comparison2 = round((spikeEvents(1, endIndex+1)+1)./(1e6/subsampleFreq));
                if comparison1 ~= comparison2
                    nonMatchingSamples = 1;
                else
                    endIndex = endIndex + 1;
                end
                maxIterations2 = maxIterations2 + 1;
            end
            if maxIterations2 == 15
                disp('here 1');
                keyboard
            end
        end
        
        auxUniqueInStepsLocal = unique(round((spikeEvents(1, startIndex:endIndex)+1)./(1e6/subsampleFreq)));
        auxUniqueInSteps = [auxUniqueInSteps, auxUniqueInStepsLocal];
        auxCountsInSteps = [auxCountsInSteps,...
            sum(bsxfun(@eq, auxUniqueInStepsLocal, round((spikeEvents(1, startIndex:endIndex)+1)./(1e6/subsampleFreq))'),1)];
        startIndex = endIndex+1;
        endIndex = min([endIndex + maxSizeDoBulk, size(spikeEvents, 2)]);
        maxIterations1 = maxIterations1 + 1;
    end
    if maxIterations1 == 100
        disp('here 2');
        keyboard
    end
    auxUnique = auxUniqueInSteps;
    auxCounts = auxCountsInSteps;
    clear auxUniqueInSteps auxCountsInSteps auxUniqueInStepsLocal startIndex endIndex...
        maxIterations1 maxIterations2 nonMatchingSamples comparison1 comparison2
else
    auxUnique = unique(round((spikeEvents+1)./(1e6/subsampleFreq)));
    auxCounts = sum(bsxfun(@eq, auxUnique, round((spikeEvents+1)./(1e6/subsampleFreq))'),1);
end

% This is a provision in case there are bin counts happening at 0
% (zero), and as 0 was also hammered in, then spikes happening on this
% bin should be passed on the actual second bin. (Does it make sense?
% The comment was added after the actual code.) Not sure if this is
% actually necessary...
if ~isempty(find(auxUnique == 0, 1, 'first'))
    auxCounts(2) = auxCounts(2) + auxCounts(auxUnique == 0);
    auxCounts(1) = [];
    auxUnique(1) = [];
end
spikeCountMatrix(1, auxUnique) = auxCounts.*(subsampleFreq);


% binsNew = zeros(dims);

for t = 1:n_stim
    binsFinal(t, :) = spikeCountMatrix(:, round(t_stim_in(t)*(10^-6)*POINTS_KEEP):round(t_stim_in(t)*(10^-6)*POINTS_KEEP + POINTS_KEEP-1));
end
%% Original
% for stim = 1:n_stim
%     offset = 1;
%     for bin_i = 1:POINTS_KEEP
%         while (1)
%             % if we are at end of spikes or if spike is past the bin
%             if(offset >= n_spikes) || (t_spikesFinal(offset) > (t_stim_in(stim) + (bin_i+1)*T_PER_POINT))
%                 break;
%             end
%             
%             % if spike is past the start  of the bin
%             if t_spikesFinal(offset) >= (t_stim_in(stim) + bin_i.*T_PER_POINT)
%                 binsFinal(stim, bin_i) = binsFinal(stim, bin_i) + 1;
%             end
%             offset = offset + 1;
%         end
%     end
% end

end