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
dpMax = max(dPrimes(:))+0.2;
dpMin = min(dPrimes(:))-0.2;
cmap = (gray(numGoodCh)); % make gray colormap that goes from black to white so number of colors is = number of good channels - this way we'll see the full range.
cmapInv = flipud(cmap); % gray scale goes from white to black, this will  make the channels with the highest dprimes black, and lowest white

%sortDPs = sortrows(dPrimes); % sort channels by repsonse in the first column (concentric)
pointSize = 30.*ones(size(nosDps));
%%
%
clc
clf;

pause(0.02);
h=axesm('stereo','origin',[45 45 0]); % define the axis space
axis off; % turn off the axis box

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

% draw the lines dividing the different zones

% NOTE: THE CENTER POINT IS STILL A BIT HIGH. NEED TO FIGURE OUT HOW TO
% JUST BRING THAT DOWN TO THE APPROPRIATE CENTER.
LtoC = (0:1:45); RtoC = fliplr(LtoC); %TtoC = 45:1:90;
linem(LtoC,LtoC,'color','k','LineStyle','--');
linem(RtoC,45+LtoC,'color','k','LineStyle','--');
line([0 0],[0.82 0],[0 0],'color','k','LineStyle','--','LineWidth',0.75)

x = dPrimes(:,1);
y = dPrimes(:,2);
z = dPrimes(:,3);

% [az,elev,r]=cart2sph(x,y,z); 
[dPrimesSph(:,1),dPrimesSph(:,2),dPrimesSph(:,3)]=cart2sph(x,y,z); 

sortDPsSph = sortrows(dPrimesSph,2,'descend'); % sort channels by repsonse in the second column (elevation)

for ch = 1:numGoodCh
    p = plot3m(rad2deg(sortDPsSph(ch,1)),rad2deg(sortDPsSph(ch,2)),sortDPsSph(ch,3),'o','MarkerSize',9,'MarkerFaceColor',cmapInv(ch,:),'MarkerEdgeColor',cmapInv(ch,:)); % PLOT3M(LAT,LON,Z)
end
%plot3m(rad2deg(az),rad2deg(elev),r,'ok','MarkerSize',9)
%scatter3m(rad2deg(az),rad2deg(elev),r,pointSize,cmap);
h1=textm(45,90,'Radial');
h2=textm(45,0,'Concentric');
h3=textm(0,45,'Bipole');

set(h1,'horizontalalignment','left','string','    Radial','FontSize',11)
set(h2,'horizontalalignment','right','string','Concentric   ','FontSize',11)
set(h3,'horizontalalignment','center','string',sprintf('\n\nBipole'),'FontSize',11)