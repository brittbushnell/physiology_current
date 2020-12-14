% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
clear

%%
figure%(6)
clf
hold on
for ch = 1:96
    if contains(dataT.eye,'RE')
%         scatter(chFit{ch}(1),chFit{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
        text(chFit{ch}(1),chFit{ch}(2),num2str(ch),'FontWeight','bold','Color',[0.8 0 0.4])
    else
%         scatter(chFit{ch}(1),chFit{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
        text(chFit{ch}(1),chFit{ch}(2),num2str(ch),'FontWeight','bold','Color',[0.2 0.4 1])
    end
    
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end
if contains(dataT.animal,'WU')
    viscircles([0,0],1.5, 'color',[0.2 0.2 0.2]);
else
    viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
end
plot(dataT.fix_x, dataT.fix_y,'ok','MarkerFaceColor','k','MarkerSize',8)
title(sprintf('%s %s %s recepive field centers',dataT.animal, dataT.array, dataT.eye),'FontSize',14,'FontWeight','Bold')