function spikesort_write(fileIndex)

global FileInfo;
global WaveformInfo;

h=waitbar(0,'Writing Files...','Position',[250 300 270 60]);

j = fileIndex;

ByteFormat=['int' num2str(FileInfo(j).BytesPerSample*8)];
UnitFormat='uchar';
WaveformSize=(FileInfo(j).PacketSize-8)/FileInfo(j).BytesPerSample;% this line changed Feb 5,2003                
PacketSize=FileInfo(j).PacketSize/FileInfo(j).BytesPerSample;
Shift1= 8/FileInfo(j).BytesPerSample; %shift to Waveform field (in Packets)
Shift2= 6;%shift to Unit field (in Bytes)
UnitLength=1;

filename=FileInfo(j).filename;
HeaderSize=FileInfo(j).HeaderSize;
fid=fopen(filename,'r+');
Locations=FileInfo(j).Locations;%Locations are in bytes relative to header end
chan_Locations=Locations(find(FileInfo(j).PacketOrder==WaveformInfo.ChannelNumber));%packets from this channel
                                                                                    %chan_Locations = chan_Locations(WaveformInfo.startIndex:WaveformInfo.startIndex +WaveformInfo.TotalNumber-1);
num_to_read=length(chan_Locations);
Units=zeros(1,num_to_read);
%write the classification back to file
fseek(fid,HeaderSize+chan_Locations(1)+Shift2,-1);%skip to start location
skip=[0; diff(chan_Locations)-UnitLength];%first skip is 0 because fwrite first skips then writes

for i=1:length(skip)
    if mod(i,500) == 0
        waitbar(i/length(skip),h);
    end
    fwrite(fid,WaveformInfo.Unit(i),UnitFormat,skip(i));
end
fclose(fid);

close(h);
