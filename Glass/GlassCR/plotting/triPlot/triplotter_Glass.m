function [h] = triplotter_Glass(rcd,cmap,vSumMax)
% required inputs(rcb,cmap)
% RCD   are d' vs blank for radial, concentric, and dipole
% CMAP  are the (r,g,b) values to be used for each data point based on their
% vector sum ranking. 


   
%%
h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)

% change data points to appropriate projections
x = rcd(:,1);
y = rcd(:,2);
z = rcd(:,3);

[th,phi,r]=cart2sph(x,y,z);
hold on
for i = 1:size(rcd,1)
    plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmap(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
end

% draw dots for edge of vertices
[thc,phic,rc]=cart2sph(1,1,1); %plot3m(rad2deg(phic),rad2deg(thc),rc,'ro','LineWidth',0.6,'MarkerSize', 7)

[thl,phil,rl]=cart2sph(1,0,1); %plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1,'MarkerSize', 7) % left
[thr,phir,rr]=cart2sph(0,1,1); %plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1,'MarkerSize', 7) %right
[thb,phib,rb]=cart2sph(1,1,0); %plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1,'MarkerSize', 7) % bottom

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1)

% draw lines for the subsections
plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6])

colormap(flipud(cmap)); colorbar;
c = colorbar('TickDirection','out');
c.Ticks = 0:0.25:1;
c.TickLabels = round(linspace(0,vSumMax,5),1);
c.Label.String = 'Vector sum of dPrimes';
c.FontAngle = 'italic';
c.FontSize = 11;

c.Label.FontSize = 13;
set(gca,'FontSize',13,'color','none')

bl=textm(0,0,'Model 1','FontSize',13);
br=textm(0,90,'Model 2','FontSize',13);
tp=textm(90,90,'Model 3','FontSize',13);

set(bl,'horizontalalignment','left','string',sprintf('\n\nRadial    '))
set(br,'horizontalalignment','right','string',sprintf('\n\n\n         Concentric'))
set(tp,'horizontalalignment','center','string',sprintf('Dipole\n\n'))