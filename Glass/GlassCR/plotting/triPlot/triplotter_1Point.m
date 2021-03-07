function triplotter_1Point(rcd,mkColor,mkSize)
%%
% figure(1)
% clf

h = axesm('stereo','origin',[45 45 0]);
axis off;
% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1);
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1);
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1);

% get edges of vertices
[thc,phic,rc]=cart2sph(1,1,1);
[thl,phil,rl]=cart2sph(1,0,1); 
[thr,phir,rr]=cart2sph(0,1,1); 
[thb,phib,rb]=cart2sph(1,1,0); 

% draw lines for the subsections
plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6]);
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6]);
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6]);

% get center of data

[thx,phix,rx]=cart2sph(rcd(1),rcd(2),rcd(3));

plot3m(rad2deg(phix),rad2deg(thx),rx+4, 'o','MarkerFaceColor',mkColor,'MarkerEdgeColor',[0.99 0.99 0.99],'MarkerSize',mkSize,'LineWidth',0.3);
% plot3m(rad2deg(phix),rad2deg(thx),rx+1, 'o','MarkerEdgeColor','r','MarkerSize', 20,'LineWidth',1.5);
