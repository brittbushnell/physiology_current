function plotGlassZscore_xAnimal_summary(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

XTV1ConRE = XTV1.conRadRE.prefConZsInCenter;
XTV1RadRE = XTV1.conRadRE.prefRadZsInCenter;
XTV1NozRE = XTV1.conRadRE.prefNozZsInCenter;

XTV1ConLE = XTV1.conRadLE.prefConZsInCenter;
XTV1RadLE = XTV1.conRadLE.prefRadZsInCenter;
XTV1NozLE = XTV1.conRadLE.prefNozZsInCenter;

XTV4ConRE = XTV4.conRadRE.prefConZsInCenter;
XTV4RadRE = XTV4.conRadRE.prefRadZsInCenter;
XTV4NozRE = XTV4.conRadRE.prefNozZsInCenter;

XTV4ConLE = XTV4.conRadLE.prefConZsInCenter;
XTV4RadLE = XTV4.conRadLE.prefRadZsInCenter;
XTV4NozLE = XTV4.conRadLE.prefNozZsInCenter;

WUV1ConRE = WUV1.conRadRE.prefConZsInCenter;
WUV1RadRE = WUV1.conRadRE.prefRadZsInCenter;
WUV1NozRE = WUV1.conRadRE.prefNozZsInCenter;

WUV1ConLE = WUV1.conRadLE.prefConZsInCenter;
WUV1RadLE = WUV1.conRadLE.prefRadZsInCenter;
WUV1NozLE = WUV1.conRadLE.prefNozZsInCenter;

WUV4ConRE = WUV4.conRadRE.prefConZsInCenter;
WUV4RadRE = WUV4.conRadRE.prefRadZsInCenter;
WUV4NozRE = WUV4.conRadRE.prefNozZsInCenter;

WUV4ConLE = WUV4.conRadLE.prefConZsInCenter;
WUV4RadLE = WUV4.conRadLE.prefRadZsInCenter;
WUV4NozLE = WUV4.conRadLE.prefNozZsInCenter;

WVV1ConRE = WVV1.conRadRE.prefConZsInCenter;
WVV1RadRE = WVV1.conRadRE.prefRadZsInCenter;
WVV1NozRE = WVV1.conRadRE.prefNozZsInCenter;

WVV1ConLE = WVV1.conRadLE.prefConZsInCenter;
WVV1RadLE = WVV1.conRadLE.prefRadZsInCenter;
WVV1NozLE = WVV1.conRadLE.prefNozZsInCenter;

WVV4ConRE = WVV4.conRadRE.prefConZsInCenter;
WVV4RadRE = WVV4.conRadRE.prefRadZsInCenter;
WVV4NozRE = WVV4.conRadRE.prefNozZsInCenter;

WVV4ConLE = WVV4.conRadLE.prefConZsInCenter;
WVV4RadLE = WVV4.conRadLE.prefRadZsInCenter;
WVV4NozLE = WVV4.conRadLE.prefNozZsInCenter;
%%
allZs = [XTV1ConRE;XTV1ConLE;XTV4ConRE;XTV4ConLE;...
    XTV1RadRE;XTV1RadLE;XTV4RadRE;XTV4RadLE;...
    XTV1NozRE;XTV1NozLE;XTV4NozRE;XTV4NozLE];

xMax = max(allZs);
xMax = xMax+(xMax/10);
xMin = -xMax;
%%
figure(13)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 400 400])

hold on
xlim([-100 100])
ylim([-100 100])
axis square
% concentric
scatter(nanmedian(XTV1ConLE),nanmedian(XTV1ConRE),70,'d','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(XTV4ConLE),nanmedian(XTV4ConRE),70,'d','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WUV1ConLE),nanmedian(WUV1ConRE),70,'o','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WUV4ConLE),nanmedian(WUV4ConRE),70,'o','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WVV1ConLE),nanmedian(WVV1ConRE),70,'o','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WVV4ConLE),nanmedian(WVV4ConRE),70,'o','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

% radial
scatter(nanmedian(XTV1RadLE),nanmedian(XTV1RadRE),70,'d','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(XTV4RadLE),nanmedian(XTV4RadRE),70,'d','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WUV1RadLE),nanmedian(WUV1RadRE),70,'o','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WUV4RadLE),nanmedian(WUV4RadRE),70,'o','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WVV1RadLE),nanmedian(WVV1RadRE),70,'o','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WVV4RadLE),nanmedian(WVV4RadRE),70,'o','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

% dipole
scatter(nanmedian(XTV1NozLE),nanmedian(XTV1NozRE),70,'d','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(XTV4NozLE),nanmedian(XTV4NozRE),70,'d','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WUV1NozLE),nanmedian(WUV1NozRE),70,'o','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WUV4NozLE),nanmedian(WUV4NozRE),70,'o','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(nanmedian(WVV1NozLE),nanmedian(WVV1NozRE),70,'o','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6,'LineWidth',1.5)
scatter(nanmedian(WVV4NozLE),nanmedian(WVV4NozRE),70,'o','MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

plot([-100 100], [-100 100],'k:')

plot(-90,90,'ok')
text(-85,90,'V1')

plot(-90,80,'ok','MarkerFaceColor','k')
text(-85,80,'V4')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')

title('Median summed z scores V1 and V4','FontSize',18,'FontAngle','italic')
ylabel('RE/AE')
xlabel('LE/FE')
