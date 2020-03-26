function [numEl, ori, sample, modifier] = parseCIName(path)
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
nameChunks = strsplit(name,'_');

if contains(name,'diskfade')
    numEl    = -1;
    ori      = -1;
    sample   = -1;
    modifier = -1;
    
elseif contains(name,'blank')                                               % blank (mean gray luminance)
    numEl    = -1;
    ori      = -1;
    sample   = -1;
    modifier = 4;
    
elseif contains(name,'Cont0')                                               % all noise
    numEl    = 0;
    ori      = -1;
    sample   = 1;
    modifier = 200;
    
else
    if contains(name,'LW_') || contains(name,'WL')                          % Line only, wide spacing
        if contains(name,'cont')
            chunks = sscanf(name, 'cont%d%c%c_%dDeg_S%d.png');
        else
            chunks = sscanf(name, 'Cont%d%c%c_%dDeg_S%d.png');
        end
        numEl    = chunks(1);
        ori      = chunks(4);
        sample   = 1; % note, while there is a 'seed' listed, the actual bg is blank
        modifier  = 2;
        
    elseif contains(name,'3W_') || contains(name,'4W_')
        if contains(name,'cont')
            chunks = sscanf(name, 'cont%d%c_%dDeg_S%d.png');
        else
            chunks = sscanf(name, 'Cont%d%c_%dDeg_S%d.png');                   % Line + noise, wide spacing
        end
        numEl    = chunks(1);
        ori      = chunks(3);
        sample   = chunks(4);
        modifier = 3;
        
    elseif contains(name,'L_')                                                % line only
        if contains(name,'cont')
            chunks = sscanf(name, 'cont%d%c_%dDeg.png');
        else
            chunks = sscanf(name, 'Cont%d%c_%dDeg.png');
        end
        numEl    = chunks(1);
        ori      = chunks(3);
        sample   = 1;
        modifier = 1;
    elseif size(nameChunks,2) == 2
        if contains(name,'cont')
            chunks = sscanf(name, 'cont%d_%dDeg.png');
        else
            chunks = sscanf(name, 'Cont%d_%dDeg.png');
        end
        numEl    = chunks(1);
        ori      = chunks(2);
        sample   = 1;
        modifier = 1;
        
    else                                                                   % line + noise
        if contains(name,'cont')
            chunks = sscanf(name, 'cont%d_%dDeg_S%d.png');
        else
            chunks = sscanf(name, 'Cont%d_%dDeg_S%d.png');
        end
        if length(chunks) >2
            numEl    = chunks(1);
            ori      = chunks(2);
            sample   = chunks(3);
        else
            numEl    = chunks(1);
            ori      = chunks(2);
            sample   = 1;
        end
        modifier  = 0;
        
    end
end
