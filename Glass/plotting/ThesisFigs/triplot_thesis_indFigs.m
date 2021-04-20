function [] = triplot_thesis_indFigs(V1data, V4data)

figDir = sprintf('/Users/brittany/Dropbox/Thesis/Glass/figures/triplot/%s',V1data.trLE.animal);

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%triplot_Thesis

[v1LEsort, v1REsort, v4LEsort, v4REsort, cmap, sortDps] = getGlassTriplotSortedMats(V1data,V4data);
%%
%close all
figure(1)
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
rct = v4LEsort(:,1:3);
cmp = v4LEsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComLEmu,v4ComLEsph] = triplotter_centerMass(rct,v4LEsort(:,4),[0 0.5 1],1,4);

% t = title(sprintf('FE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim & V4data.trLE.goodCh & V4data.trLE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.09;
ax.Position(4) = ax.Position(4)+0.09;

clear dps;
set(gca,'color','none')
figName = [V1data.trLE.animal,'_triplot_CoM_V4LE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')
%%
figure(2)
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
rct = v4REsort(:,1:3);
cmp = v4REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComREmu,v4ComREsph] = triplotter_centerMass(rct,v4REsort(:,4),[1 0 0],1,4);

% t = title(sprintf('FE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim & V4data.trRE.goodCh & V4data.trRE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.09;
ax.Position(4) = ax.Position(4)+0.09;

clear dps;
set(gca,'color','none')
figName = [V1data.trRE.animal,'_triplot_CoM_V4RE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')
%%
figure(3)
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
rct = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComLEmu,v1ComLEsph] = triplotter_centerMass(rct,v1LEsort(:,4),[0 0.5 1],1,1);

% t = title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.09;
ax.Position(4) = ax.Position(4)+0.09;

clear dps;
set(gca,'color','none')
figName = [V1data.trLE.animal,'_triplot_CoM_V1LE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')
%%
figure(4)
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
rct = v1REsort(:,1:3);
cmp = v1REsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComREmu,v1ComREsph] = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0],1,1);

% t = title(sprintf('FE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1data.trRE.goodCh & V1data.trRE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.09;
ax.Position(4) = ax.Position(4)+0.09;

clear dps;
set(gca,'color','none')
figName = [V1data.trRE.animal,'_triplot_CoM_V1RE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')
%%
figure(6)
clf
set(gcf,'Position',[34 177 100 300],'PaperSize',[1.5, 3]);

colormap(flipud(cmap));
c2 = colorbar;
c2.Position = [0.45, 0.05, 0.125, 0.875];
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 11;
c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
c2.Label.String = 'Vector sum of dPrimes';
c2.Label.FontSize = 12;

axis off
figName = [V1data.trRE.animal,'_triplot_colorBar','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')%'-dpdf''-depsc')
%%

figure(5);
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
triplotter_GlassWithTr_noCBar_oneOri(v1ComREmu,[1 0 0],1);
triplotter_GlassWithTr_noCBar_oneOri(v1ComLEmu,[0 0.5 1],1);

triplotter_GlassWithTr_noCBar_oneOri(v4ComREmu,[1 0 0],4);
ax = triplotter_GlassWithTr_noCBar_oneOri(v4ComLEmu,[0 0.5 1],4);

ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.09;
ax.Position(4) = ax.Position(4)+0.09;

set(gca,'color','none')
figName = [V1data.trLE.animal,'_triplot_CoM','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')
