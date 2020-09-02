function [oepPath oepADC] = getOepFile(unitLabel, runNum, experiment)
% Get the analog TTL data file -- in the folder of open ephys continuous
% files, this is the first file in the folder (named '100ADC1.continuous')
% INPUTS
%   - unitLabel
%   - runNum
%   - experiment -- name of experiment file, ie, 'ori16',
%     'full_field_flash'

oepDir = ['/Volumes/BIGZINGY/JuliaDATA/' experiment '/OpenEphys/'];
oepFolder = dir([oepDir unitLabel '#' num2str(runNum) '*' experiment '*']);
oepFolder = oepFolder(1).name;

oepPath = [oepDir oepFolder '/'];

oepADC = '100_ADC1.continuous';