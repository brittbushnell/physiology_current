function dPrimeVblank_thesis(XTdata,WUdata,WVdata)

%%
[XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
    WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
    WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStatsBinocOnly(XTdata,WUdata,WVdata);
%%
close all
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 1300]);
figName = ['allMonk_glassdPrimeScatters_vsBlank_binocOnly','.pdf'];

% XT V1 vs blank
[V1conLE,V1conRE,V1radLE,V1radRE,V1nozLE,V1nozRE,V1trLE,V1trRE] = getBinocGlassdPrimeBlankMats(XTV1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4nozLE,V4nozRE,V4trLE,V4trRE] = getBinocGlassdPrimeBlankMats(XTV4,1);

s = subplot(6,5,1);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV1binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square

ylabel('RE d''','FontSize',12)
text(-7.25,7,'XT','FontSize',18,'FontWeight','bold')
h = text(-5.5,0,'V1/V2','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
text(8, 8, 'd'' versus blank','FontSize',18,'FontWeight','bold');
text(-8, 10,'A','FontSize',18,'FontWeight','bold');
t = title('Concentric','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'XTickLabel',[],'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,2);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV1binoc(2)),'FontSize',11)

t = title('Radial','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,3);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV1binoc(3)),'FontSize',11)

t = title('Translational','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,4);
le = reshape(V1nozLE,numel(V1nozLE),1);
re = reshape(V1nozRE,numel(V1nozRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV1binoc(3)),'FontSize',11)

t = title('Dipole','FontSize',12);
t.Position(2) = t.Position(2)+0.015;
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,6);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV4binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square

ylabel('RE d''','FontSize',12)
h = text(-5,1.5,'V4','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
t.Position(2) = t.Position(2)+0.015;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,7);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV4binoc(2)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,8);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV4binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;


s = subplot(6,5,9);
le = reshape(V4nozLE,numel(V4nozLE),1);
re = reshape(V4nozRE,numel(V4nozRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',XTBlankV4binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

% WU V1 vs blank
[V1conLE,V1conRE,V1radLE,V1radRE,V1nozLE,V1nozRE,V1trLE,V1trRE] = getBinocGlassdPrimeBlankMats(WUV1,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4nozLE,V4nozRE,V4trLE,V4trRE] = getBinocGlassdPrimeBlankMats(WUV4,1);

s = subplot(6,5,11);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV1binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square

ylabel('AE d''','FontSize',12)
text(-7.25,6.5,'WU','FontSize',18,'FontWeight','bold')
h = text(-5.5,0,'V1/V2','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'XTickLabel',[],'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;


s = subplot(6,5,12);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV1binoc(2)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,13);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV1binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,14);
le = reshape(V1nozLE,numel(V1nozLE),1);
re = reshape(V1nozRE,numel(V1nozRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV1binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.012;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

%V4
s = subplot(6,5,16);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV4binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square
ylabel('AE d''','FontSize',12)
h = text(-5,1.5,'V4','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,17);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV4binoc(2)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,18);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV4binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,19);
le = reshape(V4nozLE,numel(V4nozLE),1);
re = reshape(V4nozRE,numel(V4nozRE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WUBlankV4binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)+0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

% WU V1 vs blank
[V1conLE,V1conAE,V1radLE,V1radAE,V1nozLE,V1nozAE,V1trLE,V1trAE] = getBinocGlassdPrimeBlankMats(WVV1,1);
[V4conLE,V4conAE,V4radLE,V4radAE,V4nozLE,V4nozAE,V4trLE,V4trAE] = getBinocGlassdPrimeBlankMats(WVV4,1);

% V4
s = subplot(6,5,26);
le = reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conAE,numel(V4conAE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV4binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square
ylabel('AE d''','FontSize',12)
xlabel('FE d''','FontSize',12)
h = text(-5,1.5,'V4','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)-0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,27);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radAE,numel(V4radAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV4binoc(2)),'FontSize',11)

xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,28);
le = reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trAE,numel(V4trAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV4binoc(3)),'FontSize',11)

xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,29);
le = reshape(V4nozLE,numel(V4nozLE),1);
re = reshape(V4nozAE,numel(V4nozAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV4binoc(3)),'FontSize',11)

xlabel('FE d''','FontSize',12)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTick',0:2:4,'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.04;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,21);
le = reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conAE,numel(V1conAE),1);
hold on

plot([-1.2 5],[-1.2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV1binoc(1)),'FontSize',11)
xlim([-1 5])
ylim([-1 5])
axis square

ylabel('AE d''','FontSize',12)
text(-7.25,6.5,'WV','FontSize',18,'FontWeight','bold')
h = text(-5.5,0,'V1/V2','FontSize',18,'FontWeight','bold');
h.Rotation = 90;
set(gca,'color','none','tickdir','out','box','off','FontSize',11,'FontAngle','italic',...
    'layer','top','XTick',0:2:4,'XTickLabel',[],'YTick',0:2:4);

s.Position(1) = s.Position(1)-0.025;
s.Position(2) = s.Position(2)-0.063;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,22);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radAE,numel(V1radAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV1binoc(2)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.063;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,23);
le = reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trAE,numel(V1trAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [0.1 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV1binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.063;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

s = subplot(6,5,24);
le = reshape(V1nozLE,numel(V1nozLE),1);
re = reshape(V1nozAE,numel(V1nozAE),1);
hold on
xlim([-1 5])
ylim([-1 5])
axis square
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,32,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(2.2,-0.15,sprintf('R^{2} %.3f',WVBlankV1binoc(3)),'FontSize',11)
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic','XTickLabel',[],'YTickLabel',[])

s.Position(1) = s.Position(1)-0.04;
s.Position(2) = s.Position(2)-0.063;
s.Position(3) = s.Position(3)-0.02;
s.Position(4) = s.Position(4)-0.02;

% XT Rsq comp
s = subplot(6,5,5);
hold on
plot(XTBlankV1binoc,'ok');
plot(XTBlankV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1])

axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
text(-0.23, 1.9, 'R^{2} comparisons','FontSize',18,'FontWeight','bold');
text(-1.25, 2.1,'B','FontSize',18,'FontWeight','bold');
xtickangle(70)

s.Position(1) = s.Position(1)+0.01;
s.Position(2) = s.Position(2)-0.09;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;

% WU Rsq comp
s = subplot(6,5,15);
hold on
plot(WUBlankV1binoc,'ok');
plot(WUBlankV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1])

axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)
s.Position(1) = s.Position(1)+0.01;
s.Position(2) = s.Position(2)-0.075;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;

% WV Rsq comp
s = subplot(6,5,25);
hold on
plot(WVBlankV1binoc,'ok');
plot(WVBlankV4binoc,'ok','MarkerFaceColor','k');
xlim([0.5 3.5])
ylim([0 1]) 

axis square
set(gca,'FontSize',11,'tickdir','out','FontAngle','italic')
ylabel(sprintf('R^{2}'),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontSize',10,'FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

s.Position(1) = s.Position(1)+0.01;
s.Position(2) = s.Position(2)-0.12;
s.Position(3) = s.Position(3)+0.02;
s.Position(4) = s.Position(4)+0.02;

set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-fillpage')