function [family,sample,texture] = parseTextName(path)
%
% PARSETEXTNAME reads in the filename of a texture image, and returns the
% relevant information regarding what the texture was.
%
% OUTPUT
% IMAGE is the image number (ex 99)
% SAMPLE is the sample number
% TEXTURE is a boolean response: 1 if the image was a texture, 0 if it was
% a noise image

fileChunks = strsplit(path,'/');
filename   = char(fileChunks(end));

if strfind(path,'diskfade')
    family   = -1;
    sample  = -1;
    texture = -1;
    
elseif strfind(path,'blank')
    family   = 0;
    sample  = 0;
    texture = 0;
    
else
    %if texture
    if strfind(filename,'t-')
        chunk  = sscanf(filename, 't-im%d-smp%d.png');
        family   = chunk(1);
        sample  = chunk(2);
        texture = 1;
    elseif strfind(filename,'n-')
        chunk  = sscanf(filename, 'n-im%d-smp%d.png');
        family   = chunk(1);
        sample  = chunk(2);
        texture = 0;
    end
end

