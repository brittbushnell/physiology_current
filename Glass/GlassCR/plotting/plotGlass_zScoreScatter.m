function plotGlass_zScoreScatter(V1,V4)

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

allZs = [V1prefConZsRE;V1prefConZsLE;V4prefConZsRE;V4prefConZsLE;...
    V1prefRadZsRE;V1prefRadZsLE;V4prefRadZsRE;V4prefRadZsLE;...
    V1prefNozZsRE;V1prefNozZsLE;V4prefNozZsRE;V4prefNozZsLE];

yMax = max(allZs);
yMax = yMax+(yMax/10);

yMin = min(allZs);
yMin = yMin-(yMin/10);
%%
s = subplot(2,2,1);
hold on
scatter(1:length(V1prefConZsLE),V1prefConZsLE,25,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V1prefRadZsLE),V1prefRadZsLE,25,'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V1prefNozZsLE),V1prefNozZsLE,25,'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
plot([0 length(V1prefNozZsLE)],[0 0],'-','color',[0.6 0.6 0.6])
set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
ylabel({'V1';'z score'},'FontSize',14,'FontWeight','bold','FontAngle','italic');
ylim([yMin yMax])
xlim([0 length(V1prefConZsLE)])
if contains(V1.trLE.animal,'XT')
    title(sprintf('LE n%d', length(V1prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else    
    title(sprintf('FE n%d', length(V1prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
s.Position(1) = s.Position(1) - 0.04;
s.Position(3) = s.Position(3) + 0.03;
text(0.5, yMax - 10, 'radial','FontWeight','bold','FontAngle','italic','Color',[0 0.6 0.2]);
text(0.5, yMax - 20, 'concentric','FontWeight','bold','FontAngle','italic','Color',[0.7 0 0.7]);
text(0.5, yMax - 30, 'dipole','FontWeight','bold','FontAngle','italic','Color',[1 0.5 0.1]);




s = subplot(2,2,2);
hold on
scatter(1:length(V1prefConZsRE),V1prefConZsRE,25,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V1prefRadZsRE),V1prefRadZsRE,25,'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V1prefNozZsRE),V1prefNozZsRE,25,'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
plot([0 length(V1prefNozZsRE)],[0 0],'-','color',[0.6 0.6 0.6])
set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
ylim([yMin yMax])
xlim([0 length(V1prefConZsRE)])
if contains(V1.trLE.animal,'XT')
    title(sprintf('RE n%d', length(V1prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else    
    title(sprintf('AE n%d', length(V1prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
s.Position(3) = s.Position(3) + 0.03;

s = subplot(2,2,3);
hold on
scatter(1:length(V4prefConZsLE),V4prefConZsLE,25,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V4prefRadZsLE),V4prefRadZsLE,25,'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V4prefNozZsLE),V4prefNozZsLE,25,'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
plot([0 length(V4prefNozZsLE)],[0 0],'-','color',[0.6 0.6 0.6])
set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
ylabel({'V4';'z score'},'FontSize',14,'FontWeight','bold','FontAngle','italic');
xlabel('Channel','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([yMin yMax])
xlim([0 length(V4prefConZsLE)])

if contains(V1.trLE.animal,'XT')
    title(sprintf('LE n%d', length(V4prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else    
    title(sprintf('FE n%d', length(V4prefConZsLE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
s.Position(1) = s.Position(1) - 0.04;
s.Position(3) = s.Position(3) + 0.03;

s = subplot(2,2,4);
hold on
scatter(1:length(V4prefConZsRE),V4prefConZsRE,25,'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V4prefRadZsRE),V4prefRadZsRE,25,'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(1:length(V4prefNozZsRE),V4prefNozZsRE,25,'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
plot([0 length(V4prefNozZsRE)],[0 0],'-','color',[0.6 0.6 0.6])
set(gca,'TickDir','out','FontSize',11,'FontAngle','italic')
xlabel('Channel','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([yMin yMax])
xlim([0 length(V4prefConZsRE)])

if contains(V1.trLE.animal,'XT')
    title(sprintf('RE n%d', length(V4prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
else   
    title(sprintf('AE n%d', length(V4prefConZsRE)),...
        'FontSize',16,'FontWeight','bold','FontAngle','italic')
end
s.Position(3) = s.Position(3) + 0.03;
