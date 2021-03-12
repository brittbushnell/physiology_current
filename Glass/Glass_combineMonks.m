% combineGlassMonks
clear
close all
clc
%%
WU = 'WU_2eyes_2arrays_GlassPatterns';
XT = 'XT_2eyes_2arrays_GlassPatterns';
WV = 'WV_2eyes_2arrays_GlassPatterns';
%%
load(WU)
WUdata = data;
WUV4 = data.V4;
WUV1 = data.V1;
clear data

load(WV)
WVdata = data;
WVV4 = data.V4;
WVV1 = data.V1;
clear data

load(XT)
XTdata = data;
XTV4 = data.V4;
XTV1 = data.V1;
clear data
%%
location = determineComputer;

if location == 1
    figDir =  ('~/bushnell-local/Dropbox/Figures/CrossAnimals/Glass/');
elseif location == 0
    figDir =  ('~/Dropbox/Figures/CrossAnimals/Glass/');
end
cd(figDir)
%% R2 comparisons from d' scatter plots
MakeFigs_GlassR2Vals(XTdata,WUdata,WVdata) % fig 14 & 15
%% triplots
plotGlass_triplot_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4);
%% OSI figures
[WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4); % fig 1-3
plotGlassOSIpatterns(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) % figs 4-8
%% ODI figures
[WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotGlassODI_xArray_xAnimal(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4); % fig 9-11
%% zScore figures 
plotGlassZscore_xAnimal(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) % fig 12 & 13
%%

