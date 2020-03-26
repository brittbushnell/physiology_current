function [id] = parsePasupathyName (path)
% Example filename: S1_A0
% INPUT
%   PATH: stimulus name from data.stimName
%
% OUTPUT
%  ID: stimulus ID# ex:s1, s2, etc
%  the number after the A is always 0, and therefore meaningless
%
% Written August 24, 2017 Brittany Bushnell



path2 = char(path);

if strfind(path2,'diskfade') 
    id = -1;
    
elseif strfind(path2,'blank')
    id = 100;
    
    % Example filename: 'S1_A0'
else
    chunks = sscanf(path2, 'S%d_A%d.png');
    id = chunks(1);
end
