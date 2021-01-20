clear all
close all
clc
%%
 
% REfile = 'WU_RE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns_stimPerm_OSI';
% LEfile = 'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info3_goodRuns_stimPerm_OSI';
% newName = 'WU_BE_GlassTR_V4_cleanMerged';
 
% REfile = 'WV_RE_glassTRCoh_nsp2_April2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% LEfile = 'WV_LE_glassTRCoh_nsp2_April2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% newName = 'WV_BE_GlassTRCoh_V4_cleanMerged';
 
% REfile = 'XT_RE_GlassTR_nsp2_Jan2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% LEfile = 'XT_LE_GlassTR_nsp2_Jan2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% newName = 'XT_BE_GlassTR_V4_cleanMerged';

% V1
% REfile = 'XT_RE_GlassTR_nsp1_Jan2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% LEfile = 'XT_LE_GlassTR_nsp1_Jan2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
% newName = 'XT_BE_GlassTR_V1_cleanMerged';

% REfile = 'WU_RE_GlassTR_nsp1_Aug2017_all_thresh35_info3_goodRuns_stimPerm_OSI';
% LEfile = 'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info3_goodRuns_stimPerm_OSI';
% newName = 'WU_BE_GlassTR_V1_cleanMerged';

REfile = 'WV_RE_glassTRCoh_nsp1_April2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
LEfile = 'WV_LE_glassTRCoh_nsp1_April2019_all_thresh35_info3_goodRuns_stimPerm_OSI';
newName = 'WV_BE_GlassTRCoh_V1_cleanMerged';
%%
location = determineComputer;
%% combine data from the two eyes into one pair of structures
data = CombineEyes_OD(LEfile, REfile);
%% save data

if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GlassTR/bothEyes/',data.RE.array);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GlassTR/bothEyes/',data.RE.array);
    
end
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end
%%
data = getGlassODI(data);
%
plotGlassPSTHs_visualResponses(data)
%% polar histograms
%plotGlassTR_prefOriDist(data) % fig 6-8
%plotGlassTR_prefOriDist_eyeComps(data) %fig 8-9
%plotGlassTR_prefOriDist_BE_bestParam(data);
data = plotGlassTR_prefOriDist_BE_bestDprimeSum(data);
%% scatter plot
%plotGlassTR_OSI_eyeComps(data) % fig 12
%% OSI histograms
% plotGlassTR_OSIdist(data) % fig 3-5
plotGlassTR_OSIdist_binoc(data) % fig 13-15
%%
saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)