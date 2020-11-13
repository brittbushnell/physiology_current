function [dataT] = plotArrayReceptiveFields(dataT)

%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal,V1data.programID, V1data.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/%s/ch/',V1data.animal, V1data.programID, V1data.eye);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure(6)
clf
for ch = 1:96
    
    hold on
    if V1data.goodCh(ch) == 1
       scatter(V1rfParams{ch}(1),V1rfParams{ch}(2),35,[0.8 0 0.6],'filled','MarkerFaceAlpha',0.7);
    end
    if V4data.goodCh(ch) == 1
        scatter(V4rfParams{ch}(1),V4rfParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    end
    
    grid on;
    xlim([-10,10])
    ylim([-10,10])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square  
end

plot(fixX, fixY,'ok','MarkerFaceColor','k','MarkerSize',9)
