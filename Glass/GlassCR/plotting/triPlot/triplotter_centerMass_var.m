function triplotter_centerMass_var(rcd,vSum,mkColor)
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
wgtLoc = (rcd).*vSum;
wgtMu = mean(wgtLoc);
[thx,phix,rx]=cart2sph(wgtMu(1),wgtMu(2),wgtMu(3));

plot3m(rad2deg(phix),rad2deg(thx),rx+4, 'o','MarkerFaceColor',mkColor,'MarkerEdgeColor',[0.99 0.99 0.99],'MarkerSize',7,'LineWidth',0.3);

% variances
LEv1Vars = var(rcd,vSum);
[th,phi,r]=cart2sph(LEv1Vars(1),LEv1Vars(2),LEv1Vars(3));