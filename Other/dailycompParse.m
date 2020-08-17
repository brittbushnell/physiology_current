clear all
close all
clc
tic
%%

files = {
%     'WV_LE_MapNoise_nsp2_20190122_003';     
%     'XT_LE_mapNoiseRight_nsp2_20181105_003';
%     'XT_LE_mapNoiseRight_nsp2_20181105_004';
%     'XT_LE_mapNoiseRight_nsp2_20181120_001';
%     'XT_LE_mapNoiseRight_nsp2_20181120_002';
%     'XT_LE_mapNoiseRight_nsp2_20181120_003';
%     'XT_LE_mapNoiseRight_nsp2_20181127_001';
%     'XT_RE_mapNoiseLeft_nsp2_20181026_001' ;
%     'XT_RE_mapNoiseRight_nsp2_20181026_003';
%     'XT_RE_mapNoiseRight_nsp2_20181119_001';

 'XT_LE_mapNoiseRight_nsp2_20181127_001'
 };

%%
failedFiles = {};
ndx = 1;
for fi = 1:length(files)
    try
        filename = string(files{fi});
        if contains(filename,'XT')
            animal = 'XT';
        else
            animal = 'WV';
        end
        inputDir = sprintf('/users/bushnell/Desktop/my_vnlstorage/bushnell_arrays/nsp2/nsp2_blackrock/%s/',animal);
        %inputDir = sprintf('/users/bushnell/Desktop/my_zemina/vnlstorage3/bushnell_arrays/%s/reThreshold/%s/%s/%s/',array,stimType,animal,eye);
        outputDir = sprintf('/users/bushnell/Desktop/my_zemina_home/binned_dir/%s',animal);
        
        fprintf('*** analyzing %s file %d/%d ****\n',filename,fi,size(files,2));
        if ~exist(sprintf('%s/%s',outputDir,strrep(filename,'.mat','')),'file')
            MworksNevParser1(filename,10,100,outputDir);
        end
%         toc/3600;
    catch ME
        fprintf('\n\n%s failed %s\n\n',filename,ME.message);
        failedFiles{ndx} = filename;
        ndx = ndx+1;
    end
end