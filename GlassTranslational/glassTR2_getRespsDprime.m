clear all
close all
clc
fprintf('running glassTR2_getRespsDprime \n')
tic
%%
% files = {
    %V4
    %     'XT_RE_GlassTR_nsp2_20190125_001_s1';...
    %     'XT_RE_GlassTR_nsp2_20190125_002_s1';...
    %     'XT_RE_GlassTR_nsp2_20190125_003_s1';...
    %     'XT_RE_GlassTR_nsp2_20190125_004_s1';...
    %     'XT_RE_GlassTR_nsp2_20190125_005_s1';...
    
    %     'XT_RE_GlassTR_nsp2_20190128_001_s1';...
    %     'XT_RE_GlassTR_nsp2_20190128_002_s1';...
    %
    %     'XT_LE_GlassTR_nsp2_20190130_001_s1';...
    %     'XT_LE_GlassTR_nsp2_20190130_002_s1';...
    %     'XT_LE_GlassTR_nsp2_20190130_003_s1';...
    %     'XT_LE_GlassTR_nsp2_20190130_004_s1';...
    %     'XT_LE_GlassTR_nsp2_20190131_001_s1';...
    % WU
   % 'WU_RE_GlassTR_nsp2_20170829_001_s1';...
   % 'WU_RE_GlassTR_nsp2_20170828_all_s1';...
    %'WU_RE_GlassTR_nsp2_20170825_001_s1';...
    %
   % 'WU_LE_GlassTR_nsp2_20170825_002_s1';...
    %'WU_LE_GlassTR_nsp2_20170824_001_s1';...
    %
    %     % XT
    %     'XT_RE_GlassTRCoh_nsp2_20190322_002_s1';...
    %     'XT_RE_GlassTRCoh_nsp2_20190322_003_s1';...
    %     'XT_RE_GlassTRCoh_nsp2_20190322_004_s1';...
    %     'XT_RE_GlassTRCoh_nsp2_20190324_002_s1';...
    %     'XT_RE_GlassTRCoh_nsp2_20190324_003_s1';...
    %     'XT_RE_GlassTRCoh_nsp2_20190324_004_s1';...
    %     'XT_LE_GlassTRCoh_nsp2_20190325_005_s1';...
    %
    %     % WV
    %     'WV_RE_glassTRCoh_nsp2_20190405_002_s1';...
    %     'WV_RE_glassTRCoh_nsp2_20190408_001_s1';...
    %     'WV_RE_glassTRCoh_nsp2_20190409_001_s1';...
    %     'WV_RE_glassTRCoh_nsp2_20190409_002_s1';...
    %     'WV_RE_glassTRCoh_nsp2_20190410_001_s1';...
    %     'WV_RE_glassTRCoh_nsp2_20190410_002_s1';...
    %
    %     'WV_LE_glassTRCoh_nsp2_20190411_001_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190412_001_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190415_001_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190415_002_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190416_001_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190416_002_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190416_003_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190417_001_s1';...
    %     'WV_LE_glassTRCoh_nsp2_20190417_002_s1';...
    %
    %% V1
    % XT
    % 'XT_RE_GlassTR_nsp1_20190125_001_s1';...
    %     'XT_RE_GlassTR_nsp1_20190125_002_s1';...
    %     'XT_RE_GlassTR_nsp1_20190125_003_s1';...
    %     'XT_RE_GlassTR_nsp1_20190125_004_s1';...
    %     'XT_RE_GlassTR_nsp1_20190125_005_s1';...
    %     'XT_RE_GlassTR_nsp1_20190128_001_s1';...
    %     'XT_RE_GlassTR_nsp1_20190128_002_s1';...
    %
    %     'XT_LE_GlassTR_nsp1_20190130_001_s1';...
    %     'XT_LE_GlassTR_nsp1_20190130_002_s1';...
    %     'XT_LE_GlassTR_nsp1_20190130_003_s1';...
    %     'XT_LE_GlassTR_nsp1_20190130_004_s1';...
    %     'XT_LE_GlassTR_nsp1_20190131_001_s1';...
    %
    %     'XT_RE_GlassTRCoh_nsp1_20190322_002_s1';...
    %     'XT_RE_GlassTRCoh_nsp1_20190322_003_s1';...
    %     'XT_RE_GlassTRCoh_nsp1_20190322_004_s1';...
    %     'XT_RE_GlassTRCoh_nsp1_20190324_002_s1';...
    %     'XT_RE_GlassTRCoh_nsp1_20190324_003_s1';...
    %     'XT_RE_GlassTRCoh_nsp1_20190324_004_s1';...
    %     'XT_LE_GlassTRCoh_nsp1_20190325_005_s1';...
    %
    %     % WV
    %     'WV_RE_glassTRCoh_nsp1_20190405_002_s1';...
    %     'WV_RE_glassTRCoh_nsp1_20190408_001_s1';...
    %     'WV_RE_glassTRCoh_nsp1_20190409_001_s1';...
    %     'WV_RE_glassTRCoh_nsp1_20190409_002_s1';...
    %     'WV_RE_glassTRCoh_nsp1_20190410_001_s1';...
    %     'WV_RE_glassTRCoh_nsp1_20190410_002_s1';...
    %
    %     'WV_LE_glassTRCoh_nsp1_20190411_001_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190412_001_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190415_001_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190415_002_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190416_001_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190416_002_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190416_003_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190417_001_s1';...
    %     'WV_LE_glassTRCoh_nsp1_20190417_002_s1';...
    %
    %     %V1
   % 'WU_RE_GlassTR_nsp1_20170829_001_s1';...
   % 'WU_RE_GlassTR_nsp1_20170825_001_s1';...
    %'WU_RE_GlassTR_nsp1_20170828_all_s1';...
    
    
    %'WU_LE_GlassTR_nsp1_20170825_002_s1';...
   % 'WU_LE_GlassTR_nsp1_20170824_001_s1';...
% %%
% files = {
%     
%     'WU_RE_GlassTR_nsp2_20170828_all_s1';...    
%     'WU_LE_GlassTR_nsp2_20170825_002_s1';...
%   
%     'WU_RE_GlassTR_nsp1_20170828_all_s1';...
%     'WU_LE_GlassTR_nsp1_20170825_002_s1';...
     
%    'XT_RE_GlassTR_nsp2_20190125_all_s1';
%    'XT_RE_GlassTR_nsp2_20190128_all_s1';
%    'XT_LE_GlassTR_nsp2_20190130_all_s1';
%    
%    'XT_RE_GlassTR_nsp1_20190125_all_s1';
%    'XT_RE_GlassTR_nsp1_20190128_all_s1';
%    'XT_LE_GlassTR_nsp1_20190130_all_s1';
%    
% 'XT_RE_GlassTRCoh_nsp2_20190322_all_s1';
% 'XT_RE_GlassTRCoh_nsp2_20190324_all_s1';
% 'XT_RE_GlassTRCoh_nsp1_20190322_all_s1';
% 'XT_RE_GlassTRCoh_nsp1_20190324_all_s1';
% 
% 'WV_RE_GlassTRCoh_nsp2_20190409_all_s1';
% 'WV_RE_GlassTRCoh_nsp2_20190410_all_s1';
% 
% 'WV_LE_GlassTRCoh_nsp2_20190415_all_s1';
% 'WV_LE_glassTRCoh_nsp2_20190416_all_s1';
% 'WV_LE_GlassTRCoh_nsp2_20190417_all_s1';
% 
% 'WV_RE_GlassTRCoh_nsp1_20190409_all_s1';
% 'WV_RE_GlassTRCoh_nsp1_20190410_all_s1';
% 
% 'WV_LE_GlassTRCoh_nsp1_20190415_all_s1';
% 'WV_LE_glassTRCoh_nsp1_20190416_all_s1';
% 'WV_LE_GlassTRCoh_nsp1_20190417_all_s1';
%     };
%%
  files = {
%       'WU_LE_GlassTR_nsp2_20170825_002_thresh30_tests'
%       'WU_LE_GlassTR_nsp2_20170825_002_thresh35_tests'
%       'WU_LE_GlassTR_nsp2_20170825_002_thresh40_tests'
%       'WU_LE_GlassTR_nsp2_20170825_002_thresh45_tests'
      
      'WU_RE_GlassTR_nsp2_20170828_all_raw';...
      'WU_LE_GlassTR_nsp2_20170825_002_raw';...
      'WU_RE_GlassTR_nsp1_20170828_all_raw';...
      'WU_LE_GlassTR_nsp1_20170825_002_raw';...
  };
%%
nameEnd = '2kFixPerm';
%%
numPerm = 2000;
numBoot = 200;
holdout = .90;
plotFlag = 0;
%%
location = determineComputer;
%%
failedFile= {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    %try
        load(files{fi});
        filename = files{fi};
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
            outputDir = sprintf('~/matFiles/%s/Parsed/',dataT.array);
        end
        %% do all vs blank permutation test
        dataT = GlassStimVsBlankPermutations_allStim(dataT,numPerm,holdout);  
        fprintf('good channel permutaitons done in %.2f hours \n',toc/3600)
        %% decide good channels
        [dataT.stimBlankChPvals,dataT.goodCh] = glassGetPermutationStatsAndGoodCh(dataT.allStimBlankDprime,dataT.allStimBlankDprimeBootPerm);
        fprintf('good channel permutaiton test done in %.2f hours \n',toc/3600)
        %% get stimulus responses
        dataT = getStimResps_GlassTR(dataT, 200);
        %% get real dPrimes for stimulus vs blank and orientations vs noise
        dataT = getStimVsBlankDPrimes_GlassTR_coh(dataT,numPerm);
        dataT = getStimVsNoiseDPrimes_GlassTR_coh(dataT);
        
        fprintf('real dPrimes computed in %.2f hours \n',toc/3600)
        %% get stim vs blank permutations
        dataT = GlassTR_StimVsBlankPermutations_coh(dataT, numPerm, holdout);
        
        fprintf('stim vs blank permutations done in %.2f hours \n',toc/3600)
        %% get stim vs noise permutations
        dataT = GlassTR_StimVsNoisePermutations_coh(dataT, numPerm,holdout);
        
        fprintf('stim vs noise permutations done in %.2f hours \n',toc/3600)
        %% get latency
        dataT = getLatencies_Glass(dataT,numPerm,plotFlag,holdout);
        dataT = getLatencies_Glass_Permutation(dataT,numPerm,holdout);
        
        dataT = getLatencies_GlassTR_byStim(dataT,numPerm,holdout);
        dataT = getLatencies_GlassTR_byStimPermutation(dataT,numPerm,holdout);
        
        fprintf('latencies computed in %.2f hours \n',toc/3600)
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
        fprintf('file done in %.2f hours \n',toc/3600)
%     catch ME
%         failedFile{failNdx} = filename;
%         failedME{failNdx} = ME;
%         failNdx = failNdx+1;
%         fprintf('xxxxxxxxxxx\n')
%         fprintf('file failed \n')
%         fprintf('%s \n',ME.identifier)
%         fprintf('xxxxxxxxxxx\n')
%     end
    close all
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlassTR2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end
fprintf ('\n step 2 of translational Glass complete in %.2f hours \n',toc/3600)
