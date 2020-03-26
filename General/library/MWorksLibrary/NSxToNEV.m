function NSxToNEV(in_nsfilename,in_nevfilename,out_nevfilename,varargin)
% NSxToNEV(in_nsfilename,in_nevfilename,out_nevfilename,...)
%
%  in_nsfilename  = [input file]  name of ns6 filename
%  in_nevfilename = [input file]  name of nev filename (one with digital timestamps)
% out_nevfilename = [output file] name of nev file to save...
% 
% other optional flags:
%
% ...,'threshold',value_in_std_dev,...
% value in units of standard deviations.
%
% ...,'bandpass',[low_cutoff high_cutoff],...
% ...,'lowpass' ,[high_cutoff],...
% ...,'highpass',[low_cutoff],...
% all cutoffs in units of Hz.
%
% see also rethreshold.
%
%       Author: Romesh Kumbhani
%        Email: romesh.kumbhani@nyu.edu
%      Version: 1.0
% Last updated: 2014-03-04


readNEV = false;

if nargin<3
    error('NSxToNEV:numArguments','You need to pass at least two arguments, the input filename, and the output filename.');
end

if ~exist(in_nsfilename,'file')
    error('NSxToNEV:readNSx','[ input] NSx file: %s doesn''t exist.\n',in_nsfilename);
end

if ~isempty(in_nevfilename)
    if ~exist(in_nsfilename,'file')
        error('NSxToNEV:readNSx','[ input] NEV file: %s doesn''t exist.\n',in_nevfilename);
    end
    readNEV = true;
end

if exist(out_nevfilename,'file')
    warning('NSxToNEV:writeoutNEV','[output] NEV file: %s already exists. File will be overwritten.\n',out_nevfilename);
end

fidout = fopen(out_nevfilename,'w');
if (fidout==-1)
    error('NSxToNEV:writeoutNEV','Cound not open: %s for writing.',out_nevfilename);
end
fclose(fidout);

t=tic;
fprintf('Rethresholding file: %s ',in_nsfilename);
[data, header] = rethreshold(in_nsfilename,varargin{:});
fprintf('[%.1f s]\n',toc(t));
t=tic;
fprintf('Loading old file: %s ',in_nevfilename);
oldnev = openNEV_rk(in_nevfilename,'nomat','nosave');
fprintf('[%.1f s]\n',toc(t));

t=tic;
fprintf('Generating new file: %s ',out_nevfilename);
if readNEV
    maxextheaderpackets = 144*3+2; % three for each analog channel + one for each digital channel (serial + dio)
else
    maxextheaderpackets = 144*3; % three for each analog channel
end
%%
nevheader          = uint8(zeros(1,336));
nevheader(  1:  8) = 'NEURALEV';
nevheader(      9) = uint8(str2double(header.FileSpec(1)));
nevheader(     10) = uint8(str2double(header.FileSpec(3)));
nevheader( 11: 12) = typecast(uint16(1),'uint8');
nevheader( 13: 16) = typecast(uint32(336 + maxextheaderpackets*32),'uint8'); % total header + extended header size
nevheader( 17: 20) = typecast(uint32(104),'uint8'); %  8 byte header + 96 byte data per packet
nevheader( 21: 24) = typecast(uint32(header.TimeRes),'uint8');
nevheader( 25: 28) = typecast(uint32(header.SamplingFreq),'uint8');
nevheader( 29: 44) = typecast(uint16(header.TimeStampRaw),'uint8')';
nevheader( 45: 76) = uint8(cat(2,'NSxToNEV v1.0',zeros(1,19)));
nevheader( 77:332) = uint8(zeros(1,256));
nevheader(333:336) = typecast(uint32(maxextheaderpackets),'uint8'); 

%% make extended header packets
nevextheader       = uint8(zeros(32*maxextheaderpackets,1));

%% encode defaults
for ii = 1:144
    offset = (ii-1)*32*3;
    % header
    nevextheader(( 1: 8)+offset) = uint8('NEUEVWAV');    
    % electrode #
    nevextheader(( 9:10)+offset) = typecast(uint16(ii),'uint8');
    % connectorBank
    nevextheader((   11)+offset) = uint8(ceil(ii/32));
    % connectorPin
    nevextheader((   12)+offset) = uint8(mod((ii)-1,32)+1);
    % DigitalFactor
    nevextheader((13:14)+offset) = typecast(uint16(21516),'uint8');
    % EnergyThreshold
    nevextheader((15:16)+offset) = typecast(uint16(0),'uint8');
    % HighThreshold
    nevextheader((17:18)+offset) = typecast(uint16(0),'uint8');
    % LowThreshold
    nevextheader((19:20)+offset) = typecast(uint16(0),'uint8');
    % Units
    nevextheader((   21)+offset) = uint8(0);
    % Waveform bytes
    nevextheader((   22)+offset) = uint8(2);
    %-----------------------------------------------------------------
    % header
    nevextheader(( 1: 8)+offset+32) = uint8('NEUEVLBL');    
    % electrode #
    nevextheader(( 9:10)+offset+32) = typecast(uint16(ii),'uint8');
    % label
    outstr = uint8(zeros(1,16));
    if (ii<=128)
        str = uint8(sprintf('chan%d',ii));
    else
        str = uint8(sprintf('ainp%d',ii-128));
    end
    outstr(1,1:length(str)) = str;
    nevextheader((11:26)+offset+32) = outstr;
    %-----------------------------------------------------------------
    % header
    nevextheader(( 1: 8)+offset+64) = uint8('NEUEVFLT');    
    % electrode #
    nevextheader(( 9:10)+offset+64) = typecast(uint16(ii)  ,'uint8');
    % HighFreqCorner
    nevextheader((11:14)+offset+64) = typecast(uint32(300) ,'uint8');
    % HighFreqOrder
    nevextheader((15:18)+offset+64) = typecast(uint32(1)   ,'uint8');
    % HighFilterType
    nevextheader((19:20)+offset+64) = typecast(uint16(1)   ,'uint8');
    % LowFreqCorner
    nevextheader((21:24)+offset+64) = typecast(uint32(7500),'uint8');
    % LowFreqOrder
    nevextheader((25:28)+offset+64) = typecast(uint32(3)   ,'uint8');
    % LowFilterType
    nevextheader((29:30)+offset+64) = typecast(uint16(1)   ,'uint8');
end

%% encode actual values
for ii = 1:header.ChannelCount    
    offset = double((header.ElectrodesInfo(ii).ElectrodeID-1)*32*3);
    % header
    nevextheader(( 1: 8)+offset) = uint8('NEUEVWAV');    
    % electrode #
    nevextheader(( 9:10)+offset) = typecast(uint16(header.ElectrodesInfo(ii).ElectrodeID),'uint8');
    % connectorBank
    nevextheader((   11)+offset) = uint8(header.ElectrodesInfo(ii).ConnectorBank-64);
    % connectorPin
    nevextheader((   12)+offset) = uint8(header.ElectrodesInfo(ii).ConnectorPin);
    % DigitalFactor
    nevextheader((13:14)+offset) = typecast(uint16(header.ElectrodesInfo(ii).DigitalFactor),'uint8');
    % EnergyThreshold
    nevextheader((15:16)+offset) = typecast(uint16(header.ElectrodesInfo(ii).EnergyThreshold),'uint8');
    % HighThreshold
    nevextheader((17:18)+offset) = typecast(uint16(header.ElectrodesInfo(ii).HighThreshold),'uint8');
    % LowThreshold
    nevextheader((19:20)+offset) = typecast(uint16(header.ElectrodesInfo(ii).LowThreshold),'uint8');
    % Units
    nevextheader((   21)+offset) = typecast(uint8(header.ElectrodesInfo(ii).Units),'uint8');
    % Waveform bytes
    nevextheader((   22)+offset) = typecast(uint8(header.ElectrodesInfo(ii).WaveformBytes),'uint8');
    %-----------------------------------------------------------------
    % header
    nevextheader(( 1: 8)+offset+32) = uint8('NEUEVLBL');    
    % electrode #
    nevextheader(( 9:10)+offset+32) = typecast(uint16(header.ElectrodesInfo(ii).ElectrodeID),'uint8');
    % label
    nevextheader((11:26)+offset+32) = uint8(header.ElectrodesInfo(ii).ElectrodeLabel);
    %-----------------------------------------------------------------
    % header
    nevextheader(( 1: 8)+offset+64) = uint8('NEUEVFLT');    
    % electrode #
    nevextheader(( 9:10)+offset+64) = typecast(uint16(header.ElectrodesInfo(ii).ElectrodeID),'uint8');
    % HighFreqCorner
    nevextheader((11:14)+offset+64) = typecast(uint32(header.ElectrodesInfo(ii).HighFreqCorner),'uint8');
    % HighFreqOrder
    nevextheader((15:18)+offset+64) = typecast(uint32(header.ElectrodesInfo(ii).HighFreqOrder),'uint8');
    % HighFilterType
    nevextheader((19:20)+offset+64) = typecast(uint16(header.ElectrodesInfo(ii).HighFilterType),'uint8');
    % LowFreqCorner
    nevextheader((21:24)+offset+64) = typecast(uint32(header.ElectrodesInfo(ii).LowFreqCorner),'uint8');
    % LowFreqOrder
    nevextheader((25:28)+offset+64) = typecast(uint32(header.ElectrodesInfo(ii).LowFreqOrder),'uint8');
    % LowFilterType
    nevextheader((29:30)+offset+64) = typecast(uint16(header.ElectrodesInfo(ii).LowFilterType),'uint8');
end

if readNEV
    offset = (144*3+0)*32;
    nevextheader(( 1: 8)+offset) = uint8('DIGLABEL');
    if ~isempty(oldnev.IOLabels{1})
        nevextheader(( 9:24)+offset) = uint8(oldnev.IOLabels{1});
    end
    nevextheader((   25)+offset) = uint8(0);

    offset = (144*3+1)*32;
    nevextheader(( 1: 8)+offset) = uint8('DIGLABEL');
    if ~isempty(oldnev.IOLabels{2})
        nevextheader(( 9:24)+offset) = uint8(oldnev.IOLabels{2});
    end
    nevextheader((   25)+offset) = uint8(1);    
end

%% Process Packets!
nPackets = 0;
for ii=1:size(data.timestamps,1)
    nPackets = nPackets + length(data.timestamps{ii});
end

if readNEV
    nPackets = nPackets + size(oldnev.Data.SerialDigitalIO.TimeStamp,2);
end

nevpackets = uint8(zeros(104,nPackets));
tmp_ts = zeros(1,nPackets);
cnt = 1;
for curchan=1:header.ChannelCount % for every channel
    fprintf('.');
    if ~mod(curchan,10)
        fprintf('\n');
    end
    for ii = 1:length(data.timestamps{curchan}) % for every snippet
        % timestamp
        tmp_ts(cnt) = double(data.timestamps{curchan}(ii));
        nevpackets(  1:  4,cnt) = typecast(uint32(data.timestamps{curchan}(ii)),'uint8')';
        % electrode id
        nevpackets(  5:  6,cnt) = typecast(uint16(header.ElectrodesInfo(curchan).ElectrodeID),'uint8');
        % unit id
        nevpackets(      7,cnt) = uint8(0); % always unsorted unit.
        % data snippet
        nevpackets(  9:104,cnt) = typecast(int16(data.snippets{curchan}(ii,:))','uint8');
        cnt = cnt + 1;
    end
end

if readNEV
    for ii = 1:size(oldnev.Data.SerialDigitalIO.TimeStamp,2)
        % timestamp
        tmp_ts(cnt) = double(oldnev.Data.SerialDigitalIO.TimeStamp(ii));
        nevpackets(  1:  4,cnt) = typecast(uint32(oldnev.Data.SerialDigitalIO.TimeStamp(ii)),'uint8')';
        % packet ID
        nevpackets(  5:  6,cnt) = typecast(uint16(0),'uint8'); % always zero for digital
        % insertion reason
        nevpackets(      7,cnt) = uint8(oldnev.Data.SerialDigitalIO.InsertionReason(ii));
        % data snippet
        nevpackets(   9:10,cnt) = typecast(int16(oldnev.Data.SerialDigitalIO.UnparsedData(ii))','uint8');
        cnt = cnt + 1;
    end
end

fprintf('\n');
% sort packets so they're in order of arrival.
[~,ndx]=sort(tmp_ts);
nevpackets = nevpackets(:,ndx);
fprintf('[%.1f s]\n',toc(t));
%% Write out NEV file
t = tic;
fprintf('Writing out NEV file...');
fidout = fopen(out_nevfilename,'w');
% write out header (336 / 8 = 42)
fwrite(fidout,typecast(nevheader(:),'uint64'),'42*uint64');

% write out extended header (144*3*32 / 8)
fwrite(fidout,typecast(nevextheader(:),'uint64'),[num2str(maxextheaderpackets * 32 / 8) '*uint64']);

% write out packets
fwrite(fidout,typecast(nevpackets(:),'uint64'),[num2str((104/8)*nPackets) '*uint64']);

fclose(fidout);
fprintf('Done. [%.1f s]\n',toc(t));

