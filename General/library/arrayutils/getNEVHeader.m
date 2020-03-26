function header = getNEVHeader(filename)
% function header = getNEVHeader(filename)
%
% For a given NEV "filename", this function extracts 
% the full header and returns it as a stream of 
% unsigned 8 bit integers. 
%%
if ~exist('filename','var')
    filename = '/experiments/m643_array/recordings/nev/m643l1#014.nev';
elseif ~exist(filename,'file')
    error('utils:getNEVHeader','The file, "%s", does not exist.\n',filename);
end

if ~strcmpi(filename(end-2:end),'nev')
    error('utils:getNEVHeader','Please use a NEV file');
end

%open file
fid = fopen(filename,'r','ieee-le');

% check to make sure it's a NEV file.
fseek(fid,0,'bof');
filetype = fread(fid,8,'uint8=>char')';
if ~strcmpi(filetype,'neuralev')
    error('utils:getNEVHeader','The file is not a valid NEV file.');
end

% grab total header size (locate at the 13th-16th bytes as a 32bit number
fseek(fid,12,'bof');
TotalHeaderSize = fread(fid,1,'*uint32');

% grab the actual full header
fseek(fid,0,'bof');
header = fread(fid,TotalHeaderSize,'*uint8');

%close file
fclose(fid);
