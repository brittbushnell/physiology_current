[XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
    WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
    WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStatsBinocOnly(XTdata,WUdata,WVdata);
%%
meanDp = zeros(6,3);
%%
close all
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 1300]);
figName = ['allMonk_glassdPrimeScatters_vsNoise_binocOnly_port','.pdf'];

% XT V1 vs noise
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(XTdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(XTdata.V4,1);

s = subplot(6,4,1);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
meanDp(1,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV1binoc(1)),'FontSize',11)
% text(-0.6, 1.75, sprintf('\\mu %.3f',meanDp(1,1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)-0.002;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('RE d''','FontSize',12)

text(-4,1,'V1/V2','FontSize',18,'FontWeight','bold')
text(2,3, 'd'' versus random dipole','FontSize',20,'FontWeight','bold');
text(-6, 3.4,'A','FontSize',18,'FontWeight','bold');
t = title('Concentric','FontSize',12);
t.Position(2) = t.Position(2)+0.01;
set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,2);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
meanDp(1,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV1binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)-0.002;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
t = title('Radial','FontSize',12);
t.Position(2) = t.Position(2)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,3);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
meanDp(1,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV1binoc(3)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.002;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
t = title('Translational','FontSize',12);
t.Position(2) = t.Position(2)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

% XT V4
s = subplot(6,4,5);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
meanDp(2,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV4binoc(1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)+0.0052;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('RE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 3.35,'XT','FontSize',18,'FontWeight','bold')
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,6);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
meanDp(2,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV4binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)+0.0052;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,7);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
meanDp(2,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',XTdipoleV4binoc(3)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)+0.0052;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

% WU
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(WUdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(WUdata.V4,1);

s = subplot(6,4,9);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
meanDp(3,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV1binoc(1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)-0.0325;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('RE d''','FontSize',12)
text(-4,1,'V1/V2','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,10);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
meanDp(3,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV1binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)-0.0325;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,11);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
meanDp(3,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV1binoc(3)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.0325;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

% WU V4
s = subplot(6,4,13);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
meanDp(4,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV4binoc(1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)-0.0225;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('RE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 3.35,'WU','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,14);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
meanDp(4,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV4binoc(1)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)-0.0225;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,15);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
meanDp(4,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WUdipoleV4binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.0225;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})


% WV V4
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(WVdata.V4,1);

s = subplot(6,4,21);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
meanDp(6,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV4binoc(1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)-0.048;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('AE d''','FontSize',12)
xlabel('FE d''','FontSize',12)
text(-4, 1,'V4','FontSize',18,'FontWeight','bold')
text(-6, 2.75,'WV','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,22);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
meanDp(6,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV4binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)-0.048;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

s = subplot(6,4,23);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
meanDp(6,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV4binoc(3)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.048;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',{'','0','1','2'},'YTickLabel',{'','0','1','2'})

% WV V1
s = subplot(6,4,17);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
meanDp(5,1) = nanmean([le;re],'all');
hold on
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV1binoc(1)),'FontSize',11)
ylim([-1 2])
xlim([-1 2])
s.Position(1) = s.Position(1)+0.03;
s.Position(2) = s.Position(2)-0.06;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
ylabel('AE d''','FontSize',12)

text(-4,1,'V1/V2','FontSize',18,'FontWeight','bold')

set(gca,'FontSize',10,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,18);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
meanDp(5,2) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV1binoc(2)),'FontSize',11)
s.Position(1) = s.Position(1)-0.012;
s.Position(2) = s.Position(2)-0.06;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

s = subplot(6,4,19);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
meanDp(5,3) = nanmean([le;re],'all');
hold on
ylim([-1 2])
xlim([-1 2])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(1.15, -0.65,sprintf('R^{2} %.3f',WVdipoleV1binoc(3)),'FontSize',11)
s.Position(1) = s.Position(1)-0.06;
s.Position(2) = s.Position(2)-0.06;
s.Position(3) = s.Position(3)+0.01;
s.Position(4) = s.Position(4)+0.01;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',{'','0','1','2'})

meanDp = round(meanDp,3);

% % XT Rsq comp
s = subplot(6,4,4);
hold on
plot(XTdipoleV1binoc,'ok');
plot(XTdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 0.8])
s.Position(1) = s.Position(1)+0.02;
s.Position(2) = s.Position(2)-0.09;
s.Position(3) = s.Position(3)+0.065;
s.Position(4) = s.Position(4)+0.065;
axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
text(0.6, 1.15, 'R^{2} comparisons','FontSize',18,'FontWeight','bold');
text(-1.25, 1.2,'B','FontSize',20,'FontWeight','bold');
xtickangle(70)

% WV Rsq comp
s = subplot(6,4,20);
hold on
plot(WVdipoleV1binoc,'ok');
plot(WVdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 0.8])
s.Position(1) = s.Position(1)+0.02;
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
s = subplot(6,4,12);
hold on
plot(WUdipoleV1binoc,'ok');
plot(WUdipoleV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 0.8]) 
s.Position(1) = s.Position(1)+0.02;
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