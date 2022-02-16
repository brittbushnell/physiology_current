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
%% move receptive field information
WUV1.chReceptiveFieldParamsLE = WUV1.trLE.chReceptiveFieldParams;
WUV1.chReceptiveFieldParamsRE = WUV1.trRE.chReceptiveFieldParams;
WUV4.chReceptiveFieldParamsLE = WUV4.trLE.chReceptiveFieldParams;
WUV4.chReceptiveFieldParamsRE = WUV4.trRE.chReceptiveFieldParams;

WVV1.chReceptiveFieldParamsLE = WVV1.trLE.chReceptiveFieldParams;
WVV1.chReceptiveFieldParamsRE = WVV1.trRE.chReceptiveFieldParams;
WVV4.chReceptiveFieldParamsLE = WVV4.trLE.chReceptiveFieldParams;
WVV4.chReceptiveFieldParamsRE = WVV4.trRE.chReceptiveFieldParams;

XTV1.chReceptiveFieldParamsBE = XTV1.trLE.chReceptiveFieldParams;
XTV4.chReceptiveFieldParamsBE = XTV4.trLE.chReceptiveFieldParams;
%%
location = determineComputer;

if location == 1
    figDir =  ('~/bushnell-local/Dropbox/Figures/CrossAnimals/Glass/');
elseif location == 0
    figDir =  ('~/Dropbox/Figures/CrossAnimals/Glass/');
end
cd(figDir)
%% OSI figures
% [WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4); % fig 1-3
 plotGlassOSIpatterns(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) % figs 4-8
%%
% makeGlassOrixTypeDiffThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)
[XTV1,XTV4,WUV1, WUV4,WVV1, WVV4] = makeGlassOriThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4);
[XTV1,XTV4,WUV1, WUV4,WVV1, WVV4] = makeGlassOriThesisFigs_allParams(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4);
%% differences in orientation between preferred and all params
XTV1diff  = angdiff(XTV1.meanOriDegDifAllStim, XTV1.meanOriDegDifPrefStim)
XTV4diff  = angdiff(XTV4.meanOriDegDifAllStim, XTV4.meanOriDegDifPrefStim)

WUV1diff  = angdiff(WUV1.meanOriDegDifAllStim, WUV1.meanOriDegDifPrefStim)
WUV4diff  = angdiff(WUV4.meanOriDegDifAllStim, WUV4.meanOriDegDifPrefStim)

WVV1diff  = angdiff(WVV1.meanOriDegDifAllStim, WVV1.meanOriDegDifPrefStim)
WVV4diff  = angdiff(WVV4.meanOriDegDifAllStim, WVV4.meanOriDegDifPrefStim)
%%
[XTV1,XTV4,WUV1, WUV4,WVV1, WVV4] = MakeTriploThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4);
%%
% close all
plotGlass_crNdxvsOriDiff(WUV1, WUV4)
plotGlass_crNdxvsOriDiff(WVV1, WVV4)
plotGlass_crNdxvsOriDiff(XTV1, XTV4)

% plotGlass_crNdxvsOriDiff_grat(WUV1, WUV4)
% plotGlass_crNdxvsOriDiff_grat(WVV1, WVV4)
% plotGlass_crNdxvsOriDiff_grat(XTV1, XTV4)

%%
% % makeSprinkleThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)

%% grating vs Glass preferred orientation
[WUV1.gratLE,WUV1.gratRE] = Glass_gratOriVSglassOri(WUV1);
[WUV4.gratLE,WUV4.gratRE] = Glass_gratOriVSglassOri(WUV4);

[WVV1.gratLE,WVV1.gratRE] = Glass_gratOriVSglassOri(WVV1);
[WVV4.gratLE,WVV4.gratRE] = Glass_gratOriVSglassOri(WVV4);

[XTV4.gratLE,XTV4.gratRE] = Glass_gratOriVSglassOri(XTV4);
%%
[WUV1.gratLEallParams,WUV1.gratREallParams] = Glass_gratOriVSglassOri_allParams(WUV1);
[WUV4.gratLEallParams,WUV4.gratREallParams] = Glass_gratOriVSglassOri_allParams(WUV4);

[WVV1.gratLEallParams,WVV1.gratREallParams] = Glass_gratOriVSglassOri_allParams(WVV1);
[WVV4.gratLEallParams,WVV4.gratREallParams] = Glass_gratOriVSglassOri_allParams(WVV4);

[XTV4.gratLEallParams,XTV4.gratREallParams] = Glass_gratOriVSglassOri_allParams(XTV4);
%% sprinkle plots
% if plotSprinkles == 1
% [XTV1.conConsistGlass, XTV1.radConsistGlass] = GlassPrefOrivsExpected(XTV1);
% [XTV4.conConsistGlass, XTV4.radConsistGlass] = GlassPrefOrivsExpected(XTV4);
% 
% [WUV1.conConsistGlass, WUV1.radConsistGlass] = GlassPrefOrivsExpected(WUV1);
% [WUV4.conConsistGlass, WUV4.radConsistGlass] = GlassPrefOrivsExpected(WUV4);
% 
% [WVV1.conConsistGlass, WVV1.radConsistGlass] = GlassPrefOrivsExpected(WVV1);
% [WVV4.conConsistGlass, WVV4.radConsistGlass] = GlassPrefOrivsExpected(WVV4);

%     [XTV1.conConsistGrat, XTV1.radConsistGrat] = gratPrefOriVSglassexpected(XTV1);
% [XTV4.conConsistGrat, XTV4.radConsistGrat] = gratPrefOriVSglassexpected(XTV4);
% 
% [WUV1.conConsistGrat, WUV1.radConsistGrat] = gratPrefOriVSglassexpected(WUV1);
% [WUV4.conConsistGrat, WUV4.radConsistGrat] = gratPrefOriVSglassexpected(WUV4);
% 
% [WVV1.conConsistGrat, WVV1.radConsistGrat] = gratPrefOriVSglassexpected(WVV1);
% [WVV4.conConsistGrat, WVV4.radConsistGrat] = gratPrefOriVSglassexpected(WVV4);
% % end

%%
% dPrimeVdipole_thesis(XTdata,WUdata,WVdata)
% dPrimeVblank_thesis(XTdata,WUdata,WVdata)

