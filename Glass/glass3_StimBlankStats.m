clear all
close all
clc
fprintf('running Glass3 statistics\n')
tic
%%
%%
%% V4
%files = {
%FE
%'WU_LE_Glass_nsp2_20170817_001_raw_perm2k';...
%         'WU_LE_Glass_nsp2_20170822_001_raw_perm2k';...       %6 reps
%         'WU_LE_Glass_nsp2_20170821_002_raw_perm2k';...       %4 reps

%AE
%        'WU_RE_Glass_nsp2_20170817_X02_raw_perm2k';...       %4 reps
%'WU_RE_Glass_nsp2_20170818_all_raw_perm2k';...

%    'WU_LE_Glass_nsp1_20170817_001_raw_perm2k';...
%     'WU_LE_Glass_nsp1_20170822_001_raw_perm2k';...       %6 reps
%     'WU_LE_Glass_nsp1_20170821_002_raw_perm2k';...       %4 reps

%AE
%    'WU_RE_Glass_nsp1_20170817_X02_raw_perm2k';...       %4 reps
%    'WU_RE_Glass_nsp1_20170818_001_raw_perm2k';...
%WV
%     %AE
%     'WV_RE_glassCoh_nsp2_20190405_001_raw_perm2k';...
%     'WV_RE_glassCoh_nsp2_20190404_all_raw_perm2k';...
%
%     %FE
%     'WV_LE_GlassCoh_nsp2_20190402_all_raw_perm2k';...
%     'WV_LE_glassCoh_nsp2_20190403_all_raw_perm2k';...
%
%     %FE smaller diameter stimulus
%     'WV_LE_glassCohSmall_nsp2_20190426_001_raw_perm2k';...  %9 reps
%     'WV_LE_glassCohSmall_nsp2_20190424_002_raw_perm2k';...  %4 reps
%     'WV_LE_glassCohSmall_nsp2_20190425_all_raw_perm2k';...
%
%     %AE smaller diameter stimulus
%     'WV_RE_glassCohSmall_nsp2_20190424_001_raw_perm2k';... %10 reps
%     'WV_RE_glassCohSmall_nsp2_20190423_all_raw_perm2k';...
%
%     %XT %%%
%     %RE
%     'XT_RE_GlassCoh_nsp2_20190321_all_raw_perm2k';...
%     'XT_RE_GlassCoh_nsp2_20190322_001_raw_perm2k';...  %6 reps
%     %LE
%     'XT_LE_GlassCoh_nsp2_20190324_005_raw_perm2k';...  %4 reps
%     'XT_LE_GlassCoh_nsp2_20190325_all_raw_perm2k';...
%
%     %RE high coh only
%     'XT_RE_Glass_nsp2_20190124_005_raw_perm2k';...   %15 reps
%     'XT_RE_Glass_nsp2_20190123_003_raw_perm2k';...  %4 reps
%     'XT_RE_Glass_nsp2_20190123_all_raw_perm2k';...
%
%     %LE high coh only
%     'XT_LE_Glass_nsp2_20190123_all_raw_perm2k';...
%     'XT_LE_Glass_nsp2_20190124_all_raw_perm2k';
%  };
%% V1
% files = {
% %FE
% 'WU_LE_Glass_nsp1_20170817_001_raw_perm2k';...
% 'WU_LE_Glass_nsp1_20170822_001_raw_perm2k';...       %6 reps
% 'WU_LE_Glass_nsp1_20170821_002_raw_perm2k';...       %4 reps
%
% %AE
% 'WU_RE_Glass_nsp1_20170817_X02_raw_perm2k';...       %4 reps
% 'WU_RE_Glass_nsp1_20170818_all_raw_perm2k';...
%
% %WV
% %AE
% 'WV_RE_glassCoh_nsp1_20190405_001_raw_perm2k';...
% 'WV_RE_glassCoh_nsp1_20190404_all_raw_perm2k';...
%
% %FE
% 'WV_LE_GlassCoh_nsp1_20190402_all_raw_perm2k';...
% 'WV_LE_glassCoh_nsp1_20190403_all_raw_perm2k';...
%
% %FE smaller diameter stimulus
% 'WV_LE_glassCohSmall_nsp1_20190426_001_raw_perm2k';...  %9 reps
% 'WV_LE_glassCohSmall_nsp1_20190424_002_raw_perm2k';...  %4 reps
% 'WV_LE_glassCohSmall_nsp1_20190425_all_raw_perm2k';...
%
% %AE smaller diameter stimulus
% 'WV_RE_glassCohSmall_nsp1_20190424_001_raw_perm2k';... %10 reps
% 'WV_RE_glassCohSmall_nsp1_20190423_all_raw_perm2k';...
%
% %XT %%%
% %RE
% 'XT_RE_GlassCoh_nsp1_20190321_all_raw_perm2k';...
% 'XT_RE_GlassCoh_nsp1_20190322_001_raw_perm2k';...  %6 reps
% %LE
% 'XT_LE_GlassCoh_nsp1_20190324_005_raw_perm2k';...  %4 reps
% 'XT_LE_GlassCoh_nsp1_20190325_all_raw_perm2k';...
%
% %RE high coh only
% 'XT_RE_Glass_nsp1_20190124_005_raw_perm2k';...   %15 reps
% 'XT_RE_Glass_nsp1_20190123_003_raw_perm2k';...  %4 reps
% 'XT_RE_Glass_nsp1_20190123_all_raw_perm2k';...
%
% %LE high coh only
% 'XT_LE_Glass_nsp1_20190123_all_raw_perm2k';...
% 'XT_LE_Glass_nsp1_20190124_all_raw_perm2k';
%% combined sessions
%% combined sessions
%files = {%FE
    %    'WU_LE_Glass_nsp2_20170817_001_raw_perm2k';...
    %     'WU_RE_Glass_nsp2_20170818_all_raw_perm2k';...
    %     'WU_LE_Glass_nsp1_20170817_001_raw_perm2k';...
    %     'WU_RE_Glass_nsp1_20170818_001_raw_perm2k';...
    %
    %     'WV_RE_glassCoh_nsp2_20190404_all_raw_perm2k';...
    %     'WV_LE_GlassCoh_nsp2_20190402_all_raw_perm2k';...
    %    'WV_RE_glassCoh_nsp1_20190404_all_raw_perm2k';...
    %    'WV_LE_glassCoh_nsp1_20190403_all_raw_perm2k';...
    
    %    'XT_RE_GlassCoh_nsp2_20190321_all_raw_perm2k';...
    %    'XT_LE_GlassCoh_nsp2_20190325_all_raw_perm2k';...
    %     'XT_RE_Glass_nsp2_20190123_all_raw_perm2k';...
    %     'XT_LE_Glass_nsp2_20190123_all_raw_perm2k';...
    
    %    'XT_RE_GlassCoh_nsp1_20190321_all_raw_perm2k';...
    %    'XT_LE_GlassCoh_nsp1_20190325_all_raw_perm2k';...
    %     'XT_RE_Glass_nsp1_20190123_all_raw_perm2k';...
    %     'XT_LE_Glass_nsp1_20190123_all_raw_perm2k';...files = {%FE
    %    'WU_LE_Glass_nsp2_20170817_001_raw_perm2k';...
    %     'WU_RE_Glass_nsp2_20170818_all_raw_perm2k';...
    %     'WU_LE_Glass_nsp1_20170817_001_raw_perm2k';...
    %     'WU_RE_Glass_nsp1_20170818_001_raw_perm2k';...
    %
    %     'WV_RE_glassCoh_nsp2_20190404_all_raw_perm2k';...
    %     'WV_LE_GlassCoh_nsp2_20190402_all_raw_perm2k';...
    %    'WV_RE_glassCoh_nsp1_20190404_all_raw_perm2k';...
    %    'WV_LE_glassCoh_nsp1_20190403_all_raw_perm2k';...
    
    %    'XT_RE_GlassCoh_nsp2_20190321_all_raw_perm2k';...
    %    'XT_LE_GlassCoh_nsp2_20190325_all_raw_perm2k';...
    %     'XT_RE_Glass_nsp2_20190123_all_raw_perm2k';...
    %     'XT_LE_Glass_nsp2_20190123_all_raw_perm2k';...
    
    %    'XT_RE_GlassCoh_nsp1_20190321_all_raw_perm2k';...
    %    'XT_LE_GlassCoh_nsp1_20190325_all_raw_perm2k';...
    %     'XT_RE_Glass_nsp1_20190123_all_raw_perm2k';...
    %     'XT_LE_Glass_nsp1_20190123_all_raw_perm2k';...
%    };
%% testing Manu's cleaned version
files = {'WU_RE_Glass_nsp1_20170817_002_cleaned3_manu_perm2k';
    'WU_RE_Glass_nsp1_20170817_002_raw_perm2k'};
%%
nameEnd =  'Stats';
failNdx = 1;
plotHists = 0;
plotOther = 0;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    % try
    load(files{fi});
    filename = files{fi};
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    %% permutation tests d'
    [dataT.radBlankDprimePvals,dataT.radBlankDprimeSig] = glassGetPermutationStats_coh(dataT.radBlankDprime,dataT.radBlankDprimeBootPerm,dataT,'radial vs blank permutation test',plotHists);
    [dataT.conBlankDprimePvals,dataT.conBlankDprimeSig] = glassGetPermutationStats_coh(dataT.conBlankDprime,dataT.conBlankDprimeBootPerm,dataT,'concentric vs blank permutation test',plotHists);
    [dataT.noiseBlankDprimePvals,dataT.noiseBlankDprimeSig] = glassGetPermutationStats(dataT.noiseBlankDprime,dataT.noiseBlankDprimeBootPerm,dataT,'noise vs blank permutation test',plotHists);
    [dataT.stimBlankDprimePvals,dataT.stimBlankDprimeSig] = glassGetPermutationStats(dataT.stimBlankDprime,dataT.stimBlankDprimeBootPerm,dataT,'all stimuli vs blank permutation test',plotHists);
    
    fprintf('stim vs blank tests done %d  hours \n',toc/3600)
    %% stimulus selectivity permutation tests
    
    [dataT.conNoiseDprimePvals,dataT.conNoiseSig] = glassGetPermutationStats_coh(dataT.conNoiseDprime,dataT.conNoiseDprimeBootPerm,dataT,'concentric vs noise permutation test',plotHists);
    [dataT.radNoiseDprimePvals,dataT.radNoiseSig] = glassGetPermutationStats_coh(dataT.radNoiseDprime,dataT.radNoiseDprimeBootPerm,dataT,'radial vs noise permutation test',plotHists);
    [dataT.conRadNoiseDprimePvals,dataT.conRadSig] = glassGetPermutationStats_coh(dataT.conRadDprime,dataT.conRadDprimeBootPerm,dataT,'concentric vs radial permutation test',plotHists);
    
    fprintf('stim vs noise permutation tests done %d  hours \n',toc/3600)
    %% latency permutation tests by stimulus
    [dataT.radOnsetLatencyPvals,dataT.radOnsetLatencySig] = glassGetPermutationStats_coh(dataT.radBlankOnLat, dataT.radBlankOnLatBoot,dataT,'radial onset latency permutation test',plotHists);
    [dataT.radOffsetLatencyPvals,dataT.radOnsetLatencySig] = glassGetPermutationStats_coh(dataT.radBlankOffLat, dataT.radBlankOffLatBoot,dataT,'radial offset latency permutation test',plotHists);
    
    [dataT.conOnsetLatencyPvals,dataT.conOnsetLatencySig] = glassGetPermutationStats_coh(dataT.conBlankOnLat, dataT.conBlankOnLatBoot,dataT,'concentric onset latency permutation test',plotHists);
    [dataT.conOffsetLatencyPvals,dataT.conOnsetLatencySig] = glassGetPermutationStats_coh(dataT.conBlankOffLat, dataT.conBlankOffLatBoot,dataT,'concentric offset latency permutation test',plotHists);
    
    [dataT.noiseOnsetLatencyPvals,dataT.noiseOnsetLatencySig] = glassGetPermutationStats(dataT.noiseBlankOnLat, dataT.noiseBlankOnLatBoot,dataT,'noise onset latency permutation test',plotHists);
    [dataT.noiseOffsetLatencyPval,dataT.noiseOnsetLatencySig] = glassGetPermutationStats(dataT.noiseBlankOffLat, dataT.noiseBlankOffLatBoot,dataT,'noise offset latency permutation test',plotHists);
    
    fprintf('latency permutation tests done %d  hours \n',toc/3600)
    %% latency permutation tests all stimuli combined
    [dataT.onLatPvalAllStim,dataT.onLatSigCh] = glass_PermTest_goodChVector(dataT.onsetLatencyAllStim,dataT.onLatBootAllStimPerm,dataT,'all stimuli onset latency permutation test',plotHists);
    [dataT.offLatPvalAllStim,dataT.offLatSigCh] = glass_PermTest_goodChVector(dataT.offsetLatencyAllStim,dataT.offLatBootAllStimPerm,dataT,'all stimuli offset latency permutation test',plotHists);
    
    fprintf('all permutation tests done %d  hours \n',toc/3600)
    %% get homogeneity
    dataT = ChiSquareHomogeneity(dataT,0.1);
    %% rank order of stim responses
    dataT = rankGlassSelectivitiesBlank(dataT);
    dataT = numSigGlassComparisons(dataT);
    %% plot
    if plotOther == 1
        plotGlass_GlassRankingsDistBlank(dataT) % figure 1 and 2
        plotGlassPSTHsCohType(dataT) % figures 3-6
    end
    %% commit to data structure
    if contains(filename,'RE')
        data.RE = dataT;
    else
        data.LE = dataT;
    end
    
    location = determineComputer;
    if location == 1
        outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
    elseif location == 0
        outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
    end
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data','-v7.3');
    fprintf('%s saved\n', saveName)
    
    toc/60
    %     catch ME
    %         failedFile{failNdx} = files{fi};
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %         fprintf('##### file failed ###### \n  %s \n',ME.message)
    %     end
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlass2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end

