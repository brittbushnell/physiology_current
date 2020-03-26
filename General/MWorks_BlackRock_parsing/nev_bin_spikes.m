function binsFinal = nev_bin_spikes(t_spikes_in, t_stim_in, POINTS_KEEP, T_PER_POINT)

t_spikesFinal = t_spikes_in;

n_stim = length(t_stim_in);
n_spikes = length(t_spikes_in);

dims(1) = n_stim;
dims(2) = POINTS_KEEP;

binsFinal = zeros(dims);

stim = 1;

for stim = 1:n_stim
    offset = 1;
    for bin_i = 1:POINTS_KEEP
        while (1)
            % if we are at end of spikes or if spike is past the bin
            if(offset >= n_spikes) || (t_spikesFinal(offset) > (t_stim_in(stim) + (bin_i+1)*T_PER_POINT))
                break;
            end
                        
            % if spike is past the start  of the bin
            if t_spikesFinal(offset) >= (t_stim_in(stim) + bin_i.*T_PER_POINT)
                binsFinal(stim, bin_i) = binsFinal(stim, bin_i) + 1;
            end
            offset = offset + 1;
        end
    end
end

end