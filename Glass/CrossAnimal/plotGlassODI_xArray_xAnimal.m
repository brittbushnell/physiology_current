function [WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotGlassODI_xArray_xAnimal(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
%%
WUV1 = getGlassODI_CombineProgs(WUV1);
WUV4 = getGlassODI_CombineProgs(WUV4);

WVV1 = getGlassODI_CombineProgs(WVV1);
WVV4 = getGlassODI_CombineProgs(WVV4);

XTV1 = getGlassODI_CombineProgs(XTV1);
XTV4 = getGlassODI_CombineProgs(XTV4);
%% 
WUV1.ODItr = getGlassODI_zScore(WUV1.trLE,WUV1.trRE);
WUV4.ODItr = getGlassODI_zScore(WUV4.trLE,WUV4.trRE);

WVV1.ODItr = getGlassODI_zScore(WVV1.trLE,WVV1.trRE);
WVV4.ODItr = getGlassODI_zScore(WVV4.trLE,WVV4.trRE);

XTV1.ODItr = getGlassODI_zScore(XTV1.trLE,XTV1.trRE);
XTV4.ODItr = getGlassODI_zScore(XTV4.trLE,XTV4.trRE);

WUV1.ODIconRad = getGlassODI_zScore(WUV1.conRadLE,WUV1.conRadRE);
WUV4.ODIconRad = getGlassODI_zScore(WUV4.conRadLE,WUV4.conRadRE);

WVV1.ODIconRad = getGlassODI_zScore(WVV1.conRadLE,WVV1.conRadRE);
WVV4.ODIconRad = getGlassODI_zScore(WVV4.conRadLE,WVV4.conRadRE);

XTV1.ODIconRad = getGlassODI_zScore(XTV1.conRadLE,XTV1.conRadRE);
XTV4.ODIconRad = getGlassODI_zScore(XTV4.conRadLE,XTV4.conRadRE);
%% fig 9
 
figure (9)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1300 700])
set(gcf,'PaperOrientation','Landscape');
t = suptitle('Ocular dominance Glass programs combined, channels in stimulus');
t.FontSize = 18;
t.FontWeight = 'bold';
t.Position(2) = t.Position(2) +0.02;

s = subplot(2,3,1);
hold on
histogram(XTV1.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV1.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV1.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(XTV1.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
title('XT','FontAngle','italic','FontSize',16,'FontWeight','Bold')
text(-1.7,0.3,'V1','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,3);
hold on
histogram(WVV1.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV1.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV1.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(WVV1.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])


title('WV','FontAngle','italic','FontSize',16,'FontWeight','Bold')
% s.Position(1) = s.Position(1) - 0.05; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,2);
hold on
histogram(WUV1.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV1.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV1.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(WUV1.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])


title('WU','FontAngle','italic','FontSize',16,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.038; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,4);
hold on
histogram(XTV4.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV4.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV4.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(XTV4.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
text(-1.7,0.3,'V4','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,6);
hold on
histogram(WVV4.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV4.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV4.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(WVV4.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])


% s.Position(1) = s.Position(1) - 0.05; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,5);
hold on
histogram(WUV4.ODIcombo,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV4.ODIcombo),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV4.ODIcombo+0.1),0.4,sprintf('%.2f',nanmedian(WUV4.ODIcombo)),'FontSize',12)
xlim([-1.3 1.3])


s.Position(1) = s.Position(1) - 0.038; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

figName = 'GlassODI_AllMonk_allArrays_comboProg.pdf';
print(gcf,figName,'-dpdf','-fillpage')

%% fig 10
figure (10)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1300 700])
set(gcf,'PaperOrientation','Landscape');
t = suptitle('Ocular dominance translational Glass channels in stimulus');
t.FontSize = 18;
t.FontWeight = 'bold';
t.Position(2) = t.Position(2) +0.02;

s = subplot(2,3,1);
hold on
histogram(XTV1.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV1.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV1.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(XTV1.ODItr)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
title('XT','FontAngle','italic','FontSize',16,'FontWeight','Bold')
text(-1.7,0.3,'V1','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,3);
hold on
histogram(WVV1.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV1.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV1.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(WVV1.ODItr)),'FontSize',12)
xlim([-1.3 1.3])


title('WV','FontAngle','italic','FontSize',16,'FontWeight','Bold')
% s.Position(1) = s.Position(1) - 0.05; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,2);
hold on
histogram(WUV1.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV1.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV1.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(WUV1.ODItr)),'FontSize',12)
xlim([-1.3 1.3])


title('WU','FontAngle','italic','FontSize',16,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.038; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,4);
hold on
histogram(XTV4.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV4.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV4.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(XTV4.ODItr)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
text(-1.7,0.3,'V4','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,6);
hold on
histogram(WVV4.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV4.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV4.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(WVV4.ODItr)),'FontSize',12)
xlim([-1.3 1.3])


% s.Position(1) = s.Position(1) - 0.05; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,5);
hold on
histogram(WUV4.ODItr,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV4.ODItr),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV4.ODItr+0.1),0.4,sprintf('%.2f',nanmedian(WUV4.ODItr)),'FontSize',12)
xlim([-1.3 1.3])


s.Position(1) = s.Position(1) - 0.038; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

figName = 'GlassODI_AllMonk_allArrays_translational.pdf';
print(gcf,figName,'-dpdf','-fillpage')
%% fig 11
 
figure (11)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1300 700])
set(gcf,'PaperOrientation','Landscape');
t = suptitle('Ocular dominance with concentric and radial Glass patterns');
t.FontSize = 18;
t.FontWeight = 'bold';
t.Position(2) = t.Position(2) +0.02;

s = subplot(2,3,1);
hold on
histogram(XTV1.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV1.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV1.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(XTV1.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
title('XT','FontAngle','italic','FontSize',16,'FontWeight','Bold')
text(-1.7,0.3,'V1','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,3);
hold on
histogram(WVV1.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV1.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV1.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(WVV1.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])


title('WV','FontAngle','italic','FontSize',16,'FontWeight','Bold')
% s.Position(1) = s.Position(1) - 0.05; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,2);
hold on
histogram(WUV1.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV1.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV1.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(WUV1.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])


title('WU','FontAngle','italic','FontSize',16,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.038; 
% s.Position(2) = s.Position(2) + 0.023; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,4);
hold on
histogram(XTV4.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(XTV4.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(XTV4.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(XTV4.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])

% ylabel('Probability')
text(-1.7,0.3,'V4','FontAngle','italic','FontSize',18,'FontWeight','Bold')
s.Position(1) = s.Position(1) - 0.08; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,6);
hold on
histogram(WVV4.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WVV4.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WVV4.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(WVV4.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])


% s.Position(1) = s.Position(1) - 0.05; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

s = subplot(2,3,5);
hold on
histogram(WUV4.ODIconRad,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(WUV4.ODIconRad),0.4,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(WUV4.ODIconRad+0.1),0.4,sprintf('%.2f',nanmedian(WUV4.ODIconRad)),'FontSize',12)
xlim([-1.3 1.3])


s.Position(1) = s.Position(1) - 0.038; 
s.Position(2) = s.Position(2) + 0.035; 
s.Position(3) = s.Position(3) + 0.08; 
s.Position(4) = s.Position(4) - 0.09; 

figName = 'GlassODI_AllMonk_allArrays_translational.pdf';
print(gcf,figName,'-dpdf','-fillpage')