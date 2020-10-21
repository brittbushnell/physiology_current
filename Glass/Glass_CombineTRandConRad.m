clear
close all
clc
%%
load('WU_BE_GlassTR_V4_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('WU_BE_V4_Aug2017_clean_merged');
crLE = data.LE;
crRE = data.RE;
conRadData = data;
clear data
%%  get correct receptive field information
[trLE.rfQuadrant, trLE.rfParams, trLE.inStim] = getRFsinStim(trLE);
trLE = GlassTR_bestSumDOris(trLE);
trLE.quadOris = getOrisInRFs(trLE);

[trRE.rfQuadrant, trRE.rfParams, trRE.inStim] = getRFsinStim(trRE);
trRE = GlassTR_bestSumDOris(trRE);
trRE.quadOris = getOrisInRFs(trRE);

[crLE.rfQuadrant, crLE.rfParams, crLE.inStim] = getRFsinStim(crLE);
[crRE.rfQuadrant, crRE.rfParams, cRE.inStim] = getRFsinStim(crRE);
%% get the preferred orientation for the preferred stimulus (density, dx)



%% concentric vs radial preference as a function of receptive field location on stimulus


