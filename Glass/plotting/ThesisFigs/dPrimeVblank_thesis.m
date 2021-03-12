[XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
    WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
    WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStatsBinocOnly(XTdata,WUdata,WVdata);
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 1300]);
figName = ['allMonk_glassdPrimeScatters_vsBlank_binocOnly','.pdf'];

% XT V1 vs noise
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(XTdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(XTdata.V4,1);

s = subplot(6,5,1);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV1binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('RE d''','FontSize',12)

text(-4,1,'V1','FontSize',18,'FontWeight','bold')
text(4.5, 4.28, 'd'' versus blank','FontSize',18,'FontWeight','bold');
text(-6, 3.5,'A','FontSize',18,'FontWeight','bold');
t = title('Concentric','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,2);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV1binoc(2)))
s.Position(1) = s.Position(1)-0.07;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
t = title('Radial','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,3);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV1binoc(3)))
s.Position(1) = s.Position(1)-0.13;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
t = title('Translational','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

% XT V4
s = subplot(6,5,5);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV4binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(2) = s.Position(2)-0.005;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('RE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 3.35,'XT','FontSize',18,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,6);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV4binoc(2)))
s.Position(1) = s.Position(1)-0.07;
s.Position(2) = s.Position(2)-0.005;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,7);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',XTdipoleV4binoc(3)))
s.Position(1) = s.Position(1)-0.13;
s.Position(2) = s.Position(2)-0.005;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

% WU
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V4,1);

s = subplot(6,5,9);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV1binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('RE d''','FontSize',12)
text(-4,1,'V1','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,10);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV1binoc(2)))
s.Position(1) = s.Position(1)-0.07;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,11);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV1binoc(3)))
s.Position(1) = s.Position(1)-0.13;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

% WU V4
s = subplot(6,5,13);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV4binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('RE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 3.35,'WU','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,14);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV4binoc(1)))
s.Position(1) = s.Position(1)-0.07;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,15);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WUdipoleV4binoc(2)))
s.Position(1) = s.Position(1)-0.13;
s.Position(2) = s.Position(2)-0.03;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})


% WV V4
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V4,1);

s = subplot(6,5,21);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV4binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(2) = s.Position(2)-0.057;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('AE d''','FontSize',12)
xlabel('FE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 3.35,'WV','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,22);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV4binoc(2)))
s.Position(1) = s.Position(1)-0.07;
s.Position(2) = s.Position(2)-0.057;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,5,23);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV4binoc(3)))
s.Position(1) = s.Position(1)-0.13;
s.Position(2) = s.Position(2)-0.057;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

% WV
s = subplot(6,5,17);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV1binoc(1)))
xlim([-1 2.5])
xlim([-1 2.5])
s.Position(1) = s.Position(1)-0.005;
s.Position(2) = s.Position(2)-0.054;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
ylabel('AE d''','FontSize',12)

text(-4,1,'V1','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,18);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV1binoc(2)))
s.Position(1) = s.Position(1)-0.07;
s.Position(2) = s.Position(2)-0.054;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,5,19);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
hold on
xlim([-1 2.5])
xlim([-1 2.5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.65, 2.5,sprintf('R^{2} %.3f',WVdipoleV1binoc(3)))
s.Position(1) = s.Position(1)-0.13;
s.Position(2) = s.Position(2)-0.054;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

% % XT Rsq comp
s = subplot(6,5,4);
hold on
plot(XTdipoleV1binoc,'ok');
plot(XTdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1])
s.Position(1) = s.Position(1)-0.05;
s.Position(2) = s.Position(2)-0.09;
s.Position(3) = s.Position(3)+0.065;
s.Position(4) = s.Position(4)+0.065;
axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
text(0, 1.52, 'R^{2} comparisons','FontSize',18,'FontWeight','bold');
text(-1.25, 1.4,'B','FontSize',18,'FontWeight','bold');
xtickangle(70)

% WV Rsq comp
s = subplot(6,5,20);
hold on
plot(WVdipoleV1binoc,'ok');
plot(WVdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1])
s.Position(1) = s.Position(1)-0.05;
s.Position(2) = s.Position(2)-0.14;
s.Position(3) = s.Position(3)+0.065;
s.Position(4) = s.Position(4)+0.065;
axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

% WU Rsq comp
s = subplot(6,5,12);
hold on
plot(WUdipoleV1binoc,'ok');
plot(WUdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1]) 
s.Position(1) = s.Position(1)-0.05;
s.Position(2) = s.Position(2)-0.12;
s.Position(3) = s.Position(3)+0.065;
s.Position(4) = s.Position(4)+0.065;
axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-bestfit')