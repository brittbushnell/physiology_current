clear all
close all
clc
%%

% REfile = 'WU_RE_GlassTR_nsp2_20170828_all_raw_2kFixPerm_OSI_prefOri_PermTests';
% LEfile = 'WU_LE_GlassTR_nsp2_20170825_002_raw_2kFixPerm_OSI_prefOri_PermTests';
% newName = 'WU_BE_GlassTR_V4_201708_may';
% 
% REfile = 'WV_RE_GlassTRCoh_nsp2_20190410_all_s1_2kFixPerm_OSI_prefOri';
% LEfile = 'WV_LE_glassTRCoh_nsp2_20190416_all_s1_2kFixPerm_OSI_prefOri';
% newName = 'WV_BE_GlassTRCoh_V4_May2020';
 
REfile = 'XT_RE_GlassTR_nsp2_20190128_all_s1_2kFixPerm_OSI_prefOri';
LEfile = 'XT_LE_GlassTR_nsp2_20190130_all_s1_2kFixPerm_OSI_prefOri';
newName = 'XT_BE_GlassTR_V4_May2020';

% V1
% REfile = 'XT_RE_GlassTR_nsp1_20190128_all_s1_2kFixPerm_OSI_prefOri';
% LEfile = 'XT_LE_GlassTR_nsp1_20190130_all_s1_2kFixPerm_OSI_prefOri';
% newName = 'XT_BE_GlassTR_V1_201901';

% REfile = 'WU_RE_GlassTR_nsp1_20170828_all_raw_2kFixPerm_OSI_prefOri';
% LEfile = 'WU_LE_GlassTR_nsp1_20170825_002_raw_2kFixPerm_OSI_prefOri';
% newName = 'WU_BE_GlassTR_V1_201708';

% REfile = 'WV_RE_GlassTRCoh_nsp1_20190410_all_s1_2kFixPerm_OSI_prefOri';
% LEfile = 'WV_LE_glassTRCoh_nsp1_20190416_all_s1_2kFixPerm_OSI_prefOri';
% newName = 'WV_BE_GlassTRCoh_V1_201904';  
%%
location = determineComputer;
    %% save data
    
    if location == 1
        outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/GlassTR/bothEyes/',dataT.array);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
    elseif location == 0
        outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/GlassTR/bothEyes/',dataT.array);
        if ~exist(outputDir, 'dir')
            mkdir(outputDir)
        end
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
%
%plotGlassPSTHs_visualResponses(data)
%% polar histograms
%plotGlassTR_prefOriDist(data) % fig 6-8
%plotGlassTR_prefOriDist_eyeComps(data) %fig 8-9
%plotGlassTR_prefOriDist_BE_bestParam(data);
data = plotGlassTR_prefOriDist_BE_bestDprimeSum(data);
%% scatter plot
%plotGlassTR_OSI_eyeComps(data) % fig 12
%% OSI histograms
% plotGlassTR_OSIdist(data) % fig 3-5
% plotGlassTR_OSIdist_binoc(data) % fig 13-15
%%
saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)