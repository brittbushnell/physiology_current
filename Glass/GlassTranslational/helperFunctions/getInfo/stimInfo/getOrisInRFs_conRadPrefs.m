function quadOris = getOrisInRFs_conRadPrefs(trData,crData)
%%
quad = trData.rfQuadrant(1:96);
q1 = deg2rad(trData.prefParamsPrefOri(quad == 1));  % This is already  limited to good channels, so no need to add another qualifier
q2 = deg2rad(trData.prefParamsPrefOri(quad == 2));
q3 = deg2rad(trData.prefParamsPrefOri(quad == 3));
q4 = deg2rad(trData.prefParamsPrefOri(quad == 4));
quadOris = [q1;q2;q3;q4];

% remove nans
q1(isnan(q1)) = [];
q2(isnan(q2)) = [];
q3(isnan(q3)) = [];
q4(isnan(q4)) = [];
%%
% get stimulus rankings for each quadrant
chRanks = nan(3,96);
prefParams = trLE.prefParamsIndex;

for ch = 1:96
    chRanks(:,ch) = crData.dPrimeRankBlank{prefParams(ch)}(:,ch);
end

q1Ranks = chRanks(:,quad == 1);
q2Ranks = chRanks(:,quad == 2);
q3Ranks = chRanks(:,quad == 3);
q4Ranks = chRanks(:,quad == 4);
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/%s/',trData.animal,trData.programID, trData.array, trData.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/%s/',trData.animal, trData.programID, trData.array, trData.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%

figure(2)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
%  quadrant 2
subplot(4,2,1,polaraxes)
if ~isempty(q2)
    hold on
    cirMu = circ_mean(q2*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q2Ranks(1,:) == 1);
    prefRad = sum(q2Ranks(1,:) == 2);
    prefNos = sum(q2Ranks(1,:) == 3);
    
    if contains(trData.eye,'RE')
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
    
    title(sprintf('n:%d con: %d rad: %d noise: %d',length(q2),prefCon,prefRad,prefNos))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})


s = subplot(4,2,3);
hold on
h = histogram(q1Ranks(1,:),'Normalization','probability');
s.Position = [0.1 0.6 0.2 0.15];
%% quadrant 1
subplot(4,2,2,polaraxes)
if ~isempty(q1)
    hold on
    cirMu = circ_mean(q1*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q1Ranks(1,:) == 1);
    prefRad = sum(q1Ranks(1,:) == 2);
    prefNos = sum(q1Ranks(1,:) == 3);
    
    if contains(trData.eye,'RE')
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
    
    title(sprintf('n:%d con: %d rad: %d noise: %d',length(q1),prefCon,prefRad,prefNos))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
subplot(4,2,3,polaraxes)
if ~isempty(q3)
    hold on
    cirMu = circ_mean(q3*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q3Ranks(1,:) == 1);
    prefRad = sum(q3Ranks(1,:) == 2);
    prefNos = sum(q3Ranks(1,:) == 3);
    
    if contains(trData.eye,'RE')
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
    title(sprintf('n:%d con: %d rad: %d noise: %d',length(q3),prefCon,prefRad,prefNos))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 4
subplot(4,2,4,polaraxes)
if ~isempty(q4)
    hold on
    cirMu = circ_mean(q4*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q4*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q4Ranks(1,:) == 1);
    prefRad = sum(q4Ranks(1,:) == 2);
    prefNos = sum(q4Ranks(1,:) == 3);
    
    if contains(trData.eye,'RE')
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
    title(sprintf('n:%d con: %d rad: %d noise: %d',length(q4),prefCon,prefRad,prefNos))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location',...
    trData.animal, trData.eye, trData.array));
t.Position(2) = -0.02;
t.FontSize = 18;


figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')