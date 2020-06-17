function [] = triplotter_stereo(xyz)

%%
clf;
h=axesm('stereo','origin',[45 45 0]);
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

% load xyz;
x = xyz(:,1);
y = xyz(:,2);
z = xyz(:,3);

[th,phi,r]=cart2sph(x,y,z); 
plot3m(rad2deg(phi),rad2deg(th),r,'ok','MarkerSize',9) % PLOT3M(LAT,LON,Z)
axis off;

[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')% center
[th,phi,r]=cart2sph(1,0,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')% bottom left
[th,phi,r]=cart2sph(0,1,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')% bottom right
[th,phi,r]=cart2sph(0,0,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')% top

h1=textm(90,90,'Model 1');
h2=textm(90,0,'Model 2');
h3=textm(0,90,'Model 3');

set(h1,'horizontalalignment','left','string','    Concentric')
set(h2,'horizontalalignment','right','string','Radial   ')
set(h3,'horizontalalignment','center','string',sprintf('\n\nDipole'))

%
