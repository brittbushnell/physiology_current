
%%
clear
close all
clc
clear
tic
%%
files = {
    'WU_LE_GratingsCon_nsp1_20170809_002_thresh35';
% 'WU_RE_GratingsCon_nsp1_20170809_003_thresh35';
% 'WU_LE_GratingsCon_nsp1_20170811_003_thresh35';
% 'WU_RE_GratingsCon_nsp1_20170809_003_thresh35';
% 'WU_RE_GratingsCon_nsp1_20170811_001_thresh35';
% 'WU_RE_GratingsCon_nsp1_20170811_002_thresh35';
    };
%%
stimType = 'gratings'; %'png'

%%
failNdx = 0;
for fi = 1:length(files)
    % try
        filename = string(files{fi});
        
        fileInfo = strsplit(filename,'_');
        
        inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
        
        if contains(stimType,'png')
            if contains(filename,'map','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            elseif contains(filename,'glass','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Glass/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            elseif contains(filename,'freq','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/RadialFrequency/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            elseif contains(filename,'tex','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Textures/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            elseif contains(filename,'Pasupathy','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Pasupathy/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            elseif contains(filename,'edge','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Edge/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            else
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            end
        else
            if contains (filename,'map','IgnoreCase',true)
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            else
                outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Gratings/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
            end
        end
        
        fprintf('*** analyzing %s file %d/%d ****\n',filename,fi, length(files));
        if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.mat','')),'file')
            if contains(filename,'__')
                continue
            else
                MworksNevParser1(filename,10,100,outputDir);
            end
        end
        toc/3600;
        
%     catch ME
%         failNdx = failNdx+1;
%         failedFiles{failNdx} = ME;
%         fprintf('%s failed\n\n',filename)
%     end 
end
