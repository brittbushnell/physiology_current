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

text(xMin +5, 0.8,'RE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
text(xMin +5, 0.65,'LE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
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