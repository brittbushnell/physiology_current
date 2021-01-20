function [] = plotQuadHist(quadOris, quadRanks, quad, eye) 

hold on
cirMu = circ_mean(quadOris*2)/2;
cirMu2= cirMu+pi;

cirVar = circ_var(quadOris*2)/2;
cirVar2 = cirVar +pi;

prefCon = sum(quadRanks(1,:) == 1);
prefRad = sum(quadRanks(1,:) == 2);
prefNos = sum(quadRanks(1,:) == 3);

if contains(eye,'RE')
    [bins,edges] = histcounts(quadOris,0:pi/6:pi);
    bins2 = sqrt(bins);
    polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
    
    [bins,edges] = histcounts(quadOris+pi,[0:pi/6:pi]+pi);
    bins2 = sqrt(bins);
    polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
    
    polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
else
    [bins,edges] = histcounts(quadOris,0:pi/6:pi);
    bins2 = sqrt(bins);
    polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
    
    [bins,edges] = histcounts(quadOris+pi,[0:pi/6:pi]+pi);
    bins2 = sqrt(bins);
    polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
    
    polarplot([cirMu 0 cirMu2],[0.4 0 0.4],'k-','LineWidth',.85)
end

if quad == 1
    % plot radial
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
elseif quad == 2
    % plot radial
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
elseif quad == 3
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
elseif quad == 4
    % plot radial
    polarplot([deg2rad(315) 0 deg2rad(135)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
    text(deg2rad(125),0.45,sprintf('%d',prefRad),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
    % plot concentric
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.45,sprintf('%d',prefCon),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
end

text(deg2rad(90),0.45,sprintf('%d',prefNos),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
text(cirMu+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu),char(176)),'FontSize',11,'HorizontalAlignment','left','FontWeight','bold')
text(cirMu2+0.2,0.45,sprintf('%.1f%c',rad2deg(cirMu2),char(176)),'FontSize',11,'HorizontalAlignment','right','FontWeight','bold')

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

title(sprintf('n:%d',length(quadOris)))

ax = gca;
ax.RLim   = [0,0.55];