function [type] = parseMapNoiseName (path)

% INPUT
%   PATH: file name with full path from data.filename
%
% OUTPUT
%  type: stimulus or blank
%     0: blank
%     1: stimulus
% Written June 12, 2020 Brittany Bushnell


pathChunks = strsplit(path,'/');
name   = char(pathChunks(end));

if contains(name,'diskfade')
    type = -1;
    
elseif contains(name,'blank')
    type = 0;
else
    type = 1;
end