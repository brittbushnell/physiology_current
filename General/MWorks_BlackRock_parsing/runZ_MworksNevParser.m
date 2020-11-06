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
monks = {
    % 'WU';
    'WV';
    %'XT';
    };
ez = {
    'LE';
    'RE';
    };
brArray = {
    %'nsp2';
    'nsp1';
    };
stimType = 'png';%'gratings'
%%

failNdx = 0;
for an = 1:length(monks)
    animal = monks{an};
    for ey = 1:length(ez)
        eye = ez{ey};
        for ar = 1:length(brArray)
            array = brArray{ar};
            %%
            inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/%s/',array,stimType,animal,eye);
            
            cd(inputDir);
            tmp = dir;
            ndx = 1;
            files = {};
            %%
            for t = 1:size(tmp,1)
                if contains(tmp(t).name,'thresh')
                    if ~contains(tmp(t).name,'bar','IgnoreCase',true) % ignore bar map files
                        files{ndx} = tmp(t).name;
                        ndx = ndx+1;
                    end
                end
            end
            clear tmp
            clear ndx
        end
    end
end

if contains(stimType,'grat','IgnoreCase',true)
    files(contains(files,'Contour','IgnoreCase',true)) = [];
end
%%
% files = {
%     'WU_LE_Gratmap_nsp1_20170428_004_thresh35'
%     };
% stimType = 'grat';
% array = 'nsp1';
% animal = 'WU';
% eye = 'LE';
%%
for fi = 1:length(files)
    try
        filename = string(files{fi});
        
        if contains(stimType,'png')
            if contains(filename,'map','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',array,stimType,animal,eye);
            elseif contains(filename,'glass','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Glass/%s/',array,stimType,animal,eye);
            elseif contains(filename,'freq','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/RadialFrequency/%s/',array,stimType,animal,eye);
            elseif contains(filename,'tex','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Textures/%s/',array,stimType,animal,eye);
            elseif contains(filename,'Pasupathy','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Pasupathy/%s/',array,stimType,animal,eye);
            elseif contains(filename,'edge','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Edge/%s/',array,stimType,animal,eye);
            else
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/%s/',array,stimType,animal,eye);
            end
        else
            if contains (filename,'map','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',array,stimType,animal,eye);
            else
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Gratings/%s/',array,stimType,animal,eye);
            end
        end
        
        fprintf('*** analyzing %s file %d/%d ****\n',filename,fi,size(files,2));
        %if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.mat','')),'file')
        if contains(filename,'__')
            continue
        else
            MworksNevParser1(filename,10,100,outputDir);
        end
        %end
        toc/3600;
        
    catch ME
        failNdx = failNdx+1;
        fprintf('\n\n%s failed %s\n\n',filename,ME.message);
        failedFiles{failNdx,1} = ME;
        
    end
end
%         end
%     end
% end
%end
fprintf('\n\n ***** %d FILES FAILED AT SOME POINT *****\n\n',failNdx)