
%%
clear all
close all
clc
clear
tic
%%
files = {
    'WU_RE_Glass_nsp1_20170818_002_thresh35'
    
    'XT_LE_Glass_nsp2_20190123_002_thresh35'
    
    'XT_RE_GlassCoh_nsp1_20190321_003_thresh35'
    
    'WV_LE_glassTRCohSmall_nsp2_20190430_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190430_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190430_003_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190501_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190501_002_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190502_001_thresh35'
    'WV_LE_glassTRCohSmall_nsp2_20190503_001_thresh35'
    
    'WV_RE_glassTRCohSmall_nsp2_20190503_002_thresh35'
    'WV_RE_glassTRCohSmall_nsp2_20190506_001_thresh35'
    'WV_RE_glassTRCohSmall_nsp2_20190506_002_thresh35'
    'WV_RE_glassTRCohSmall_nsp2_20190507_001_thresh35'
    'WV_RE_glassTRCohSmall_nsp2_20190508_001_thresh35'
    };
%%
stimType = 'png'; %'gratings';

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
