function plotGlassZscoreHist_eyesTogether(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

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
%% get preferences
allZs = [XTV1ConRE;XTV1ConLE;XTV4ConRE;XTV4ConLE;...
    XTV1RadRE;XTV1RadLE;XTV4RadRE;XTV4RadLE;...
    XTV1NozRE;XTV1NozLE;XTV4NozRE;XTV4NozLE;...
    WVV1ConRE;WVV1ConLE;WVV4ConRE;WVV4ConLE;...
    WVV1RadRE;WVV1RadLE;WVV4RadRE;WVV4RadLE;...
    WVV1NozRE;WVV1NozLE;WVV4NozRE;WVV4NozLE;...
    WUV1ConRE;WUV1ConLE;WUV4ConRE;WUV4ConLE;...
    WUV1RadRE;WUV1RadLE;WUV4RadRE;WUV4RadLE;...
    WUV1NozRE;WUV1NozLE;WUV4NozRE;WUV4NozLE];

xMax = max(allZs);
xMax = xMax+(xMax/10);
xMin = -xMax;
%%
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000])
hold on
suptitle('Summed Z scores across stimuli for LE vs RE')

s = subplot(6,3,1);
hold on
xlim([xMin xMax])
ylim([0 0.9])
text(0, 1.5,'XT','FontSize',20,'FontAngle','italic','FontWeight','bold')
histogram(XTV1ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV1ConLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1ConLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV1ConLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV1ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV1ConRE),0.6,'v','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1ConRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV1ConRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Concentric','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) + 0.055;

if contains(XTV1.trLE.animal,'XT')
    text(xMin +5, 0.8,'RE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
    text(xMin +5, 0.65,'LE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
else
    text(xMin +5, 0.8,'AE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
    text(xMin +5, 0.65,'FE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
end
s.Position(1) = s.Position(1) - 0.085;

s = subplot(6,3,4);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV1RadLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1RadLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV1RadLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV1RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV1RadRE),0.6,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1RadRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV1RadRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Radial','FontSize',14,'FontAngle','italic')
y = ylabel('V1','FontSize',18,'FontAngle','italic','FontWeight','bold','Rotation',0);
y.Position(1) = y.Position(1) - 20;
s.Position(1) = s.Position(1) - 0.085;
s.Position(2) = s.Position(2) + 0.045;

s = subplot(6,3,7);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV1NozLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1NozLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV1NozLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV1NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV1NozRE),0.6,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV1NozRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV1NozRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Dipole','FontSize',14,'FontAngle','italic')
s.Position(1) = s.Position(1) - 0.085;
s.Position(2) = s.Position(2) + 0.027;

% V4
s = subplot(6,3,10);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV4ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV4ConLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4ConLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV4ConLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV4ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV4ConRE),0.6,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4ConRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV4ConRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Concentric','FontSize',14,'FontAngle','italic')
s.Position(1) = s.Position(1) - 0.085;
s.Position(2) = s.Position(2) - 0.03;


s = subplot(6,3,13);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV4RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV4RadLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4RadLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV4RadLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV4RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV4ConLE),0.6,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4RadRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV4RadRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
y = ylabel('V4','FontSize',18,'FontAngle','italic','FontWeight','bold','Rotation',0);
title('Radial','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) - 0.037;
s.Position(1) = s.Position(1) - 0.085;
y.Position(1) = y.Position(1) - 20;

s = subplot(6,3,16);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV4NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV4NozLE),0.6,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4NozLE)-10,0.7,sprintf('LE %.2f',nanmedian(XTV4NozLE)),'FontSize',12,'FontAngle','italic')

histogram(XTV4NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV4NozRE),0.6,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(nanmedian(XTV4NozRE)-10,0.82,sprintf('RE %.2f',nanmedian(XTV4NozRE)),'FontSize',12,'FontAngle','italic')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Dipole','FontSize',14,'FontAngle','italic')
xlabel('Summed z score','FontSize',14,'FontAngle','italic')
ylabel('Proportion','FontSize',14,'FontAngle','italic')
s.Position(1) = s.Position(1) - 0.085;
s.Position(2) = s.Position(2) - 0.053; 