function [expoPath, expoFile] = getXMLFile(unitLabel, runNum, experiment)
% INPUTS
%   - unitLabel
%   - runNum
%   - experiment -- name of experiment file, ie, 'ori16',
%     'full_field_flash'
xmlDir = '/arc/2.4/p1/pep/';

animalID = unitLabel(1:4);
if animalID == 'm670'
    animalID = 'm670_V1V2';
elseif animalID == 'm667'
    animalID = 'm667_MT';
else
    animalID = [animalID '_V1'];
end

expoPath = [xmlDir animalID '/recordings/'];
addpath(expoPath);

expoFile = dir([expoPath '/' unitLabel '#' num2str(runNum) '[' experiment '*].xml']);
expoFile = expoFile(1).name;

