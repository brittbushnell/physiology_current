function [numEl, ori, sample, modifier] = parseCIName_reg(path)
% INPUT
%   PATH: file name with full path from data.filename
%
% OUTPUT
%  NUMEL: number of elements in the line segment (0, 1, 3, 4, 5,or 7)
%  ORI: Orientation of the line element
%  SAMPLE: there are 15 samples (exemplars) of each stimulus.
%  MODIFIER:
%    0: Standard line in noise
%    1: Line only
%    2: Line only, wide spacing (applicable only to 3 and 4 element lines)
%    3: Wide spaced line in noise
%    4: blank screen
%    200: everything 200 means it was a noise stimulus
%
% Example CI filename:  Cont4LW_0Deg_S1
%               - 4 elements in line
%               - wide spacing
%               - 0 deg orientation
%               - sample #1
%
%  written August 21, 2017 Brittany N Bushnell


pathChunks = strsplit(path,'/');
name   = char(pathChunks(end));

if contains(name,'diskfade')
    numEl    = -1;
    ori      = -1;
    sample   = -1;
    modifier = -1;
    
elseif contains(name,'blank')                                               % blank (mean gray luminance)
    numEl    = NaN;
    ori      = NaN;
    sample   = NaN;
    modifier = 4;
    
elseif contains(name,'Cont0')                                               % all noise
    numEl    = NaN;
    ori      = NaN;
    sample   = NaN;
    modifier = 200;
    
else
    if contains(name,'LW_')                                                 % Line only, wide spacing
        chunks = sscanf(name, 'Cont%d%c%c_%dDeg_S%d.png');
        numEl    = chunks(1);
        ori      = chunks(4);
        sample   = NaN; % note, while there is a 'seed' listed, the actual bg is blank
        modifier  = 2;
        
    elseif contains(name,'3W_') || contains(name,'4W_')
        chunks = sscanf(name, 'Cont%d%c_%dDeg_S%d.png');                   % Line + noise, wide spacing
        numEl    = chunks(1);
        ori      = chunks(3);
        sample   = chunks(4);
        modifier = 3;
        
    elseif contains(name,'L_')                                              % line only
        chunks = sscanf(name, 'Cont%d%c_%dDeg.png');
        numEl    = chunks(1);
        ori      = chunks(3);
        sample   = 1;
        modifier = 1;
        
    else                                                                   % line + noise
        chunks = sscanf(name, 'Cont%d_%dDeg_S%d.png');
        numEl    = chunks(1);
        ori      = chunks(2);
        sample   = chunks(3);
        modifier  = 0;
    end
end
