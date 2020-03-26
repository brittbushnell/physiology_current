function [data,header] = getNSxData(filename,channel)
% function [data,header] = getNSxData(filename)
%
% For a given NSx "filename", this function extracts
% the data and header
%


%%
logname     = '/tmp/%s.ns.log';


if ~exist('filename','var')
    [filename, pname] = uigetfile({'*.ns2';'*.ns6'},'Choose an NSx file');
    filename = [pname filesep filename];
    %     filename = '/experiments/m643_array/recordings/ns6/m643l1#014.ns6';
end
[~,fname] = fileparts(filename);
logfilename = sprintf(logname,fname);
flog = fopen(logfilename,'w');
if flog==-1
    error('getNSxData:logcreation','Couldn''t create log file in /tmp');
end


if ~exist(filename,'file')
    error('getNSxData:file_exist_check','The file, %s, does not exist.\n',filename);
end

if ~(strcmpi(filename(end-2:end-1),'ns') && ~isnan(str2double(filename(end))))
    error('getNSxData:NSx_file_check','Please use a NSx file');
end

%open file
fid = fopen(filename,'r','ieee-le');

bb=tic;
% check to make sure it's a NSx file.
fseek(fid,0,'bof');
filetype = fread(fid,8,'uint8=>char')';
if ~strcmpi(filetype,'neuralsg') && ~strcmpi(filetype,'neuralcd')
    % not "NEURALSG" or "NEURALCD" formats...
    error('getNSxData:valid_NSxfile_check','The file is not a valid NSx file.');
end

% grab header
switch filetype
    case 'NEURALSG'
        fprintf(flog,'Found Neural SG data.\n');
        header.FileSpec       = '2.1';
        header.HeaderBytes    = [];
        header.SamplingLabel  = fread(fid, [1 16], '*char');
        header.TimeRes        = 30000;
        header.SamplingFreq   = header.TimeRes / fread(fid, 1, 'uint32=>double');
        header.ChannelCount   = double(fread(fid, 1, 'uint32=>double'));
        header.ChannelID      = fread(fid, header.ChannelCount, '*uint32');
        tmp                   = dir(filename);
        header.DateTime       = tmp.date;
        header.HeaderBytes    = ftell(fid);
        clear tmp;
    case 'NEURALCD'
        fprintf(flog,'Found Neural CD data.\n');
        BasicHeader           = fread(fid, 306, '*uint8');
        header.FileSpec       = sprintf('%d.%d',BasicHeader(1:2));
        header.HeaderBytes    = double(typecast(BasicHeader(3:6), 'uint32'));
        header.SamplingLabel  = char(BasicHeader(7:22))';   header.SamplingLabel(header.SamplingLabel==0)=[];
        header.Comment        = char(BasicHeader(23:278))'; header.Comment(find(header.Comment==0,1):end) = 0;
        header.TimeRes        = double(typecast(BasicHeader(283:286), 'uint32'));
        header.SamplingFreq   = header.TimeRes / double(typecast(BasicHeader(279:282), 'uint32'));
        header.TimeStampRaw   = double(typecast(BasicHeader(287:302), 'uint16')); % 7 items (Y,M,DoW,D,H,M,S)
        header.TimeStamp      = datestr(datenum([header.TimeStampRaw([1 2 4:6]);header.TimeStampRaw(7)+header.TimeStampRaw(8)/1000]'),'dddd, mmmm dd, yyyy @ HH:MM:SS.FFF');
        header.ChannelCount   = double(typecast(BasicHeader(303:306), 'uint32'));
        ExtHeaderLength       = 66;
        readSize              = double(header.ChannelCount * ExtHeaderLength);
        header.ExtendedHeader = fread(fid, readSize, '*uint8');
end

% Begin DATA!

fseek(fid,0,'eof');
dBOF = header.HeaderBytes;
dEOF = double(ftell(fid));
fseek(fid,dBOF,'bof');
data.segments = 0;
% find the number of data segments...
switch filetype
    case 'NEURALSG'
        data.TimeStamps = nan;
        data.DataPoints = (dEOF-dBOF)/(header.ChannelCount*2);
        data.dBOD = dBOF;
        data.dEOF = dEOF;
        data.segments = 1;
    case 'NEURALCD'
        data.segments = 0;
        while double(ftell(fid)) < dEOF
            %check to see if there was a data header. Data headers start
            %with a unsigned integer value of 1.
            if (fread(fid,1,'uint8') ~= 1)
                % header was not found! use the remainder of file as data.
                data.DataPoints = (dEOF-dBOF)/(header.ChannelCount*2);
                break;
            end
            % header found
            data.segments = data.segments + 1;
            data.TimeStamps(data.segments) = fread(fid,1,'uint32');
            data.DataPoints(data.segments) = fread(fid,1,'uint32');
            fprintf(flog,'Segment #%d\nTimestamp: %d\nnDataPoints: %d\n',data.segments,data.TimeStamps(data.segments),data.DataPoints(data.segments));
            % mark begining of segment
            data.dBOD(data.segments)       = double(ftell(fid));
            % advance file pointer to end of segment
            fprintf(flog,'Skiping to next segment.\n');
            tic;
            fseek(fid, data.DataPoints(data.segments) * header.ChannelCount * 2, 'cof');
            fprintf(flog,'Done. %.1f secs\n',toc);
            % mark end of segment
            data.dEOD(data.segments)       = double(ftell(fid));
        end
        fprintf(flog,'------------------------\nFound %02d data segment(s)\n',data.segments);
end

% remove all blank segments
if length(data.DataPoints) > 1 && all(data.TimeStamps(1:2) == [0,0])
    data.DataPoints(1) = [];
    data.Timestamps(1) = [];
    data.dBOD(1) = [];
    data.dEOD(1) = [];
    data.segments = data.segments - 1;
end

%

if exist('channel','var') && isa(channel,'numeric')
    fprintf(flog,'-READING-DATA-PACKETS------------\n');
    for ii=1:data.segments
        % for each segment
        % go to beginning of segment
        fseek(fid,data.dBOD(ii),'bof');
        % get data
        if (channel==129)
            fseek(fid,2*(97-1),'bof');
            data.raw{ii} = fread(fid,data.DataPoints(ii),'*int16',2*97-2)';
        elseif (channel<=96)
            fseek(fid,2*(channel-1),'cof');
            data.raw{ii} = fread(fid,data.DataPoints(ii),'*int16',2*header.ChannelCount-2)';
        end
        fprintf(flog,'---------------------------------\n');
    end
else
    fprintf(flog,'-READING-DATA-PACKETS------------\n');
    for ii=1:data.segments
        % for each segment
        % go to beginning of segment
        fseek(fid,data.dBOD(ii),'bof');
        % get data
        
        % # of 16 bit words
        n16points = mod(data.DataPoints(ii)*header.ChannelCount,4);
        % # of 64 bit words
        n64points = (data.DataPoints(ii)*header.ChannelCount - n16points)/4;
        fprintf(flog,'Reading data in 64bit words. n=%d\n',n64points);
        data.raw{ii} = fread(fid,n64points,'*int64');
        fprintf(flog,'Converting data to 16bit words.\n');
        data.raw{ii} = typecast(data.raw{ii},'int16');
        fprintf(flog,'Reading remain data as 16 bit words. n=%d\n',n16points);
        data.raw{ii} = cat(1,data.raw{ii},fread(fid,n16points,'*int16'));
        fprintf(flog,'Reshaping data to %dx%d.\n',header.ChannelCount,data.DataPoints(ii));
        data.raw{ii} = reshape(data.raw{ii},header.ChannelCount,data.DataPoints(ii));
        
        fprintf(flog,'---------------------------------\n');
    end
end
% close file
fclose(fid);


if (~strcmpi(char(header.ExtendedHeader((1:2)))', 'CC'))
    frintf(flog,'Extended header not supported. Skipping.\n');
else
    fprintf(flog,'Parsing Extended Header.\n');
    for curchannel = 1: header.ChannelCount
        offset = double((curchannel-1)*66);
        header.ElectrodesInfo(curchannel).ElectrodeID       = typecast(header.ExtendedHeader((3:4)+offset), 'uint16');
        header.ElectrodesInfo(curchannel).ConnectorBank     = char(header.ExtendedHeader(21+offset) + ('A' - 1));
        header.ElectrodesInfo(curchannel).ConnectorPin      = header.ExtendedHeader(22+offset);
        header.ElectrodesInfo(curchannel).DigitalFactor     = int16(1000*double(typecast(header.ExtendedHeader((29:30)+offset), 'int16'))/double(typecast(header.ExtendedHeader((25:26)+offset), 'int16')));
        header.ElectrodesInfo(curchannel).EnergyThreshold   = 0;
        header.ElectrodesInfo(curchannel).HighThreshold     = 0;
        header.ElectrodesInfo(curchannel).LowThreshold      = 0;
        
        header.ElectrodesInfo(curchannel).Units             = 0;
        header.ElectrodesInfo(curchannel).WaveformBytes     = 2;
        header.ElectrodesInfo(curchannel).ElectrodeLabel	= char(header.ExtendedHeader((5:20)+offset));
        
        if strcmp(header.SamplingLabel,'raw')
            header.ElectrodesInfo(curchannel).HighFreqCorner    = 300;
            header.ElectrodesInfo(curchannel).HighFreqOrder     = 1;
            header.ElectrodesInfo(curchannel).HighFilterType    = 1;
            header.ElectrodesInfo(curchannel).LowFreqCorner     = 7500000;
            header.ElectrodesInfo(curchannel).LowFreqOrder      = 3;
            header.ElectrodesInfo(curchannel).LowFilterType     = 1;
            
        else
            header.ElectrodesInfo(curchannel).HighFreqCorner = typecast(header.ExtendedHeader((47:50)+offset), 'uint32');
            header.ElectrodesInfo(curchannel).HighFreqOrder  = typecast(header.ExtendedHeader((51:54)+offset), 'uint32');
            header.ElectrodesInfo(curchannel).HighFilterType = typecast(header.ExtendedHeader((55:56)+offset), 'uint16');
            header.ElectrodesInfo(curchannel).LowFreqCorner  = typecast(header.ExtendedHeader((57:60)+offset), 'uint32');
            header.ElectrodesInfo(curchannel).LowFreqOrder   = typecast(header.ExtendedHeader((61:64)+offset), 'uint32');
            header.ElectrodesInfo(curchannel).LowFilterType  = typecast(header.ExtendedHeader((65:66)+offset), 'uint16');
        end
    end
end

fprintf(flog,'Total Time: %.1f s\n',toc(bb));
fclose(flog);