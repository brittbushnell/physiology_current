function [V1rfQuadrant,V1rfParams, V1inStim, V4rfQuadrant,V4rfParams, V4inStim] = getRFsinGlass_V1andV4(V1data,V4data)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%

%%
StimXcenter = unique(V1data.pos_x);
StimYcenter = unique(V1data.pos_y);

fixX  = unique(V1data.fix_x);
fixY  = unique(V1data.fix_y);

V1rfParams = V1data.chReceptiveFieldParams;
V4rfParams = V4data.chReceptiveFieldParams;
%% make dummy plot to get stimulus bounds
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal,V1data.programID, V1data.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal, V1data.programID, V1data.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%
figure(80)
clf
vs = viscircles([StimXcenter, StimYcenter],4,...
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

V1rfQuadrant = nan(1,96);
V1inStim = zeros(1,96);

V4rfQuadrant = nan(1,96);
V4inStim = zeros(1,96);

for ch = 1:96
    rfXv1 = V1rfParams{ch}(1);
    rfYv1 = V1rfParams{ch}(2);
    if rfXv1 > 0
        if rfYv1 > 0  % RF is in the top right quadrant (+,+)
            V1rfQuadrant(ch) = 1;
        else % bottom right (+,-)
            V1rfQuadrant(ch) = 4;
        end
    else
        if rfYv1 > 0  % RF is in the top left quadrant (-,+)
            V1rfQuadrant(ch) = 2;
        else % bottom left (-,-)
            V1rfQuadrant(ch) = 3;
        end
    end
    V1inStim(1,ch) = sum(inpolygon(rfXv1,rfYv1,stimX,stimY) & ((rfXv1-0).^2+(rfYv1-0).^2 <= 4^2));
    
    rfXv4 = V4rfParams{ch}(1);
    rfYv4 = V4rfParams{ch}(2);
    if rfXv4 > 0
        if rfYv4 > 0  % RF is in the top right quadrant (+,+)
            V4rfQuadrant(ch) = 1;
        else % bottom right (+,-)
            V4rfQuadrant(ch) = 4;
        end
    else
        if rfYv4 > 0  % RF is in the top left quadrant (-,+)
            V4rfQuadrant(ch) = 2;
        else % bottom left (-,-)
            V4rfQuadrant(ch) = 3;
        end
    end
    V4inStim(1,ch) = sum(inpolygon(rfXv4,rfYv4,stimX,stimY) & ((rfXv4-0).^2+(rfYv4-0).^2 <= 4^2));
end
%% plot all receptive fields on one figure
cd ../
figure%(5)
clf
for ch = 1:96
    
    hold on
    if V1data.goodCh(ch) == 1
        draw_ellipse(V1rfParams{ch},[0.8 0 0])
    end
    if V4data.goodCh(ch) == 1
        draw_ellipse(V4rfParams{ch},[0.2 0.2 1])
        
    end
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    
    
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k')
text(8, 9.7, sprintf('V1 n %d',sum(V1rfQuadrant==1)),'FontSize',12)
text(-9.5, 9.7, sprintf('V1 n %d',sum(V1rfQuadrant==2)),'FontSize',12)
text(-9.5, -9.25, sprintf('V1 n %d',sum(V1rfQuadrant==3)),'FontSize',12)
text(8, -9.25, sprintf('V1 n %d',sum(V1rfQuadrant==4)),'FontSize',12)

text(8, 9.25, sprintf('V4 n %d',sum(V4rfQuadrant==1)),'FontSize',12)
text(-9.5, 9.25, sprintf('V4 n %d',sum(V4rfQuadrant==2)),'FontSize',12)
text(-9.5, -9.7, sprintf('V4 n %d',sum(V4rfQuadrant==3)),'FontSize',12)
text(8, -9.7, sprintf('V4 n %d',sum(V4rfQuadrant==4)),'FontSize',12)

text(-1, 9.7,'V1','Color',[0.8 0 0],'FontWeight','Bold','FontSize',14)
text(0.6, 9.7,'V4','Color',[0.2 0.2 1],'FontWeight','Bold','FontSize',14)

title(sprintf('%s %s receptive field boundaries relative to Glass pattern stimuli',V1data.animal, V1data.eye))

figName = [V1data.animal,'_',V1data.eye,'_V1andV4_RFlocRelGlassStim','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure%(6)
clf
for ch = 1:96
    
    hold on
    if V1data.goodCh(ch) == 1
        plot(V1rfParams{ch}(1),V1rfParams{ch}(2),'o','MarkerEdgeColor',[0.8 0 0],'MarkerSize',8,'LineWidth',1.5)
    end
    if V4data.goodCh(ch) == 1
        plot(V4rfParams{ch}(1),V4rfParams{ch}(2),'o','MarkerEdgeColor',[0.2 0.2 1],'MarkerSize',8,'LineWidth',1.5)
    end
    
    grid on;
    
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k','MarkerSize',9)

text(8, 9.7, sprintf('V1 n %d',sum(V1rfQuadrant==1)),'FontSize',12)
text(-9.5, 9.7, sprintf('V1 n %d',sum(V1rfQuadrant==2)),'FontSize',12)
text(-9.5, -9.25, sprintf('V1 n %d',sum(V1rfQuadrant==3)),'FontSize',12)
text(8, -9.25, sprintf('V1 n %d',sum(V1rfQuadrant==4)),'FontSize',12)

text(8, 9.25, sprintf('V4 n %d',sum(V4rfQuadrant==1)),'FontSize',12)
text(-9.5, 9.25, sprintf('V4 n %d',sum(V4rfQuadrant==2)),'FontSize',12)
text(-9.5, -9.7, sprintf('V4 n %d',sum(V4rfQuadrant==3)),'FontSize',12)
text(8, -9.7, sprintf('V4 n %d',sum(V4rfQuadrant==4)),'FontSize',12)

text(-1, 9.7,'V1','Color',[0.8 0 0],'FontWeight','Bold','FontSize',14)
text(0.6, 9.7,'V4','Color',[0.2 0.2 1],'FontWeight','Bold','FontSize',14)

title(sprintf('%s %s receptive field centers relative to Glass pattern stimuli',V1data.animal, V1data.eye))

figName = [V1data.animal,'_',V1data.eye,'_V1andV4_RFcenterRelGlassStim.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
