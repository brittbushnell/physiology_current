function [rfQuadrant,inStim,inCenterStim,within2degStim] = getRFsRelGlass_ecc_Sprinkles(trData, crData)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
% Receptive fields are relative to fixation at (0,0). In order to get
% quadrants, need to move the stimulus center to (0,0) which means
% adjusting receptive field centers and stimulus center in the correct
% direction.

%%
glassX = unique(trData.pos_x);
glassY = unique(trData.pos_y);

if contains(trData.animal,'XT') && contains(trData.array,'V4')
    rfParamsOrig = trData.chReceptiveFieldParamsBE;
else
    rfParamsOrig = trData.chReceptiveFieldParams;
end
%% for XT, move receptive field locations to be in same coordinate space as Glass fixation
if contains(trData.animal,'XT')
    for ch = 1:96
        rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1) + unique(trData.fix_x);
        rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2) + unique(trData.fix_y);
    end
else
        for ch = 1:96
        rfParamsRelGlassFix{ch}(1) = rfParamsOrig{ch}(1);
        rfParamsRelGlassFix{ch}(2) = rfParamsOrig{ch}(2);
    end
end
%% center stimulus at (0,0)
% Need stimulus to be centered at origin to define the quadrants according
% to their signs

if glassX ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1) - unique(trData.pos_x);
    end
    glassXstim0 = unique(trData.pos_x) - unique(trData.pos_x);
else
    for ch = 1:96
        rfParamsStim0{ch}(1) = rfParamsRelGlassFix{ch}(1);
    end
    glassXstim0 = unique(trData.pos_x);
end

if glassY ~= 0
    for ch = 1:96
        rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2) - unique(trData.pos_y);
    end
    glassYstim0 = unique(trData.pos_x) - unique(trData.pos_x);
else
    for ch = 1:96
        rfParamsStim0{ch}(2) = rfParamsRelGlassFix{ch}(2);
    end
    glassYstim0 = unique(trData.pos_x);
end
if glassXstim0 ~=0 && glassYstim0 ~= 0
    fprintf('stimulus did not move to (0,0) \n')
    keyboard
end
%% make dummy plot to get stimulus bounds
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/',trData.animal, trData.programID,trData.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/',trData.animal, trData.programID,trData.array);
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
within2degStim = zeros(1,96);
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
    within2degStim(1,ch) = (((rfX-0).^2+(rfY-0).^2 <= 6^2));
end
%% plot all receptive fields on one figure

figure%(5)
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
plot(trData.fix_x,trData.fix_y,'+k','MarkerFaceColor','k')
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))

if contains(trData.animal,'XT') && contains(trData.array,'V4')
    title({sprintf('%s BE %s %s',trData.animal, trData.array, trData.programID);...
        sprintf('%d in stimulus boundary, %d in center degree of stimulus',sum(inStim), sum(inCenterStim))})
else
    title({sprintf('%s %s %s %s',trData.animal, trData.eye, trData.array, trData.programID);...
        sprintf('%d in stimulus boundary, %d in center degree of stimulus',sum(inStim), sum(inCenterStim))})
end

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_RFlocRelGlassStim','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% glitteratti plot

figure %(8)
clf
hold on
viscircles([glassX,glassY],6,...
    'color',[0.2 0.2 0.2],'LineWidth',0.5);
viscircles([glassX,glassY],4,...
    'color',[0.2 0.2 0.2],'LineWidth',0.6);
viscircles([glassX,glassY],2,...
    'color',[0.2 0.2 0.2],'LineWidth',0.6);
grid on;
for ch = 1:96
    if trData.goodCh(ch) == 1
        pOri = trData.prefParamsPrefOri(ch);
        rfX = rfParamsRelGlassFix{ch}(1);
        rfY = rfParamsRelGlassFix{ch}(2);
        o = squeeze(trData.OSI(1,:,:,ch));
        lwidth = o(trData.prefParamsIndex(ch));
        %         t(ch) =lwidth;
        if lwidth > 0.5
            lLen = 1+(lwidth^2);
        else
            lLen = 1-(lwidth^2);
        end
        x2 = rfX +(lLen*cos(pOri));
        y2 = rfY +(lLen*sin(pOri));
        
        if crData.dPrimeRankBlank{trData.prefParamsIndex(ch)}(ch) == 1
            plot([rfX, x2], [rfY, y2],'-','color',[0.7 0 0.7],'lineWidth',lLen)
        elseif crData.dPrimeRankBlank{trData.prefParamsIndex(ch)}(ch) == 2
            plot([rfX, x2], [rfY, y2],'-','color',[0 0.6 0.2],'lineWidth',lLen)
        else
            plot([rfX, x2], [rfY, y2],'-','color',[1 0.5 0.1],'lineWidth',lLen)
        end
    end
xlim([-15,15])
ylim([-15,15])
set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')    
end
text(-14, 14, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14) 
text(-14, 13, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14) 
text(-14, 12, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14) 

axis square
suptitle({'Preferred orientations and pattern type for each channel and their receptive field locations';...
    sprintf('%s %s %s',trData.animal, trData.eye, trData.array)})

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_RFloc_prefOri_prefPattern','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')