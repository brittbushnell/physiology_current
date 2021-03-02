function plotGlassZscoreHist_eyes_monks(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

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
%% get limits
allZs = [XTV1ConRE;XTV1ConLE;XTV4ConRE;XTV4ConLE;...
    XTV1RadRE;XTV1RadLE;XTV4RadRE;XTV4RadLE;...
    XTV1NozRE;XTV1NozLE;XTV4NozRE;XTV4NozLE];

xMax = max(allZs);
xMax = xMax+(xMax/10);
xMin = -xMax;
%%

s = subplot(6,3,1);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1ConLE)-15,0.7,sprintf('%.2f',nanmedian(XTV1ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV1ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1ConRE)-15,0.8,sprintf('%.2f',nanmedian(XTV1ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-375,0.5,'Concentric','FontSize',14,'FontAngle','italic','FontWeight','bold')

text(xMin +5, 0.8,'RE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
text(xMin +5, 0.65,'LE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
text(0,1.2,'XT','FontSize',18,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) - 0.011;

s = subplot(6,3,4);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1RadLE)-15,0.7,sprintf('%.2f',nanmedian(XTV1RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV1RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1RadRE)-15,0.8,sprintf('%.2f',nanmedian(XTV1RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-350,0.5,'Radial','FontSize',14,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) - 0.011;
s.Position(2) = s.Position(2) + 0.01;

s = subplot(6,3,7);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV1NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1NozLE)-10,0.7,sprintf('%.2f',nanmedian(XTV1NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV1NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV1NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1NozRE)-10,0.82,sprintf('%.2f',nanmedian(XTV1NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-350,0.5,'Dipole','FontSize',14,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) - 0.011;
s.Position(2) = s.Position(2) + 0.023;

s = subplot(6,3,10);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1ConLE)-15,0.7,sprintf('%.2f',nanmedian(XTV1ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV1ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1ConRE)-15,0.8,sprintf('%.2f',nanmedian(XTV1ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-375,0.5,'Concentric','FontSize',14,'FontAngle','italic','FontWeight','bold')

s.Position(1) = s.Position(1) - 0.011;
s.Position(2) = s.Position(2) - 0.0396;


s = subplot(6,3,13);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV1RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1RadLE)-15,0.7,sprintf('%.2f',nanmedian(XTV1RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV1RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(XTV1RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV1RadRE)-15,0.8,sprintf('%.2f',nanmedian(XTV1RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-350,0.5,'Radial','FontSize',14,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) - 0.011;
s.Position(2) = s.Position(2) - 0.037;

s = subplot(6,3,16);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(XTV4NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(XTV4NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV4NozLE)-10,0.7,sprintf('%.2f',nanmedian(XTV4NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(XTV4NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(XTV4NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(XTV4NozRE)-10,0.82,sprintf('%.2f',nanmedian(XTV4NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(-350,0.5,'Dipole','FontSize',14,'FontAngle','italic','FontWeight','bold')
xlabel('Summed z score','FontSize',14,'FontAngle','italic')
s.Position(1) = s.Position(1) - 0.011;
s.Position(2) = s.Position(2)  - 0.027;
% WU
s = subplot(6,3,2);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV1ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV1ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV1ConLE)-15,0.7,sprintf('%.2f',nanmedian(WUV1ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV1ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV1ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV1ConRE)-15,0.8,sprintf('%.2f',nanmedian(WUV1ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)

text(xMin +5, 0.8,'AE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
text(xMin +5, 0.65,'FE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
text(0,1.2,'WU','FontSize',18,'FontAngle','italic','FontWeight','bold')


s = subplot(6,3,5);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV1RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV1RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV1RadLE)-15,0.7,sprintf('%.2f',nanmedian(WUV1RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV1RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV1RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV1RadRE)-15,0.8,sprintf('%.2f',nanmedian(WUV1RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(2) = s.Position(2) + 0.01;

s = subplot(6,3,8);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV4NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(WUV4NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4NozLE)-10,0.7,sprintf('%.2f',nanmedian(WUV4NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV4NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(WUV4NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4NozRE)-10,0.82,sprintf('%.2f',nanmedian(WUV4NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(2) = s.Position(2) + 0.023;

s = subplot(6,3,11);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV4ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV4ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4ConLE)-15,0.7,sprintf('%.2f',nanmedian(WUV4ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV4ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV4ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4ConRE)-15,0.8,sprintf('%.2f',nanmedian(WUV4ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(2) = s.Position(2) - 0.0396;


s = subplot(6,3,14);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV4RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV4RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4RadLE)-15,0.7,sprintf('%.2f',nanmedian(WUV4RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV4RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WUV4RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4RadRE)-15,0.8,sprintf('%.2f',nanmedian(WUV4RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(2) = s.Position(2) - 0.037;

s = subplot(6,3,17);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WUV4NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(WUV4NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4NozLE)-10,0.7,sprintf('%.2f',nanmedian(WUV4NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WUV4NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(WUV4NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WUV4NozRE)-10,0.82,sprintf('%.2f',nanmedian(WUV4NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
xlabel('Summed z score','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2)  - 0.027;

% WV
s = subplot(6,3,3);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV1ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV1ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1ConLE)-15,0.7,sprintf('%.2f',nanmedian(WVV1ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV1ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV1ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1ConRE)-15,0.8,sprintf('%.2f',nanmedian(WVV1ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)

text(0,1.2,'WV','FontSize',18,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) +0.02; 

s = subplot(6,3,6);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV1RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV1RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1RadLE)-15,0.7,sprintf('%.2f',nanmedian(WVV1RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV1RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV1RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1RadRE)-15,0.8,sprintf('%.2f',nanmedian(WVV1RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(270,0.5,'V1','FontSize',20,'FontAngle','italic','FontWeight','bold')
s.Position(1) = s.Position(1) +0.02; 
s.Position(2) = s.Position(2) + 0.01;

s = subplot(6,3,9);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV1NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(WVV1NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1NozLE)-10,0.7,sprintf('%.2f',nanmedian(WVV1NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV1NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(WVV1NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV1NozRE)-10,0.82,sprintf('%.2f',nanmedian(WVV1NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(1) = s.Position(1) +0.02; 
s.Position(2) = s.Position(2) + 0.023;

s = subplot(6,3,12);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV4ConLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV4ConLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4ConLE)-15,0.7,sprintf('%.2f',nanmedian(WVV4ConLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV4ConRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV4ConRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4ConRE)-15,0.8,sprintf('%.2f',nanmedian(WVV4ConRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
s.Position(1) = s.Position(1) +0.02; 
s.Position(2) = s.Position(2) - 0.0396;


s = subplot(6,3,15);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV4RadLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV4RadLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4RadLE)-15,0.7,sprintf('%.2f',nanmedian(WVV4RadLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV4RadRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability','EdgeAlpha',0.7)
scatter(nanmedian(WVV4RadRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4RadRE)-15,0.8,sprintf('%.2f',nanmedian(WVV4RadRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(270,0.5,'V4','FontSize',20,'FontAngle','italic','FontWeight','bold')

s.Position(1) = s.Position(1) +0.02; 
s.Position(2) = s.Position(2) - 0.037;

s = subplot(6,3,18);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(WVV4NozLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
scatter(nanmedian(WVV4NozLE),0.6,60,'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4NozLE)-10,0.7,sprintf('%.2f',nanmedian(WVV4NozLE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color',[0 0.2 0.8])

histogram(WVV4NozRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
scatter(nanmedian(WVV4NozRE),0.6,60,'v','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
text(nanmedian(WVV4NozRE)-10,0.82,sprintf('%.2f',nanmedian(WVV4NozRE)),'FontSize',12,'FontAngle','italic','FontWeight','bold','Color','r')

plot([0 0], [0 0.8],':k')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
xlabel('Summed z score','FontSize',14,'FontAngle','italic')
s.Position(1) = s.Position(1) +0.02; 
s.Position(2) = s.Position(2)  - 0.027;