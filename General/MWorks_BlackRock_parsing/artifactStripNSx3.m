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
%nevName = '/Volumes/NSP1B/WU_LE_Gratings_nsp1_20170619_001.nev';
%nevName = '/Volumes/NSP2/nsp2_blackrock/WU_LE_Gratings_nsp2_20170609_001.nev';

%nevName = '/Volumes/NSP1B/WU_LE_Gratings_nsp2_20170707_001.nev';
nevName = '/Volumes/NSP2/nsp2_blackrock/WU_LE_Gratings_nsp2_20170704_004.nev';
%nevName = '/Volumes/NSP2/nsp2_blackrock/WU_LE_RadFreqLoc2_nsp2_20170707_002.nev'
%nevName = '/Users/bbushnell/Dropbox/ArrayData/WU_LE_Gratings_nsp2_20170704_004.nev';

%nevName = '/Volumes/NSP1B/WU_LE_RadFreqSparse_nsp2_20170609_002.nev';
%nevName = '/Volumes/NSP1B/WU_LE_Gratings_nsp2_20170609_001.nev';

%location  = 1;
ovr = 0; % set this to 1 to create new .mat files each time.
thresh = -1200;
date = '07/07';
array = 'V4';

chunks = strsplit(nevName,'/');
nameInfo = string(chunks(end));
chunks = strsplit(nameInfo,'_');
program = chunks(3);

elect = [11, 60];%, 60];
%elect = fliplr(elect);
cutCrit = 99;
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
%% Extract information
goods = nan(96,1);
inval = nan(96,1);

for t = 1:length(elect)
    ch = elect(1,t);
    
    %% find waveforms
    
    ndx = find(nevFile.Data.Spikes.Electrode == ch);
    chWaveform = nevFile.Data.Spikes.Waveform(:,ndx);
    chWaveform2 = chWaveform;
    amps = (max(chWaveform)) - (min(chWaveform));
    chWaveform2(end+1,:) = amps;
    
    
    cutoff = prctile(chWaveform2(end,:),cutCrit);
    
    useWaves = nan(48,size(chWaveform2,2));
    badWaves = nan(48,size(chWaveform2,2));
    
    for i = 1:(size(chWaveform2,2))
        if chWaveform2(end,i) > cutoff
            badWaves(:,i) = chWaveform2(1:end-1,i);
            continue
        end
        
        if min(chWaveform(:,i)) < thresh
            badWaves(:,i) = chWaveform2(1:end-1,i);
        else
            useWaves(:,i) = chWaveform2(1:end-1,i);
        end
    end
    goods(ch,96) = size(badWaves,2);
    inval(ch,96) = size(badWaves,2);
    
    figure
    hold on
    plot(chWaveform)
    title (sprintf('%s %s %s Electrode %d all waveforms crit: %d',date,array,program,ch,cutCrit))
    set(gca,'color','none','tickdir','out','box','off')
    xlabel('time(ms)')
    pause(0.5)
    
    figure
    hold on
    plot(badWaves)
    title (sprintf('%s %s %s Electrode %d invalidated waveforms crit: %d',date,array,program,ch,cutCrit))
    set(gca,'color','none','tickdir','out','box','off')
    xlabel('time(ms)')
    pause(0.25)
    
    figure
    hold on
    plot(useWaves)
    title (sprintf('%s %s %s Electrode %d kept waveforms crit: %d',date,array,program,ch,cutCrit))
    set(gca,'color','none','tickdir','out','box','off')
    xlabel('time(ms)')
    
    pause(0.1)
end
%
%     close all


toc