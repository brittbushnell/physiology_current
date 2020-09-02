function [spiketimes, channels, waveforms] = spiketimes2cell(sortedSpikeFile, sortedSpikeDir, saveFile, procOverwrite)

% Organize .mat output of Plexon offline sorter's sorted spikes into cells that are more
% easily indexed by MATLAB
% Plexon outputs an intuitive but computationally annoying mat file where
% each channel's spike times are assigned to a named channel variable.
% input:
%       - sortedSpikeFile = plexon's mat output (after 'saving each
%       waveform')
%       - sortedSpikeDir = directory these were saved
%       - outputDir = where to save output
% output:
%       - spiketimes = cell array of spike times for each channel that had
%       spikes on it.
%       - channels = associated channels (not mapped)
%       - waveforms = shape of waveforms for each sorted spike

if ~exist(saveFile) || procOverwrite
    load([sortedSpikeDir sortedSpikeFile]);
    var = whos;
    varnames = extractfield(var, 'name');

    sz      = [var(:).size];
    sz      = sz(1:2:end);
    iich    = find(sz>1);

    nCh     = length(iich);
    spiketimes  = cell(1,nCh);
    channels    = nan(1,nCh);
    waveforms   = cell(1,nCh);

    for ii = 1:nCh
        channelVar      = varnames{iich(ii)};
        tempChan        = eval(channelVar);
        spiketimes{ii}  = tempChan(:,3);
        channels(ii)    = iich(ii);
        waveforms{ii}   = tempChan(:,4:end);
    end

    save(saveFile, 'spiketimes', 'channels', 'waveforms')
else
    load(saveFile)
end