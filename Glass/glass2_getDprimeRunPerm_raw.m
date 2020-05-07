clear all
close all
clc
tic
%% V4
% files = {
%FE
%'WU_LE_Glass_nsp2_20170817_001_raw';...
%'WU_LE_Glass_nsp2_20170822_001_raw';...       %6 reps
%'WU_LE_Glass_nsp2_20170821_002_raw';...       %4 reps

%AE
%'WU_RE_Glass_nsp2_20170817_X02_raw';...       %4 reps
% 'WU_RE_Glass_nsp2_20170818_all_raw';...
% 
% %WV
% %AE
% 'WV_RE_glassCoh_nsp2_20190405_001_raw';...
% 'WV_RE_glassCoh_nsp2_20190404_all_raw';...
% 
% %FE
% 'WV_LE_GlassCoh_nsp2_20190402_all_raw';...
% 'WV_LE_glassCoh_nsp2_20190403_all_raw';...
% 
% %FE smaller diameter stimulus
% 'WV_LE_glassCohSmall_nsp2_20190426_001_raw';...  %9 reps
% 'WV_LE_glassCohSmall_nsp2_20190424_002_raw';...  %4 reps
% 'WV_LE_glassCohSmall_nsp2_20190425_all_raw';...
% 
% %AE smaller diameter stimulus
% 'WV_RE_glassCohSmall_nsp2_20190424_001_raw';... %10 reps
% 'WV_RE_glassCohSmall_nsp2_20190423_all_raw';...
% 
% %XT %%%
% %RE
% 'XT_RE_GlassCoh_nsp2_20190321_all_raw';...
% 'XT_RE_GlassCoh_nsp2_20190322_001_raw';...  %6 reps
% %LE
% 'XT_LE_GlassCoh_nsp2_20190324_005_raw';...  %4 reps
% 'XT_LE_GlassCoh_nsp2_20190325_all_raw';...
% 
% %RE high coh only
% 'XT_RE_Glass_nsp2_20190124_005_raw';...   %15 reps
% 'XT_RE_Glass_nsp2_20190123_003_raw';...  %4 reps
% 'XT_RE_Glass_nsp2_20190123_all_raw';...
% 
% %LE high coh only
% 'XT_LE_Glass_nsp2_20190123_all_raw';...
% 'XT_LE_Glass_nsp2_20190124_all_raw';
% 
% %% V1
% %FE
% 'WU_LE_Glass_nsp1_20170817_001_raw';...
% 'WU_LE_Glass_nsp1_20170822_001_raw';...       %6 reps
% 'WU_LE_Glass_nsp1_20170821_002_raw';...       %4 reps
% 
% %AE
% 'WU_RE_Glass_nsp1_20170817_X02_raw';...       %4 reps
% 'WU_RE_Glass_nsp1_20170818_all_raw';...
% 
% %WV
% %AE
% 'WV_RE_glassCoh_nsp1_20190405_001_raw';...
% 'WV_RE_glassCoh_nsp1_20190404_all_raw';...
% 
% %FE
% 'WV_LE_GlassCoh_nsp1_20190402_all_raw';...
% 'WV_LE_glassCoh_nsp1_20190403_all_raw';...
% 
% %FE smaller diameter stimulus
% 'WV_LE_glassCohSmall_nsp1_20190426_001_raw';...  %9 reps
% 'WV_LE_glassCohSmall_nsp1_20190424_002_raw';...  %4 reps
% 'WV_LE_glassCohSmall_nsp1_20190425_all_raw';...
% 
% %AE smaller diameter stimulus
% 'WV_RE_glassCohSmall_nsp1_20190424_001_raw';... %10 reps
% 'WV_RE_glassCohSmall_nsp1_20190423_all_raw';...
% 
% %XT %%%
% %RE
% 'XT_RE_GlassCoh_nsp1_20190321_all_raw';...
% 'XT_RE_GlassCoh_nsp1_20190322_001_raw';...  %6 reps
% %LE
% 'XT_LE_GlassCoh_nsp1_20190324_005_raw';...  %4 reps
% 'XT_LE_GlassCoh_nsp1_20190325_all_raw';...
% 
% %RE high coh only
% 'XT_RE_Glass_nsp1_20190124_005_raw';...   %15 reps
% 'XT_RE_Glass_nsp1_20190123_003_raw';...  %4 reps
% 'XT_RE_Glass_nsp1_20190123_all_raw';...
% 
% %LE high coh only
% 'XT_LE_Glass_nsp1_20190123_all_raw';...
% 'XT_LE_Glass_nsp1_20190124_all_raw';
%% XX
%'XX_LE_Glass_nsp1_20200210_all_raw';

% 'XX_LE_Glass_nsp2_20200210_all_raw';
%'XX_RE_Glass_nsp1_20200211_all_raw';
%'XX_RE_Glass_nsp2_20200211_all_raw';

%};
%%
files = {
        'WU_LE_Glass_nsp2_20170817_001_raw';...
        'WU_RE_Glass_nsp2_20170818_all_raw';...
%         'WU_LE_Glass_nsp1_20170817_001_raw';...
%         'WU_RE_Glass_nsp1_20170818_001_raw';...
    %
    %     'WV_RE_glassCoh_nsp2_20190404_all_raw';...
    %     'WV_LE_GlassCoh_nsp2_20190402_all_raw';...
    %     'WV_RE_glassCoh_nsp1_20190404_all_raw';...
    %     'WV_LE_glassCoh_nsp1_20190403_all_raw';...
    %
    %     'XT_RE_GlassCoh_nsp2_20190321_all_raw';...
    %     'XT_LE_GlassCoh_nsp2_20190325_all_raw';...
    %     'XT_RE_Glass_nsp2_20190123_all_raw';...
    %     'XT_LE_Glass_nsp2_20190123_all_raw';...
    
    %    'XT_RE_GlassCoh_nsp1_20190321_all_raw';...
    %    'XT_LE_GlassCoh_nsp1_20190325_all_raw';...
    %     'XT_RE_Glass_nsp1_20190123_all_raw';...
    %     'XT_LE_Glass_nsp1_20190123_all_raw';...
    };
%%
nameEnd = '2kFixPerm';
numPerm = 2000;
numBoot = 200;
holdout = .90;
plotFlag = 0;
%%
location = determineComputer;

failedFile= {};
failedME = {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
    filename = files{fi};
    load(filename);
    fprintf('\n*** analyzing %s \n*** file %d/%d \n', filename,fi,size(files,1))
    
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    %%
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/Parsed/',dataT.array);
    elseif location == 3
        outputDir = sprintf('~/matFiles/%s/',dataT.animal);
    end
    %% do all vs blank permutation test
    dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);
    
    fprintf('good channel permutaiton test done %.2f hours \n',toc/3600)
    %% decide good channels
    [dataT.stimBlankChPvals,dataT.goodCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
    if contains(filename,'WU')
        dataT.goodCh(66) = 0;
    end
    %% get real stimulus d's
    dataT = getStimVsBlankDPrimes_Glass_coh(dataT,numBoot, holdout);
    dataT = getGlassStimDPrimes_coh(dataT, numBoot, holdout);
    
    fprintf('real dPrimes computed %.2f hours \n',toc/3600)
    %% get stim vs blank permutations
    dataT = GlassStimVsBlankPermutations_coh(dataT, numPerm, holdout);
    
    fprintf('permutation test stim vs blank done %.2f hours \n',toc/3600)
    %% stimulus vs noise permutations
    % for now, skipping this in lieu of setting up a vector process
    % similiar to Yasmine and James Cavanaugh.
    
%     dataT = GlassStimVsNoisePermutation_coh(dataT, numPerm,holdout);
%     
%     fprintf('permutation test stim vs noise done%.2f hours \n',toc/3600)
    %% get latency
    dataT = getLatencies_Glass(dataT,numPerm,plotFlag,holdout);
    dataT = getLatencies_Glass_Permutation(dataT,numPerm,holdout);
    
    dataT = getLatencies_Glass_byStim(dataT,numPerm,holdout);
    dataT = getLatencies_Glass_byStimPermutation(dataT,numPerm,holdout);
    
    fprintf('latencies computed %.2f hours \n',toc/3600)
    
    %%
    if contains(filename,'RE')
        data.RE = dataT;
    else
        data.LE = dataT;
    end
    saveName = [outputDir filename '_' nameEnd '.mat'];
    save(saveName,'data','-v7.3');
    fprintf('%s saved\n', saveName)
    %%
    clear dataT
    
    fprintf('file %s done %.2f hours \n',filename, toc/3600)
    %     catch ME
    %         failedFile{failNdx} = filename;
    %         failedME{failNdx} = ME;
    %         failNdx = failNdx+1;
    %         fprintf('file failed \n')
    %     end
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlass2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end
toc/3600
