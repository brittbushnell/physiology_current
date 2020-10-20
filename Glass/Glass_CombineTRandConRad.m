clear all
close all
clc
%%
trData = load('XT_BE_GlassTR_V4_May2020');
trLE = trData.LE;
trRE = trData.RE;

radConData = load('WU_BE_V4_Aug2017_clean_merged');
crLE = radConData.LE;
crRE = radConData.RE;
%%


    %% get the preferred orientation for the preferred stimulus (density, dx)
    [rfQuadrant,rfParams, inStim] = getRFsinStim(dataT);
    dataT = GlassTR_bestSumDOris(dataT);
     dataT.quadOris = getOrisInRFs(dataT);




