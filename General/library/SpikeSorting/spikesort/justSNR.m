function snr = justSNR(filename)
%function snr = justSNR(filename)
%
% justSNR(filename) takes a NEV file as input and returns a list of
% channel numbers, sort codes, SNR values, and spike counts from that file
%

  global WaveformInfo;
  
  nevWaveforms(filename);

  disp('Completed waveform read. Computing SNR...');
  
  k = 1;
  
  waveforms = struct;
  waveInd = 1;
  for i = 1:96
    units = unique(WaveformInfo(i).Unit);

    for j = 1:length(units)
      wav = WaveformInfo(i).Waveforms(find(WaveformInfo(i).Unit == ...
                                           units(j)),:);
      snr(k,:) = [i double(units(j)) getSNR(double(wav)) size(wav,1)];
      k = k + 1;
    end
  end
end

