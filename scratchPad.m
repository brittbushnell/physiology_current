rcdWU = WUv4LEsort(:,1:3);
cmpWU = WUv4LEsort(:,6:8);
triplotter_Glass_allMonk_multiColor(rcdWU,cmpWU);

rcd = WVv4LEsort(:,1:3);
cmap = WVv4LEsort(:,6:8);

vSum = WVv4LEsort(:,4);
%%
figure(1)
clf
hold on

h=axesm('stereo','origin',[45 45 0]);
axis off;
% draw the outlines of the triangle
t1 = plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',1);

t2 = plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',1);
t3 = plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',1);


% draw dots for edge of vertices
[thc,phic,rc]=cart2sph(1,1,1); %plot3m(rad2deg(phic),rad2deg(thc),rc,'ro','LineWidth',0.6,'MarkerSize', 7)

[thl,phil,rl]=cart2sph(1,0,1); %plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1,'MarkerSize', 7) % left
[thr,phir,rr]=cart2sph(0,1,1); %plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1,'MarkerSize', 7) %right
[thb,phib,rb]=cart2sph(1,1,0); %plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1,'MarkerSize', 7) % bottom


% draw lines for the subsections
ctol = plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6]);
ctor = plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6]);
ctpb = plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6]);
%
% [thRad,phiRad,rRad]=cart2sph(1,0,0); plot3m(rad2deg(phiRad),rad2deg(thRad),rRad,'ro','LineWidth',1,'MarkerSize', 7) % left
% [thDip,phiDip,rDip]=cart2sph(0,0,1); plot3m(rad2deg(phiDip),rad2deg(thDip),rDip,'co','LineWidth',1,'MarkerSize', 7) % left
% [thCon,phiCon,rCon]=cart2sph(0,1,0); plot3m(rad2deg(phiCon),rad2deg(thCon),rCon,'bo','LineWidth',1,'MarkerSize', 7) % left

% change data points to appropriate projections
x = rcd(:,1);
y = rcd(:,2);
z = rcd(:,3);

[th,phi,r]=cart2sph(x,y,z);

hold on
for i = 1:size(rcd,1)
   plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmap(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
end

% get center of data
wgtLoc = (rcd).*vSum;
wgtMu = mean(wgtLoc);
[thx,phix,rx]=cart2sph(wgtMu(1),wgtMu(2),wgtMu(3));

plot3m(rad2deg(phix),rad2deg(thx),rx, '*','MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerSize', 10,'LineWidth',1.5);
%% radial zone
radFakeL = plot3m([rad2deg(phil),rad2deg(phiRad)],[rad2deg(thl),rad2deg(thRad)],[rl,rRad],'-','color',[0.6 0.6 0.6]);
radFakeB = plot3m([rad2deg(phib),rad2deg(phiRad)],[rad2deg(thb),rad2deg(thRad)],[rb,rRad],'-','color',[0.6 0.6 0.6]);
radX = [radFakeL.XData,radFakeB.XData];
radY = [radFakeL.YData,radFakeB.YData];
radZ = [radFakeL.ZData,radFakeB.ZData];

shp = alphaShape(radX',radY',radZ');
plot(shp)

%% concentric zone
conFakeR = plot3m([rad2deg(phir),rad2deg(phiCon)],[rad2deg(thr),rad2deg(thCon)],[rr,rCon],'-','color',[0.6 0.6 0.6]);
conFakeB = plot3m([rad2deg(phib),rad2deg(phiCon)],[rad2deg(thb),rad2deg(thCon)],[rb,rCon],'-','color',[0.6 0.6 0.6]);

%% dipole zone
dipFakeL = plot3m([rad2deg(phil),rad2deg(phiDip)],[rad2deg(thl),rad2deg(thDip)],[rl,rDip],'-','color',[0.6 0.6 0.6]);
dioFakeR = plot3m([rad2deg(phir),rad2deg(phiDip)],[rad2deg(thr),rad2deg(thDip)],[rr,rDip],'-','color',[0.6 0.6 0.6]);