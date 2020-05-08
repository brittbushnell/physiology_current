function [] = triplotter_stereo_Glass(rcb)
% input should be matrix of  radial, concentric, bipole across the columns,
% and each row is a different channel. 

% [~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);
% 
% figure (7)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1000 900]);
% 
% radDps = squeeze(dataT.radBlankDprime(end,:,:,:));
% conDps = squeeze(dataT.conBlankDprime(end,:,:,:));
% nosDps = squeeze(dataT.noiseBlankDprime(:,:,:));
% 
% radMax = max(radDps(:));
% conMax = max(conDps(:));
% nosMax = max(nosDps(:));
% 
% xyz = [radMax,conMax,nosMax];
% from Romesh
%line([0 1],[0 0],[0 0],'color','k','LineStyle','--'); %horizontal
% line([0 0],[1 0],[0 0],'color','k','LineStyle','--'); % vertical
% line([-1 0],[0 0],[0 0],'color','k','LineStyle','--'); % flipped horz

% dt = 2;
% dx = 2;
% radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
% conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
% nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));
% rcb = [radDps,conDps,nosDps];
%%
%
% clc
% clf;
% pause(0.02);
h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

% draw lines for the vertices
% [th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(1,0,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(0,1,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(0,0,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% draw the lines dividing the different zones
LtoC = (0:1:45); RtoC = fliplr(LtoC); %TtoC = 45:1:90;
linem(LtoC,LtoC,'color','k','LineStyle','--');
linem(RtoC,45+LtoC,'color','k','LineStyle','--');
line([0 0],[0.82 0],[0 0],'color','k','LineStyle','--')

x = rcb(:,1);
y = rcb(:,2);
z = rcb(:,3);

[az,elev,r]=cart2sph(x,y,z); 
plot3m(rad2deg(az),rad2deg(elev),r,'ok','MarkerSize',9) % PLOT3M(LAT,LON,Z)

h1=textm(45,90,'Model 1');
h2=textm(45,0,'Model 2');
h3=textm(0,45,'Model 3');

set(h1,'horizontalalignment','left','string','    Radial')
set(h2,'horizontalalignment','right','string','Concentric   ')
set(h3,'horizontalalignment','center','string',sprintf('\n\nBipole'))