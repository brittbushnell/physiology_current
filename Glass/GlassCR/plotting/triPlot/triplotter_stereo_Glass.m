function [] = triplotter_stereo_Glass(rcb,grayMax)
% input should be matrix of  radial, concentric, dipole across the columns,
% and each row is a different channel. 
%%

h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)

% draw dots for edge of vertices
% [th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro','LineWidth',0.6)
% 
% 
% [thl,phil,rl]=cart2sph(1,0,1); plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1) % left
% [thr,phir,rr]=cart2sph(0,1,1); plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1) %right
% [thb,phib,rb]=cart2sph(1,1,0); plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1) % bottom

% change data points to appropriate projections
x = rcb(:,1);
y = rcb(:,2);
z = rcb(:,3);

[th,phi,r]=cart2sph(x,y,z);

% plot with the gray scale based on the sum of the d's
%(sqrt(d'1^2+d'2^2+d'3^2))  The grayscale is what determines the grayscale,
% but the d' for con, rad, dipole are what define the xyz locations of the
% data points
sum_xyz = sqrt(rcb(:,1).^2 + rcb(:,2).^2 + rcb(:,3).^2);
binLim = linspace(0,grayMax,11);
binLim = binLim(2:end);

hold on;
% now, go through each channel and base their color on which bin they fall
% into.
for i = 1:length(rcb)
    tmp = sum_xyz(i);
    
    if tmp > binLim(9) %&& tmp < binLim(5) % plot black
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].* 0,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4); hold on;  
    elseif tmp > binLim(8) && tmp < binLim(9)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.1,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(7) && tmp < binLim(8)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.2,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(6) && tmp < binLim(7)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.3,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(5) && tmp < binLim(6)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.4,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(4) && tmp < binLim(5)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.5,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(3) && tmp < binLim(4)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.6,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(2) && tmp < binLim(3)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.7,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > binLim(1) && tmp < binLim(2)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.8,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
    elseif tmp > 0 && tmp < binLim(1)
       plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  [1 1 1].*.9,'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);  
    end
        
end
map = [.9 .9 .9; .8 .8 .8; .7 .7 .7; .6 .6 .6; .5 .5 .5; .4 .4 .4; .3 .3 .3; .2 .2 .2; .1 .1 .1; 0 0 0];
colormap(map); colorbar;
c = colorbar('TickDirection','out');
c.Ticks = 0:0.25:1;
c.TickLabels = round(linspace(0,grayMax,5),1);
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

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1)

% draw lines for the sections
[thc,phic,rc]=cart2sph(1,1,1); plot3m(rad2deg(phic),rad2deg(thc),rc,'ro','LineWidth',1) % center

plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6])
