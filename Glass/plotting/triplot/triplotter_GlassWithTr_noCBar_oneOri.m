function [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmap)
% required inputs(rcb,cmap)
% RCD   are d' vs blank for radial, concentric, and dipole
% CMAP  are the (r,g,b) values to be used for each data point based on their
% vector sum ranking. 


   
%%
axesm('stereo','origin',[45 45 0]);
axis off;
hold on
% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)

% find the edge of vertices
[thc,phic,rc]=cart2sph(1,1,1); %plot3m(rad2deg(phic),rad2deg(thc),rc,'ro','LineWidth',0.6,'MarkerSize', 7)

[thl,phil,rl]=cart2sph(1,0,1); %plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1,'MarkerSize', 7) % left
[thr,phir,rr]=cart2sph(0,1,1); %plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1,'MarkerSize', 7) %right
[thb,phib,rb]=cart2sph(1,1,0); %plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1,'MarkerSize', 7) % bottom

% draw lines for the subsections
plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6])

% change data points to appropriate projections
rct = flipud(rct); cmap = flipud(cmap); %flipping the order so high d' are plotted last and easier to see
x = rct(:,1);
y = rct(:,2);
z = rct(:,3);

[th,phi,r]=cart2sph(x,y,z);

% set up counter for number of data points within each segment.
inCon = 0;
inRad = 0;
inTr = 0;

for i = 1:size(rct,1)
   [~,mndx] = max(rct(i,:));
   if mndx == 1
       inRad = inRad+1;
       plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmap(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.9 0.9 0.9],'LineWidth',0.4);
   elseif mndx == 2
       inCon = inCon+1;
       plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmap(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.9 0.9 0.9],'LineWidth',0.4);
   else
       inTr = inTr+1;
       plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmap(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.9 0.9 0.9],'LineWidth',0.4);
   end
end


% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1)



