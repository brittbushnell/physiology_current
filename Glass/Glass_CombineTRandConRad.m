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
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data
%%  get correct receptive field information
[trLE.rfQuadrant, trLE.rfParams, trLE.inStim] = getRFsinStim(trLE);
trLE = GlassTR_bestSumDOris(trLE);
trLE.quadOris = getOrisInRFs(trLE);

[trRE.rfQuadrant, trRE.rfParams, trRE.inStim] = getRFsinStim(trRE);
trRE = GlassTR_bestSumDOris(trRE);
trRE.quadOris = getOrisInRFs(trRE);

[conRadLE.rfQuadrant, conRadLE.rfParams, conRadLE.inStim] = getRFsinStim(conRadLE);
[conRadRE.rfQuadrant, conRadRE.rfParams, conRadE.inStim] = getRFsinStim(conRadRE);
%% get the preferred density dx for concentric and radial
% tr.prefParamsIndex refers to dt,dx indices so 1 = (1,1) 2 = (1,2) 3 = (2,1) 4 = (2,2)

%% concentric vs radial preference as a function of receptive field location on stimulus


%% save combined data
