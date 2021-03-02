function [] = getRFsinGlass_V1V4_BE(V1dataLE,V4dataLE,V1dataRE,V4dataRE)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%

%%
StimXcenter = unique(V1dataLE.pos_x);
StimYcenter = unique(V1dataLE.pos_y);

fixX  = unique(V1dataLE.fix_x);
fixY  = unique(V1dataLE.fix_y);

V1rfParamsLE = V1dataLE.chReceptiveFieldParams;
V4rfParamsLE = V4dataLE.chReceptiveFieldParams;

V1rfParamsRE = V1dataRE.chReceptiveFieldParams;
V4rfParamsRE = V4dataRE.chReceptiveFieldParams;
%% make dummy plot to get stimulus bounds
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/',V1dataLE.animal,V1dataLE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/',V1dataLE.animal, V1dataLE.programID);
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

V1rfQuadrantLE = nan(1,96);
V1inStimLE = zeros(1,96);

V4rfQuadrantLE = nan(1,96);
V4inStimLE = zeros(1,96);

V1rfQuadrantRE = nan(1,96);
V1inStimRE = zeros(1,96);

V4rfQuadrantRE = nan(1,96);
V4inStimRE = zeros(1,96);

for ch = 1:96
    rfXv1LE = V1rfParamsLE{ch}(1);
    rfYv1E = V1rfParamsLE{ch}(2);
%% LE    
    if rfXv1LE > 0
        if rfYv1E > 0  % RF is in the top right quadrant (+,+)
            V1rfQuadrantLE(ch) = 1;
        else % bottom right (+,-)
            V1rfQuadrantLE(ch) = 4;
        end
    else
        if rfYv1E > 0  % RF is in the top left quadrant (-,+)
            V1rfQuadrantLE(ch) = 2;
        else % bottom left (-,-)
            V1rfQuadrantLE(ch) = 3;
        end
    end
    V1inStimLE(1,ch) = sum(inpolygon(rfXv1LE,rfYv1E,stimX,stimY) & ((rfXv1LE-0).^2+(rfYv1E-0).^2 <= 4^2));
    
    rfXv4LE = V4rfParamsLE{ch}(1);
    rfYv4LE = V4rfParamsLE{ch}(2);
    if rfXv4LE > 0
        if rfYv4LE > 0  % RF is in the top right quadrant (+,+)
            V4rfQuadrantLE(ch) = 1;
        else % bottom right (+,-)
            V4rfQuadrantLE(ch) = 4;
        end
    else
        if rfYv4LE > 0  % RF is in the top left quadrant (-,+)
            V4rfQuadrantLE(ch) = 2;
        else % bottom left (-,-)
            V4rfQuadrantLE(ch) = 3;
        end
    end
    V4inStimLE(1,ch) = sum(inpolygon(rfXv4LE,rfYv4LE,stimX,stimY) & ((rfXv4LE-0).^2+(rfYv4LE-0).^2 <= 4^2));
    %% RE
       rfXv1RE = V1rfParamsRE{ch}(1);
    rfYv1E = V1rfParamsRE{ch}(2);
%% RE    
    if rfXv1RE > 0
        if rfYv1E > 0  % RF is in the top right quadrant (+,+)
            V1rfQuadrantRE(ch) = 1;
        else % bottom right (+,-)
            V1rfQuadrantRE(ch) = 4;
        end
    else
        if rfYv1E > 0  % RF is in the top left quadrant (-,+)
            V1rfQuadrantRE(ch) = 2;
        else % bottom left (-,-)
            V1rfQuadrantRE(ch) = 3;
        end
    end
    V1inStimRE(1,ch) = sum(inpolygon(rfXv1RE,rfYv1E,stimX,stimY) & ((rfXv1RE-0).^2+(rfYv1E-0).^2 <= 4^2));
    
    rfXv4RE = V4rfParamsRE{ch}(1);
    rfYv4RE = V4rfParamsRE{ch}(2);
    if rfXv4RE > 0
        if rfYv4RE > 0  % RF is in the top right quadrant (+,+)
            V4rfQuadrantRE(ch) = 1;
        else % bottom right (+,-)
            V4rfQuadrantRE(ch) = 4;
        end
    else
        if rfYv4RE > 0  % RF is in the top left quadrant (-,+)
            V4rfQuadrantRE(ch) = 2;
        else % bottom left (-,-)
            V4rfQuadrantRE(ch) = 3;
        end
    end
    V4inStimRE(1,ch) = sum(inpolygon(rfXv4RE,rfYv4RE,stimX,stimY) & ((rfXv4RE-0).^2+(rfYv4RE-0).^2 <= 4^2)); 
end
%% plot all receptive fields on one figure

figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 400])
set(gcf,'PaperOrientation','Landscape');
% LE
subplot(1,2,1)
for ch = 1:96
    
    hold on
    if V1dataLE.goodCh(ch) == 1
        draw_ellipse(V1rfParamsLE{ch},[0.8 0 0.6])
    end
    if V4dataLE.goodCh(ch) == 1
        draw_ellipse(V4rfParamsLE{ch},[0.2 0.4 1])
        
    end
    xlim([-12,12])
    ylim([-12,12])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square

end
if contains(V1dataRE.animal,'XT')
    title('LE')
else
    title('FE')
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k')

text(6, 9.7, sprintf('V1 n %d',sum(V1dataLE.goodCh==1)),'FontSize',12,'Color',[0.8 0 0.6])
text(6, 8.7, sprintf('V4 n %d',sum(V4dataLE.goodCh==1)),'FontSize',12,'Color',[0.2 0.4 1])

% RE
subplot(1,2,2)
for ch = 1:96 
    hold on
    if V1dataRE.goodCh(ch) == 1
        draw_ellipse(V1rfParamsRE{ch},[0.8 0 0.6])
    end
    if V4dataRE.goodCh(ch) == 1
        draw_ellipse(V4rfParamsRE{ch},[0.2 0.4 1])
        
    end
    xlim([-12,12])
    ylim([-12,12])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
end
if contains(V1dataRE.animal,'XT')
    title('RE')
else
    title('AE')
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k')
text(6, 9.7, sprintf('V1 n %d',sum(V1dataRE.goodCh==1)),'FontSize',12,'Color',[0.8 0 0.6])
text(6, 8.7, sprintf('V4 n %d',sum(V4dataRE.goodCh==1)),'FontSize',12,'Color',[0.2 0.4 1])

suptitle(sprintf('%s receptive field boundaries relative to Glass pattern stimuli',V1dataLE.animal))

figName = [V1dataLE.animal,'_BE_V1andV4_RFlocRelGlassStim','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(6)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 400])
set(gcf,'PaperOrientation','Landscape');
subplot(1,2,1)
for ch = 1:96
    
    hold on
    if V1dataLE.goodCh(ch) == 1
       scatter(V1rfParamsLE{ch}(1),V1rfParamsLE{ch}(2),35,[0.8 0 0.6],'filled','MarkerFaceAlpha',0.7);
    end
    if V4dataLE.goodCh(ch) == 1
        scatter(V4rfParamsLE{ch}(1),V4rfParamsLE{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    end

    xlim([-12,12])
    ylim([-12,12])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
if contains(V1dataRE.animal,'XT')
    title('LE')
else
    title('FE')
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k')

text(6, 9.7, sprintf('V1 n %d',sum(V1dataLE.goodCh==1)),'FontSize',12,'Color',[0.8 0 0.6])
text(6, 8.7, sprintf('V4 n %d',sum(V4dataLE.goodCh==1)),'FontSize',12,'Color',[0.2 0.4 1])
%% RE
subplot(1,2,2)
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 1
       scatter(V1rfParamsRE{ch}(1),V1rfParamsRE{ch}(2),35,[0.8 0 0.6],'filled','MarkerFaceAlpha',0.7);
    end
    if V4dataRE.goodCh(ch) == 1
        scatter(V4rfParamsRE{ch}(1),V4rfParamsRE{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    end

    xlim([-12,12])
    ylim([-12,12])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
if contains(V1dataRE.animal,'XT')
    title('RE')
else
    title('AE')
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k')

text(6, 9.7, sprintf('V1 n %d',sum(V1dataRE.goodCh==1)),'FontSize',12,'Color',[0.8 0 0.6])
text(6, 8.7, sprintf('V4 n %d',sum(V4dataRE.goodCh==1)),'FontSize',12,'Color',[0.2 0.4 1])
%%
suptitle(sprintf('%s receptive field centers relative to Glass pattern stimuli',V1dataLE.animal))

figName = [V1dataLE.animal,'_BE_V1andV4_RFcenterRelGlassStim.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% plot binocular sites for V1 and V4
diffV1 = nan(1,96);
diffV4 = nan(1,96);

%%
figure(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');

s = subplot(2,2,1); % V1
hold on

s.Position(3) = s.Position(3) +0.015;

nch = 0;
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 1 && V1dataLE.goodCh(ch) == 1
       REx = V1rfParamsRE{ch}(1);
       REy = V1rfParamsRE{ch}(2);
       
       LEx = V1rfParamsLE{ch}(1);
       LEy = V1rfParamsLE{ch}(2);
       
       scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
       scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       plot([REx,LEx],[REy,LEy],'k-')
       
       diffV1(ch) = sqrt(((LEx-REx)^2)+((LEy-LEy)^2));
       nch = nch +1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V1 binocular units')
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')    

s = subplot(2,2,2); % V4
hold on
s.Position(3) = s.Position(3) +0.015;
nch = 0;
for ch = 1:96
    
    hold on
    if V4dataRE.goodCh(ch) == 1 && V4dataLE.goodCh(ch) == 1
       REx = V4rfParamsRE{ch}(1);
       REy = V4rfParamsRE{ch}(2);
       
       LEx = V4rfParamsLE{ch}(1);
       LEy = V4rfParamsLE{ch}(2);
       
       scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
       scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       plot([REx,LEx],[REy,LEy],'k-')
       dTmp = sqrt(((LEx-REx)^2)+((LEy-LEy)^2));
%        if
%        diffV4(ch) = dTmp;
       
       nch = nch+1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V4 binocular units')
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')

s = subplot(2,2,3); % V1
hold on
s.Position(2) = s.Position(2) +0.06;
s.Position(3) = s.Position(3) +0.015;
nch = 0;
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 1 && V1dataLE.goodCh(ch) == 1
       REx = V1rfParamsRE{ch}(1);
       REy = V1rfParamsRE{ch}(2);
       
       LEx = V1rfParamsLE{ch}(1);
       LEy = V1rfParamsLE{ch}(2);
       
      % scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
       %scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       plot([REx,LEx],[REy,LEy],'k-')
       
       diffV1(ch) = sqrt(((LEx-REx)^2)+((LEy-LEy)^2));
       nch = nch +1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end

s = subplot(2,2,4); % V4
hold on
s.Position(2) = s.Position(2) +0.06;
s.Position(3) = s.Position(3) +0.015;
nch = 0;
for ch = 1:96
    
    hold on
    if V4dataRE.goodCh(ch) == 1 && V4dataLE.goodCh(ch) == 1
       REx = V4rfParamsRE{ch}(1);
       REy = V4rfParamsRE{ch}(2);
       
       LEx = V4rfParamsLE{ch}(1);
       LEy = V4rfParamsLE{ch}(2);
       
      % scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
       %scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       plot([REx,LEx],[REy,LEy],'k-')
       dTmp = sqrt(((LEx-REx)^2)+((LEy-LEy)^2));
%        if
%        diffV4(ch) = dTmp;
       
       nch = nch+1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
suptitle(sprintf('%s receptive field centers LE blue RE red',V4dataLE.animal))
%% monocular only
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 800])
set(gcf,'PaperOrientation','Landscape');

s = subplot(2,2,1); % V1
hold on
% s.Position(1) = s.Position(1) - 0.02;
% s.Position(2) = s.Position(2) - 0.02;
 s.Position(3) = s.Position(3) + 0.015;
nch = 0;
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 0 && V1dataLE.goodCh(ch) == 1       
       LEx = V1rfParamsLE{ch}(1);
       LEy = V1rfParamsLE{ch}(2);
       
       scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       nch = nch+1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V1 LE monocular units')
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')    


s = subplot(2,2,2); % V1
hold on
% s.Position(1) = s.Position(1) + 0.02;
% s.Position(2) = s.Position(2) - 0.02;
s.Position(3) = s.Position(3) + 0.03;

nch = 0;
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 1 && V1dataLE.goodCh(ch) == 0     
       REx = V1rfParamsRE{ch}(1);
       REy = V1rfParamsRE{ch}(2);
       
       scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
       nch = nch+1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V1 RE monocular units')
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')

s = subplot(2,2,3); % V1
hold on
% s.Position(1) = s.Position(1) - 0.02;
% s.Position(2) = s.Position(2) - 0.02;
s.Position(3) = s.Position(3) + 0.015;
nch = 0;
for ch = 1:96
    
    hold on
    if V4dataRE.goodCh(ch) == 0 && V4dataLE.goodCh(ch) == 1       
       LEx = V4rfParamsLE{ch}(1);
       LEy = V4rfParamsLE{ch}(2);
       
       scatter(LEx,LEy,35,'b','MarkerFaceAlpha',0.7);
       nch = nch+1;
    end

    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V4 LE monocular units')
    
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')
s = subplot(2,2,4); % V1
hold on
% s.Position(1) = s.Position(1) + 0.02;
% s.Position(2) = s.Position(2) - 0.02;
s.Position(3) = s.Position(3) + 0.03;
nch = 0;
for ch = 1:96
    
    hold on
    if V4dataRE.goodCh(ch) == 1 && V4dataLE.goodCh(ch) == 0    
       nch = nch+1;
       REx = V4rfParamsRE{ch}(1);
       REy = V4rfParamsRE{ch}(2);
       
       scatter(REx,REy,35,'r','MarkerFaceAlpha',0.7);
    end
    
    
    xlim([-10,10])
    ylim([-10,10])
    grid on;
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
title('V4 RE monocular units')
text(8.5,9,sprintf('n %d',nch),'FontWeight','normal')

suptitle(sprintf('%s receptive field centers LE blue RE red',V4dataLE.animal))
