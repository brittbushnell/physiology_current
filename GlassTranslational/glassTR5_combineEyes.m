clear all
close all
clc
%%

REfile = 'WU_RE_GlassTR_nsp2_20170828_all_s1_perm2k_OSIvsBlank_PermTests';
LEfile = 'WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k_OSIvsNoise_PermTests';
newName = 'WU_BE_GlassTR_V4_201708';   

% REfile = 'WU_RE_GlassTR_nsp1_20170828_all_s1_perm2k_OSIvsNoise_PermTests';
% LEfile = 'WU_LE_GlassTR_nsp1_20170825_002_s1_perm2k_OSIvsNoise_PermTests';
% newName = 'WU_BE_GlassTR_V1_201708';   
 
% REfile = 'XT_RE_GlassTR_nsp2_20190125_all_s1_perm2k_select';
% LEfile = 'XT_LE_GlassTR_nsp2_20190130_all_s1_perm2k_select';
% newName = 'XT_BE_GlassTR_V4_201901';
 
% REfile = 'XT_RE_GlassTR_nsp1_20190125_all_s1_perm2k_select';
% LEfile = 'XT_LE_GlassTR_nsp1_20190130_all_s1_perm2k_select';
% newName = 'XT_BE_GlassTR_V1_201901';
 
% REfile = 'WV_RE_GlassTRCoh_nsp2_20190409_all_s1_perm2k_select';
% LEfile = 'WV_LE_GlassTRCoh_nsp2_20190415_all_s1_perm2k_select';
% newName = 'WV_BE_GlassTRCoh_V4_201904';
 
% REfile = 'WV_RE_GlassTRCoh_nsp1_20190409_all_s1_perm2k_select';
% LEfile = 'WV_LE_GlassTRCoh_nsp1_20190415_all_s1_perm2k_select';
% newName = 'WV_BE_GlassTRCoh_V1_201904';
%%
location = determineComputer;
if location == 1
    outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
elseif location == 0
    outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
end
%% combine data from the two eyes into one pair of structures
data = CombineEyes_OD(LEfile, REfile);

location = determineComputer;
if location == 1
    outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
elseif location == 0
    outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
end
%%
data = getGlassODI(data);
%%
plotGlassPSTHs_visualResponses(data)
%%
 plotGlassTR_tuningCurvesPolar(data.RE)
 plotGlassTR_tuningCurvesPolar(data.LE)

plotGlassTR_OSIdist(data)
%%
saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)