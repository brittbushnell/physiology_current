% artifactStripNSx
%{
This script takes in a Blackrock NS file (NS2 or NS6), and does some simple
artifact rejection.
%}
% see README_artifactStripNSx for more detailed notes

clear all
close all
clc
tic
%%
nevName = '/Volumes/NSP1B/WU_LE_Gratings_nsp2_20170704_004.nev';
%nevName = '/Users/bbushnell/Dropbox/ArrayData/WU_LE_Gratings_nsp2_20170704_004.nev';
location  = 1;
ovr = 0; % set this to 1 to create new .mat files each time.
stopPass = 250;
%% Open NSx and NEV files
% nsxFile = openNSx(file,'c:5','report');

% if strfind(file,'ns6')
%     nevName = strrep(file,'ns6','nev');
% elseif strfind(file,'ns2')
%     nevName = strrep(file,'ns2','nev');
% else
%     error('Cannot identify file type')
% end

if ovr == 0
    nevFile = openNEV(nevName);
else
    nevFile = openNEV(nevName,'nomat','overwrite');
end
%% get amplitudes
amp = ((max(nevFile.Data.Spikes.Waveform)) - (min(nevFile.Data.Spikes.Waveform)));
cutoff  = prctile(amp,98);
%% Extract information
%doe = [52, 81, 89, 80, 79, 71, 60];
for ch = 60% 1:size(doe,2)
    %ch = doe(1,t);
    %% find waveforms
    
    ndx = find(nevFile.Data.Spikes.Electrode == ch);
    chWaveform = nevFile.Data.Spikes.Waveform(:,ndx);
    tmpAmp = ((max(chWaveform)) - (min(chWaveform)));
    highCut = prctile(tmpAmp,99);
    
    %% plot amplitudes for each ch
    figure
    hold on
    histogram(tmpAmp)
    plot([cutoff cutoff], [0 6500],'r','LineWidth',1.5)
    title (sprintf('Ch %d waveform amplitudes',ch))
    set(gca,'color','none','tickdir','out','box','off')
    xlabel('amplitude')
    %% plot waveforms for each channel
    figure
    hold on
    for i = 1:size(chWaveform,2)
        if tmpAmp(:,i) >= highCut
            plot(nevFile.Data.Spikes.Waveform(:,i),'k','LineWidth',1.25);
        elseif tmpAmp(:,i) <= lowCut
            plot(nevFile.Data.Spikes.Waveform(:,i),'k','LineWidth',1.25);
        else
            plot(nevFile.Data.Spikes.Waveform(:,i));
        end
    end
    title (sprintf('Ch %d waveforms',ch))
    set(gca,'color','none','tickdir','out','box','off')
    xlabel('time(ms)')
    
%     figure
%     hold on
%     for i = 1:size(chWaveform,2)
%         if tmpAmp(:,i) >= cutoff
%             plot(nevFile.Data.Spikes.Waveform(:,i),'k','LineWidth',1.25);
%         else
%             plot(nevFile.Data.Spikes.Waveform(:,i));
%         end
%     end
%     title (sprintf('Ch %d waveforms',ch))
%     set(gca,'color','none','tickdir','out','box','off')
%     xlabel('time(ms)')
end
%% plot amplitudes for all ch
% figure
% hold on
% histogram(amp)
% plot([cutoff cutoff], [0 6500],'r','LineWidth',1.5)
% title ('amplitudes across all channels')
% set(gca,'color','none','tickdir','out','box','off')
% xlabel('amplitude')
%% plot waveforms for all channels
% figure
% plot(nevFile.Data.Spikes.Waveform);
% title ('Waveforms for all channels')
% set(gca,'color','none','tickdir','out','box','off')
% xlabel('time(ms)')
%% Threshold
% duration = size(nsxFile.Data{2},2);
%
% rawData = double(nsxFile.Data{2});
%
% [b,a] = butter(4,stopPass/15000,'high');
% filteredData = filter(b,a,rawData);

toc