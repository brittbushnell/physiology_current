function makeGlassR2CompFig(conRegV1,conRegV4,radRegV1,radRegV4,trRegV1,trRegV4,animal)
hold on
if contains(animal,'XT')
    subplot(3,1,1)
    scatter(1,conRegV1(1),'ok')
    scatter(1,conRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(2,radRegV1(1),'ok')
    scatter(3,trRegV1(1),'ok')
    
    scatter(2,radRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(3,trRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    
    set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
        'layer','top','XTick',1:3,'XTickLabel',[]);
    xlim([0 4])
    title('XT')
    legend('V1','V4')
    axis square
    
elseif contains(animal,'WU')
    subplot(3,1,2)
    scatter(1,conRegV1(1),'ok')
    scatter(1,conRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(2,radRegV1(1),'ok')
    scatter(3,trRegV1(1),'ok')
    
    scatter(2,radRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(3,trRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    
    set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
        'layer','top','XTick',1:3,'XTickLabel',[]);
    xlim([0 4])
    title('WU')
    ylabel('R2')
    axis square
    
else
    subplot(3,1,3)
    scatter(1,conRegV1(1),'ok')
    scatter(1,conRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(2,radRegV1(1),'ok')
    scatter(3,trRegV1(1),'ok')
    
    scatter(2,radRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    scatter(3,trRegV4(1),'o','MarkerFaceColor','k','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    
    set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
        'layer','top','XTick',1:3,'XTickLabel',{'Concentric','Radial','Translational'});
    xtickangle(45)
    xlim([0 4])
    title('WV')
    axis square
end