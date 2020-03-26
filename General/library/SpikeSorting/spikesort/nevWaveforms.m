function waveforms = nevWaveforms(filename)
global loc;
global FileInfo;
global WaveformInfo;

if nargin < 2
    channels = 1:96;
end

FileInfo=struct('filename',[],'format','nev','HeaderSize',0,...
    'PacketSize',0,'ActiveChannels',[],'PacketOrder',uint8([]),...
    'SpikesNumber',[],'BytesPerSample',0); %initialize FileInfo structure
        
FileInfo(1).filename = filename;

ActiveChannelList=[];

ActiveChannelList = [];
for i = 1:length(FileInfo)
    spikesort_nevscan(i); %changed from sac_nevscan 10Apr2013 -Adam C. Snyder

    ActiveChannelList = union(ActiveChannelList,FileInfo(i).ActiveChannels);
end

if length(unique([FileInfo(:).PacketSize]))~=1
    error('Variable Packet Sizes');
end

WaveformSize=(FileInfo(1).PacketSize-8)/FileInfo(1).BytesPerSample;
ByteLength=['int' num2str(FileInfo(1).BytesPerSample*8)];

for j = 1:length(channels)
    totalSpikes(j) = 0;
    for i = 1:length(FileInfo)
        totalSpikes(j) = totalSpikes(j) + length(find(FileInfo(i).PacketOrder==channels(j)));
    end
end

numSamples = (FileInfo(1).PacketSize-8)/2;

gaveWarning = false; %for improved error handling -Adam C. Snyder 09Apr2013
for channelIndex = 1:length(channels)
    for fileIndex = 1:length(FileInfo)
      
      PacketNumbers=find(FileInfo(fileIndex).PacketOrder==channels(channelIndex));
        loc = FileInfo(fileIndex).HeaderSize + FileInfo(fileIndex).Locations(PacketNumbers);
        [wav, times, units] = readWaveforms(loc,numSamples, FileInfo(fileIndex).filename);
        WaveformInfo(channelIndex).Waveforms = wav';
        WaveformInfo(channelIndex).Unit = units;
        try %I have no idea why, but this field (TimeResolutionTimeStamps) isn't being generated for me right now, and I can't see quickly where it's supposed to be coming from or what it's used for later, so I'm just going to 'try' out of it for now. 03Oct2012 -ACS
            WaveformInfo(channelIndex).Times = double(times)/FileInfo(fileIndex).TimeResolutionTimeStamps*1000;
        catch ME
            if ~gaveWarning&&strcmp(ME.identifier,'MATLAB:nonExistentField'), %for improved error handling -Adam C. Snyder 09Apr2013
                warning(ME.identifier,ME.message);
                gaveWarning = true;
            elseif ~strcmp(ME.identifier,'MATLAB:nonExistentField')
                warning(ME.identifier,ME.message);
            end;
        end;
    end
end

waveforms = WaveformInfo;
