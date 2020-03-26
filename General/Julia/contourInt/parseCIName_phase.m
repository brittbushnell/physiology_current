function [numEl, phase, ori, sample, modifier] = parseCIName_phase(path)
% For contour integration experiments -- phase version, with varying phase
% gabors.
%
% INPUT
%   PATH: file name with full path from data.filename
%
% OUTPUT
%  NUMEL: number of elements in the line segment (0, 1, 3, 4, 5,or 7)
%         ---> note, phase exp only has one line length (7)
%  PHASE: phase alignment of the gabors.
%         - either 1 or 2
%         - 1 = "O"
%         - 2 = "E"
%  ORI: Orientation of the line element
%  SAMPLE: there are 15 samples (exemplars) of each stimulus.
%  MODIFIER:
%    0: Standard line in noise
%    1: Line only
%    2: (NOT IN PHASE EXP) Line only, wide spacing (applicable only to 3 and 4 element lines)
%    3: (NOT IN PHASE EXP) Wide spaced line in noise
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
%  modified for phase exp -- oct 5 2018, julia pai

pathChunks = strsplit(path,'/');
name   = char(pathChunks(end));

if contains(name,'diskfade')
    numEl    = -1;
    phase    = NaN;
    ori      = -1;
    sample   = -1;
    modifier = -1;
    
elseif contains(name,'blank')   % blank screen (mean gray luminance)
    numEl    = NaN;
    phase    = NaN;
    ori      = NaN;
    sample   = NaN;
    modifier = 4;
    
elseif contains(name,'Cont0')  % all noise (distractor gabors)
    chunks  = sscanf(name, 'Cont0%cP_s%d.bmp.png');
    numEl   = NaN;
    phase   = char(chunks(1));
    if phase == 'O'
        phase = 1;
    elseif phase == 'E'
        phase = 2;
    end
    ori      = NaN;
    sample   = chunks(2);
    modifier = 200;
     
else                                                    % stimuli with lines
    
    if contains(name,'LE')||contains(name,'LO')         % only line, no noise
        chunks = sscanf(name, 'Cont%dL%cP_%dDeg.bmp.png');
        numEl    = chunks(1);
        phase    = char(chunks(2));
        if phase == 'O'
            phase = 1;
        elseif phase == 'E'
            phase = 2;
        end
        ori      = chunks(3);
        sample   = NaN;
        modifier  = 1;
    else
        chunks = sscanf(name, 'Cont%d%cP_%dDeg_s%d.bmp.png'); % Line with noise
        numEl    = chunks(1);
        phase    = char(chunks(2));
        if phase == 'O'
            phase = 1;
        elseif phase == 'E'
            phase = 2;
        end
        ori      = chunks(3);
        sample   = chunks(4);
        modifier  = 0;
    end
end

end