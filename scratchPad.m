figure(90)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 700]);
set(gcf,'PaperOrientation','landscape')

subplot(4,1,1)
hold on
scatter(1:size(V1dataLE,1),squeeze(V1dataLE(:,1)),'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V1dataLE,1),squeeze(V1dataLE(:,2)),'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V1dataLE,1),squeeze(V1dataLE(:,3)),'MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
set(gca,'tickdir','out')
title('LE V1')
ylabel('d''')

subplot(4,1,3)
hold on
scatter(1:size(V4dataLE,1),squeeze(V4dataLE(:,1)),'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V4dataLE,1),squeeze(V4dataLE(:,2)),'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V4dataLE,1),squeeze(V4dataLE(:,3)),'MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
set(gca,'tickdir','out')
title('LE V4')
ylabel('d''')

subplot(4,1,2)
hold on
scatter(1:size(V1dataRE,1),squeeze(V1dataRE(:,1)),'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V1dataRE,1),squeeze(V1dataRE(:,2)),'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V1dataRE,1),squeeze(V1dataRE(:,3)),'MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
set(gca,'tickdir','out')
title('RE V1')

subplot(4,1,4)
hold on
scatter(1:size(V4dataRE,1),squeeze(V4dataRE(:,1)),'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V4dataRE,1),squeeze(V4dataRE(:,2)),'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
scatter(1:size(V4dataRE,1),squeeze(V4dataRE(:,3)),'MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
xlabel('channel')
set(gca,'tickdir','out')
title('RE V4')