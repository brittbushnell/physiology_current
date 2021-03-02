function MakeFigs_GlassR2Vals(XTdata,WUdata,WVdata)

%%
[XTBlankV1monoc,XTBlankV4monoc,XTdipoleV1monoc,XTdipoleV4monoc,...
    XTBlankV1binoc,XTBlankV4binoc,XTdipoleV1binoc,XTdipoleV4binoc,...
    WUBlankV1monoc,WUBlankV4monoc,WUdipoleV1monoc,WUdipoleV4monoc,...
    WUBlankV1binoc,WUBlankV4binoc,WUdipoleV1binoc,WUdipoleV4binoc,...
    WVBlankV1monoc,WVBlankV4monoc,WVdipoleV1monoc,WVdipoleV4monoc,...
    WVBlankV1binoc,WVBlankV4binoc,WVdipoleV1binoc,WVdipoleV4binoc]= getGlassRegStats(XTdata,WUdata,WVdata);
%%
figure(14)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 700 800]);
% set(gcf,'PaperOrientation','landscape')
s = suptitle('Regression values for stimuli vs blank');
s.Position(2) = s.Position(2)+0.028;

subplot(3,2,1)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(XTBlankV1monoc,'ok');
plot(XTBlankV4monoc,'ok','MarkerFaceColor','k');
t = title('All included channels','FontSize',12);
t.Position(2) = t.Position(2)+0.05;
ylabel(sprintf('R^{2}'),'FontSize',14)

text(6,0.5,'XT','FontSize',20,'FontWeight','bold')

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',[]);


subplot(3,2,3)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WUBlankV1monoc,'ok');
plot(WUBlankV4monoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)
text(6,0.5,'WU','FontSize',20,'FontWeight','bold')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',[]);



subplot(3,2,5)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WVBlankV1monoc,'ok');
plot(WVBlankV4monoc,'ok','MarkerFaceColor','k');
text(6,0.5,'WV','FontSize',20,'FontWeight','bold')
ylabel(sprintf('R^{2}'),'FontSize',14)
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

%
subplot(3,2,2)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(XTBlankV4binoc,'ok','MarkerFaceColor','k');
plot(XTBlankV1binoc,'ok');

t = title('All binocular channels','FontSize',12);
t.Position(2) = t.Position(2)+0.05;
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',[]);

l = legend('V4','V1','Location','northeastoutside');
l.Box = 'off';
l.FontSize = 14;
l.Position(1) = l.Position(1) +0.06;

subplot(3,2,4)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WUBlankV1binoc,'ok');
plot(WUBlankV4binoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',[]);



subplot(3,2,6)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WVBlankV1binoc,'ok');
plot(WVBlankV4binoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:4,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

figName = ['R2Vals_stimVBlank','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%
figure(15)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 700 800]);
s = suptitle('Regression values for stimuli vs dipole');
s.Position(2) = s.Position(2)+0.028;

subplot(3,2,1)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(XTdipoleV1monoc,'ok');
plot(XTdipoleV4monoc,'ok','MarkerFaceColor','k');
t = title('All included channels','FontSize',12);
t.Position(2) = t.Position(2)+0.05;
ylabel(sprintf('R^{2}'),'FontSize',14)

text(6,0.5,'XT','FontSize',20,'FontWeight','bold')

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',[]);


subplot(3,2,3)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WUdipoleV1monoc,'ok');
plot(WUdipoleV4monoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)
text(6,0.5,'WU','FontSize',20,'FontWeight','bold')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',[]);



subplot(3,2,5)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WVdipoleV1monoc,'ok');
plot(WVdipoleV4monoc,'ok','MarkerFaceColor','k');
text(6,0.5,'WV','FontSize',20,'FontWeight','bold')
ylabel(sprintf('R^{2}'),'FontSize',14)
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',{'Concentric','Radial','Translational', 'Dipole'});
xtickangle(70)

%
subplot(3,2,2)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(XTdipoleV4binoc,'ok','MarkerFaceColor','k');
plot(XTdipoleV1binoc,'ok');

t = title('All binocular channels','FontSize',12);
t.Position(2) = t.Position(2)+0.05;
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',[]);

l = legend('V4','V1','Location','northeastoutside');
l.Box = 'off';
l.FontSize = 14;
l.Position(1) = l.Position(1) +0.06;

subplot(3,2,4)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WUdipoleV1binoc,'ok');
plot(WUdipoleV4binoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',[]);



subplot(3,2,6)
hold on
xlim([0 5])
ylim([0 1])
axis square
plot(WVdipoleV1binoc,'ok');
plot(WVdipoleV4binoc,'ok','MarkerFaceColor','k');
ylabel(sprintf('R^{2}'),'FontSize',14)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',1:3,'XTickLabel',{'Concentric','Radial','Translational'});
xtickangle(70)
figName = ['R2Vals_stimVdipole','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')