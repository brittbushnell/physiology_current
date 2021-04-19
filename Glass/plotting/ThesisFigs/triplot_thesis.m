function [] = triplot_thesis(V1data, V4data)

cd '/Users/brittany/Dropbox/Thesis/Glass/figures/triplot'

%triplot_Thesis

[v1LEsort, v1REsort, v4LEsort, v4REsort, cmap, sortDps] = getGlassTriplotSortedMats(V1data,V4data);
%%
%close all
figure(1)
clf
set(gcf,'Position',[34 177 700 700],'PaperSize',[7, 7]);
% s = suptitle(sprintf('%s relative sensitivity to Glass pattern forms',V1data.trLE.animal));
% s.Position = s.Position+0.03;
% s.FontSize = 20;



s = subplot(3,2,3);
hold on
rct = v4LEsort(:,1:3);
cmp = v4LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComLEmu,v4ComLEsph] = triplotter_centerMass(rct,v4LEsort(:,4),[1 0 0]);

t = title(sprintf('FE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & V4data.trLE.goodCh & V4data.trLE.inStim)),'FontSize',12);
t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.025;
% s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.045;
s.Position(4) = s.Position(4) + 0.045;

text(-1.5,0.1,'V4','FontSize',18,'FontWeight','bold')

s = subplot(3,2,4);
hold on
rct = v4REsort(:,1:3);
cmp = v4REsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComREmu,v4ComREsph] = triplotter_centerMass(rct,v4REsort(:,4),[1 0 0]);

% t = title(sprintf('AE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & V4data.trRE.goodCh & V4data.trRE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.09;
% s.Position(2) = s.Position(2) - 0.065;
s.Position(3) = s.Position(3) + 0.045;
s.Position(4) = s.Position(4) + 0.045;


s = subplot(3,2,1);
hold on
rct = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComLEmu,v1ComLEsph] = triplotter_centerMass(rct,v1LEsort(:,4),[1 0 0]);

% t = title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.025;
s.Position(2) = s.Position(2) - 0.01;
s.Position(3) = s.Position(3) + 0.045;
s.Position(4) = s.Position(4) + 0.045;

% text(-1.5,0.1,'V1','FontSize',18,'FontWeight','bold')
% text(1,1.8,sprintf('%s',V1data.trLE.animal),'FontSize',20,'FontWeight','bold')

s = subplot(3,2,2);
hold on
rct = v1REsort(:,1:3);
cmp = v1REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComREmu,v1ComREsph] = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0]);

% t = title(sprintf('AE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1data.trRE.goodCh & V1data.trRE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

clear dps;
s.Position(1) = s.Position(1) - 0.09;
s.Position(2) = s.Position(2) - 0.01;
s.Position(3) = s.Position(3) + 0.045;
s.Position(4) = s.Position(4) + 0.045;

colormap(ax,flipud(cmap));
c2 = colorbar(ax,'Position',[0.87 0.475 0.02 0.3]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 11;
c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
% c2.Label.String = 'Vector sum of dPrimes';
c2.Label.FontSize = 12;


v1Dist = vecnorm((v1ComLEsph) - (v1ComREsph),2,2);
v4Dist = vecnorm((v4ComLEsph) - (v4ComREsph),2,2);
pValV1 = getGlassCoMperm2(v1REsort(:,1:3),v1LEsort(:,1:3),v1Dist,V1data.trLE.animal, 'V1');
pValV4 = getGlassCoMperm2(v4REsort(:,1:3),v4LEsort(:,1:3),v4Dist,V4data.trLE.animal, 'V4');

s = subplot(3,2,5);
hold on
triplotter_GlassWithTr_noCBar_oneOri(v1ComREmu,[1 0 0],1);
triplotter_GlassWithTr_noCBar_oneOri(v1ComLEmu,[0 0 1],1);

triplotter_GlassWithTr_noCBar_oneOri(v4ComREmu,[1 0 0],4);
triplotter_GlassWithTr_noCBar_oneOri(v4ComLEmu,[0 0 1],4);


text(-2.2,-1.45,sprintf('V4 CoM distance: %.2f ',v4Dist),'FontSize',12)
text(-2.2,-1.25,sprintf('V1 CoM distance: %.2f ',v1Dist),'FontSize',12)
if pValV4>0.05
    text(0.85,-1.45,sprintf('p = %.2f',pValV4),'FontSize',12)
else
    text(0.85,-1.45,sprintf('p = %.2f*',pValV4),'FontSize',12)
end
if pValV1 >0.05
    text(0.85,-1.25,sprintf('p = %.2f',pValV1),'FontSize',12)
else
    text(0.85,-1.25,sprintf('p = %.2f*',pValV1),'FontSize',12)
end
% text(0.5,0.7,'RE','FontWeight','bold','color',[1 0 0],'FontSize',12)
% text(0.5,0.5,'LE','FontWeight','bold','color',[0 0 1],'FontSize',12)
% text(1,0.7,'V1','FontWeight','bold','FontSize',12)
% text(1,0.5,'V4','FontWeight','bold','FontSize',12)
% plot(1.4,0.7,'ok')
% plot(1.4,0.5,'ok','MarkerFaceColor','k')
% 
% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)

s.Position(1) = s.Position(1) + 0.18;
s.Position(2) = s.Position(2) - 0.012;
s.Position(3) = s.Position(3) + 0.045;
s.Position(4) = s.Position(4) + 0.045;

set(gca,'color','none')
figName = [V1data.trLE.animal,'_triplot_CoM','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')