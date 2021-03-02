function [] = plotGlassOSIpatterns(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
%%
% figure (1)
% clf
% hold on
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1000 800])
% set(gcf,'PaperOrientation','Landscape');
% 
% 
% t = suptitle('Difference between preferred and dominant orientation as a function of OSI');
% t.Position(2) = -0.025;
% t.FontSize = 18;
% 
% plotPrefDomOriDiffVsOSI_monkID(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
% 
% figName = 'GlassOriDiff_byQuad_monkID.pdf';
% print(gcf, figName,'-dpdf','-bestfit')
%% all three animals, same symbols for each animal
figure (4)
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
%% OSI distributions all quadrants and animals together 
% plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
[WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotGlassOSI_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4); % fig 5-6
%% summary figures
plotGlassOSI_summaryFigs(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) % fig 7-8

