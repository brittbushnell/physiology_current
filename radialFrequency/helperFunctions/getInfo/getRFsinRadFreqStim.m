function [rfQuadrant,rfParams, inStim] = getRFsinRadFreqStim(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%

%%
% radX = unique(dataT.pos_x);
% radY = unique(dataT.pos_y);
% rfParams = dataT.chReceptiveFieldParams;
% % adjust
% if radX ~= 0
%     for ch = 1:96
%         rfParams{ch}(1) = rfParams{ch}(1) - radX(2);
%     end
% end
%
% if radY ~= 0
%     for ch = 1:96
%         rfParams{ch}(2) = rfParams{ch}(2) - radY(2);
%     end
% end
%% stimulus locations for each animal:
rfParams = dataT.chReceptiveFieldParams;

if contains(dataT.animal,'WV')
    radX = [0 2 2];
    radY = [0 -2 0];
elseif contains(dataT.animal,'XT')
    radX = [0 2 1];
    radY = [-4 -4 -5];
elseif contains(dataT.animal,'WU')
    if contains(dataT.programID,'Loc1','IgnoreCase',true)
        radX = [-4.5 -3 -1.5];
        radY = [1.5 0 -1.5];
    else
        radX = [-4.5 -1.5 -3];
        radY = [-1.5 1.5 0];
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
hold on;
vs1 = viscircles([radX(1),radY(1)],4,...
    'color',[0.8 0 0.6]);

vs2 = viscircles([radX(2),radY(2)],4,...
    'color',[0.8 0 0.6]);

vs3 = viscircles([radX(3),radY(3)],4,...
    'color',[0.8 0 0.6]);


stimX1 = vs1.get.Children(2).XData;
stimY1 = vs1.get.Children(2).YData;

stimX2 = vs1.get.Children(2).XData;
stimY2 = vs1.get.Children(2).YData;

stimX3 = vs1.get.Children(2).XData;
stimY3 = vs1.get.Children(2).YData;

xlim([-10,10])
ylim([-10,10])
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
inStim = ones(1,96);

for ch = 1%:96
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
    %inStim(1,ch) = sum(inpolygon(rfX,rfY,stimX,stimY) & ((rfX-0).^2+(rfY-0).^2 <= 4^2));
    
    figure(4)
    clf
    hold on
    vs1 = viscircles([radX(1),radY(1)],4,...
        'color',[0.8 0 0.6]);
    
    vs2 = viscircles([radX(2),radY(2)],4,...
        'color',[0.8 0 0.6]);
    
    vs3 = viscircles([radX(3),radY(3)],4,...
        'color',[0.8 0 0.6]);
    
    
    stimX1 = vs1.get.Children(2).XData;
    stimY1 = vs1.get.Children(2).YData;
    
    stimX2 = vs1.get.Children(2).XData;
    stimY2 = vs1.get.Children(2).YData;
    
    stimX3 = vs1.get.Children(2).XData;
    stimY3 = vs1.get.Children(2).YData;
    
    plot(dataT.fix_x,dataT.fix_y,'s','MarkerFaceColor',[0.8 0 0.6],'MarkerEdgeColor','w','MarkerSize',9)
    if inStim(ch) == 1
        draw_ellipse(rfParams{ch})
    else
        draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
    end
    
    plot(rfX,rfY,'.k','MarkerSize',14)
    grid on;
    
    title({sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID);...
        sprintf('ch %d quadrant %d',ch,rfQuadrant(ch))})
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelRadFreqStims_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
    
end
%% plot all receptive fields on one figure
cd ../
figure(5)
clf
hold on

for ch = 1:96
    if inStim(ch) == 1
        draw_ellipse(rfParams{ch})
    else
        draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
    end
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    vs1 = viscircles([radX(1),radY(1)],4,...
        'color',[0.8 0 0.6]);
    
    vs2 = viscircles([radX(2),radY(2)],4,...
        'color',[0.8 0 0.6]);
    
    vs3 = viscircles([radX(3),radY(3)],4,...
        'color',[0.8 0 0.6]);
    
    
    stimX1 = vs1.get.Children(2).XData;
    stimY1 = vs1.get.Children(2).YData;
    
    stimX2 = vs1.get.Children(2).XData;
    stimY2 = vs1.get.Children(2).YData;
    
    stimX3 = vs1.get.Children(2).XData;
    stimY3 = vs1.get.Children(2).YData;
    
    plot(dataT.fix_x,dataT.fix_y,'s','MarkerFaceColor',[0.8 0 0.6],'MarkerEdgeColor','w','MarkerSize',9)
end
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))

title(sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelRadFreqStims','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
