function [type, numDots, dx, coh, sample] = parseGlassName (path)
% Example filename: C_N100_Dx0.01_Coh0.0_v1_Dsz4
% INPUT
%   PATH: file name with full path from data.filename   
%
% OUTPUT
%  type: numeric versions of the first letter of the pattern type
%     0:  noise
%     1: concentric
%     2: radial
%     3: translational
%     100:blank
%
% numDots: number of dots in pattern
% dx: dx
% coh: Percent of coherent dots
% sample: sample # of same parameters
% dsz: dot size in pixels
%
% Written August 24, 2017 Brittany Bushnell
%
% edited 7/8/2020 to automatically detect if the full path needs to be
% removed or not.  

% path = 'crapper/C_N100_Dx0.01_Coh0.0_v1_Dsz4.png'; %example name for
% testing
% 
if contains(path,'/')
    % WU's files were parsed differently.
    pathChunks = strsplit(path,'/');
    name   = char(pathChunks(end));
else
    name = cell2mat(path);
end


if contains(name,'diskfade')
    type    = -1;
    numDots = -1;
    dx      = -1;
    coh     = -1;
    sample  = -1;
    
elseif contains(name,'blank')
    type    = 100;
    numDots = 0;
    dx      = 100;
    coh     = 100;
    sample  = 0;

    % Example filename: 'C_N100_Dx0.01_Coh0.0_v1_Dsz4.png'
    
else
    chunks = sscanf(name, '%1c_N%d_Dx%f_Coh%f_v%d_Dsz%d.png');
    
    if chunks(4) == 0 % noise = 0 coherence
        type = 0;
    elseif contains(name,'C_')
        type = 1;
    elseif contains(name,'R_')
        type = 2;
    elseif contains(name,'T_')
        type = 3;
    end
  
    numDots = chunks(2);
    dx      = chunks(3);
    coh     = chunks(4);
    sample  = chunks(5);
    
   % fprintf('\n %s\n  %d  %d %.2f  %.2f %d\n', name,type,numDots,dx,coh,sample)
end