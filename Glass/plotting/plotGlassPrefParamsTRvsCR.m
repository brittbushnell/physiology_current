function plotGlassPrefParamsTRvsCR(trLE,trRE,conRadRE,conRadLE)
%%
figure%(1)
clf
set(gcf,'PaperOrientation','Landscape');

leTrNdx = (trLE.inStim == 1) & (trLE.goodCh == 1);
reTrNdx = (trRE.inStim == 1) & (trRE.goodCh == 1);

leCrNdx = (conRadLE.inStim == 1) & (conRadLE.goodCh == 1);
reCrNdx = (conRadRE.inStim == 1) & (conRadRE.goodCh == 1);

subplot(1,2,1)
hold on
% xlim([0 97])
ylim([0.5 4.5])
scatter(1:sum(leTrNdx),trLE.prefParamsIndex(trLE.inStim == 1 & trLE.goodCh == 1),30,'filled','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(1:sum(leCrNdx),conRadLE.prefParamsIndex(conRadLE.inStim == 1 & conRadLE.goodCh == 1),60,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

axis square
title('LE/FE')
xlabel('channel')
ylabel('preferred density dx pair')
l = legend('translational','concentric and radial');
l.Position(1) = l.Position(1) + 0.2;
l.Position(2) = l.Position(2) - 0.5;
l.Box = 'off';
l.FontSize = 14;
set(gca,'tickdir','out','YTick',1:4,'YTickLabel',{'200, 0.02','200,0.03','400, 0.02','400,0.03'},'FontSize',12,'FontAngle','italic','FontWeight','bold')


subplot(1,2,2)
hold on
% xlim([0 97])
ylim([0.5 4.5])
scatter(1:sum(reTrNdx),trRE.prefParamsIndex(trRE.inStim == 1 & trRE.goodCh == 1),30,'filled','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(1:sum(reCrNdx),conRadRE.prefParamsIndex(conRadRE.inStim == 1 & conRadRE.goodCh == 1),60,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

axis square
title('RE/AE')
xlabel('channel')
s = suptitle(sprintf('%s %s preferred dots,dx combo in Glass experiments',trLE.animal, trLE.array));
s.Position(2) = s.Position(2) - 0.13;
s.FontSize = 18;
s.FontWeight = 'bold';
figName = [trLE.animal,'_',trLE.array,'_prefParamsTRvsCR','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
set(gca,'tickdir','out','YTick',1:4,'YTickLabel',[],'FontSize',12,'FontAngle','italic','FontWeight','bold')
