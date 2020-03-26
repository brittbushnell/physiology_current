function [newName] = figTitleName(filename)

% This function takes in a filename with the standard naming convention and
% modifies it so it can be used for figure titles
%
% EX:
% original filename: WU_LE_Gratings_nsp1_20170809_001
% new title: WU FE Gratings V1/V2 20170809 001

newName = strrep(filename, '_', ' ');

if strfind(filename,'nsp1')
    newName = strrep(newName, 'nsp1', 'V1');
else
    newName = strrep(newName, 'nsp2', 'V4');
end

if ~contains(filename,'XT')
    if strfind(filename,'LE')
        newName = strrep(newName, 'LE', 'FE');
    elseif strfind(filename,'RE')
        newName = strrep(newName, 'RE', 'AE');
    elseif strfind(filename,'BE')
        newName = strrep(newName, 'BE', 'Binoc');
    end
end