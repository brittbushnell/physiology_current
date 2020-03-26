function output = decodeNEVHeader(header)

if ~isa(header,'uint8')
    error('util:decodeNEVHeader','The header is not an unsigned 8bit integer array');
end

output.FileTypeID    = char(header(1:8))';
output.FileSpec      = sprintf('%d.%d',header(9:10));
output.Flags         = dec2bin(typecast(header(11:12),'uint16'),16);
output.HeaderSize    = typecast(header(13:16),'uint32');
output.PacketSize    = typecast(header(17:20),'uint32');
output.TimeRes       = typecast(header(21:24),'uint32');
output.SampleRes     = typecast(header(25:28),'uint32');
output.TimeStampRaw  = typecast(header(29:44),'uint16'); % 7 items (Y,M,DoW,D,H,M,S)
output.TimeStamp      = datestr(datenum([output.TimeStampRaw([1 2 4:6]);output.TimeStampRaw(7)+output.TimeStampRaw(8)/1000]'),'dddd, mmmm dd, yyyy @ HH:MM:SS.FFF');
output.Application   = char(header(45:76))';
output.Comment       = char(header(77:77+find(header(77:332)==0,1,'first')-2));
if isempty(output.Comment)
    output.Comment = char(zeros(1,256));
end
output.nExtHeaders   = typecast(header(333:336),'uint32');