function quadOris = getOrisInRFs(dataT)
%%
quad = dataT.rfQuadrant(1:96);
q1 = deg2rad(dataT.prefParamsPrefOri(quad == 1));  % This is already limited to good channels, so no need to add another qualifier
q2 = deg2rad(dataT.prefParamsPrefOri(quad == 2));
q3 = deg2rad(dataT.prefParamsPrefOri(quad == 3));
q4 = deg2rad(dataT.prefParamsPrefOri(quad == 4));
quadOris = [q1;q2;q3;q4];

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
%%
location = determineComputer;
if length(dataT.inStim) > 96 % running on a single session rather than merged data
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/singleSession/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/singleSession/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/',dataT.animal,dataT.programID, dataT.array, dataT.eye);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/',dataT.animal, dataT.programID, dataT.array, dataT.eye);
    end
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%

figure
clf
% quadrant 2
subplot(2,2,1,polaraxes)
if ~isempty(q2)
    hold on
    cirMu = circ_mean(q2*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2*2)/2;
    cirVar2 = cirVar +pi;
    
    if contains(dataT.eye,'RE')
        [bins,edges] = histcounts(q2,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q2+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q2,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n %d',length(q2)))
    
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
        [bins,edges] = histcounts(q1,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q1+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q1,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n %d',length(q1)))
    
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
        [bins,edges] = histcounts(q3,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q3+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q3,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n %d',length(q3)))
    
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
    
    cirVar = circ_var(q4*2)/2;
    cirVar2 = cirVar +pi;
    if contains(dataT.eye,'RE')
        [bins,edges] = histcounts(q4,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q4+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q4,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
        %polarplot([cirVar 0 cirVar2],[0.4 0 0.4],'k:','LineWidth',.85)
    end
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n %d',length(q4)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location',...
    dataT.animal, dataT.eye, dataT.array));
t.Position(2) = -0.02;
t.FontSize = 18;


figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_prefOriByRFlocation','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')