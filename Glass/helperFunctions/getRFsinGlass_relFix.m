function [rfQuadrant,rfParams, inStim] = getRFsinGlass_relFix(dataT)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%

%%
stimXcenter = unique(dataT.pos_x);
stimYcenter = unique(dataT.pos_y);

fixX  = unique(dataT.fix_x);
fixY  = unique(dataT.fix_y);

rfParams = dataT.chReceptiveFieldParams;

% if fixX ~= 0  
%     for ch = 1:96
%         rfParams{ch}(1) = rfParams{ch}(1) - fixX;
%     end
% end
% 
% if fixY ~= 0
%     for ch = 1:96
%         rfParams{ch}(2) = rfParams{ch}(2) - fixY;
%     end
% end
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

%
figure(80)
clf
vs = viscircles([stimXcenter, stimYcenter],4,...
    'color',[0.8 0 0.6]);
xlim([-10,10])
ylim([-10,10])
stimX = vs.get.Children(2).XData;
stimY = vs.get.Children(2).YData;
set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
    'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
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
    
%     figure(4)
%     clf
%     hold on
%     if inStim(ch) == 1
%         draw_ellipse(rfParams{ch})
%     else
%         draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
%     end
%     
%     viscircles([stimXcenter, stimYcenter],4,...
%         'color',[0.8 0 0.6],'LineWidth',3);
%     
%     plot(rfX,rfY,'.k','MarkerSize',14)
%     plot(fixX, fixY,'s','MarkerFaceColor',[0.8 0 0.6],'MarkerEdgeColor','w','MarkerSize',10)
%     grid on;
%     
%     title({sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID);...
%         sprintf('ch %d quadrant %d',ch,rfQuadrant(ch))})
%     xlim([-10,10])
%     ylim([-10,10])
%     set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
%         'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
%     axis square
%     
%     figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelGlassStim_ch',num2str(ch),'.pdf'];
%     %print(gcf, figName,'-dpdf','-fillpage')
    
end
%% plot all receptive fields on one figure
cd ../
figure(5)
clf
for ch = 1:96
    
    hold on
    if dataT.goodCh(ch) == 1
        if inStim(ch) == 1
            draw_ellipse(rfParams{ch},[0.3 0.3 0.3])
        else
            draw_ellipse(rfParams{ch},[1 0.8 0.6])
        end
    end
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    
end
viscircles([stimXcenter,stimYcenter],4,...
    'color',[0.8 0 0.6]);
plot(fixX, fixY,'or','MarkerFaceColor','r')
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))

title(sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFlocRelGlassStim_ch',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(6)
clf
for ch = 1:96
    
    hold on
    if dataT.goodCh(ch) == 1
        if inStim(ch) == 1
            plot(rfParams{ch}(1),rfParams{ch}(2),'s','MarkerEdgeColor',[0.2 0.2 0.2],'MarkerSize',8,'LineWidth',1.5)
        else
            plot(rfParams{ch}(1),rfParams{ch}(2),'o','MarkerEdgeColor',[0.2 0.2 0.2],'MarkerSize',8,'LineWidth',1.5)
        end
    end
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
    
    
end
viscircles([stimXcenter,stimYcenter],4,...
    'color',[0.8 0 0.6]);
plot(fixX, fixY,'or','MarkerFaceColor','r','MarkerSize',9)
text(9, 9.5, sprintf('n %d',sum(rfQuadrant==1)))
text(-9.5, 9.5, sprintf('n %d',sum(rfQuadrant==2)))
text(-9.5, -9.5, sprintf('n %d',sum(rfQuadrant==3)))
text(9, -9.5, sprintf('n %d',sum(rfQuadrant==4)))

title(sprintf('%s %s %s %s',dataT.animal, dataT.eye, dataT.array, dataT.programID))

figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_RFcenterRelGlassStim_ch',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
