clear all
close all
clc
tic
%%
files = {

%     'WU_RE_GlassTR_nsp2_20170828_all_raw_2kFixPerm';...
%     'WU_LE_GlassTR_nsp2_20170825_002_raw_2kFixPerm';...
    %
%     'WU_RE_GlassTR_nsp1_20170828_all_raw_2kFixPerm';...
%     'WU_LE_GlassTR_nsp1_20170825_002_raw_2kFixPerm';...
%     
%     
%     'XT_RE_GlassTR_nsp2_20190128_all_s1_2kFixPerm';...
%     'XT_LE_GlassTR_nsp2_20190130_all_s1_2kFixPerm';...
    
%     'XT_RE_GlassTR_nsp1_20190128_all_s1_2kFixPerm1';...
%     'XT_LE_GlassTR_nsp1_20190130_all_s1_2kFixPerm1';...
    
%     'WV_RE_GlassTRCoh_nsp2_20190410_all_s1_2kFixPerm';...
%     'WV_LE_glassTRCoh_nsp2_20190416_all_s1_2kFixPerm';...
%     
%     'WV_RE_GlassTRCoh_nsp1_20190410_all_s1_2kFixPerm';...
%     'WV_LE_glassTRCoh_nsp1_20190416_all_s1_2kFixPerm';...
% 
% 
%     'WU_RE_GlassTR_nsp1_20170828_all_raw_2kFixPerm';...
%     'WU_LE_GlassTR_nsp1_20170825_002_raw_2kFixPerm';...
%     
%     %'WV_RE_GlassTRCoh_nsp2_20190410_all_s1_2kFixPerm';...
%     %'WV_LE_glassTRCoh_nsp2_20190416_all_s1_2kFixPerm';...
%     'WV_RE_GlassTRCoh_nsp1_20190410_all_s1_2kFixPerm';...
%     'WV_LE_glassTRCoh_nsp1_20190416_all_s1_2kFixPerm';...
    
%     'XT_RE_GlassTR_nsp2_20190128_all_s1_2kFixPerm';...
%     'XT_LE_GlassTR_nsp2_20190130_all_s1_2kFixPerm';...
%     'XT_RE_GlassTR_nsp1_20190128_all_s1_2kFixPerm';...
%     'XT_LE_GlassTR_nsp1_20190130_all_s1_2kFixPerm';...
'WU_LE_GlassTR_nsp2_20170825_002_thresh35_vers2_2kFixPerm'
    };
%%
%files = {
    %'WU_LE_GlassTR_nsp2_20170825_002_thresh30_vers2_2kFixPerm';
%     'WU_LE_GlassTR_nsp2_20170825_002_thresh35_vers2_2kFixPerm';
%     'WU_LE_GlassTR_nsp2_20170825_002_thresh40_vers2_2kFixPerm';
%     'WU_LE_GlassTR_nsp2_20170825_002_thresh45_vers2_2kFixPerm';  
%};

nameEnd = 'OSI_pOriBestParam';
%%
numPerm = 2000;
numBoot = 200;
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
    dataT = glassTR_getOriSelectivity2thetaNoise(dataT,numBoot,holdout);
    dataT = glassTR_getOriSelectivity2thetaNoisePermutations(dataT,numPerm,holdout);
    fprintf('computed orientation statistics %.2f minutes \n',toc/60)
    %% run perumtation test for OSI
    fprintf('selectivity computed in %d mins\n',toc/60)
    
    [dataT.OSI2thetaNoisePval,dataT.OSI2thetaNoiseSig] = glassGetPermutationStats_1tail...
        (dataT.OriSelectIndex2thetaNoise,dataT.OriSelectIndex2thetaNoisePerm,...
        dataT,'translational OSI permutations no subtraction',0);
    
    fprintf('computed OSI permutation tests %.2f minutes \n',toc/60)
    %% get the preferred orientation for the preferred stimulus (density, dx)
    dataT = GlassTR_bestSumDOris(dataT);
    [dataT.rfQuadrant, dataT.quadOris] = getOrisInRFs(dataT);
    %%
    %plotGlassTR_tuningCurvesPolarNoise(dataT)
    %plotGlassTR_tuningCurvesPolarArray(dataT)
    %dataT = plotGlassTR_polarWithSpikeCounts(dataT);
    %[dataT] = plotGlassTR_polarWithSpikeCounts_thresh(dataT);
   % plotGlassTR_PolarTuning_errorBar(dataT)
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

