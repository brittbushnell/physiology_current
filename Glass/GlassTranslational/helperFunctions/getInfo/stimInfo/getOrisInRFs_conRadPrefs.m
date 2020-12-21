function quadOris = getOrisInRFs_conRadPrefs(trData,crData)
%% get quadrant locations for all included channels
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
prefParams = trData.prefParamsIndex;

for ch = 1:96
    chRanks(:,ch) = crData.dPrimeRankBlank{prefParams(ch)}(:,ch);
end

q1Ranks = chRanks(:,quad == 1);
q2Ranks = chRanks(:,quad == 2);
q3Ranks = chRanks(:,quad == 3);
q4Ranks = chRanks(:,quad == 4);
%% now, for all channels with receptive fields inside the stimulus boundaries
quadInStim = trData.rfQuadrant(trData.inStim == 1);
q1InStim = deg2rad(trData.prefParamsPrefOri(quadInStim == 1));  % This is already  limited to good channels, so no need to add another qualifier
q2InStim = deg2rad(trData.prefParamsPrefOri(quadInStim == 2));
q3InStim = deg2rad(trData.prefParamsPrefOri(quadInStim == 3));
q4InStim = deg2rad(trData.prefParamsPrefOri(quadInStim == 4));
quadInStimOris = [q1InStim;q2InStim;q3InStim;q4InStim];

% remove nans
q1InStim(isnan(q1InStim)) = [];
q2InStim(isnan(q2InStim)) = [];
q3InStim(isnan(q3InStim)) = [];
q4InStim(isnan(q4InStim)) = [];
%%
% get stimulus rankings for each quadrant
chRanks = nan(3,96);
prefParams = trData.prefParamsIndex;

for ch = 1:96
    chRanks(:,ch) = crData.dPrimeRankBlank{prefParams(ch)}(:,ch);
end

q1RanksInStim = chRanks(:,quadInStim == 1);
q2RanksInStim = chRanks(:,quadInStim == 2);
q3RanksInStim = chRanks(:,quadInStim == 3);
q4RanksInStim = chRanks(:,quadInStim == 4);
%%
quadInStimCenter = trData.rfQuadrant(trData.inStimCenter == 1);
q1InStimCenter = deg2rad(trData.prefParamsPrefOri(quadInStimCenter == 1));  % This is already  limited to good channels, so no need to add another qualifier
q2InStimCenter = deg2rad(trData.prefParamsPrefOri(quadInStimCenter == 2));
q3InStimCenter = deg2rad(trData.prefParamsPrefOri(quadInStimCenter == 3));
q4InStimCenter = deg2rad(trData.prefParamsPrefOri(quadInStimCenter == 4));
quadInStimCenterOris = [q1InStimCenter;q2InStimCenter;q3InStimCenter;q4InStimCenter];

% remove nans
q1InStimCenter(isnan(q1InStimCenter)) = [];
q2InStimCenter(isnan(q2InStimCenter)) = [];
q3InStimCenter(isnan(q3InStimCenter)) = [];
q4InStimCenter(isnan(q4InStimCenter)) = [];
%%
% get stimulus rankings for each quadrant
chRanks = nan(3,96);
prefParams = trData.prefParamsIndex;

for ch = 1:96
    chRanks(:,ch) = crData.dPrimeRankBlank{prefParams(ch)}(:,ch);
end

q1RanksInStimCenter = chRanks(:,quadInStimCenter == 1);
q2RanksInStimCenter = chRanks(:,quadInStimCenter == 2);
q3RanksInStimCenter = chRanks(:,quadInStimCenter == 3);
q4RanksInStimCenter = chRanks(:,quadInStimCenter == 4);
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
axis off

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location all good channels',...
    trData.animal, trData.eye, trData.array));
t.Position(2) = -0.02;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14) 
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14) 
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14) 

%  quadrant 2
s1 = subplot(2,2,1,polaraxes);

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
    % plot radial 
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12) 
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q2)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 1
s1 = subplot(2,2,2,polaraxes);
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
    
        % plot radial 
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12) 
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q1)))
    s1.Position(2) = s1.Position(2) - 0.02;
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
s1 = subplot(2,2,3,polaraxes);
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
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12) 
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q3)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;
% quadrant 4
s1 = subplot(2,2,4,polaraxes);
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
    
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12) 
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q4)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(3)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location all channels within stimulus bounds',...
    trData.animal, trData.eye, trData.array));
t.Position(2) = -0.02;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

%  quadrant 2
s1 = subplot(2,2,1,polaraxes);

if ~isempty(q2InStim)
    hold on
    cirMu = circ_mean(q2InStim*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2InStim*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q2RanksInStim(1,:) == 1);
    prefRad = sum(q2RanksInStim(1,:) == 2);
    prefNos = sum(q2RanksInStim(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q2InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q2InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q2InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    % plot radial
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q2InStim)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 1
s1 = subplot(2,2,2,polaraxes);
if ~isempty(q1InStim)
    hold on
    cirMu = circ_mean(q1InStim*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q1RanksInStim(1,:) == 1);
    prefRad = sum(q1RanksInStim(1,:) == 2);
    prefNos = sum(q1RanksInStim(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q1InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q1InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q1InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    
    % plot radial
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q1InStim)))
    s1.Position(2) = s1.Position(2) - 0.02;
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
s1 = subplot(2,2,3,polaraxes);
if ~isempty(q3InStim)
    hold on
    cirMu = circ_mean(q3InStim*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q3RanksInStim(1,:) == 1);
    prefRad = sum(q3RanksInStim(1,:) == 2);
    prefNos = sum(q3RanksInStim(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q3InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q3InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q3InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q3InStim)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;
% quadrant 4
s1 = subplot(2,2,4,polaraxes);
if ~isempty(q4InStim)
    hold on
    cirMu = circ_mean(q4InStim*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q4InStim*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q4RanksInStim(1,:) == 1);
    prefRad = sum(q4RanksInStim(1,:) == 2);
    prefNos = sum(q4RanksInStim(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q4InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q4InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q4InStim,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4InStim+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
        %polarplot([cirVar 0 cirVar2],[0.4 0 0.4],'k:','LineWidth',.85)
    end
    
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q4InStim)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_inStim','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(4)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location all channels in center half of stim',...
    trData.animal, trData.eye, trData.array));
t.Position(2) = -0.02;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

%  quadrant 2
s1 = subplot(2,2,1,polaraxes);

if ~isempty(q2InStimCenter)
    hold on
    cirMu = circ_mean(q2InStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2InStimCenter*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q2RanksInStimCenter(1,:) == 1);
    prefRad = sum(q2RanksInStimCenter(1,:) == 2);
    prefNos = sum(q2RanksInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q2InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q2InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q2InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    % plot radial
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q2InStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 1
s1 = subplot(2,2,2,polaraxes);
if ~isempty(q1InStimCenter)
    hold on
    cirMu = circ_mean(q1InStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q1RanksInStimCenter(1,:) == 1);
    prefRad = sum(q1RanksInStimCenter(1,:) == 2);
    prefNos = sum(q1RanksInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q1InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q1InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q1InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    
    % plot radial
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    
    title(sprintf('n:%d',length(q1InStimCenter)))
    s1.Position(2) = s1.Position(2) - 0.02;
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
s1 = subplot(2,2,3,polaraxes);
if ~isempty(q3InStimCenter)
    hold on
    cirMu = circ_mean(q3InStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q3RanksInStimCenter(1,:) == 1);
    prefRad = sum(q3RanksInStimCenter(1,:) == 2);
    prefNos = sum(q3RanksInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q3InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q3InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q3InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    end
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q3InStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;
% quadrant 4
s1 = subplot(2,2,4,polaraxes);
if ~isempty(q4InStimCenter)
    hold on
    cirMu = circ_mean(q4InStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q4InStimCenter*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q4RanksInStimCenter(1,:) == 1);
    prefRad = sum(q4RanksInStimCenter(1,:) == 2);
    prefNos = sum(q4RanksInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q4InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q4InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q4InStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4InStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
        %polarplot([cirVar 0 cirVar2],[0.4 0 0.4],'k:','LineWidth',.85)
    end
    
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    
    text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
    
    text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
    text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')
    set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
    title(sprintf('n:%d',length(q4InStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_InStimCenter','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')