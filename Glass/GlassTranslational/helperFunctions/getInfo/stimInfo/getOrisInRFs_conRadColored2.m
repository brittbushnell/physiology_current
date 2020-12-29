function [quadOris] = getOrisInRFs_conRadColored2(trData,crData)

%% get the preferred stimuli for each channel by quadrant
chRanks = nan(3,96);
prefParams = trData.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if trData.goodCh(ch) == 1
        chRanks(:,ch) = crData.dPrimeRankBlank{prefParams(ch)}(:,ch);
    end
end
%% 
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/',trData.animal,trData.programID, trData.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/',trData.animal, trData.programID, trData.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get quadrant locations for all included channels
t1Text = ({'distribution of preferred orientations all channels within 2 degrees stimulus bounds';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
quads = trData.rfQuadrant(1:96);
[allQuadOris,allQuadRanks] = getGlassPrefsByQuad(trData.prefParamsPrefOri,quads,chRanks);
GlassPolarPlotsByStimQuadrant(allQuadOris,allQuadRanks,t1Text)
figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% now, for all channels with receptive fields inside the stimulus boundaries
quadInStim = trData.rfQuadrant(trData.inStim == 1);
[quadOrisInStim,quadRanksInStim] = getGlassPrefsByQuad(trData.prefParamsPrefOri,quadInStim,chRanks);
%% outer ring of stimulus
quadNotInCenter = trData.rfQuadrant(trData.inStimCenter == 0 & trData.inStim == 1);
[quadOrisNotInCenter,quadRanksNotInCenter] = getGlassPrefsByQuad(quadNotInCenter,chRanks);
%% withing two degrees of the stimulus
quadIn2Deg = trData.rfQuadrant(trData.inStimCenter == 0 & trData.inStim == 1 & trData.within2Deg ==1);
[quadOrisIn2Deg,quadRanksIn2Deg] = getGlassPrefsByQuad(quadIn2Deg,chRanks);
%%

%% all included channels

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
print(gcf, figName,'-dpdf','-bestfit')
%% all channels within 2 degrees
figure%(3)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle({'distribution of preferred orientations all channels within 2 degrees stimulus bounds';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
t.Position(2) = -0.02;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

%  quadrant 2
s1 = subplot(2,2,1,polaraxes);

if ~isempty(q2In2Deg)
    hold on
    cirMu = circ_mean(q2In2Deg*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2In2Deg*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q2RanksIn2Deg(1,:) == 1);
    prefRad = sum(q2RanksIn2Deg(1,:) == 2);
    prefNos = sum(q2RanksIn2Deg(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q2In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q2In2Deg+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q2In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2In2Deg+pi,[0:pi/6:pi]+pi);
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
    
    title(sprintf('n:%d',length(q2In2Deg)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 1
s1 = subplot(2,2,2,polaraxes);
if ~isempty(q1In2Deg)
    hold on
    cirMu = circ_mean(q1In2Deg*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q1RanksIn2Deg(1,:) == 1);
    prefRad = sum(q1RanksIn2Deg(1,:) == 2);
    prefNos = sum(q1RanksIn2Deg(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q1In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q1In2Deg+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q1In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1In2Deg+pi,[0:pi/6:pi]+pi);
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
    
    title(sprintf('n:%d',length(q1In2Deg)))
    s1.Position(2) = s1.Position(2) - 0.02;
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
s1 = subplot(2,2,3,polaraxes);
if ~isempty(q3In2Deg)
    hold on
    cirMu = circ_mean(q3In2Deg*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q3RanksIn2Deg(1,:) == 1);
    prefRad = sum(q3RanksIn2Deg(1,:) == 2);
    prefNos = sum(q3RanksIn2Deg(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q3In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q3In2Deg+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q3In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3In2Deg+pi,[0:pi/6:pi]+pi);
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
    title(sprintf('n:%d',length(q3In2Deg)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;
% quadrant 4
s1 = subplot(2,2,4,polaraxes);
if ~isempty(q4In2Deg)
    hold on
    cirMu = circ_mean(q4In2Deg*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q4In2Deg*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q4RanksIn2Deg(1,:) == 1);
    prefRad = sum(q4RanksIn2Deg(1,:) == 2);
    prefNos = sum(q4RanksIn2Deg(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q4In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q4In2Deg+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q4In2Deg,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4In2Deg+pi,[0:pi/6:pi]+pi);
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
    title(sprintf('n:%d',length(q4In2Deg)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% Channels at the outer ring of the stimulus bounds
figure%(4)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle(sprintf('%s %s %s distribution of preferred orientations based on receptive field location all channels in outer half of stim',...
    trData.animal, trData.eye, trData.array));
t.Position(2) = -0.02;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

%  quadrant 2
s1 = subplot(2,2,1,polaraxes);

if ~isempty(q2NotInStimCenter)
    hold on
    cirMu = circ_mean(q2NotInStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q2NotInStimCenter*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q2RanksNotInStimCenter(1,:) == 1);
    prefRad = sum(q2RanksNotInStimCenter(1,:) == 2);
    prefNos = sum(q2RanksNotInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q2NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q2NotInStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q2NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q2NotInStimCenter+pi,[0:pi/6:pi]+pi);
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
    
    title(sprintf('n:%d',length(q2NotInStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
s1.Position(2) = s1.Position(2) - 0.02;
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 1
s1 = subplot(2,2,2,polaraxes);
if ~isempty(q1NotInStimCenter)
    hold on
    cirMu = circ_mean(q1NotInStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q1RanksNotInStimCenter(1,:) == 1);
    prefRad = sum(q1RanksNotInStimCenter(1,:) == 2);
    prefNos = sum(q1RanksNotInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q1NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q1NotInStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q1NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q1NotInStimCenter+pi,[0:pi/6:pi]+pi);
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
    
    title(sprintf('n:%d',length(q1NotInStimCenter)))
    s1.Position(2) = s1.Position(2) - 0.02;
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

% quadrant 3
s1 = subplot(2,2,3,polaraxes);
if ~isempty(q3NotInStimCenter)
    hold on
    cirMu = circ_mean(q3NotInStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    prefCon = sum(q3RanksNotInStimCenter(1,:) == 1);
    prefRad = sum(q3RanksNotInStimCenter(1,:) == 2);
    prefNos = sum(q3RanksNotInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q3NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q3NotInStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q3NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q3NotInStimCenter+pi,[0:pi/6:pi]+pi);
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
    title(sprintf('n:%d',length(q3NotInStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;
% quadrant 4
s1 = subplot(2,2,4,polaraxes);
if ~isempty(q4NotInStimCenter)
    hold on
    cirMu = circ_mean(q4NotInStimCenter*2)/2;
    cirMu2= cirMu+pi;
    
    cirVar = circ_var(q4NotInStimCenter*2)/2;
    cirVar2 = cirVar +pi;
    
    prefCon = sum(q4RanksNotInStimCenter(1,:) == 1);
    prefRad = sum(q4RanksNotInStimCenter(1,:) == 2);
    prefNos = sum(q4RanksNotInStimCenter(1,:) == 3);
    
    if contains(trData.eye,'RE')
        [bins,edges] = histcounts(q4NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        [bins,edges] = histcounts(q4NotInStimCenter+pi,[0:pi/6:pi]+pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
        
        polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
    else
        [bins,edges] = histcounts(q4NotInStimCenter,0:pi/6:pi);
        bins2 = sqrt(bins);
        polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
        
        [bins,edges] = histcounts(q4NotInStimCenter+pi,[0:pi/6:pi]+pi);
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
    title(sprintf('n:%d',length(q4NotInStimCenter)))
    
    ax = gca;
    ax.RLim   = [0,0.55];
end
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_NotInStim1deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% within 2 degrees and color coded bars
figure%(13)
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
axis off

t = suptitle({'Distributions of preferred orientations based on RF location';...
    sprintf('%s %s %s',trData.animal, trData.eye, trData.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(0.35, -0.1, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0.5, -0.1, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.6, -0.1, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

s1 = subplot(2,2,1,polaraxes);
hold on

radDomOri = 45;
conDomOri = 135;
q2PrefOris = q2In2Deg';
q2PrefStim = q2RanksIn2Deg(1,:);
conOris = (q2PrefOris(q2PrefStim == 1));
radOris = (q2PrefOris(q2PrefStim == 2));
dipOris = (q2PrefOris(q2PrefStim == 3));

% dipole distributions
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
text(deg2rad(91),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)

% concentric distributions
[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
text(deg2rad(55),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
text(deg2rad(125),0.45,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
title(sprintf('n:%d',length(q2In2Deg)))

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(2) = s1.Position(2) - 0.02;

s1 = subplot(2,2,2,polaraxes);
hold on

radDomOri = 45;
conDomOri = 135;
q1PrefOris = q1In2Deg';
q1PrefStim = q1RanksIn2Deg(1,:);
conOris = (q1PrefOris(q1PrefStim == 1));
radOris = (q1PrefOris(q1PrefStim == 2));
dipOris = (q1PrefOris(q1PrefStim == 3));

% dipole distributions
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
text(deg2rad(91),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)

% concentric distributions
[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
text(deg2rad(125),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
text(deg2rad(55),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
title(sprintf('n:%d',length(q1In2Deg)))

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(2) = s1.Position(2) - 0.02;

s1 = subplot(2,2,3,polaraxes);
hold on

radDomOri = 45;
conDomOri = 135;
q3PrefOris = q3In2Deg';
q3PrefStim = q3RanksIn2Deg(1,:);
conOris = (q3PrefOris(q3PrefStim == 1));
radOris = (q3PrefOris(q3PrefStim == 2));
dipOris = (q3PrefOris(q3PrefStim == 3));

% dipole distributions
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
text(deg2rad(91),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)

% concentric distributions
[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
text(deg2rad(125),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
text(deg2rad(55),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
title(sprintf('n:%d',length(q3In2Deg)))

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(2) = s1.Position(2) - 0.02;

s1 = subplot(2,2,4,polaraxes);
hold on

radDomOri = 45;
conDomOri = 135;
q4PrefOris = q4In2Deg';
q4PrefStim = q4RanksIn2Deg(1,:);
conOris = (q4PrefOris(q4PrefStim == 1));
radOris = (q4PrefOris(q4PrefStim == 2));
dipOris = (q4PrefOris(q4PrefStim == 3));

% dipole distributions
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
text(deg2rad(91),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)

% concentric distributions
[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
text(deg2rad(55),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)
polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
text(deg2rad(125),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
title(sprintf('n:%d',length(q4In2Deg)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(2) = s1.Position(2) - 0.02;

figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConColored_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')