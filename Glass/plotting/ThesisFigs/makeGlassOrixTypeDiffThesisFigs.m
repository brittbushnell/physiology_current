location = determineComputer;
if location == 1
    figDir =  '~/bushnell-local/Dropbox/Thesis/Glass/figures/oriTuning';
elseif location == 0
    figDir =  '/Users/brittany/Dropbox/Thesis/Glass/figures/oriTuning';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
cDiff1 = WVV1.trLE.conDiff.q1;
cDiff2 = WVV1.trLE.conDiff.q2;
cDiff3 = WVV1.trLE.conDiff.q3;
cDiff4 = WVV1.trLE.conDiff.q4;

WVcDiffLEv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = WVV1.trLE.radDiff.q1;
rDiff2 = WVV1.trLE.radDiff.q2;
rDiff3 = WVV1.trLE.radDiff.q3;
rDiff4 = WVV1.trLE.radDiff.q4;

WVrDiffLEv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = WVV1.trRE.conDiff.q1;
cDiff2 = WVV1.trRE.conDiff.q2;
cDiff3 = WVV1.trRE.conDiff.q3;
cDiff4 = WVV1.trRE.conDiff.q4;

WVcDiffREv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = WVV1.trRE.radDiff.q1;
rDiff2 = WVV1.trRE.radDiff.q2;
rDiff3 = WVV1.trRE.radDiff.q3;
rDiff4 = WVV1.trRE.radDiff.q4;

WVrDiffREv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = WVV4.trLE.conDiff.q1;
cDiff2 = WVV4.trLE.conDiff.q2;
cDiff3 = WVV4.trLE.conDiff.q3;
cDiff4 = WVV4.trLE.conDiff.q4;

WVcDiffLEv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = WVV4.trLE.radDiff.q1;
rDiff2 = WVV4.trLE.radDiff.q2;
rDiff3 = WVV4.trLE.radDiff.q3;
rDiff4 = WVV4.trLE.radDiff.q4;

WVrDiffLEv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = WVV4.trRE.conDiff.q1;
cDiff2 = WVV4.trRE.conDiff.q2;
cDiff3 = WVV4.trRE.conDiff.q3;
cDiff4 = WVV4.trRE.conDiff.q4;

WVcDiffREv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = WVV4.trRE.radDiff.q1;
rDiff2 = WVV4.trRE.radDiff.q2;
rDiff3 = WVV4.trRE.radDiff.q3;
rDiff4 = WVV4.trRE.radDiff.q4;

WVrDiffREv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = WUV1.trLE.conDiff.q1;
cDiff2 = WUV1.trLE.conDiff.q2;
cDiff3 = WUV1.trLE.conDiff.q3;
cDiff4 = WUV1.trLE.conDiff.q4;

WUcDiffLEv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = WUV1.trLE.radDiff.q1;
rDiff2 = WUV1.trLE.radDiff.q2;
rDiff3 = WUV1.trLE.radDiff.q3;
rDiff4 = WUV1.trLE.radDiff.q4;

WUrDiffLEv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = WUV1.trRE.conDiff.q1;
cDiff2 = WUV1.trRE.conDiff.q2;
cDiff3 = WUV1.trRE.conDiff.q3;
cDiff4 = WUV1.trRE.conDiff.q4;

WUcDiffREv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = WUV1.trRE.radDiff.q1;
rDiff2 = WUV1.trRE.radDiff.q2;
rDiff3 = WUV1.trRE.radDiff.q3;
rDiff4 = WUV1.trRE.radDiff.q4;

WUrDiffREv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = WUV4.trLE.conDiff.q1;
cDiff2 = WUV4.trLE.conDiff.q2;
cDiff3 = WUV4.trLE.conDiff.q3;
cDiff4 = WUV4.trLE.conDiff.q4;

WUcDiffLEv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = WUV4.trLE.radDiff.q1;
rDiff2 = WUV4.trLE.radDiff.q2;
rDiff3 = WUV4.trLE.radDiff.q3;
rDiff4 = WUV4.trLE.radDiff.q4;

WUrDiffLEv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = WUV4.trRE.conDiff.q1;
cDiff2 = WUV4.trRE.conDiff.q2;
cDiff3 = WUV4.trRE.conDiff.q3;
cDiff4 = WUV4.trRE.conDiff.q4;

WUcDiffREv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = WUV4.trRE.radDiff.q1;
rDiff2 = WUV4.trRE.radDiff.q2;
rDiff3 = WUV4.trRE.radDiff.q3;
rDiff4 = WUV4.trRE.radDiff.q4;

WUrDiffREv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = XTV1.trLE.conDiff.q1;
cDiff2 = XTV1.trLE.conDiff.q2;
cDiff3 = XTV1.trLE.conDiff.q3;
cDiff4 = XTV1.trLE.conDiff.q4;

XTcDiffLEv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = XTV1.trLE.radDiff.q1;
rDiff2 = XTV1.trLE.radDiff.q2;
rDiff3 = XTV1.trLE.radDiff.q3;
rDiff4 = XTV1.trLE.radDiff.q4;

XTrDiffLEv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = XTV1.trRE.conDiff.q1;
cDiff2 = XTV1.trRE.conDiff.q2;
cDiff3 = XTV1.trRE.conDiff.q3;
cDiff4 = XTV1.trRE.conDiff.q4;

XTcDiffREv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = XTV1.trRE.radDiff.q1;
rDiff2 = XTV1.trRE.radDiff.q2;
rDiff3 = XTV1.trRE.radDiff.q3;
rDiff4 = XTV1.trRE.radDiff.q4;

XTrDiffREv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = XTV4.trLE.conDiff.q1;
cDiff2 = XTV4.trLE.conDiff.q2;
cDiff3 = XTV4.trLE.conDiff.q3;
cDiff4 = XTV4.trLE.conDiff.q4;

XTcDiffLEv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = XTV4.trLE.radDiff.q1;
rDiff2 = XTV4.trLE.radDiff.q2;
rDiff3 = XTV4.trLE.radDiff.q3;
rDiff4 = XTV4.trLE.radDiff.q4;

XTrDiffLEv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = XTV4.trRE.conDiff.q1;
cDiff2 = XTV4.trRE.conDiff.q2;
cDiff3 = XTV4.trRE.conDiff.q3;
cDiff4 = XTV4.trRE.conDiff.q4;

XTcDiffREv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = XTV4.trRE.radDiff.q1;
rDiff2 = XTV4.trRE.radDiff.q2;
rDiff3 = XTV4.trRE.radDiff.q3;
rDiff4 = XTV4.trRE.radDiff.q4;

XTrDiffREv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);

%%

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),600,400],'InvertHardcopy','off','PaperSize',[7.5,6.5])

t = suptitle('Dominant vs preferred orientation');
t.FontSize = 20;

subplot(1,2,1)
hold on
plot([0 90],[0 90],'-','color',[0.4 0.4 0.4])
scatter(mean(WVcDiffLEv1),mean(WVcDiffREv1),50,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WVcDiffLEv4),mean(WVcDiffREv4),60,'d','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(mean(WUcDiffLEv1),mean(WUcDiffREv1),50,'s','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUcDiffLEv4),mean(WUcDiffREv4),60,'s','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(mean(XTcDiffLEv1),mean(XTcDiffREv1),50,'o','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTcDiffLEv4),mean(XTcDiffREv4),60,'o','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

xlim([0 90])
ylim([0 90])
axis square
xlabel('LE/FE','FontSize',12,'FontAngle','italic')
ylabel('RE/AE','FontSize',12,'FontAngle','italic')
set(gca,'tickdir','out','FontSize',11,'FontAngle','italic')
title('Concentric')

subplot(1,2,2)
hold on

scatter(mean(WVrDiffLEv1),mean(WVrDiffREv1),50,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUrDiffLEv1),mean(WUrDiffREv1),50,'s','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTrDiffLEv1),mean(XTrDiffREv1),50,'o','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(mean(WVrDiffLEv4),mean(WVrDiffREv4),60,'d','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUrDiffLEv4),mean(WUrDiffREv4),60,'s','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTrDiffLEv4),mean(XTrDiffREv4),60,'o','MarkerEdgeColor','w','MarkerFaceColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

plot([0 90],[0 90],'-','color',[0.4 0.4 0.4])

xlim([0 90])
ylim([0 90])
axis square
xlabel('LE/FE','FontSize',12,'FontAngle','italic')
ylabel('RE/AE','FontSize',12,'FontAngle','italic')
set(gca,'tickdir','out','FontSize',11,'FontAngle','italic')
title('Radial')

l = legend('WV V1','WU V1','XT V1','WV V4','WU V4','XT V4');
l.Box = 'off';
l.Position(1) = l.Position(1) - 0.3;
l.Position(2) = l.Position(2) - 0.5;
l.NumColumns = 2;

figName = 'domOriVsprefOri_2plots_type.pdf';
set(gca,'color','none')
print(figName,'-dpdf','-bestfit')
%%
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),600,400],'InvertHardcopy','off','PaperSize',[7.5,6.5])

t = suptitle('Dominant vs preferred orientation');
t.FontSize = 20;

subplot(1,2,1)
hold on
plot([0 90],[0 90],'-','color',[0.4 0.4 0.4])
scatter(mean(WVcDiffLEv1),mean(WVcDiffREv1),60,'d','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WVrDiffLEv1),mean(WVrDiffREv1),60,'d','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(mean(WUcDiffLEv1),mean(WUcDiffREv1),60,'s','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUrDiffLEv1),mean(WUrDiffREv1),60,'s','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

scatter(mean(XTcDiffLEv1),mean(XTcDiffREv1),60,'o','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTrDiffLEv1),mean(XTrDiffREv1),60,'o','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

xlim([0 90])
ylim([0 90])
axis square
xlabel('LE/FE','FontSize',12,'FontAngle','italic')
ylabel('RE/AE','FontSize',12,'FontAngle','italic')
set(gca,'tickdir','out','FontSize',11,'FontAngle','italic')
title('V1/V2')

subplot(1,2,2)
hold on

scatter(mean(WVcDiffLEv4),mean(WVcDiffREv4),60,'d','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUcDiffLEv4),mean(WUcDiffREv4),60,'s','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTcDiffLEv4),mean(XTcDiffREv4),60,'o','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)


scatter(mean(WVrDiffLEv4),mean(WVrDiffREv4),60,'d','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(WUrDiffLEv4),mean(WUrDiffREv4),60,'s','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(mean(XTrDiffLEv4),mean(XTrDiffREv4),60,'o','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

plot([0 90],[0 90],'-','color',[0.4 0.4 0.4])

xlim([0 90])
ylim([0 90])
axis square
xlabel('LE/FE','FontSize',12,'FontAngle','italic')
ylabel('RE/AE','FontSize',12,'FontAngle','italic')
set(gca,'tickdir','out','FontSize',11,'FontAngle','italic')
title('V4')

l = legend('WV Con','WU Con','XT Con','WV Rad','WU Rad','XT Rad');
l.Box = 'off';
l.Position(1) = l.Position(1) - 0.3;
l.Position(2) = l.Position(2) - 0.5;
l.NumColumns = 2;

figName = 'domOriVsprefOri_2plots_area.pdf';
set(gca,'color','none')
print(figName,'-dpdf','-bestfit')
%%
figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),350,400],'InvertHardcopy','off','PaperSize',[6.5,6.5])


t = suptitle('Dominant vs preferred orientation');
t.FontSize = 20;


hold on
scatter(mean(WVcDiffLEv1),mean(WVcDiffREv1),60,'d','MarkerEdgeColor',[0.7 0 0.7])
scatter(mean(WVcDiffLEv4),mean(WVcDiffREv4),75,'d','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7])

scatter(mean(WUcDiffLEv1),mean(WUcDiffREv1),60,'s','MarkerEdgeColor',[0.7 0 0.7])
scatter(mean(WUcDiffLEv4),mean(WUcDiffREv4),75,'s','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7])

scatter(mean(XTcDiffLEv1),mean(XTcDiffREv1),60,'o','MarkerEdgeColor',[0.7 0 0.7])
scatter(mean(XTcDiffLEv4),mean(XTcDiffREv4),75,'o','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7])


scatter(mean(WVrDiffLEv1),mean(WVrDiffREv1),60,'d','MarkerEdgeColor',[0 0.6 0.2])
scatter(mean(WVrDiffLEv4),mean(WVrDiffREv4),75,'d','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2])

scatter(mean(WUrDiffLEv1),mean(WUrDiffREv1),60,'s','MarkerEdgeColor',[0 0.6 0.2])
scatter(mean(WUrDiffLEv4),mean(WUrDiffREv4),75,'s','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2])

scatter(mean(XTrDiffLEv1),mean(XTrDiffREv1),60,'o','MarkerEdgeColor',[0 0.6 0.2])
scatter(mean(XTrDiffLEv4),mean(XTrDiffREv4),75,'o','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2])

plot([0 90],[0 90],'-','color',[0.4 0.4 0.4])

xlim([0 90])
ylim([0 90])

pos = get(gca,'Position');
pos = [pos(1)+0.06, pos(2) + 0.22, pos(3) - 0.2, pos(4) - 0.2];

axis square
xlabel('LE/FE','FontSize',12,'FontAngle','italic')
ylabel('RE/AE','FontSize',12,'FontAngle','italic')
set(gca,'tickdir','out','FontSize',11,'FontAngle','italic','Position',pos,'XTick',0:30:90,'YTick',0:30:90);

l = legend('WV Con V1/V2','WV Con V4','WU Con V1/V2','WU Con V4','XT Con V1/V2','XT Con V4','WV Rad V1/V2','WV Rad V4','WU Rad V1/V2','WU Rad V4','XT Rad V1/V2','XT Rad V4');
l.Box = 'off';
l.Position(1) = l.Position(1) - 0.085;
l.Position(2) = l.Position(2) - 0.5;
l.NumColumns = 3;
l.FontSize = 11;

axis square

figName = 'domOriVsprefOri_1plot.pdf';
set(gca,'color','none')
print(figName,'-dpdf','-bestfit')