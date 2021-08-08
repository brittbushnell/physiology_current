location = determineComputer;
if location == 1
    figDir =  '~/bushnell-local/Dropbox/Figures/ReceptiveFields';
elseif location == 0
    figDir = '~/Dropbox//Figures/ReceptiveFields';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('XT V1')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(XTV1rfParams{ch}(1),XTV1rfParams{ch}(2),'MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['XT_V1_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('XT V4')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(XTV4rfParams{ch}(1),XTV4rfParams{ch}(2),'MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['XT_V4_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('WV V1')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WVV1rfParamsRE{ch}(1),WVV1rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WVV1rfParamsLE{ch}(1),WVV1rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['WV_V1_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('WV V4')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WVV4rfParamsRE{ch}(1),WVV4rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WVV4rfParamsLE{ch}(1),WVV4rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['WV_V4_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('WU V1')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WUV1rfParamsRE{ch}(1),WUV1rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WUV1rfParamsLE{ch}(1),WUV1rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['WU_V1_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 450, 450],'PaperSize',[3 3])
hold on

xlim([-15 15])
ylim([-15 15])
title('WU V4')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WUV4rfParamsRE{ch}(1),WUV4rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WUV4rfParamsLE{ch}(1),WUV4rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

set(gcf,'InvertHardcopy','off','Color','w')
figName = ['WU_V4_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')


