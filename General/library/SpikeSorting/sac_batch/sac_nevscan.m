function sac_nevscan(j)
global FileInfo;
fid=fopen([ FileInfo(j).filename],'r','l');

%read general header
FileType=fread(fid,8,'char');
Version=fread(fid,2,'uint8');
FileFormatAdditional=fread(fid,2,'char');
HeaderSize=fread(fid,1,'uint32');
PacketSize=fread(fid,1,'uint32');
FileInfo(j).TimeResolutionTimeStamps=fread(fid,1,'uint32');
FileInfo(j).TimeResolutionSamples=fread(fid,1,'uint32');
%unsure about actualtype of TimeOrigin
TimeOrigin=fread(fid,8,'uint16');
Application=fread(fid,32,'char');
Comment=fread(fid,256,'uint8');
ExtendedHeaderNumber=fread(fid,1,'ulong');

BytesPerSample = 2;

%read extended headers
for i=1:ExtendedHeaderNumber
    Identifier=fread(fid,8,'*char')';
    %modify this later
    switch Identifier
        case 'NEUEVWAV'
            ElecID=fread(fid,1,'uint16');
            PhysConnect=fread(fid,1,'uint8');
            PhysConnectPin=fread(fid,1,'uint8');
            FileInfo(j).nVperBit(ElecID)=fread(fid,1,'uint16');
            EnergyThresh=fread(fid,1,'uint16');
            FileInfo(j).HighThresh(ElecID)=fread(fid,1,'int16');
            FileInfo(j).LowThresh(ElecID)=fread(fid,1,'int16');
            SortedUnits=fread(fid,1,'uint8');
            BytesPerSample=((fread(fid,1,'uint8'))>1)+1;
            temp=fread(fid,10,'uint8');
        otherwise, % added26/7/05 after identifying bug in reading extended headers
            temp=fread(fid,24,'uint8');
    end
end

% Calculate number of packets
fseek(fid,0,'eof');
FileSize=ftell(fid);
PacketNumber=(FileSize-HeaderSize)/PacketSize;

%initialization
fseek(fid,HeaderSize,'bof');
fread(fid,1,'uint32');


%read the data
% MAS 2013/08/20 - the line below used to cast as uint8, which broke things
% for when channel numbers exceeded 255. Now it's fixed.
FileInfo(j).PacketOrder=uint16(fread(fid,PacketNumber,'uint16',PacketSize-2));%read the channel identifiers
fseek(fid,HeaderSize,'bof');
Times=fread(fid,PacketNumber,'uint32',PacketSize-4);%read the packet timestamps
fclose(fid);
FileInfo(j).Locations=(0:PacketSize:PacketSize*(PacketNumber-1))';%The location of packets.
% This line was changed, August 12, 2003

%Determine active channels and number of spikes on each
maxActiveChannel = max(FileInfo(j).PacketOrder(:)); %Changed from magic numbers to the active channel with the greatest index 31AUG2012 -ACS
FileInfo(j).SpikesNumber=zeros(1,maxActiveChannel);

spikesRead = 0;
for ii=1:maxActiveChannel  
    FileInfo(j).SpikesNumber(ii)=sum(FileInfo(j).PacketOrder==ii);
    spikesRead = spikesRead + FileInfo(j).SpikesNumber(ii);
end

%FileInfo(j).ActiveChannels=find(FileInfo(j).SpikesNumber);

%Set file information global
FileInfo(j).SamplingRate      = 30;
FileInfo(j).ThresholdLocation = 11;
FileInfo(j).ActiveChannels    = find(FileInfo(j).SpikesNumber);
FileInfo(j).HeaderSize        = HeaderSize;
FileInfo(j).PacketSize        = PacketSize;
FileInfo(j).BytesPerSample    = BytesPerSample; %This can have electrode dependent values, but here only set once
FileInfo(j).NumSamples        = (PacketSize - 8)/BytesPerSample;
FileInfo(j).Application       = Application;

%% The next section deals with finding and purging amplifier pops

%ShockThreshold=round(0.9*length(FileInfo(j).ActiveChannels));

%if ShockThreshold>30
%    suspects=find((Times(ShockThreshold:end)-Times(1:end-ShockThreshold+1))<=2);
%    for i2=suspects'
%        ShockPackets=find(abs(Times-Times(i2))<2);
%        FileInfo(j).PacketOrder(ShockPackets)=0;
%    end
%    for i1=1:max( FileInfo(j).ActiveChannels)
%        FileInfo(j).SpikesNumber(i1)=sum(FileInfo(j).PacketOrder==i1);
%    end
%end
