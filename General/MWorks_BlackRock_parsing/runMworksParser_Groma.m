
%%
clear
close all
clc
clear
tic
%%
files = {
%     'XT_LE_gratings_nsp1_20181027_003_thresh35'
%     'XT_LE_gratings_nsp1_20181107_004_thresh35'
%     'XT_LE_gratings_nsp1_20181206_001_thresh35'
%      'XT_LE_gratings_nsp1_20181210_001_thresh35'
%     'XT_LE_gratings_nsp1_20181212_001_thresh35'
%     'XT_LE_gratings_nsp1_20181213_003_thresh35'
%     'XT_LE_gratings_nsp1_20181213_004_thresh35'
%     'XT_RE_Gratings_nsp1_20190122_002_thresh35'
%     'XT_RE_Gratings_nsp1_20190131_003_thresh35'
%     'XT_RE_gratings_nsp1_20181028_003_thresh35'
%     'XT_RE_gratings_nsp1_20181107_005_thresh35'
%     'XT_RE_gratings_nsp1_20181129_003_thresh35'
%     'XT_LE_Gratings_nsp1_20190131_002_thresh35'
    
%     'XT_LE_Gratings_nsp2_20190131_002_thresh35'
%     'XT_LE_gratings_nsp2_20181027_003_thresh35'
%     'XT_LE_gratings_nsp2_20181107_004_thresh35'
%     'XT_LE_gratings_nsp2_20181206_001_thresh35'
%     'XT_LE_gratings_nsp2_20181210_001_thresh35'
%     'XT_LE_gratings_nsp2_20181212_001_thresh35'
%     'XT_LE_gratings_nsp2_20181213_003_thresh35'
%     'XT_LE_gratings_nsp2_20181213_004_thresh35'
%     'XT_RE_Gratings_nsp2_20190122_002_thresh35'
%     'XT_RE_Gratings_nsp2_20190131_003_thresh35'
%     'XT_RE_gratings_nsp2_20181028_003_thresh35'
%     'XT_RE_gratings_nsp2_20181107_005_thresh35'
%     'XT_RE_gratings_nsp2_20181129_003_thresh35'
'XT_LE_gratings_nsp2_20181107_004_thresh30'
};
%%
stimType = 'gratings'; %'png';

%%
failNdx = 0;
for fi = 1:length(files)
    try
        filename = string(files{fi});
        
        fileInfo = strsplit(filename,'_');
        
        input = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s/', fileInfo(1), fileInfo(4), fileInfo(2));


        if contains(filename,'grating','IgnoreCase',true)
            outputDir = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/parsed/',fileInfo(1), fileInfo(4));
        else
        end
        
        fprintf('\n*** analyzing %s file %d/%d ****\n',filename,fi, length(files));
        if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.mat','')),'file')
            if contains(filename,'__')
                continue
            else
                MworksNevParserGroma(filename,10,100,outputDir);
            end
        end
        toc/3600;
        
    catch ME
        failNdx = failNdx+1;
        failedFiles{failNdx} = ME;
        fprintf('%s failed\n\n',filename)
    end 
end
