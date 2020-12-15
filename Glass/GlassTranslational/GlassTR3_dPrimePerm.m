clear all
close all
clc
fprintf('running glassTR3_DprimePerm \n')
tic
%%
files = {
    'XT_LE_GlassTR_nsp2_Jan2019_all_thresh35_info3_goodRuns';
    'XT_LE_GlassTR_nsp1_Jan2019_all_thresh35_info3_goodRuns';
    'XT_RE_GlassTR_nsp2_Jan2019_all_thresh35_info3_goodRuns';
    'XT_RE_GlassTR_nsp1_Jan2019_all_thresh35_info3_goodRuns';

%     'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info3_goodRuns';
%     'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info3_goodRuns';
%     'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info3_goodRuns';
%     'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info3_goodRuns';
%     
%     'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns';
%     'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info3_goodRuns';
%     'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info3_goodRuns';
%     'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns';
    };

%%
nameEnd = 'stimPerm';
%%
numPerm = 2000;
numBoot = 200;
holdout = 0.90;
plotHists = 0;
%%
location = determineComputer;
%%
failedFile= {};
failNdx = 1;
for fi = 1:size(files,1)
    %% Get basic information about experiments
    try
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
        %% get real dPrimes for stimulus vs blank and orientations vs noise
        [dataT.linBlankDprime, dataT.noiseBlankDprime] = GlassTRvBlankDPrimes_zscore(dataT,numBoot, holdout);
        dataT.linNoiseDprime = GlassTRvNoiseDPrimes_zscore(dataT,numBoot, holdout);
        fprintf('real dPrimes computed in %.2f hours \n',toc/3600)
        %% get stim vs blank permutations
        [dataT.linBlankDprimePerm, dataT.noiseBlankDprimePerm, dataT.linBlankDprimeBootPerm, dataT.noiseBlankDprimeBootPerm] = GlassTR_StimVsBlankPermutations_coh(dataT, numPerm, holdout);
        
        fprintf('stim vs blank permutations done in %.2f hours \n',toc/3600)
        %% get stim vs noise permutations
        [dataT.linNoiseDprimePerm,dataT.linNoiseDprimePermBoot] = GlassTR_StimVsNoisePermutations_coh(dataT, numPerm,holdout);
        
        fprintf('stim vs noise permutations done in %.2f hours \n',toc/3600)
        %% do permutation tests
        % ex:      [dataT.radNoiseDprimePvals,dataT.radNoiseDprimeSig] = glassGetPermutationStats_coh(dataT.radNoiseDprime,dataT.radNoiseDprimeBootPerm,dataT,'radial vs noise permutation test',plotHists);

        [dataT.linBlankDprimePvals,dataT.linBlankDprimeSig] = glassTRGetPermutationStats_coh(dataT.linBlankDprime,dataT.linBlankDprimeBootPerm,dataT,'translational vs blank permutation test',plotHists);
        [dataT.noiseBlankDprimePvals,dataT.noiseBlankDprimeSig] = glassTRGetPermutationStats_coh(dataT.noiseBlankDprime,dataT.noiseBlankDprimeBootPerm,dataT,'noise translational vs blank permutation test',plotHists);
        [dataT.linNoiseDprimePvals,dataT.linNoiseDprimeSig] = glassTRGetPermutationStats_coh(dataT.linNoiseDprime,dataT.linNoiseDprimePermBoot,dataT,'translational vs noise permutation test',plotHists);
%%
                
        %% get latency
%         dataT = getLatencies_Glass(dataT,numPerm,plotFlag,holdout);
%         dataT = getLatencies_Glass_Permutation(dataT,numPerm,holdout);
%         
%         dataT = getLatencies_GlassTR_byStim(dataT,numPerm,holdout);
%         dataT = getLatencies_GlassTR_byStimPermutation(dataT,numPerm,holdout);
%         
%         fprintf('latencies computed in %.2f hours \n',toc/3600)
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
    catch ME
        failedFile{failNdx} = filename;
        failedME{failNdx} = ME;
        failNdx = failNdx+1;
        fprintf('xxxxxxxxxxx\n')
        fprintf('file failed \n')
        fprintf('%s \n',ME.identifier)
        fprintf('xxxxxxxxxxx\n')
    end
    close all
end
if failNdx >1
    saveName = [outputDir 'failedFilesGlassTR2_stimVblank' '.mat'];
    save(saveName,'failedFile','failedME','-v7.3');
end
fprintf ('\n step 2 of translational Glass complete in %.2f hours \n',toc/3600)
