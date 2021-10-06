
%%
clear
close all
clc
clear
tic
%%
files = {
    'XT_LE_gratings_nsp1_20181027_003_thresh35'
    'XT_LE_gratings_nsp1_20181107_004_thresh35'
    'XT_LE_gratings_nsp1_20181206_001_thresh35'
    'XT_LE_gratings_nsp1_20181210_001_thresh35'
    'XT_LE_gratings_nsp1_20181212_001_thresh35'
    'XT_LE_gratings_nsp1_20181213_003_thresh35'
    'XT_LE_gratings_nsp1_20181213_004_thresh35'
    'XT_RE_Gratings_nsp1_20190122_002_thresh35'
    'XT_RE_Gratings_nsp1_20190131_003_thresh35'
    'XT_RE_gratings_nsp1_20181028_003_thresh35'
    'XT_RE_gratings_nsp1_20181107_005_thresh35'
    'XT_RE_gratings_nsp1_20181129_003_thresh35'
    'XT_LE_Gratings_nsp1_20190131_002_thresh35'
    };
%%
stimType = 'gratings'; %'png';

%%
failNdx = 0;
for fi = 1:length(files)
    % try
        filename = string(files{fi});
        
        fileInfo = strsplit(filename,'_');
        
        output = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s', fileInfo(1), fileInfo(4), fileInfo(2));

%         if contains(stimType,'png')
%             if contains(filename,'map','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             elseif contains(filename,'glass','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Glass/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             elseif contains(filename,'freq','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/RadialFrequency/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             elseif contains(filename,'tex','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Textures/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             elseif contains(filename,'Pasupathy','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Pasupathy/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             elseif contains(filename,'edge','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Edge/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             else
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             end
%         else
%             if contains (filename,'map','IgnoreCase',true)
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Mapping/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             else
%                 outputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/parsed/Gratings/%s/',fileInfo(4),stimType,fileInfo(1),fileInfo(2));
%             end
%         end
        if contains(filename,'grating','IgnoreCase',true)
            outputDir = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/parsed/',fileInfo(1), fileInfo(4));
%             output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/gratings/%s/%s/%s',array,animal,eye,newName);
        else
%             output = sprintf('/mnt/vnlstorage3/bushnell_arrays/%s/reThreshold/png/%s/%s/%s',array,animal,eye,newName);
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
