function [a,b] = loadfiles(filename,varargin)
if ~exist('ReadExpoXML','file')
    addpath(genpath('/u/vnl/matlab/ExpoMatlab'));
end
if ~exist('ReadPlexon','file')
    addpath(genpath('/u/vnl/matlab/PlexonMatlab'));
end
fprintf('Loading Plexon File\n');
a =  ReadPlexon([filename '.plx'],varargin{:});
fprintf('Loading ExpoXML File\n');
b = ReadExpoXML([filename '.xml'],0,1);
fprintf('Done.\n');