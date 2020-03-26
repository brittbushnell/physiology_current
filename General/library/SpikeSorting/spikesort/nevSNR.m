function files = nevSNR(dirstring)

global WaveformInfo;

files = dir(dirstring);
files([files.isdir])=[]; %added to remove '.' and '..' (and other directories) from list of files to process. 03Oct2012 -ACS

for k = 1:length(files)
  files(k).name

  nevWaveforms(fullfile(dirstring,files(k).name)); %changed to include the full path -surprised this ever worked without this, frankly. 03Oct2012 -ACS

  waveforms = struct;
  waveInd = 1;
  for i = 1:96
    units = unique(WaveformInfo(i).Unit);

    for j = 1:length(units)
      waveforms(waveInd).channel = i;
      waveforms(waveInd).unit = units(j);
%      waveforms(waveInd).waveforms = WaveformInfo(i).Waveforms(find(WaveformInfo(i).Unit == units(j)),:);
      wav = WaveformInfo(i).Waveforms(find(WaveformInfo(i).Unit == units(j)),:);
      waveforms(waveInd).SNR = getSNR(double(wav));
      waveInd = waveInd + 1;
    end
  end

  files(k).waveforms = waveforms;
end

