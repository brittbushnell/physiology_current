function [name, rf, rad, mod, ori, sf] = parseRFName(filename)
% PARSERFNAME is a function that takes in the Radial Frequency filename and
% returns the relevant stimulus information for analysis.
%
% Created by Brittany Bushnell May 24, 2017


% pathChunks = strsplit(filename, '/');
% name = char(pathChunks{end});

name = char(filename);

% example filename: RF4_RAD2.0_MOD200.00_ORI0_SF1.png

if contains(filename,'blank')
    % arbitrarially setting all values to something crazy high so when
    % all possible values are ordered, the blank is always the last one.
    rf  = 10000;
    mod = 10000;
    ori = 10000;
    sf  = 100;
    rad = 100;
    
elseif contains(filename,'Circle')
    chunks = sscanf(name, 'Circle_RAD%f_SF%d.png');
    
    % for circles, all of the values that are actually 0, are set to double
    % the maximum value that's changed so the circle response will appear
    % at the far R of all plots.
    rf  = 32;
    rad = chunks(1);
    mod = 400;
    ori = 720;
    sf  = chunks(2);
    
else
    chunks = sscanf(name, 'RF%d_RAD%f_MOD%f_ORI%f_SF%d.png');
    rf  = chunks(1);
    rad = chunks(2);
    mod = chunks(3);
    ori = chunks(4);
    sf  = chunks(5);
end
