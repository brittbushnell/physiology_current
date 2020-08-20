function [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff, con] = getMwksGratParameters(data)
% getMwksGratParameters 
% [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff, con] = getMwksGratParameters(data)
% This is a function that returns the unique stimulus parameters that were
% run during an Mwks grating experiment.
%
% Written Nov 9, 2017 Brittany Bushnell

    sfs   = unique(data.spatial_frequency);
    oris  = unique(data.rotation);
    width = unique(data.width); %do not call this size! size is already a function!!!
    xloc  = unique(data.xoffset);
    yloc  = unique(data.yoffset);
    numOris = size(oris,2);
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    
    if nargout == 9
        con = unique(data.contrast);
    end