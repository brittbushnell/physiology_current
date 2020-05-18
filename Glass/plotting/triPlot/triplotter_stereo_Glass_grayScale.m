% function [] = triplotter_stereo_Glass_grayScale(dPrimes,cmap)
% input should be matrix of  radial, concentric, bipole across the columns,
% and each row is a different channel. 

% [~,numDots,numDxs,~,~,~,dots,dxs,~,~] = getGlassParameters(dataT);

figure(25)
clf
dt = 2;
dx = 2;
numGoodCh = sum(dataT.goodCh);
radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));

dPrimes = [conDps,radDps,nosDps];

dPrimeSum = nansum(dPrimes,2);
[~,dPrimeNdx] = sort(dPrimeSum);

dpMax = max(dPrimes(:))+0.2;
dpMin = min(dPrimes(:))-0.2;

% prepare color map
cmap = (gray(numGoodCh)); % make gray colormap that goes from black to white so number of colors is = number of good channels - this way we'll see the full range.
cmapInv = flipud(cmap); % gray scale goes from white to black, this will  make the channels with the highest dprimes black, and lowest white

%pad cmap so all non responsive channels should correspond to white, so
%they don't take up meaningful light colors in the cmap.

if numGoodCh < 96
    whitePadding = ones((96-numGoodCh),3);
    cmapInvPadded = [whitePadding; cmapInv];
    
    if length(cmapInvPadded) ~= 96
        error('Error in making cmap: length of padded cmap does not equal 96')
    end
    cmapInv = cmapInvPadded;
end
%sortDPs = sortrows(dPrimes); % sort channels by repsonse in the first column (concentric)
pointSize = 30.*ones(size(nosDps));
%%
%
clc
clf;

pause(0.02);
set(gca,'color',[0.9 0.9 1],'box','off')  % want background to be white, otherwise mean gray dots which are meaningful will blend into the background

h=axesm('stereo','origin',[45 45 0]); % define the axis space

%axis off; % turn off the axis box

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')
%%
% draw the vertices
[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
[th,phi,r]=cart2sph(1,0,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
[th,phi,r]=cart2sph(0,1,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
[th,phi,r]=cart2sph(0,0,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')

x = dPrimes(:,1);
y = dPrimes(:,2);
z = dPrimes(:,3);

% [az,elev,r]=cart2sph(x,y,z); 
[dPrimesSph(:,1),dPrimesSph(:,2),dPrimesSph(:,3)]=cart2sph(x,y,z); 

%sortDPsSph = sortrows(dPrimesSph,2,'descend'); % sort channels by repsonse in the second column (elevation)

for ch = 1:numGoodCh
    Ndx = dPrimeNdx(ch);
    %p = plot3m(rad2deg(sortDPsSph(ch,1)),rad2deg(sortDPsSph(ch,2)),sortDPsSph(ch,3),'o','MarkerSize',9,'MarkerFaceColor',cmapInv(grayNdx,:),'MarkerEdgeColor',cmapInv(grayNdx,:)); % PLOT3M(LAT,LON,Z)
    p = plot3m(rad2deg(dPrimesSph(Ndx,1)),rad2deg(dPrimesSph(Ndx,2)),dPrimesSph(Ndx,3),'o','MarkerSize',9,'MarkerFaceColor',cmapInv(Ndx,:),'MarkerEdgeColor',cmapInv(Ndx,:)); % PLOT3M(LAT,LON,Z)
end
%plot3m(rad2deg(az),rad2deg(elev),r,'ok','MarkerSize',9)
%scatter3m(rad2deg(az),rad2deg(elev),r,pointSize,cmap);
h1=textm(45,90,'Radial');
h2=textm(45,0,'Concentric');
h3=textm(0,45,'Bipole');

set(h1,'horizontalalignment','left','string','    Radial','FontSize',11)
set(h2,'horizontalalignment','right','string','Concentric   ','FontSize',11)
set(h3,'horizontalalignment','center','string',sprintf('\n\nDipole'),'FontSize',11)



