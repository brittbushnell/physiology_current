clc
clear all
close all
tic;
%%
% addpath(genpath('~/Desktop/my_vnlstorage/bushnell_arrays/'))
% addpath(genpath('~/Desktop/my_zemina/vnlstorage2/'));
% addpath(genpath('~/Desktop/my_zemina/vnlstorage3/'));
% addpath(genpath('/v/awake/'));
% addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/WU/')
% addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/XT/')
% addpath('~/Desktop/my_vnlstorage/bushnell_arrays/nsp1/mworks/WV/')
%
% addpath('~/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/WV/')
% addpath('~/Desktop/my_zemina/vnlstorage2/bushnell_arrays/nsp1/mworks/XT/')
%
% addpath('~/Desktop/my_zemina/vnlstorage3/bushnell_arrays/nsp1/mworks/WV/')
%%
%animal = 'WU';
%stimType = 'png';
%stimType = 'grat';
%% figure out what you're running
for mk = 1:3
    if mk == 1
        animal = 'WU';
    elseif mk == 2
        animal = 'WV';
    else
        animal = 'XT';
    end
    for st = 1:2
        if st == 1
            stimType = 'png';
        else
            stimType = 'gratings';
        end
        for ar = 1:2
            if ar == 1
                array = 'nsp2';
            else
                array = 'nsp1';
            end
            for ey = 1:2
                if ey == 1
                    eye = 'RE';
                else
                    eye = 'LE';
                end
                %%
                inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/%s/',array,stimType,animal,eye);
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/',array,stimType,animal);
                
                %%
                cd(inputDir);
                tmp = dir;
                ndx = 1;
                files = {};
                for t = 1:size(tmp,1)
                    if contains(tmp(t).name,'thresh')
                        files{ndx} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
                clear tmp
                clear ndx
                %%
                failedFiles = [];
                ndx = 1;
                for fi = 1:size(files,2)
                    try
                        filename = string(files{fi});
                        
                        fprintf('*** analyzing %s file %d/%d ****\n',filename,fi,size(files,2));
                        if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.mat','')),'file')
                            MworksNevParser1(filename,10,100,outputDir);
                        end
                        toc/3600;
                    catch ME
                        fprintf('\n\n%s failed %s\n\n',filename,ME.message);
                        failedFiles{ndx} = filename;
                        ndx = ndx+1;
                    end
                end
            end
        end
    end
end