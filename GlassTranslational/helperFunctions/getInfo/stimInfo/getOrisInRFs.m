function [rfQuadrant, quadOris] = getOrisInRFs(glassData,rfData)
% This function determines which quadrant of the stimulus receptive fields
% are in, and what the distribution of preferred orientations are for
% receptive fields within each quadrant.
%
%
% TO DO:
%    - limit to receptive fields within the stimulus boundaries
%    - for each quadrant add in the proportion of those channels that
%    prefer radial or concentric

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
%
%  Quadrants:        2 | 1
%                   -------
%                    3 | 4
%

rfQuadrant = nan(1,96);
for ch = 1:96
    rfX = rfParams{ch}(1);
    rfY = rfParams{ch}(2);
    
    if rfX > 0
        if rfY > 0  % RF is in the top right quadrant
            rfQuadrant(ch) = 1;
        else % bottom right
            rfQuadrant(ch) = 4;
        end
    else
        if rfY > 0  % RF is in the top left quadrant
            rfQuadrant(ch) = 2;
        else % bottom left
            rfQuadrant(ch) = 3;
        end
    end
end
%%
q1 = deg2rad(glassData.prefParamsPrefOri(rfQuadrant == 1));  % This is already  limited to good channels, so no need to add another qualifier
q2 = deg2rad(glassData.prefParamsPrefOri(rfQuadrant == 2));
q3 = deg2rad(glassData.prefParamsPrefOri(rfQuadrant == 3));
q4 = deg2rad(glassData.prefParamsPrefOri(rfQuadrant == 4));
quadOris = [q1;q2;q3;q4];

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
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
        'FaceColor',[0.6 0.6 0.0]);
    title(ch)
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
end
%%
figure (5)
clf

% quadrant 2
subplot(2,2,1,polaraxes)
if ~isempty(q2)
    hold on
    cirMu = circ_mean(q2*2)/2;
    cirMu2= cirMu+pi;
    
    if contains(glassData.eye,'RE')
        polarhistogram(q2,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarhistogram(q2+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
    else
        [bins,edges] = histcounts(q2,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'b-','LineWidth',.85)
        text(cirMu+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left')
        text(cirMu2+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right')
        set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
        
        %     polarhistogram(q2,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarhistogram(q2+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarplot(nanmedian(q2),0.25,'<w','MarkerFaceColor','b','MarkerSize',8)
        %     polarplot(nanmedian(q2)+pi,0.25,'>w','MarkerFaceColor','b','MarkerSize',8)
        %     text(nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2))),'FontSize',11)
        %     text(pi+nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2)+pi)),'FontSize',11)
        
    end
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
% quadrant 1
subplot(2,2,2,polaraxes)
if ~isempty(q1)
    hold on
    cirMu = circ_mean(q1*2)/2;
    cirMu2= cirMu+pi;
    
    if contains(glassData.eye,'RE')
        polarhistogram(q1,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarhistogram(q1+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
    else
        [bins,edges] = histcounts(q1,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'b-','LineWidth',.85)
        text(cirMu+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left')
        text(cirMu2+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right')
        set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
        
        %     polarhistogram(q2,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarhistogram(q2+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarplot(nanmedian(q2),0.25,'<w','MarkerFaceColor','b','MarkerSize',8)
        %     polarplot(nanmedian(q2)+pi,0.25,'>w','MarkerFaceColor','b','MarkerSize',8)
        %     text(nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2))),'FontSize',11)
        %     text(pi+nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2)+pi)),'FontSize',11)
        
    end
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
% quadrant 3
subplot(2,2,3,polaraxes)
if ~isempty(q3)
    hold on
    cirMu = circ_mean(q3*2)/2;
    cirMu2= cirMu+pi;
    
    if contains(glassData.eye,'RE')
        polarhistogram(q3,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarhistogram(q3+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
    else
        [bins,edges] = histcounts(q3,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'b-','LineWidth',.85)
        text(cirMu+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left')
        text(cirMu2+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right')
        set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
        
        %     polarhistogram(q2,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarhistogram(q2+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarplot(nanmedian(q2),0.25,'<w','MarkerFaceColor','b','MarkerSize',8)
        %     polarplot(nanmedian(q2)+pi,0.25,'>w','MarkerFaceColor','b','MarkerSize',8)
        %     text(nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2))),'FontSize',11)
        %     text(pi+nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2)+pi)),'FontSize',11)
        
    end
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 4
subplot(2,2,4,polaraxes)
if ~isempty(q4)
    hold on
    cirMu = circ_mean(q4*2)/2;
    cirMu2= cirMu+pi;
    
    if contains(glassData.eye,'RE')
        polarhistogram(q4,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
        polarhistogram(q4+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','r','EdgeColor','w')
    else
        [bins,edges] = histcounts(q4,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'b-','LineWidth',.85)
        text(cirMu+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left')
        text(cirMu2+0.2,0.5,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right')
        set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
        
        %     polarhistogram(q2,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarhistogram(q2+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')
        %     polarplot(nanmedian(q2),0.25,'<w','MarkerFaceColor','b','MarkerSize',8)
        %     polarplot(nanmedian(q2)+pi,0.25,'>w','MarkerFaceColor','b','MarkerSize',8)
        %     text(nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2))),'FontSize',11)
        %     text(pi+nanmedian(q2)+0.03,0.28,sprintf('mean %.2f',rad2deg(circ_mean(q2)+pi)),'FontSize',11)
        
    end
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location',...
    glassData.animal, glassData.eye, glassData.array));
t.Position(2) = -0.02;
t.FontSize = 18;
