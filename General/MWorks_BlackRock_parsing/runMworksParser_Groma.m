
%%
clear
close all
clc
clear
tic
%%
files = {
    'XT_LE_edgeCos_nsp1_20181106_001_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181106_002_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181127_003_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181127_004_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181127_005_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181129_004_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181129_005_thresh35_ogcorrupt';
    'XT_LE_edgeCos_nsp1_20181129_006_thresh35_ogcorrupt';
    'XT_RE_edgeCos_nsp1_20181128_001_thresh35_ogcorrupt';
    'XT_RE_edgeCos_nsp1_20181128_002_thresh35_ogcorrupt';
    'XT_RE_edgeCos_nsp1_20181128_004_thresh35_ogcorrupt';
    'XT_RE_edgeCos_nsp1_20181129_001_thresh35_ogcorrupt';
    'XT_RE_edgeCos_nsp1_20181129_002_thresh35_ogcorrupt';

    'XT_LE_edgeCos_nsp2_20181129_005_thresh35';
    'XT_LE_edgeCos_nsp2_20181129_006_thresh35';
    'XT_RE_edgeCos_nsp2_20181128_001_thresh35';
    'XT_RE_edgeCos_nsp2_20181128_002_thresh35';
    'XT_RE_edgeCos_nsp2_20181128_003_thresh35';
    'XT_RE_edgeCos_nsp2_20181128_004_thresh35';
    'XT_RE_edgeCos_nsp2_20181129_001_thresh35';
    'XT_RE_edgeCos_nsp2_20181129_002_thresh35';
};
%%
stimType = 'gratings'; %'png';

%%
failNdx = 0;
for fi = 1:length(files)
%     try
        filename = string(files{fi});
        
        fileInfo = strsplit(filename,'_');
        
        input = sprintf('/v/awake/%s/recordings/%sReThreshold/gratingsAndEdges/%s/', fileInfo(1), fileInfo(4), fileInfo(2));


        if contains(filename,'grating','IgnoreCase',true) || contains(filename,'edge','IgnoreCase',true)
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
        
%     catch ME
%         failNdx = failNdx+1;
%         failedFiles{failNdx} = ME.message;
%         fprintf('%s failed\n\n',filename)
%     end 
end
