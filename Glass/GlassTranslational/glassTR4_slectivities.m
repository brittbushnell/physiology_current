clear
close all
clc
tic
%%
files = {
    'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info_goodRuns_stimPerm';
    'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info_goodRuns_stimPerm';
    'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info_goodRuns_stimPerm';
    'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info_goodRuns_stimPerm';
    
    'XT_RE_GlassTRCoh_nsp2_March2019_all_cleaned35_info_goodRuns_stimPerm';
    'XT_RE_GlassTRCoh_nsp1_March2019_all_thresh35_info_goodRuns_stimPerm';
    'XT_LE_GlassTRCoh_nsp1_20190325_005_thresh35_ogcorrupt_info_goodRuns_stimPerm';
    'XT_LE_GlassTRCoh_nsp2_20190325_005_thresh35_info_goodRuns_stimPerm';
    
    'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info_goodRuns_stimPerm';
    'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info_goodRuns_stimPerm';
    'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info_goodRuns_stimPerm';
    'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info_goodRuns_stimPerm';
    };

nameEnd = 'OSI';
%%
numPerm = 2000;
numBoot = 200;
failNdx = 1;
holdout = 0.9;
plotFlag = 1;
%%
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
    [dataT.prefOri, dataT.OSI] = glassTR_getOriSelectivity_zScore(dataT,numBoot,holdout);
    [dataT.prefOriPerm, dataT.OSIperm, dataT.prefOriPermBoot, dataT.SIpermBoot] = glassTR_getOriSelectivityPerm_zScore(dataT,numBoot,holdout);
    fprintf('computed orientation statistics %.2f minutes \n',toc/60)
    %% run perumtation test for OSI
    
    [dataT.OSIPval,dataT.OSISig] = glassGetPermutationStats_1tail(dataT.OSI, dataT.OSIperm, dataT,'translational OSI permutations',0);
    
    fprintf('computed OSI permutation tests %.2f minutes \n',toc/60)
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
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GlassTR/dPrimePerm/',dataT.array);
    end
    
    if ~exist(outputDir, 'dir')
        mkdir(outputDir)
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

