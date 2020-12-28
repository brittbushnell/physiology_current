clear
close all
clc
%%
% % V4
% LEfile = 'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
% REfile = 'WU_RE_Glass_nsp2_Aug2017_all_thresh35_info3_goodRuns_dPrime';
% newName = 'WU_BE_V4_Glass_clean_merged';

LEfile = 'WV_LE_glassCoh_nsp2_April2019_all_thresh35_info3_goodRuns_dPrime';
REfile = 'WV_RE_glassCoh_nsp2_April2019_all_thresh35_info3_goodRuns_dPrime';
newName = 'WV_BE_V4_Glass_clean_merged';
%  
% LEfile =  'XT_LE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
% REfile =  'XT_RE_Glass_nsp2_Jan2019_all_thresh35_info3_goodRuns_dPrime';
% newName = 'XT_BE_V4_Glass_clean_merged';
 
% V1
LEfile = 'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
REfile = 'WU_RE_Glass_nsp1_Aug2017_all_thresh35_info3_goodRuns_dPrime';
newName = 'WU_BE_V1_Glass_clean_merged';
 
% LEfile = 'WV_LE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
% REfile = 'WV_RE_glassCoh_nsp1_April2019_all_thresh35_info3_goodRuns_dPrime';
% newName = 'WV_BE_V1_Glass_clean_merged';
 
% LEfile =  'XT_LE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';
% REfile =  'XT_RE_Glass_nsp1_Jan2019_all_thresh35_info3_goodRuns_dPrime';
% newName = 'XT_BE_V1_Glass_clean_merged';
%% combine data from the two eyes into one pair of structures
data = CombineEyes_OD(LEfile, REfile);

location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/bothEyes/%s/',data.RE.array,data.RE.animal);
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/bothEyes/%s/',data.RE.array,data.RE.animal);
    if ~exist(outputDir,'dir')
        mkdir(outputDir)
    end
end
%%
data = getGlassODI(data);
%% histograms
 plotGlassChiSquareDistribution(data)
 %% scatter
 plotGlass_dPrimeScatter(data)
 %% PSTHs
 plotGlassPSTHs_visualResponses(data)
%% binocular triplots
if contains(REfile,'XT')
    triplotter_stereo_Glass_BE(data,5.5)
else
    triplotter_stereo_Glass_BE(data,3.5)
end
%%
saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)