function [rfQuadrant,rfParams, inStim] = getRFsinGlass(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%

%%
glassX = unique(dataT.pos_x);
glassY = unique(dataT.pos_y);
rfParams = dataT.chReceptiveFieldParams;

if glassX ~= 0  
    for ch = 1:96
        rfParams{ch}(1) = rfParams{ch}(1) - glassX;
    end
end

if glassY ~= 0
    for ch = 1:96
        rfParams{ch}(2) = rfParams{ch}(2) - glassY;
    end
end
%% make dummy plot to get stimulus bounds
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/ch/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/ch/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure(80)
vs = viscircles([0,0],4,...
    'color',[0.8 0 0.6]);
xlim([-10,10])
ylim([-10,10])
stimX = vs.get.Children(2).XData;
stimY = vs.get.Children(2).YData;
%close(figure(80)) % don't actually need to see it, just want to have the
%vs info which gives us the x and y coordiantes of the circle.
%% determine what quadrant of the stimulus the receptive field is in

% glassAngles = 1 means the receptive field is in either top right or
% bottom left quadrants. Here, the local orientations from the radial
% patterns are 45 and 225.

% glassAngles = 2 means the receptive field is in either the top left or
% bottom right quadrants. Here, the local orientations from the radial
% patterns are 135 and 315.
%
%  Quadrants:        2 | 1
%                   -------
%                    3 | 4
%

rfQuadrant = nan(1,96);
inStim = zeros(1,96);

for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    if rfX > 0
        if rfY > 0  % RF is in the top right quadrant (+,+)
            rfQuadrant(ch) = 1;
        else % bottom right (+,-)
            rfQuadrant(ch) = 4;
        end
    else
        if rfY > 0  % RF is in the top left quadrant (-,+)
            rfQuadrant(ch) = 2;
        else % bottom left (-,-)
            rfQuadrant(ch) = 3;
        end
    end
    inStim(1,ch) = sum(inpolygon(rfX,rfY,stimX,stimY) & ((rfX-0).^2+(rfY-0).^2 <= 4^2));
    
    figure(4)
    clf
    hold on
    if inStim(ch) == 1
        draw_ellipse(rfParams{ch})
    else
        draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
    end
    
    viscircles([0,0],4,...
        'color',[0.8 0 0.6],'LineWidth',3);
    
    plot(rfX,rfY,'.k','MarkerSize',14)
    grid on;
    
    title({sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID);...
        sprintf('ch %d quadrant %d',ch,rfQuadrant(ch))})
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelGlassStim_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
    
end
%% plot all receptive fields on one figure
cd ../
figure(5)
clf
for ch = 1:96
    
    hold on
    if inStim(ch) == 1
        draw_ellipse(rfParams{ch})
    else
        draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
    end
    
    viscircles([0,0],4,...
        'color',[0.8 0 0.6],'LineWidth',3);
    
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    
end
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))

title(sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelGlassStim_ch',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
