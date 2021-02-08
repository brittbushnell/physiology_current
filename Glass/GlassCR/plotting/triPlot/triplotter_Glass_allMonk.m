% function [] = triplotter_Glass_allMonk()

% input should be matrix of  radial, concentric, dipole across the columns,
% and each row is a different channel. 
%%
figure(800)
clf
hold on

h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)

% draw dots for edge of vertices
[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro','LineWidth',0.6)


[thl,phil,rl]=cart2sph(1,0,1); plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1) % left
[thr,phir,rr]=cart2sph(0,1,1); plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1) %right
[thb,phib,rb]=cart2sph(1,1,0); plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1) % bottom

% change data points to appropriate projections
x = rcb(:,1);
y = rcb(:,2);
z = rcb(:,3);

[th,phi,r]=cart2sph(x,y,z);

% plot with the gray scale based on the sum of the d's
%(sqrt(d'1^2+d'2^2+d'3^2))
sum_xyz = sqrt(rcb(:,1).^2 + rcb(:,2).^2 + rcb(:,3).^2);
binLim = linspace(0,grayMax,11);
binLim = binLim(2:end);


