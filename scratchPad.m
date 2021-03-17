figure(1)
h=axesm('stereo','origin',[45 45 0]);
axis off;
hold on
% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1.2)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1.2)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1.2)

% draw lines for the subsections
plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6],'LineWidth',1.2)
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6],'LineWidth',1.2)
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6],'LineWidth',1.2)

set(gca,'FontSize',13,'color','none')

textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');