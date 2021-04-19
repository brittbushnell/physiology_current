figure(3)
clf
set(gcf,'Position',[34 177 250 250],'PaperSize',[2.5, 2.5]);

hold on
rct = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComLEmu,v1ComLEsph] = triplotter_centerMass(rct,v1LEsort(:,4),[1 0 0]);

% t = title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.2;
ax.Position(4) = ax.Position(4)+0.2;

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
[v1ComREmu,v1ComREsph] = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0]);

% t = title(sprintf('FE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1data.trRE.goodCh & V1data.trRE.inStim)),'FontSize',12);
% t.Position(2) = t.Position(2) +0.07;

% text(-1,-0.9,'Radial','FontSize',12)
% text(0.6,-0.9,'Concentric','FontSize',12)
% text(-0.35,0.95,'Translational','FontSize',12)
axis square
ax.Position(1) = ax.Position(1)-0.125;
ax.Position(2) = ax.Position(2)-0.08;
ax.Position(3) = ax.Position(3)+0.2;
ax.Position(4) = ax.Position(4)+0.2;

clear dps;
set(gca,'color','none')
figName = [V1data.trRE.animal,'_triplot_CoM_V1RE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')%'-dpdf''-depsc')