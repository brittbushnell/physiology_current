% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
for ch = 1:96
    
    hold on
    if V1dataRE.goodCh(ch) == 1
       scatter(V1rfParamsRE{ch}(1),V1rfParamsRE{ch}(2),35,[0.8 0 0.6],'filled','MarkerFaceAlpha',0.7);
    end
    if V4dataRE.goodCh(ch) == 1
        scatter(V4rfParamsRE{ch}(1),V4rfParamsRE{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    end
    
    grid on;
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end
viscircles([StimXcenter,StimYcenter],4,...
    'color','k');
plot(fixX, fixY,'ok','MarkerFaceColor','k','MarkerSize',9)

text(8, 9.7, sprintf('V1 n %d',sum(V1rfQuadrantRE==1)),'FontSize',12)
text(-9.5, 9.7, sprintf('V1 n %d',sum(V1rfQuadrantRE==2)),'FontSize',12)
text(-9.5, -9.25, sprintf('V1 n %d',sum(V1rfQuadrantRE==3)),'FontSize',12)
text(8, -9.25, sprintf('V1 n %d',sum(V1rfQuadrantRE==4)),'FontSize',12)

text(8, 9.25, sprintf('V4 n %d',sum(V4rfQuadrantRE==1)),'FontSize',12)
text(-9.5, 9.25, sprintf('V4 n %d',sum(V4rfQuadrantRE==2)),'FontSize',12)
text(-9.5, -9.7, sprintf('V4 n %d',sum(V4rfQuadrantRE==3)),'FontSize',12)
text(8, -9.7, sprintf('V4 n %d',sum(V4rfQuadrantRE==4)),'FontSize',12)

text(-1, 9.7,'V1','Color',[0.8 0 0.6],'FontWeight','Bold','FontSize',14)
text(0.6, 9.7,'V4','Color',[0.2 0.4 1],'FontWeight','Bold','FontSize',14)