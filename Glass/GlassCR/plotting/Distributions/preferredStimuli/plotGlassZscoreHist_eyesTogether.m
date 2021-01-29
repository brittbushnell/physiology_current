function plotGlassZscoreHist_eyesTogether(V1, V4)

fprintf('\n *****Change all markers to arrows rather than lines in zscore hists *****\n')

V1prefConZsRE = V1.conRadRE.prefConZsInCenter;
V1prefRadZsRE = V1.conRadRE.prefRadZsInCenter;
V1prefNozZsRE = V1.conRadRE.prefNozZsInCenter;

V1prefConZsLE = V1.conRadLE.prefConZsInCenter;
V1prefRadZsLE = V1.conRadLE.prefRadZsInCenter;
V1prefNozZsLE = V1.conRadLE.prefNozZsInCenter;

V4prefConZsRE = V4.conRadRE.prefConZsInCenter;
V4prefRadZsRE = V4.conRadRE.prefRadZsInCenter;
V4prefNozZsRE = V4.conRadRE.prefNozZsInCenter;

V4prefConZsLE = V4.conRadLE.prefConZsInCenter;
V4prefRadZsLE = V4.conRadLE.prefRadZsInCenter;
V4prefNozZsLE = V4.conRadLE.prefNozZsInCenter;
%% get preferences
allZs = [V1prefConZsRE;V1prefConZsLE;V4prefConZsRE;V4prefConZsLE;...
    V1prefRadZsRE;V1prefRadZsLE;V4prefRadZsRE;V4prefRadZsLE;...
    V1prefNozZsRE;V1prefNozZsLE;V4prefNozZsRE;V4prefNozZsLE];

xMax = max(allZs);
xMax = xMax+(xMax/10);
xMin = -xMax;
%%

s = subplot(6,1,1);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V1prefConZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V1prefConZsLE),0.067],'v','MarkerFaceColor',[0 0.2 0.8],'MarkerEdgeColor',[0 0.2 0.8])
text(nanmedian(V1prefConZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V1prefConZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V1prefConZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V1prefConZsRE),nanmedian(V1prefConZsRE)],[0 0.7],'k:')
text(nanmedian(V1prefConZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V1prefConZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Concentric','FontSize',16,'FontAngle','italic')
s.Position(2) = s.Position(2) + 0.055;

if contains(V1.trLE.animal,'XT')
    text(xMin +5, 0.8,'RE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
    text(xMin +5, 0.65,'LE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
else
    text(xMin +5, 0.8,'AE','color','r','FontSize',14,'FontAngle','italic','FontWeight','bold')
    text(xMin +5, 0.65,'FE','color',[0 0.2 0.8],'FontSize',14,'FontAngle','italic','FontWeight','bold')
end

s = subplot(6,1,2);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V1prefRadZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V1prefRadZsLE),nanmedian(V1prefRadZsLE)],[0 0.7],'k:')
text(nanmedian(V1prefRadZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V1prefRadZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V1prefRadZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V1prefRadZsRE),nanmedian(V1prefRadZsRE)],[0 0.7],'k:')
text(nanmedian(V1prefRadZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V1prefRadZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Radial','FontSize',14,'FontAngle','italic')
y = ylabel('V1','FontSize',18,'FontAngle','italic','FontWeight','bold','Rotation',0);
y.Position(1) = y.Position(1) - 15;

s.Position(2) = s.Position(2) + 0.045;

s = subplot(6,1,3);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V1prefNozZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V1prefNozZsLE),nanmedian(V1prefNozZsLE)],[0 0.7],'k:')
text(nanmedian(V1prefNozZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V1prefNozZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V1prefNozZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V1prefNozZsRE),nanmedian(V1prefNozZsRE)],[0 0.7],'k:')
text(nanmedian(V1prefNozZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V1prefNozZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Dipole','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) + 0.027;

% V4
s = subplot(6,1,4);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V4prefConZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V4prefConZsLE),nanmedian(V4prefConZsLE)],[0 0.7],'k:')
text(nanmedian(V4prefConZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V4prefConZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V4prefConZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V4prefConZsRE),nanmedian(V4prefConZsRE)],[0 0.7],'k:')
text(nanmedian(V4prefConZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V4prefConZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Concentric','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) - 0.03;


s = subplot(6,1,5);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V4prefRadZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V4prefRadZsLE),nanmedian(V4prefRadZsLE)],[0 0.7],'k:')
text(nanmedian(V4prefRadZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V4prefRadZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V4prefRadZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V4prefRadZsRE),nanmedian(V4prefRadZsRE)],[0 0.7],'k:')
text(nanmedian(V4prefRadZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V4prefRadZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Radial','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) - 0.037;
y = ylabel('V4','FontSize',18,'FontAngle','italic','FontWeight','bold','Rotation',0);
y.Position(1) = y.Position(1) - 15;

s = subplot(6,1,6);
hold on
xlim([xMin xMax])
ylim([0 0.9])

histogram(V4prefNozZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.2 0.8],'Normalization','probability')
plot([nanmedian(V4prefNozZsLE),nanmedian(V4prefNozZsLE)],[0 0.7],'k:')
text(nanmedian(V4prefNozZsLE)-10,0.7,sprintf('LE %.2f',nanmedian(V4prefNozZsLE)),'FontSize',12,'FontAngle','italic')

histogram(V4prefNozZsRE,'BinWidth',10,'EdgeColor','w','FaceColor','r','Normalization','probability')
plot([nanmedian(V4prefNozZsRE),nanmedian(V4prefNozZsRE)],[0 0.7],'k:')
text(nanmedian(V4prefNozZsRE)-10,0.82,sprintf('RE %.2f',nanmedian(V4prefNozZsRE)),'FontSize',12,'FontAngle','italic')

% plot([0 0], [0 0.8],'-','color',[0.6 0.6 0.6])

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
title('Dipole','FontSize',14,'FontAngle','italic')
xlabel('Summed z score','FontSize',14,'FontAngle','italic')
ylabel('Proportion','FontSize',14,'FontAngle','italic')
s.Position(2) = s.Position(2) - 0.053; 