function [V1,V4] = PlotGlassZscoresCenterStimByPref(V1, V4)

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
%% LE 

% V1
s = subplot(6,2,1); 
hold on
xlim([xMin xMax])
ylim([0 0.8])
histogram(V1prefConZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0.7 0 0.7],'Normalization','probability')
plot([nanmedian(V1prefConZsLE),nanmedian(V1prefConZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefConZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefConZsLE)),'FontSize',12,'FontAngle','italic')

if contains(V1.trLE.animal,'XT')
    title(sprintf('LE n%d', length(V1prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else
    title(sprintf('FE n%d', length(V1prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) - 0.015;
s.Position(4) = s.Position(4) -0.02;
text(xMin+2, 0.75, 'concentric','FontWeight','bold','FontAngle','italic','Color',[0.7 0 0.7]);


s = subplot(6,2,3); 
hold on
 xlim([xMin xMax])
ylim([0 0.8])
histogram(V1prefRadZsLE,'BinWidth',10,'EdgeColor','w','EdgeColor','w','FaceColor',[0 0.6 0.2],'Normalization','probability')
plot([nanmedian(V1prefRadZsLE),nanmedian(V1prefRadZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefRadZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefRadZsLE)),'FontSize',12,'FontAngle','italic')
ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');

text(xMin + (xMin/1.7),0.18,'V1','FontSize',20,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) + 0.013;
s.Position(4) = s.Position(4) -0.02;
text(xMin+2, 0.75, 'radial','FontWeight','bold','FontAngle','italic','Color',[0 0.6 0.2]);


s = subplot(6,2,5); 
hold on
xlim([xMin xMax])
ylim([0 0.8])
histogram(V1prefNozZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[1 0.5 0.1],'Normalization','probability')
plot([nanmedian(V1prefNozZsLE),nanmedian(V1prefNozZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefNozZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefNozZsLE)),'FontSize',12,'FontAngle','italic')
ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) + 0.04;
s.Position(4) = s.Position(4) -0.02;
text(xMin+2, 0.75, 'dipole','FontWeight','bold','FontAngle','italic','Color',[1 0.5 0.1]);

%%
% V4
s = subplot(6,2,7); 
hold on

xlim([xMin xMax])
ylim([0 0.8])
histogram(V4prefConZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0.7 0 0.7],'Normalization','probability')
plot([nanmedian(V4prefConZsLE),nanmedian(V4prefConZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefConZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefConZsLE)),'FontSize',12,'FontAngle','italic')

if contains(V1.trLE.animal,'XT')
    title(sprintf('LE n%d', length(V4prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else
    title(sprintf('FE n%d', length(V4prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) - 0.015;
s.Position(4) = s.Position(4) -0.02;


s = subplot(6,2,9); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V4prefRadZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.6 0.2],'Normalization','probability')
plot([nanmedian(V4prefRadZsLE),nanmedian(V4prefRadZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefRadZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefRadZsLE)),'FontSize',12,'FontAngle','italic')
ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');

text(xMin + (xMin/1.7),0.18,'V4','FontSize',20,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) + 0.013;
s.Position(4) = s.Position(4) -0.02;

s = subplot(6,2,11); 
hold on

xlim([xMin xMax])
ylim([0 0.8])
histogram(V4prefNozZsLE,'BinWidth',10,'EdgeColor','w','FaceColor',[1 0.5 0.1],'Normalization','probability')
plot([nanmedian(V4prefNozZsLE),nanmedian(V4prefNozZsLE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefNozZsLE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefNozZsLE)),'FontSize',12,'FontAngle','italic')

ylabel('proportion','FontSize',17,'FontWeight','bold','FontAngle','italic');
xlabel('z score','FontSize',17,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) + 0.04;
s.Position(4) = s.Position(4) -0.02;
%% RE
% V1
s = subplot(6,2,2); 
hold on

xlim([xMin xMax])
ylim([0 0.8])
histogram(V1prefConZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[0.7 0 0.7],'Normalization','probability')
plot([nanmedian(V1prefConZsRE),nanmedian(V1prefConZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefConZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefConZsRE)),'FontSize',12,'FontAngle','italic')

if contains(V1.trRE.animal,'XT')
    title(sprintf('RE n%d', length(V1prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else
    title(sprintf('AE n%d', length(V1prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end

s.Position(2) = s.Position(2) - 0.015;
s.Position(4) = s.Position(4) -0.02;


s = subplot(6,2,4); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V1prefRadZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.6 0.2],'Normalization','probability')
plot([nanmedian(V1prefRadZsRE),nanmedian(V1prefRadZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefRadZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefRadZsRE)),'FontSize',12,'FontAngle','italic')

s.Position(2) = s.Position(2) + 0.013;
s.Position(4) = s.Position(4) -0.02;

s = subplot(6,2,6); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V1prefNozZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[1 0.5 0.1],'Normalization','probability')
plot([nanmedian(V1prefNozZsRE),nanmedian(V1prefNozZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V1prefNozZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V1prefNozZsRE)),'FontSize',12,'FontAngle','italic')
s.Position(2) = s.Position(2) + 0.04;
s.Position(4) = s.Position(4) -0.02;

% V4
s = subplot(6,2,8); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V4prefConZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[0.7 0 0.7],'Normalization','probability')
plot([nanmedian(V4prefConZsRE),nanmedian(V4prefConZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefConZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefConZsRE)),'FontSize',12,'FontAngle','italic')

if contains(V4.trRE.animal,'XT')
    title(sprintf('RE n%d', length(V4prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else
    title(sprintf('AE n%d', length(V4prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end

s.Position(2) = s.Position(2) - 0.015;
s.Position(4) = s.Position(4) -0.02;


s = subplot(6,2,10); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V4prefRadZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[0 0.6 0.2],'Normalization','probability')
plot([nanmedian(V4prefRadZsRE),nanmedian(V4prefRadZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefRadZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefRadZsRE)),'FontSize',12,'FontAngle','italic')

s.Position(2) = s.Position(2) + 0.013;
s.Position(4) = s.Position(4) -0.02;

s = subplot(6,2,12); 
hold on

xlim([xMin xMax])
ylim([0 0.8])

histogram(V4prefNozZsRE,'BinWidth',10,'EdgeColor','w','FaceColor',[1 0.5 0.1],'Normalization','probability')
plot([nanmedian(V4prefNozZsRE),nanmedian(V4prefNozZsRE)],[0 0.7],'k:')

set(gca,'TickDir','out','FontSize',11,'FontAngle','italic','Layer','top','YTick',0:0.2:0.8)
text(nanmedian(V4prefNozZsRE)-0.3,0.75,sprintf('median %.2f',nanmedian(V4prefNozZsRE)),'FontSize',12,'FontAngle','italic')
xlabel('z score','FontSize',17,'FontWeight','bold','FontAngle','italic');

s.Position(2) = s.Position(2) + 0.04;
s.Position(4) = s.Position(4) -0.02;

%% 



