function plotGlassOSI_summaryFigs(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
%%
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
hold on

subplot(2,1,1)

hold on
scatter(XTV1LE,XTV1RE,'k','MarkerEdgeAlpha',0.7)
scatter(WVV1LE,WVV1RE,'k','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
scatter(WUV1LE,WUV1RE,'k','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
plot([0 1], [0 1],':k')
title('V1','FontSize',16,'FontWeight','bold','FontAngle','italic');

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
ylabel('RE','FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('LE','FontSize',14,'FontWeight','bold','FontAngle','italic');

subplot(2,1,2)

hold on
scatter(XTV4LE,XTV4RE,'k','MarkerEdgeAlpha',0.7)
scatter(WVV4LE,WVV4RE,'k','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
scatter(WUV4LE,WUV4RE,'k','filled','MarkerEdgeAlpha',0.7,'MarkerFaceAlpha',0.7)
plot([0 1], [0 1],':k')
title('V4','FontSize',16,'FontWeight','bold','FontAngle','italic');

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
ylabel('RE','FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('LE','FontSize',14,'FontWeight','bold','FontAngle','italic');



