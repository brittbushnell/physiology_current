clc
clear all
close all
%%
% addpath(genpath('~/Desktop/my_vnlstorage/bushnell_arrays/'))
% addpath(genpath('~/Desktop/my_zemina/vnlstorage2/'));
% addpath(genpath('~/Desktop/my_zemina/vnlstorage3/'));
% addpath(genpath('/v/awake/'));
%%
animal = 'WU';
array = 'nsp2';

inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/',array,animal);
outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/parsed',array,animal);

%%
cd(inputDir);
tmp = dir;
ndx = 1;
for t = 1:size(tmp,1)
    if contains(tmp(t).name,'nev')
        files{ndx} = tmp(t).name;
        ndx = ndx+1;
    end
end
%%
failedFiles = [];
ndx = 1;
for fi = 1:size(files,2)
%    try
    filename = string(files{fi});
    if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.nev','')),'file')
        MworksNevParser(filename,'outputDir',outputDir)
    end
%     catch ME
%        fprintf('\n\n%s failed %s\n\n',filename,ME.message); 
%        failedFiles{ndx} = filename;
%        ndx = ndx+1;
%     end
end