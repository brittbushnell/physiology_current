function plotGlassZscore_xAnimal(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

figure(12)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000])
hold on
s = suptitle('Glass pattern z scores for each pattern in center of stimuli');
s.FontAngle = 'italic';
s.FontSize = 18;
s.FontWeight = 'bold';

plotGlassZscoreHist_eyes_monks(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

figName = 'GlassSumZscore_AllMonk.pdf';
print(gcf,figName,'-dpdf','-fillpage')
%%
figure(13)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 400 400])

plotGlassZscore_xAnimal_summary(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

figName = 'GlassSumZscore_summary.pdf';
print(gcf,figName,'-dpdf','-fillpage')
