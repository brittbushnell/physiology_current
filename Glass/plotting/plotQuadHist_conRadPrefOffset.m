function [] = plotQuadHist_conRadPrefOffset(quadOris, quadRanks,quad)

if quad == 1
    sp = 2;
    qOris = quadOris.q1;
    qRanks = quadRanks.q1;
elseif quad == 2
    sp = 1;
    qOris = quadOris.q2;
    qRanks = quadRanks.q2;
elseif quad == 3
    sp = quad;
    qOris = quadOris.q3;
    qRanks = quadRanks.q3;
else
    sp = quad;
    qOris = quadOris.q4;
    qRanks = quadRanks.q4;
end

%%
%  clf
% subplot(1,1,1,polaraxes);
s1 = subplot(2,2,sp,polaraxes);
hold on
conOris = (qOris(qRanks == 1));
radOris = (qOris(qRanks == 2));
dipOris = (qOris(qRanks == 3));

if quad == 2 || quad == 4
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],':','color',[0 0.6 0.2],'LineWidth',0.7)
    text(deg2rad(125),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
else
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],':','color',[0 0.6 0.2],'LineWidth',0.7)
    text(deg2rad(55),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
end
if quad == 2 || quad == 4
    polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],':','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(55),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
else
    polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],':','color',[0.7 0 0.7],'LineWidth',0.85)
    text(deg2rad(125),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
end
% dipole distributions
[bins,edges] = histcounts(dipOris+pi,[0.2:pi/20:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
 % plot the reflected value
[bins,edges] = histcounts(dipOris,0.2:pi/20:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.45)
text(deg2rad(91),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)


% concentric distributions
[bins,edges] = histcounts(conOris+pi,[0:pi/20:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/20:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)



% radial distributions
[bins,edges] = histcounts(radOris+pi,[0.1:pi/20:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0.1:pi/20:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)
%

%%

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})
title(sprintf('n:%d',length(qOris)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(2) = s1.Position(2) - 0.02;
