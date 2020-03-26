function [animal,eye, program, array, date] = parseFileName(filename)
% PARSEFILENAME 
%[animal, program, array, date] = parseFileName(filename)
% This is a function that parses out the information contained in
% a filename.
%
% INPUT
%   FILENAME: the name of the .mat file you want to analyze
%     ex: WU_LE_Gratings_nsp2_withRF.mat or
%         WU_RE_Gratings_nsp2_20170705_001.mat
%  OUTPUT
%   ANIMAL: animal name
%   EYE: LE or RE
%   PROGRAM: Name of program the data was recorded from
%   ARRAY: Returned information will assume that V1 was recorded with NSP1
%   and V4 was recorded with NSP2
%   DATE: Whatever information is contained regarding when the file was
%   run, for above it would be 20170705 or withRF.
%
% Written Nov 5, 2017 Brittany Bushnell

chunks = strsplit(filename,'_');

animal = chunks{1};
eye = chunks{2};
program = chunks{3};
array = chunks{4};
date = chunks{5};

% convert array name to cortical area name.
if strfind(array,'nsp1') 
    array = 'V1';
elseif strfind(array,'V1')
    array = 'V1';
elseif strfind(array,'nsp2')
     array = 'V4';
elseif strfind(array,'V4')
    array = 'V4';
else
    error('parseFileName: cannot identify array name')
end