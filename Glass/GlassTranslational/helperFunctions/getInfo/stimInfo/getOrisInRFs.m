function quadOris = getOrisInRFs(dataT)
%%
rfParams = dataT.chReceptiveFieldParams;

q1 = deg2rad(dataT.prefParamsPrefOri(dataT.rfQuadrant == 1));  % This is already  limited to good channels, so no need to add another qualifier
q2 = deg2rad(dataT.prefParamsPrefOri(dataT.rfQuadrant == 2));
q3 = deg2rad(dataT.prefParamsPrefOri(dataT.rfQuadrant == 3));
q4 = deg2rad(dataT.prefParamsPrefOri(dataT.rfQuadrant == 4));
quadOris = [q1;q2;q3;q4];

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
    figure%(4)
    clf
    hold on    
    draw_ellipse(rfParams{ch})
    
    viscircles([0,0],4,...
        'color',[0.6 0.6 0.0]);
    
    plot(rfParams{ch}(1),rfParams{ch}(2),'.k','MarkerSize',14)
    title(ch)
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',12,'FontAngle','italic')
    axis square
    end
    %pause
end
%%
figure
clf

% quadrant 2
subplot(2,2,1,polaraxes)
if ~isempty(q2)
    hold on
    cirMu = circ_mean(q2*2)/2;
    cirMu2= cirMu+pi;
    
    if contains(dataT.eye,'RE')
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
        
        title(sprintf('n %d',length(q2)))
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
    
    if contains(dataT.eye,'RE')
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
        title(sprintf('n %d',length(q1)))
        
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
    
    if contains(dataT.eye,'RE')
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
        
        title(sprintf('n %d',length(q3)))
        
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
    
    if contains(dataT.eye,'RE')
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
        
        title(sprintf('n %d',length(q4)))
        
    end
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location',...
    dataT.animal, dataT.eye, dataT.array));
t.Position(2) = -0.02;
t.FontSize = 18;