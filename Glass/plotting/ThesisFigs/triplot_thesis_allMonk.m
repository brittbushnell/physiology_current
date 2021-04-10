%triplot_Thesis
[XTv1LEsort, XTv1REsort, XTv4LEsort, XTv4REsort,XTcmap,XTsortDps] = getGlassTriplotSortedMats(XTV1,XTV4);
[WUv1LEsort, WUv1REsort, WUv4LEsort, WUv4REsort,WUcmap,WUsortDps] = getGlassTriplotSortedMats(WUV1,WUV4);
[WVv1LEsort, WVv1REsort, WVv4LEsort, WVv4REsort,WVcmap,WVsortDps] = getGlassTriplotSortedMats(WVV1,WVV4);
%%
close all
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900],'PaperOrientation','landscape');

figName = ['allMonk_triplot','.pdf'];

s = subplot(4,4,13);
hold on
rct = WUv4LEsort(:,1:3);
cmp = WUv4LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv4LEsort(:,4),[1 0 0]);

t = title(sprintf('FE n: %d',sum(WUV4.conRadLE.goodCh & WUV4.conRadLE.inStim & WUV4.trLE.goodCh & WUV4.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(4,4,14);
hold on
rct = WUv4REsort(:,1:3);
cmp = WUv4REsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv4REsort(:,4),[1 0 0]);

t = title(sprintf('AE n: %d',sum(WUV4.conRadRE.goodCh & WUV4.conRadRE.inStim & WUV4.trRE.goodCh & WUV4.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

s = subplot(4,4,15);
hold on
rct = WVv4LEsort(:,1:3);
cmp = WVv4LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv4LEsort(:,4),[1 0 0]);

t = title(sprintf('FE n: %d',sum(WVV4.conRadLE.goodCh & WVV4.conRadLE.inStim & WVV4.trLE.goodCh & WVV4.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) + 0.025;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;
text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(4,4,16);
hold on
rct = WVv4REsort(:,1:3);
cmp = WVv4REsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv4REsort(:,4),[1 0 0]);

t = title(sprintf('AE n: %d',sum(WVV4.conRadRE.goodCh & WVV4.conRadRE.inStim & WVV4.trRE.goodCh & WVV4.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

s = subplot(4,4,9);
hold on
rct = WUv1LEsort(:,1:3);
cmp = WUv1LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WUv1LEsort(:,4),[1 0 0]);

t = title(sprintf('FE n: %d',sum(WUV1.conRadLE.goodCh & WUV1.conRadLE.inStim & WUV1.trLE.goodCh & WUV1.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.5,0.75,'WU','FontSize',18,'FontWeight','bold')

s = subplot(4,4,10);
hold on
rct = WUv1REsort(:,1:3);
cmp = WUv1REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar_minimal(rct,cmp);
triplotter_centerMass(rct,WUv1REsort(:,4),[1 0 0]);

t = title(sprintf('AE n: %d',sum(WUV1.conRadRE.goodCh & WUV1.conRadRE.inStim & WUV1.trRE.goodCh & WUV1.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

colormap(ax,flipud(WUcmap));
c2 = colorbar(ax,'Position',[0.45 0.14 0.01 0.2]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 11;
c2.TickLabels = round(linspace(0,WUsortDps(1,4),5),1);
c2.Label.String = 'WU Vector sum of dPrimes';
c2.Label.FontSize = 12;

s = subplot(4,4,11);
hold on
rct = WVv1LEsort(:,1:3);
cmp = WVv1LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,WVv1LEsort(:,4),[1 0 0]);

t = title(sprintf('FE n: %d',sum(WVV1.conRadLE.goodCh & WVV1.conRadLE.inStim & WVV1.trLE.goodCh & WVV1.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) + 0.025;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;
text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.5,0.75,'WV','FontSize',18,'FontWeight','bold')

s = subplot(4,4,12);
hold on
rct = WVv1REsort(:,1:3);
cmp = WVv1REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar_minimal(rct,cmp);
triplotter_centerMass(rct,WVv1REsort(:,4),[1 0 0]);

t = title(sprintf('AE n: %d',sum(WVV1.conRadRE.goodCh & WVV1.conRadRE.inStim & WVV1.trRE.goodCh & WVV1.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.25;
s.Position(2) = s.Position(2) - 0.09;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

colormap(ax,flipud(WVcmap));
c2 = colorbar(ax,'Position',[0.9 0.14 0.01 0.2]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 11;
c2.TickLabels = round(linspace(0,WVsortDps(1,4),5),1);
c2.Label.String = 'WV Vector sum of dPrimes';
c2.Label.FontSize = 12;

s = subplot(4,4,6);
hold on
rct = XTv4LEsort(:,1:3);
cmp = XTv4LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv4LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(XTV4.conRadLE.goodCh & XTV4.conRadLE.inStim & XTV4.trLE.goodCh & XTV4.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
% s.Position(2) = s.Position(2) - 0.15;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(4,4,7);
hold on
rct = XTv4REsort(:,1:3);
cmp = XTv4REsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv4REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(XTV4.conRadRE.goodCh & XTV4.conRadRE.inStim & XTV4.trRE.goodCh & XTV4.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.05;
% s.Position(2) = s.Position(2) - 0.15;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;



s = subplot(4,4,2);
hold on
rct = XTv1LEsort(:,1:3);
cmp = XTv1LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
triplotter_centerMass(rct,XTv1LEsort(:,4),[1 0 0]);

t = title(sprintf('LE n: %d',sum(XTV1.conRadLE.goodCh & XTV1.conRadLE.inStim & XTV1.trLE.goodCh & XTV1.trLE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
% s.Position(1) = s.Position(1) - 0.12;
s.Position(2) = s.Position(2) + 0.025;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
text(-1.5,0.75,'XT','FontSize',18,'FontWeight','bold')

s = subplot(4,4,3);
hold on
rct = XTv1REsort(:,1:3);
cmp = XTv1REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar_minimal(rct,cmp);
triplotter_centerMass(rct,XTv1REsort(:,4),[1 0 0]);

t = title(sprintf('RE n: %d',sum(XTV1.conRadRE.goodCh & XTV1.conRadRE.inStim & XTV1.trRE.goodCh & XTV1.trRE.inStim)),'FontSize',12,'FontWeight','bold');
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) + 0.025;
s.Position(3) = s.Position(3) + 0.017;
s.Position(4) = s.Position(4) + 0.017;

colormap(ax,flipud(XTcmap));
c2 = colorbar(ax,'Position',[0.65 0.63 0.01 0.2]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 11;
c2.TickLabels = round(linspace(0,XTsortDps(1,4),5),1);
c2.Label.String = 'XT Vector sum of dPrimes';
c2.Label.FontSize = 12;

set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')