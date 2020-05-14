clear all
close all
clc
tic
%%
files = {
    'WU_RE_GlassTR_nsp2_20170828_all_raw_2kFixPerm_OSI_prefOri';...
    'WU_LE_GlassTR_nsp2_20170825_002_raw_2kFixPerm_OSI_prefOri';...
    %
    'WU_RE_GlassTR_nsp1_20170828_all_raw_2kFixPerm_OSI_prefOri';...
    'WU_LE_GlassTR_nsp1_20170825_002_raw_2kFixPerm_OSI_prefOri';...
    };

nameEnd = 'PermTests';
%%
failNdx = 1;
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
    %% latency by orientation
    %             [dataT.linOnsetLatencyPvals,dataT.linOnsetLatencySig] = glassGetPermutationStats_coh...
    %                 (dataT.linBlankOnLat, dataT.linBlankOnLatBoot,dataT,'translational onset latency permutation test',plotFlag);
    %             [dataT.linOffsetLatencyPvals,dataT.linOnsetLatencySig] = glassGetPermutationStats_coh...
    %                 (dataT.linBlankOffLat, dataT.linBlankOffLatBoot,dataT,'translational offset latency permutation test',plotFlag);
    %
    %             [dataT.noiseOnsetLatencyPvals,dataT.noiseOnsetLatencySig] = glassGetPermutationStats...
    %                 (dataT.noiseBlankOnLat, dataT.noiseBlankOnLatBoot,dataT,'noise onset latency permutation test in translational',plotFlag);
    %             [dataT.noiseOffsetLatencyPval,dataT.noiseOnsetLatencySig] = glassGetPermutationStats...
    %                 (dataT.noiseBlankOffLat, dataT.noiseBlankOffLatBoot,dataT,'noise offset latency permutation test in translational',plotFlag);
    %
    %             fprintf('latency permutation tests done in %d mins\n',toc/60)
    %% latency permutation tests all stimuli combined
    %             [dataT.onLatPvalAllStim,dataT.onLatSigCh] = glass_PermTest_goodChVector...
    %                 (dataT.onsetLatencyAllStim,dataT.onLatBootAllStimPerm,dataT,'all stimuli onset latency permutation test',plotFlag);
    %             [dataT.offLatPvalAllStim,dataT.offLatSigCh] = glass_PermTest_goodChVector...
    %                 (dataT.offsetLatencyAllStim,dataT.offLatBootAllStimPerm,dataT,'all stimuli offset latency permutation test',plotFlag);
    %
    %             fprintf('all permutation tests done in %d mins\n',toc/60)
    %% permutation tests for OSI
    [dataT.OSI2thetaNoisePval,dataT.OSI2thetaNoiseSig] = glassGetPermutationStats_coh...
        (dataT.OriSelectIndex2thetaNoise,dataT.OriSelectIndex2thetaNoisePerm,dataT,'translational vs noise OSI using 2x theta permutation test',plotFlag);
    
%     [dataT.OSI4thetaNoisePval,dataT.OSI4thetaNoiseSig] = glassGetPermutationStats_coh...
%         (dataT.OriSelectIndex4thetaNoise,dataT.OriSelectIndex4thetaNoisePerm,dataT,'translational vs noise OSI using 4x theta permutation test',plotFlag);
    %% permutation tests for preferred orientation
%     [dataT.PrefOri2thetaNoisePval,dataT.PrefOri2thetaNoiseSig] = glassGetPermutationStats_coh...
%         (dataT.prefOri2thetaNoise,dataT.prefOri2thetaNoisePerm,dataT,'preferred orientation translational Glass using 2x theta permutation test',plotFlag);
%     
%     [dataT.OSI4thetaNoisePval,dataT.OSI4thetaNoiseSig] = glassGetPermutationStats_coh...
%         (dataT.prefOri4thetaNoise,dataT.prefOri4thetaNoisePerm,dataT,'preferred orientation translational Glass using 4x theta permutation test',plotFlag);
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

