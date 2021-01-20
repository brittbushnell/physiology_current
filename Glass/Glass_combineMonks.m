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

cd '/Users/brittany/Dropbox/Figures/CrossAnimals/Glass';
%% all three animals, shapes to ID animal 
figure (1)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');


t = suptitle('Difference between preferred and dominant orientation as a function of OSI');
t.Position(2) = -0.025;
t.FontSize = 18;

plotPrefDomOriDiffVsOSI_monkID(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

figName = 'GlassOriDiff_byQuad_monkID.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%% all three animals, same symbols for each animal
figure (2)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle('Difference between preferred and dominant orientation as a function of OSI');
t.Position(2) = -0.025;
t.FontSize = 18;
plotPrefDomOriDiffVsOSI_noID(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
figName = 'GlassOriDiff_byQuad_noMonkID.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%% all quadrants and animals together
plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
plotGlassOSI_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
