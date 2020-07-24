load('WU_LE_GratingsMapRF_nsp2_20170620_001_thresh35_info_resps');
rfData = data.LE;
load('WU_LE_GlassTR_nsp2_20170825_002_raw_2kFixPerm_OSI_prefOri_PermTests');
glassData = data.LE;
%%
glassX = unique(glassData.pos_x);
glassY = unique(glassData.pos_y);
rfParams = rfData.chReceptiveFieldParams;

if glassX ~= 0
    glassX = glassX - glassX;
    for ch = 1:96
        rfParams{ch}(1) = rfParams{ch}(1) - glassX;
    end
end
if glassY ~= 0
    glassY = glassY - glassY;
    for ch = 1:96
        rfParams{ch}(2) = rfParams{ch}(2) - glassY;
    end
end

glassLeft   = glassX - 4;
glassRight  = glassX + 4;
glassTop    = glassY + 4;
glassBottom = glassY - 4;
%% determine what quadrant of the stimulus the receptive field is in

% glassAngles = 1 means the receptive field is in either top right or
% bottom left quadrants. Here, the local orientations from the radial
% patterns are 45 and 225.

% glassAngles = 2 means the receptive field is in either the top left or
% bottom right quadrants. Here, the local orientations from the radial
% patterns are 135 and 315.
rfQuadrant = nan(1,96);
for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    
    if rfX > 0
        if rfY > 0  % RF is in the top right quadrant
            rfQuadrant(ch) = 1;
        else
            rfQuadrant(ch) = 2;
        end
    else
        if rfY > 0  % RF is in the top right quadrant
            rfQuadrant(ch) = 2;
        else
            rfQuadrant(ch) = 1;
        end
    end
end



oriDivisions = 0:22.5:360; % this will give the angles every 22.5 degrees. 

%%
for ch = 40%1:96
    figure(4)
    clf
    hold on
    plot(glassX,glassY,'.r','MarkerSize',20)
    plot(glassLeft,glassY,'.r','MarkerSize',20)
    plot(glassRight,glassY,'.r','MarkerSize',20)
    plot(glassX,glassTop,'.r','MarkerSize',20)
    plot(glassX,glassBottom,'.r','MarkerSize',20)
    
    draw_ellipse(rfParams{ch})
    
    viscircles([0,0],4,...
        'color',[0.6 0.6 0.0]);
    title(ch)
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
end
%%


