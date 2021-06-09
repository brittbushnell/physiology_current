h = subplot(3,4,9);
hold on
zs = squeeze(LEzTR(3,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',7)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

title(sprintf('%s',LEdata.eye))

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

mygca(1) = gca;
b = get(gca,'YLim');
yMaxs(1) = max(b);
yMins(1) = min(b);

b = get(gca,'XLim');
xMaxs(1) = max(b);
xMins(1) = min(b);

h.Position(4) = h.Position(4) - 0.03;
clear zs

h = subplot(3,4,10);
hold on
zs = squeeze(LEzTR(3,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',7)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

mygca(1) = gca;
b = get(gca,'YLim');
yMaxs(1) = max(b);
yMins(1) = min(b);

b = get(gca,'XLim');
xMaxs(1) = max(b);
xMins(1) = min(b);

h.Position(4) = h.Position(4) - 0.03;
clear zs
%
h = subplot(3,4,11);
hold on
zs = squeeze(REzTR(3,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

mygca(1) = gca;
b = get(gca,'YLim');
yMaxs(1) = max(b);
yMins(1) = min(b);

b = get(gca,'XLim');
xMaxs(1) = max(b);
xMins(1) = min(b);

h.Position(4) = h.Position(4) - 0.03;
clear zs

h = subplot(3,4,12);
hold on
zs = squeeze(REzTR(3,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),yScale(2)+0.01,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',7)
text(nanmean(zs)+0.15,yScale(2)+0.01,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,yScale(2)+0.013],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

mygca(1) = gca;
b = get(gca,'YLim');
yMaxs(1) = max(b);
yMins(1) = min(b);

b = get(gca,'XLim');
xMaxs(1) = max(b);
xMins(1) = min(b);

h.Position(4) = h.Position(4) - 0.03;
clear zs