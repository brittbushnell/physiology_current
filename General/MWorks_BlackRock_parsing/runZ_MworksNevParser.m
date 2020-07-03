clc
clear all
close all
tic;
%%
% addpath(genpath('~/Desktop/my_vnlstorage/bushnell_arrays/'))
% addpath(genpath('~/Desktop/my_zemina/vnlstorage2/'));
% addpath(genpath('~/Desktop/my_zemina/vnlstorage3/'));
% addpath(genpath('/v/awake/'));
addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/WU/')
addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/XT/')
addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/WV/')

addpath('~/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/WV/')
addpath('~/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/XT/')

addpath('~/Desktop/my_zemina/vnlstorage3/bushnell_arrays/nsp1/mworks/WV/')
%%
animal = 'WU';
array = 'nsp2';

inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/',array,animal);
%inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage/bushnell_arrays/%s/%s_blackrock/%s/',array,array,animal);
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
    fprintf('*** analyzing %s file %d/%d ****\n',filename,fi,size(files,2));
    if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.nev','')),'file')
        MworksNevParser(filename,10,100,outputDir);
    end
    toc/3600;
%     catch ME
%        fprintf('\n\n%s failed %s\n\n',filename,ME.message); 
%        failedFiles{ndx} = filename;
%        ndx = ndx+1;
%     end
end