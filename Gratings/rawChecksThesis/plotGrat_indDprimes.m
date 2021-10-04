close all

figure
set(gcf,'paperSize',[5 4])
XTV1LE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(XTV1LEstimBlankDprime(or,s,:),3));
        XTV1LE = [XTV1LE tmp];
    end
end

scatter(1:length(XTV1LE),XTV1LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)


set(gca,'tickdir','out','XTick',1:length(XTV1LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('XT V1')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')
%%
figure
XTV1RE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(XTV1REstimBlankDprime(or,s,:),3));
        XTV1RE = [XTV1RE tmp];
    end
end

scatter(1:length(XTV1RE),XTV1RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

set(gca,'tickdir','out','XTick',1:length(XTV1RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('XT V1')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['XT_V1_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
set(gcf,'paperSize',[5 4])
WUV1LE = [];
hold on

for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WUV1LEstimBlankDprime(or,s,:),3));
        WUV1LE = [WUV1LE tmp];
    end
end

scatter(1:length(WUV1LE),WUV1LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V1/V2')
set(gca,'tickdir','out','XTick',1:length(WUV1LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('WU V1')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figName = ['WU_V1_LE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
WUV1RE = [];
hold on

for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WUV1REstimBlankDprime(or,s,:),3));
        WUV1RE = [WUV1RE tmp];
    end
end

scatter(1:length(WUV1RE),WUV1RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V1/V2')
set(gca,'tickdir','out','XTick',1:length(WUV1RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('WU V1')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['WU_V1_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
WVV1LE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WVV1LEstimBlankDprime(or,s,:),3));
        WVV1LE = [WVV1LE tmp];
    end
end

scatter(1:length(WVV1LE),WVV1LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V1/V2')
set(gca,'tickdir','out','XTick',1:length(WVV1LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('WV V1')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figName = ['WV_V1_LE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
set(gcf,'paperSize',[5 4])
WVV1RE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WVV1REstimBlankDprime(or,s,:),3));
        WVV1RE = [WVV1RE tmp];
    end
end

scatter(1:length(WVV1RE),WVV1RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V1/V2')
set(gca,'tickdir','out','XTick',1:length(WVV1RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')


set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('WV V1')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['WV_V1_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%


figure
XTV4LE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(XTV4LEstimBlankDprime(or,s,:),3));
        XTV4LE = [XTV4LE tmp];
    end
end

scatter(1:length(XTV4LE),XTV4LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(XTV4LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('XT V4')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figName = ['XT_V4_LE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
XTV4RE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(XTV4REstimBlankDprime(or,s,:),3));
        XTV4RE = [XTV4RE tmp];
    end
end

scatter(1:length(XTV4RE),XTV4RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(XTV4RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('XT V4')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['XT_V4_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
WUV4LE = [];
hold on

for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WUV4LEstimBlankDprime(or,s,:),3));
        WUV4LE = [WUV4LE tmp];
    end
end

scatter(1:length(WUV4LE),WUV4LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(WUV4LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('WU V4')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figName = ['WU_V4_LE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
set(gcf,'paperSize',[5 4])
WUV4RE = [];
hold on

for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WUV4REstimBlankDprime(or,s,:),3));
        WUV4RE = [WUV4RE tmp];
    end
end

scatter(1:length(WUV4RE),WUV4RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(WUV4RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')


set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('WU V4')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['WU_V4_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
WVV4LE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WVV4LEstimBlankDprime(or,s,:),3));
        WVV4LE = [WVV4LE tmp];
    end
end

scatter(1:length(WVV4LE),WVV4LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(WVV4LE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('WV V4')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figName = ['WV_V4_LE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figure
set(gcf,'PaperSize',[5 4]);
WVV4RE = [];
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        tmp = squeeze(mean(WVV4REstimBlankDprime(or,s,:),3));
        WVV4RE = [WVV4RE tmp];
    end
end

scatter(1:length(WVV4RE),WVV4RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)

title('V4/V2')
set(gca,'tickdir','out','XTick',1:length(WVV4RE),'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

xlabel('stimulus')
title('V4')
xlim([0 42])
ylim([-0.5 1.5])

set(gcf,'InvertHardcopy','off','color','w')
xlabel('stimulus')
title('WV V4')
xlim([0 42])
ylim([-0.5 1.5])

figName = ['WV_V4_RE_GratingDp_fit','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')