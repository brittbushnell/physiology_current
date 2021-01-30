clear all
close all
clc
tic
%%
files = {
  'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info_goodRuns_stimPerm';
  'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info_goodRuns';
  'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info_goodRuns';
  'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info_goodRuns';
  
  'XT_RE_GlassTRCoh_nsp2_March2019_all_cleaned35_info_goodRuns';
  'XT_RE_GlassTRCoh_nsp1_March2019_all_thresh35_info_goodRuns';
  'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt_info_goodRuns';
  'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35_info_goodRuns';    
  
  'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info_goodRuns';
  'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info_goodRuns';
  'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info_goodRuns';
  'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info_goodRuns';
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
    %% save data
    
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GlassTR/dPrimePerm/',dataT.array);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GlassTR/dPrimePerm/',dataT.array);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
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

