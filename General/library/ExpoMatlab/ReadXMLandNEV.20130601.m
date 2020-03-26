function ExpoXMLimport = ReadXMLandNEV(varargin)
%
%ExpoXMLimport = ReadXMLandNEV('file1','file2'[,'file3'][,'nomat'])
%

% This function is used to merge and synchronize Blackrock NEV files and
% Expo XML files. At least one of the files must be an Expo XML file, and
% one must be a Blackrock NEV file that contains Digital Sync Pulses on Pin 0.
%
% Examples:
%
% e = ReadXMLandNEV('m639r1#1[ori16].xml','m639r1#001.nev');
%
%     Read the XML file, 'm639r1#1[ori16].xml', and the NEV file,
%     'm639r1#001.nev' and merge the info to produce one matlab structure.
%
% e = ReadXMLandNEV('m639r1#1[ori16].xml','m639r1#001.nev','m639r1#001replay.nev');
%
%     Read the XML file, 'm639r1#1[ori16].xml', and the NEV files,
%     'm639r1#001.nev', 'm639r1#001replay.nev'. Then merge the info to produce one 
%     matlab structure.  Spiketimes from the replay will override
%     spiketimes from the non-replay file. Replayed files do not have digital
%     timestamps embedded, so the digital input from the non-replayed file
%     will be preserved.
%
%
% e = ReadXMLandNEV('m639r1#1[ori16].xml','m639r1#001.nev','nomat');
%


%%
if ~ismember(nargin,[2 3 4])
    error('Expo:ReadXMLandNEV','Please specify at least two or three files.');
end

nXMLfiles = 0;
nNEVfiles = 0;
nomat = 0;
for ii=1:nargin
    if strcmp(varargin{ii},'nomat')
        nomat = 1;
    else
        [p,n,e] = fileparts(varargin{ii});
        if isempty(p)
            p = pwd;
        end
        if isempty(strfind(p(1:3),filesep))
            p = cat(2,'.',filesep,p);
        end
        switch e
            case '.xml'
                %disp('Found XML file');
                nXMLfiles = nXMLfiles + 1;
                filenameXML = [p filesep n e];
            case '.nev'
                %disp('Found NEV file');
                nNEVfiles = nNEVfiles + 1;
                filenameNEV{nNEVfiles} = [p filesep n e];
        end
    end
end
clear p n e ii;
%%
if (nXMLfiles ~= 1)||(nNEVfiles < 1)||(nNEVfiles > 2)
    error('Expo:ReadXMLandNEV','Specify one XML and one or two NEV files.');
end

NEVimport = cell(nNEVfiles,1);

%%
for ii=1:nNEVfiles
    if exist([filenameNEV{ii}(1:end-3) 'mat'],'file')
        fprintf('Found a preprocessed NEV file and ');
        if nomat
            fprintf('ignoring it!\n');
            NEVimport{ii} = openNEV(filenameNEV{ii},'report','8bits','nomat','nosave');
        else
            fprintf('using it!\n');
            NEVimport{ii} = openNEV(filenameNEV{ii},'report','8bits','nosave');
        end
    else
        fprintf('Processing NEV file and saving it to a MAT file.\n');
        NEVimport{ii} = openNEV(filenameNEV{ii},'report','8bits');
    end
end

if exist([filenameXML(1:end-3) 'mat'],'file')
    fprintf('Found preprocessed XML file. Using it!\n');
    load([filenameXML(1:end-4) '.mat'],'ExpoXMLimport');
else
    fprintf('Processing XML file and saving it to a MAT file.\n');
    ExpoXMLimport = ReadExpoXML(filenameXML,0,1);
    save([filenameXML(1:end-4) '.mat'],'ExpoXMLimport');
end

% clear ii *argin;
%% Determine which one has the digital words

nNEV_digital = 0;
nNEV_rerun   = 0;

NEVimport_D = [];
NEVimport_R = [];


for ii=1:nNEVfiles
    if ~isempty(NEVimport{ii}.Data.SerialDigitalIO.UnparsedData)
        % found digital data!
        nNEV_digital = nNEV_digital + 1;
        NEVimport_D = NEVimport{ii};
    else
        % found rerun data!
        nNEV_rerun = nNEV_rerun + 1;
        NEVimport_R = NEVimport{ii};
    end
end

if (nNEV_digital < 1)
    error('Expo:ReadXMLandNEV','You did not supply a NEV file with with digital timestamps.');
end

if (nNEV_digital > 1)
    warning('Expo:ReadXMLandNEV','Found two NEV files, both with digital timestamps. Using the last one only!');
    NEVimport = NEVimport{1};
end

%%
NEVimport = NEVimport_D;
clear NEVimport_D;
if nNEV_rerun
    NEVimport.ElectrodesInfo = NEVimport_R.ElectrodesInfo;
    NEVimport.Data.Spikes    = NEVimport_R.Data.Spikes;
end

%%
dwords = double(NEVimport.Data.SerialDigitalIO.UnparsedData);
times  = double(NEVimport.Data.SerialDigitalIO.TimeStampSec*10000);
samples = double(NEVimport.Data.SerialDigitalIO.TimeStamp);
xmltimes = double(ExpoXMLimport.frames.Times');


fprintf('-PRECORRECTION--------------------\n');
fprintf('%010d digital words received\n',size(dwords,2));
fprintf('%010d screen frames presented\n',ExpoXMLimport.frames.nticks);
fprintf('----------------------------------\n');

% %%
% ndwords    = length(dwords);
% monitorNDX = (dwords==256);
% validNDX   = setdiff(1:ndwords,find(monitorNDX));
% dwords     = mod(dwords(validNDX),256);
% times      = times(validNDX);
% samples    = samples(validNDX);
%
%

%%
priorndx = find(diff(samples) == 1);
badndx   = priorndx + 1;
goodndx = setdiff(1:length(dwords),badndx);

dwords(priorndx) = dwords(priorndx) + dwords(badndx);
dwords = dwords(goodndx);
times = times(goodndx);
samples = samples(goodndx);

fprintf('-POSTCORRECTION-------------------\n');
fprintf('%010d digital words received\n',size(dwords,2));
fprintf('%010d screen frames presented\n',ExpoXMLimport.frames.nticks);
fprintf('----------------------------------\n');

if (size(dwords,2) > ExpoXMLimport.frames.nticks)
    fprintf('-FOUND TOO MANY DWORDS!-----------\n');
    fprintf('%010d digital words before.\n',size(dwords,2));
    dwords  = dwords(1,1:ExpoXMLimport.frames.nticks);
    times   = times(1,1:ExpoXMLimport.frames.nticks);
    samples = samples(1,1:ExpoXMLimport.frames.nticks);
    fprintf('%010d digital words after.\n',size(dwords,2));
    fprintf('----------------------------------\n');
end
%%
% find first and last "aligned tick!"
firstaligned_NDX = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'first');
lastaligned_NDX  = find(diff(times)<(83.3+4)&diff(times)>(83.3-4),1,'last')+1;
% calc offset & scale
offset           = times(firstaligned_NDX)-xmltimes(firstaligned_NDX);
times_offset     = times - offset;
scale            = (xmltimes(lastaligned_NDX)-xmltimes(firstaligned_NDX))/(times_offset(lastaligned_NDX) - times_offset(firstaligned_NDX));
% apply offset & scale to all spikes
NEV.timestamps = round((double(NEVimport.Data.Spikes.TimeStamp)/3 - offset).*scale);
NEV.channel    = NEVimport.Data.Spikes.Electrode;
NEV.templateID = NEVimport.Data.Spikes.Unit;

NEV.uni_channel    = double(unique(NEV.channel));
NEV.uni_templateID = double(unique(NEV.templateID));

ExpoXMLimport.spiketimes_EXPO = ExpoXMLimport.spiketimes;
ExpoXMLimport.spiketimes.IDs = 0:(length(unique([double(NEV.channel)*1000 + double(NEV.templateID) NEV.uni_channel]))-1);
ExpoXMLimport.spiketimes.Channels  = zeros(size(ExpoXMLimport.spiketimes.IDs));
ExpoXMLimport.spiketimes.Templates = zeros(size(ExpoXMLimport.spiketimes.IDs));
%%
cnt = 1;
fprintf('Processing Spikes...\n');
for curChan = NEV.uni_channel
    fprintf('CH %03d [',curChan);
    for curTempID = NEV.uni_templateID
        tempTimes = round(NEV.timestamps((NEV.templateID==curTempID)&(NEV.channel == curChan)));
        if ~isempty(tempTimes)
            ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
            ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
            ExpoXMLimport.spiketimes.Templates(cnt) = curTempID;
            cnt = cnt + 1;
            fprintf('.');
        end
    end
    tempTimes = sort(round(NEV.timestamps((NEV.templateID~=255)&(NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 256;
        cnt = cnt + 1;
        fprintf('*');
    end
    tempTimes = sort(round(NEV.timestamps((NEV.channel == curChan))));
    if ~isempty(tempTimes)
        ExpoXMLimport.spiketimes.Times{cnt} = tempTimes(tempTimes>0);
        ExpoXMLimport.spiketimes.Channels(cnt) = curChan;
        ExpoXMLimport.spiketimes.Templates(cnt) = 257;
        cnt = cnt + 1;
        fprintf('#');
    end
    fprintf('] ');
    if ~mod(curChan,8)
        fprintf('\n');
    end
end
ExpoXMLimport.spiketimes.IDs = 0:(cnt-2);
%%
ExpoXMLimport.blackrock.dwords = dwords;
ExpoXMLimport.blackrock.samples = samples;
ExpoXMLimport.blackrock.times = times;
ExpoXMLimport.blackrock.offset = offset;
ExpoXMLimport.blackrock.scale = scale;

%%
fprintf('\nSaving Results in an *.full.mat file.\n');
save([filenameXML(1:end-4) '.full.mat'],'ExpoXMLimport');

