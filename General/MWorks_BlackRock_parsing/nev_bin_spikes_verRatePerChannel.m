function binsFinal = nev_bin_spikes_verRatePerChannel(t_spikes_in, t_stim_in, POINTS_KEEP, T_PER_POINT, metaData)

t_stim_in = double(t_stim_in);

n_stim = length(t_stim_in);

dims(1) = n_stim;
dims(2) = POINTS_KEEP;

subsampleFreq = 1/0.01;

binsFinal = zeros(dims);

spikeCountMatrix = zeros(1, ceil(metaData.DataDurationSec*subsampleFreq));
spikeCountMatrix(1, :) = nev_bin_spikes(t_spikes_in, 0, size(spikeCountMatrix, 2), T_PER_POINT);

for t = 1:n_stim
    binsFinal(t, :) = spikeCountMatrix(:, round(t_stim_in(t)*(10^-6)*POINTS_KEEP):round(t_stim_in(t)*(10^-6)*POINTS_KEEP + POINTS_KEEP-1));
end

end
