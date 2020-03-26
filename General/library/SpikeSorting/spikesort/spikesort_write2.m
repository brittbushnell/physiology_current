function spikesort_write2(fileIndex)

global FileInfo;
global WaveformInfo;

j = fileIndex;

ByteFormat=['int' num2str(FileInfo(j).BytesPerSample*8)];
UnitFormat='uchar';
WaveformSize=(FileInfo(j).PacketSize-8)/FileInfo(j).BytesPerSample;% this line changed Feb 5,2003                
PacketSize=FileInfo(j).PacketSize/FileInfo(j).BytesPerSample;
UnitLength=1;

filename=FileInfo(j).filename;
HeaderSize=FileInfo(j).HeaderSize;
Locations=FileInfo(j).Locations;%Locations are in bytes relative to header end
chan_Locations=Locations(FileInfo(j).PacketOrder==WaveformInfo.ChannelNumber);%packets from this channel

loc = chan_Locations + 6 + HeaderSize;

writeUnits(loc, WaveformInfo.Unit, filename);

%load (['spikesortunits/' FileInfo(j).filename '.mat']);

FileInfo(j).units{WaveformInfo.ChannelNumber} = zeros(256,1);
FileInfo(j).units{WaveformInfo.ChannelNumber}(unique(double(WaveformInfo.Unit))+1) = 1;

%save (['spikesortunits/' FileInfo(j).filename '.mat'], 'units');