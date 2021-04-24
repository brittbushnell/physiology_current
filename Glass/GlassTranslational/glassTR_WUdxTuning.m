clear
close all
clc
%%
V1 = 'WU_LE_GlassTR_nsp1_Aug2019_all_thresh35_DxComp_goodRuns_stimPerm_OSI';
V4 = 'WU_LE_GlassTR_nsp2_Aug2019_all_thresh35_DxComp_goodRuns_stimPerm_OSI';

%% 
load(V1)
V1data = data.LE;
clear data

load(V4)
V4data = data.LE;
clear data
%%
