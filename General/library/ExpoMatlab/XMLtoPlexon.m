function XMLtoPlexon(Filename,Swap)
%
% XMLtoPlexon(filename,swap)
%
% filename = XML file name
% swap     = 0 for little endian, 1 for big endian [default = 0]

%%
if ~exist('Filename','var')
    error('ExpoMatlab:XMLtoPlexon','A filename was not provided. See syntax');
end

if ~exist('Swap','var')
	Swap = 0;
end

if ~exist(Filename,'file')
    error('ExpoMatlab:XMLtoPlexon','The input file provided was not found');
end

fprintf('Parsing XML file...');
ExpoXMLimport = ReadExpoXML(Filename,1,1);
fprintf('\ndone.\n');

if isempty(ExpoXMLimport.waveforms)
    error('ExpoMatlab:XMLtoPlexon','The data did not contain any waveforms.');
end

Header      = Filename(1:end-4);
NChan       = ExpoXMLimport.waveforms.NumOfChannels;
Offset      = size(Header,2);
Freq        = ExpoXMLimport.waveforms.SampleRate;
Resolution  = ExpoXMLimport.waveforms.DataSize*8;
MaxMV       = 5000;
Data        = [];
midpoint    = (2.^Resolution)./2;


fprintf('Parsing and convertin data to signed 16 bit words...');
switch Resolution
    case 8
        Data = int16(double([ExpoXMLimport.waveforms.Data{:,1}])-midpoint);  % uint8 -> int8
    case 16 % assumes little endian
        temp = [ExpoXMLimport.waveforms.Data{:,1}];       % [uint8 h uint8 l]
        temp = temp(1:2:end-1,:).*256 + temp(2:2:end,:);  % [uint8 h uint8 l] -> [uint16]
        Data = int16(double(temp) - midpoint);            % [uint16] -> [int16].
        clear temp;
end
fprintf('done.\n');

fprintf('Writing continuous data stream file...');
fid = fopen([Filename(1:end-3) 'waveforms'],'w+');
fprintf(fid,'%s',Header);
fwrite(fid,Data,'int16');
fclose(fid);
fprintf('done.\n');

fprintf('Writing options file for Plexon...');
fid = fopen([Filename(1:end-3) 'ofi'],'w+');
fprintf(fid,'Freq=%.6f\r\n',Freq);
fprintf(fid,'MaxMV=%.6f\r\n',MaxMV);
fprintf(fid,'NChan=%d\r\n',NChan);
fprintf(fid,'Offset=%d\r\n',Offset);
fprintf(fid,'Resolution=%d\r\n',Resolution);
fprintf(fid,'Swap=%d\r\n',Swap);
fclose(fid);
fprintf('done.\n');


