function [rfQuadrant,inStim,inCenterStim] = getRFsRelGlass_ecc(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
% Receptive fields are relative to fixation at (0,0). In order to get
% quadrants, need to move the stimulus center to (0,0) which means
% adjusting receptive field centers and stimulus center in the correct
% direction.

%%
glassX = unique(dataT.pos_x);
glassY = unique(dataT.pos_y);

if contains(dataT.animal,'XT') && contains(dataT.array,'V4')
    rfParamsOrig = dataT.chReceptiveFieldParamsBE;
else
    rfParamsOrig = dataT.chReceptiveFieldParams;
end
%% for XT, move receptive field locations to be in same coordinate space as Glass fixation
if contains(dataT.animal,'XT')
    for ch = 1:96
        rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1) + unique(dataT.fix_x);
        rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2) + unique(dataT.fix_y);
    end
end
%% center stimulus at (0,0)
% Need stimulus to be centered at origin to define the quadrants according
% to their signs

if glassX ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1) - unique(dataT.pos_x);
    end
    glassXstim0 = unique(dataT.pos_x) - unique(dataT.pos_x);
end

if glassY ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2) - unique(dataT.pos_y);
    end
    glassYstim0 = unique(dataT.pos_x) - unique(dataT.pos_x);
end
if glassXstim0 ~=0 || glassYstim0 ~= 0
    fprintf('stimulus did not move to (0,0)')
    keyboard
end
%% make dummy plot to get stimulus bounds
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/',dataT.animal, dataT.programID,dataT.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/',dataT.animal, dataT.programID,dataT.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%%
figure(80)
clf

hold on;
vs = viscircles([0,0],4,...
    'color',[0.8 0 0.6]);
xlim([-10,10])
ylim([-10,10])
axis square
stimX = vs.get.Children(2).XData;
stimY = vs.get.Children(2).YData;

vxSmall = viscircles([0,0],2,...
    'color',[0.8 0 0.6]);
stimXSmall = vxSmall.get.Children(2).XData;
stimYSmall = vxSmall.get.Children(2).YData;
% don't actually need to see it, just want to have the
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
inCenterStim = zeros(1,96);
%%
for ch = 1:96
    rfX = rfParamsStim0{ch}(1);
    rfY = rfParamsStim0{ch}(2);
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
    inStim(1,ch) = (((rfX-0).^2+(rfY-0).^2 <= 4^2));
    inCenterStim(1,ch) = (((rfX-0).^2+(rfY-0).^2 <= 2^2));
end
%% plot all receptive fields on one figure

figure(5)
clf
viscircles([glassX,glassY],4,...
    'color',[0.2 0.2 0.2]);
viscircles([glassX,glassY],2,...
    'color',[0.2 0.2 0.2]);
grid on;

for ch = 1:96
    
    hold on
    
    if inCenterStim(ch) == 1
        scatter(rfParamsRelGlassFix{ch}(1),rfParamsRelGlassFix{ch}(2),40,[1 0.4 0],'filled','MarkerFaceAlpha',0.8);
    elseif inStim(ch) == 1 && inCenterStim(ch) == 0
        scatter(rfParamsRelGlassFix{ch}(1),rfParamsRelGlassFix{ch}(2),40,[0 0.6 0.2],'filled','MarkerFaceAlpha',0.7);
    else
        scatter(rfParamsRelGlassFix{ch}(1),rfParamsRelGlassFix{ch}(2),40,[0.5 0.5 0.5],'filled','MarkerFaceAlpha',0.7);
    end

    xlim([-15,15])
    ylim([-15,15])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    
end
plot(dataT.fix_x,dataT.fix_y,'+k','MarkerFaceColor','k')
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))
if contains(dataT.animal,'XT')
title({sprintf('%s BE %s %s',dataT.animal, dataT.array, dataT.programID);...
    sprintf('%d in stimulus boundary, %d in center half of stimulus',sum(inStim), sum(inCenterStim))})
else
    title({sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID);...
    sprintf('%d in stimulus boundary, %d in center half of stimulus',sum(inStim), sum(inCenterStim))})
end
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelGlassStim','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
