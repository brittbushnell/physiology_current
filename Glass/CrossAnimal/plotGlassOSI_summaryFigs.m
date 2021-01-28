function plotGlassOSI_summaryFigs(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
%% LE vs RE OSI
XTV1LE = XTV1.trLE.prefOSIinStim;
XTV1RE = XTV1.trRE.prefOSIinStim;
XTV4LE = XTV4.trLE.prefOSIinStim;
XTV4RE = XTV4.trRE.prefOSIinStim;

WUV1LE = WUV1.trLE.prefOSIinStim;
WUV1RE = WUV1.trRE.prefOSIinStim;
WUV4LE = WUV4.trLE.prefOSIinStim;
WUV4RE = WUV4.trRE.prefOSIinStim;

WVV1LE = WVV1.trLE.prefOSIinStim;
WVV1RE = WVV1.trRE.prefOSIinStim;
WVV4LE = WVV4.trLE.prefOSIinStim;
WVV4RE = WVV4.trRE.prefOSIinStim;

figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 400 400])
set(gcf,'PaperOrientation','Landscape');

hold on
plot([0 1], [0 1],':k')
axis square
set(gca,'TickDir','out','FontSize',12,'FontAngle','italic','YTick',0:0.2:1,'XTick',0:0.2:1)
scatter(nanmedian(XTV1LE),nanmedian(XTV1RE),50,'r','MarkerEdgeAlpha',0.7)
scatter(nanmedian(WVV1LE),nanmedian(WVV1RE),50,'r','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
scatter(nanmedian(WUV1LE),nanmedian(WUV1RE),50,'r','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)

scatter(nanmedian(XTV4LE),nanmedian(XTV4RE),50,'b','MarkerEdgeAlpha',0.7)
scatter(nanmedian(WVV4LE),nanmedian(WVV4RE),50,'b','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
scatter(nanmedian(WUV4LE),nanmedian(WUV4RE),50,'b','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)

title('median OSI','FontSize',16,'FontWeight','bold','FontAngle','italic');
ylabel('RE OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('LE OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');

text(0.05, 0.95, 'V1','color','b','FontSize',12,'FontWeight','bold','FontAngle','italic');
text(0.11, 0.95, 'V4','color','r','FontSize',12,'FontWeight','bold','FontAngle','italic');

text(0.07, 0.9, 'Amblyopic','FontSize',12,'FontWeight','bold','FontAngle','italic');
text(0.07, 0.85, 'Control','FontSize',12,'FontWeight','bold','FontAngle','italic');
plot(0.05,0.9,'ok')
plot(0.05,0.85,'ok','MarkerFaceColor','k')
figName = 'GlassOSI_LEvRE.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%% Radial vs Concentric OSI
XTV1LEradOSI = mean(XTV1.conRadLE.radOSI);
XTV1REradOSI = mean(XTV1.conRadRE.radOSI);
XTV4LEradOSI = mean(XTV4.conRadLE.radOSI);
XTV4REradOSI = mean(XTV4.conRadRE.radOSI);

XTV1LEconOSI = mean(XTV1.conRadLE.conOSI);
XTV1REconOSI = mean(XTV1.conRadRE.conOSI);
XTV4LEconOSI = mean(XTV4.conRadLE.conOSI);
XTV4REconOSI = mean(XTV4.conRadRE.conOSI);

WVV1LEradOSI = mean(WVV1.conRadLE.radOSI);
WVV1REradOSI = mean(WVV1.conRadRE.radOSI);
WVV4LEradOSI = mean(WVV4.conRadLE.radOSI);
WVV4REradOSI = mean(WVV4.conRadRE.radOSI);

WVV1LEconOSI = mean(WVV1.conRadLE.conOSI);
WVV1REconOSI = mean(WVV1.conRadRE.conOSI);
WVV4LEconOSI = mean(WVV4.conRadLE.conOSI);
WVV4REconOSI = mean(WVV4.conRadRE.conOSI);

WUV1LEradOSI = mean(WUV1.conRadLE.radOSI);
WUV1REradOSI = mean(WUV1.conRadRE.radOSI);
WUV4LEradOSI = mean(WUV4.conRadLE.radOSI);
WUV4REradOSI = mean(WUV4.conRadRE.radOSI);

WUV1LEconOSI = mean(WUV1.conRadLE.conOSI);
WUV1REconOSI = mean(WUV1.conRadRE.conOSI);
WUV4LEconOSI = mean(WUV4.conRadLE.conOSI);
WUV4REconOSI = mean(WUV4.conRadRE.conOSI);

%%
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 400 400])
set(gcf,'PaperOrientation','Landscape');

hold on
plot([0 1], [0 1],':k')
axis square
set(gca,'TickDir','out','FontSize',12,'FontAngle','italic','YTick',0:0.2:1,'XTick',0:0.2:1)

scatter(XTV1LEconOSI,XTV1LEradOSI,50,'b','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(XTV4LEconOSI,XTV4LEradOSI,50,'r','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WVV1LEconOSI,WVV1LEradOSI,50,'b','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WVV4LEconOSI,WVV4LEradOSI,50,'r','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WUV1LEconOSI,WUV1LEradOSI,50,'b','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WUV4LEconOSI,WUV4LEradOSI,50,'r','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)


scatter(XTV1REconOSI,XTV1REradOSI,52,'b','s','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(XTV4REconOSI,XTV4REradOSI,52,'r','s','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WVV1REconOSI,WVV1REradOSI,52,'b','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WVV4REconOSI,WVV4REradOSI,52,'r','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WUV1REconOSI,WUV1REradOSI,52,'b','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WUV4REconOSI,WUV4REradOSI,52,'r','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

text(0.05, 0.95, 'V1','color','b','FontSize',12,'FontWeight','bold','FontAngle','italic');
text(0.11, 0.95, 'V4','color','r','FontSize',12,'FontWeight','bold','FontAngle','italic');

text(0.07, 0.9, 'Amblyopic','FontSize',12,'FontAngle','italic');
text(0.07, 0.85, 'Control','FontSize',12,'FontAngle','italic');
plot(0.05,0.9,'ok')
plot(0.05,0.85,'ok','MarkerFaceColor','k')

ylabel('radial OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('concentric OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
title('OSI for channels prefer radial vs concentric')

figName = 'GlassOSI_radVcon_1plot.pdf';
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(9)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 700 400])
set(gcf,'PaperOrientation','Landscape');

subplot (1,2,1)
hold on
plot([0 1], [0 1],':k')
axis square
set(gca,'TickDir','out','FontSize',12,'FontAngle','italic','YTick',0:0.2:1,'XTick',0:0.2:1)

scatter(XTV1LEconOSI,XTV1LEradOSI,50,'b','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(XTV4LEconOSI,XTV4LEradOSI,50,'r','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WVV1LEconOSI,WVV1LEradOSI,50,'b','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WVV4LEconOSI,WVV4LEradOSI,50,'r','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WUV1LEconOSI,WUV1LEradOSI,50,'b','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WUV4LEconOSI,WUV4LEradOSI,50,'r','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

ylabel('radial OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('concentric OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
title('LE/FE')
text(0.05, 0.95, 'V1','color','b','FontSize',12,'FontWeight','bold','FontAngle','italic');
text(0.13, 0.95, 'V4','color','r','FontSize',12,'FontWeight','bold','FontAngle','italic');

text(0.07, 0.9, 'Amblyopic','FontSize',12,'FontAngle','italic');
text(0.07, 0.85, 'Control','FontSize',12,'FontAngle','italic');
plot(0.05,0.9,'ok')
plot(0.05,0.85,'ok','MarkerFaceColor','k')


subplot (1,2,2)
hold on
plot([0 1], [0 1],':k')
axis square
set(gca,'TickDir','out','FontSize',12,'FontAngle','italic','YTick',0:0.2:1,'XTick',0:0.2:1)
scatter(XTV1REconOSI,XTV1REradOSI,52,'b','s','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(XTV4REconOSI,XTV4REradOSI,52,'r','s','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WVV1REconOSI,WVV1REradOSI,52,'b','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WVV4REconOSI,WVV4REradOSI,52,'r','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)

scatter(WUV1REconOSI,WUV1REradOSI,52,'b','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
scatter(WUV4REconOSI,WUV4REradOSI,52,'r','s','filled','MarkerEdgeAlpha',0.55,'MarkerFaceAlpha',0.55)
title('RE/AE')

suptitle('OSI for channels prefer radial vs concentric')

figName = 'GlassOSI_radVcon_2plots.pdf';
print(gcf, figName,'-dpdf','-fillpage')
