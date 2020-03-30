clear all
close all
clc
tic
%%
files = {
'WU_RE_GlassTR_nsp2_20170828_all_s1_perm2k';...
'WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k';...

'WU_RE_GlassTR_nsp1_20170828_all_s1_perm2k';...
'WU_LE_GlassTR_nsp1_20170825_002_s1_perm2k';...

% 'XT_RE_GlassTR_nsp2_20190125_all_s1_perm2k';...
% 'XT_RE_GlassTR_nsp2_20190128_all_s1_perm2k';...
% 'XT_LE_GlassTR_nsp2_20190130_all_s1_perm2k';...
% 
% 'XT_RE_GlassTR_nsp1_20190125_all_s1_perm2k';...
% 'XT_RE_GlassTR_nsp1_20190128_all_s1_perm2k';...
% 'XT_LE_GlassTR_nsp1_20190130_all_s1_perm2k';...

'XT_RE_GlassTRCoh_nsp2_20190322_all_s1_perm2k';...
'XT_RE_GlassTRCoh_nsp2_20190324_all_s1_perm2k';...
'XT_RE_GlassTRCoh_nsp1_20190322_all_s1_perm2k';...
'XT_RE_GlassTRCoh_nsp1_20190324_all_s1_perm2k';...

'WV_RE_GlassTRCoh_nsp2_20190409_all_s1_perm2k';...
'WV_RE_GlassTRCoh_nsp2_20190410_all_s1_perm2k';...

'WV_LE_GlassTRCoh_nsp2_20190415_all_s1_perm2k';...
'WV_LE_glassTRCoh_nsp2_20190416_all_s1_perm2k';...
'WV_LE_GlassTRCoh_nsp2_20190417_all_s1_perm2k';...

'WV_RE_GlassTRCoh_nsp1_20190409_all_s1_perm2k';...
'WV_RE_GlassTRCoh_nsp1_20190410_all_s1_perm2k';...

'WV_LE_GlassTRCoh_nsp1_20190415_all_s1_perm2k';...
'WV_LE_glassTRCoh_nsp1_20190416_all_s1_perm2k';...
'WV_LE_GlassTRCoh_nsp1_20190417_all_s1_perm2k';...
    };

nameEnd = 'OSIvsNoise2Only';
%%
numPerm = 200;
numBoot = 2000;
failNdx = 1;
holdout = 0.9;
plotFlag = 1;

for fi = 1:size(files,1)
    %try
    %% Get basic information about experiments
    
    load(files{fi});
    filename = files{fi};
    fprintf('\n** analyzing %s **\n', filename)
    fprintf('file %d/%d \n',fi,size(files,1))
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end    
    %% selectivity
    % compute selectivitie indices based on Smith et al., 2002
    dataT = glassTR_getOriSelectivity2thetaNoise(dataT,numBoot,numPerm,holdout); 
    fprintf('computed orientation statistics %.2f minutes \n',toc/60)
    %% run perumtation test for OSI
    fprintf('selectivity computed in %d mins\n',toc/60)
     [dataT.OSI2thetaNoisePval,dataT.OSI2thetaNoiseSig] = glassGetPermutationStats_coh...
        (dataT.OriSelectIndex2thetaNoise,dataT.OriSelectIndex2thetaNoisePerm,dataT,'translational vs noise OSI using 2x theta permutation test',plotFlag);
    fprintf('computed OSI permutation tests %.2f minutes \n',toc/60)
    %% permutation tests for preferred orientation
    [dataT.prefOri2thetaNoisePval,dataT.prefOri2thetaNoiseSig] = glassGetPermutationStats_coh...
        (mod(rad2deg(dataT.prefOri2thetaNoise),360),mod(rad2deg(dataT.prefOri2thetaNoisePerm),360),dataT,'preferred orientation translational Glass using 2x theta permutation test',plotFlag);
    fprintf('computed preferred orientation permutation tests %.2f minutes \n',toc/60)
    %%
    plotGlassTR_tuningCurvesPolarNoise(dataT)
    %% commit to data structure
    if contains(filename,'RE')
        data.RE = dataT;
    else
        data.LE = dataT;
    end
    %% save data
    location = determineComputer;
    if location == 1
        outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
    elseif location == 0
        outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
    end
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data','-v7.3');
    fprintf('%s saved\n', saveName)
    fprintf('all tests done in %d mins\n',toc/60)
    %%        %close all
    %     catch ME
    %         failedFile{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %         fprintf('xxxxxxxxxxx\n')
    %         fprintf('file failed \n')
    %         fprintf('%s \n',ME.identifier)
    %         fprintf('xxxxxxxxxxx\n')
    %     end
end

