%function [] = triplotter_stereo_Glass(rcb)
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
 clc
 clf;
% pause(0.02);
h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k')
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k')
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k')

% draw lines for the vertices
[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(1,0,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(0,1,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
% [th,phi,r]=cart2sph(0,0,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')

[th,phi,r]=cart2sph(1,0,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
[th,phi,r]=cart2sph(0,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
[th,phi,r]=cart2sph(1,1,0); plot3m(rad2deg(phi),rad2deg(th),r,'ro')
x = rcb(:,1);
y = rcb(:,2);
z = rcb(:,3);

[th,phi,r]=cart2sph(x,y,z);
%plot3m(rad2deg(phi),rad2deg(th),r,'b.')

% plot with the gray scale based on the sum of the d's
%(sqrt(d'1^2+d'2^2+d'3^2))
sum_xyz = sqrt(xyz(:,1).^2 + xyz(:,2).^2 + xyz(:,3).^2);%sum(xyz,2);
[~,binLim] = histcounts(sum_xyz,6);
binLim = binLim(2:end);
for i = 1:length(xyz)
    tmp = sum_xyz(i);
    %pause
    if binLim(4)  < tmp %&& tmp < binLim(5) % plot black
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), '.','color',  [1 1 1].*0, 'MarkerSize', 25); hold on;  
    elseif binLim(3)  < tmp && tmp < binLim(4)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), '.','color', [1 1 1].*.2, 'MarkerSize', 25);
    elseif binLim(2)  < tmp && tmp < binLim(3)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), '.','color', [1 1 1].*.4, 'MarkerSize', 25);
    elseif binLim(1)  < tmp && tmp < binLim(2)
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), '.','color', [1 1 1].*.6, 'MarkerSize', 25);
    elseif 0 < tmp && tmp < binLim(1) % plot white-ish
        plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), '.','color', [1 1 1].*.8, 'MarkerSize', 25);
    end
end
map = [0 0 0; .2 .2 .2; .4 .4 .4; .6 .6 .6; .8 .8 .8];
colormap(flipud(map)); colorbar;
c = colorbar('TickDirection','out','Ticks',[[],[],0.2,[],0.4,[],0.6,[],0.8,[],1],...
    'TickLabels',{binLim(1),round(binLim(2),1),round(binLim(3),1),round(binLim(4),1),round(binLim(5),1)});
c.Label.String = 'vector sum of dPrimes';


c.Label.FontSize = 12;
set(gca,'FontSize',12)
% [th,phi,r]=cart2sph(x,y,z); 
% plot3m(rad2deg(phi),rad2deg(th),r,'ok','MarkerSize',9) % PLOT3M(LAT,LON,Z)

bl=textm(0,0,'Model 1','FontSize',12);
br=textm(0,90,'Model 2','FontSize',12);
tp=textm(90,90,'Model 3','FontSize',12);

set(bl,'horizontalalignment','left','string',sprintf('\n\nRadial    '))
set(br,'horizontalalignment','right','string',sprintf('\n\n       Concentric'))
set(tp,'horizontalalignment','center','string',sprintf('Dipole\n\n'))
%set(gca,'FontSize',16)
