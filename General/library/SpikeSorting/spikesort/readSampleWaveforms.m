function readSampleWaveforms(ch)

global FileInfo;
global Handles;
global WaveformInfo;

w = waitbar(0,'Please wait, reading sample waveforms');

for j = 1:length(ch)
    PacketNumbers = [];
    for i=1:length(FileInfo)
        nums = find(FileInfo(i).PacketOrder == ch(j));
        PacketNumbers = [PacketNumbers; ones(length(nums),1)*i nums];
    end

%    spInd = randperm(size(PacketNumbers,1));
%    spInd = sort(spInd(1:end));
    
%    PacketNumbers{j} = PacketNumbers{j}(spInd,:);

    Waveforms = [];
    Unit = [];
    Times = [];
    Breaks = zeros(length(FileInfo),1);
      
    for i = find(cellfun(@ismember,repmat({ch(j)},size(FileInfo)),{FileInfo.ActiveChannels})), %changed from "1:length(FileInfo)" so that now it only runs through files that contain the current channel. -21Mar2013 -Adam C. Snyder
        PN = PacketNumbers(PacketNumbers(:,1)==i,2);
        loc = FileInfo(i).HeaderSize + FileInfo(i).Locations(PN);        

        [wav,tim,uni] = readWaveforms(loc,WaveformInfo.NumSamples,FileInfo(i).filename);
        wav = int16(double(wav) / 1000 * FileInfo(i).nVperBit(ch(j))); %changed 'j' to 'ch(j)' to support skipped channel indices 31AUG2012 -ACS
        
        Waveforms = [Waveforms; wav'];
        
        newTimes = double(tim)/FileInfo(i).TimeResolutionTimeStamps*1000;
                
        if i < length(FileInfo)
            if isempty(newTimes)
                Breaks(i+1) = Breaks(i);
            else
                Breaks(i+1) = Breaks(i)+max(newTimes);
            end
        end
        
        newTimes = newTimes + Breaks(i);
        
        Times = [Times; newTimes];
        Unit = [Unit; uni];
        waitbar ((j-1)/length(ch)+(i/length(FileInfo))/length(ch));
    
        FileInfo(i).units{ch(j)} = zeros(256,1);
        FileInfo(i).units{ch(j)}(unique(double(Unit))+1) = 1;
    end

    save (sprintf('spikesortunits/ch%i.mat',ch(j)),'Waveforms','Times','Unit','Breaks');
end

close(w);
