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
%% OSI figures
% [WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4); % fig 1-3
 plotGlassOSIpatterns(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) % figs 4-8
 %%
% makeGlassOrixTypeDiffThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)
% makeGlassOriThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)
%%
[XTV1,XTV4,WUV1, WUV4,WVV1, WVV4] = MakeTriploThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4);
%%

plotGlass_crNdxvsOriDiff(V1data, V4data)

% makeSprinkleThesisFigs(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)
[XTV1.conConsist, XTV1.radConsist] = GlassPrefOrivsExpected(XTV1);
[XTV4.conConsist, XTV4.radConsist] = GlassPrefOrivsExpected(XTV4);

[WUV1.conConsist, WUV1.radConsist] = GlassPrefOrivsExpected(WUV1);
[WUV4.conConsist, WUV4.radConsist] = GlassPrefOrivsExpected(WUV4);

[WVV1.conConsist, WVV1.radConsist] = GlassPrefOrivsExpected(WVV1);
[WVV4.conConsist, WVV4.radConsist] = GlassPrefOrivsExpected(WVV4);

%%
% dPrimeVdipole_thesis(XTdata,WUdata,WVdata)
% dPrimeVblank_thesis(XTdata,WUdata,WVdata)

