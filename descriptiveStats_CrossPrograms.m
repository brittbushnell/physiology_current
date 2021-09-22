clear
close all
%% Gratings
load('WU_LE_Gratings_nsp2_20170704_004_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WUV4grat.LE = data.LE;
clear data

load('WU_RE_Gratings_nsp2_20170704_001_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WUV4grat.RE = data.RE;
clear data

[WUV4grat.ODI] = getGratODI(WUV4grat);

load('WU_LE_Gratings_nsp1_20170704_004_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WUV1grat.LE = data.LE;
clear data

load('WU_RE_Gratings_nsp1_20170704_001_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WUV1grat.RE = data.RE;
clear data
[WUV1grat.ODI] = getGratODI(WUV1grat);
%% WV gratings
load('WV_LE_gratings_nsp2_20190422_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WVV4grat.LE = data.LE;
clear data

load('WV_RE_gratings_nsp2_20190422_003_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WVV4grat.RE = data.RE;
clear data
[WVV4grat.ODI] = getGratODI(WVV4grat);

load('WV_LE_gratings_nsp1_20190422_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WVV1grat.LE = data.LE;
clear data

load('WV_RE_gratings_nsp1_20190422_003_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WVV1grat.RE = data.RE;
clear data
[WVV1grat.ODI] = getGratODI(WVV1grat);
%% XT gratings
load('XT_LE_Gratings_nsp2_20190131_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
XTV4grat.LE = data.LE;
clear data

load('XT_RE_Gratings_nsp2_20190122_002_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
XTV4grat.RE = data.RE;
clear data
[XTV4grat.ODI] = getGratODI(XTV4grat);

load('XT_LE_Gratings_nsp1_20190131_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
XTV1grat.LE = data.LE;
clear data

load('XT_RE_Gratings_nsp1_20190122_002_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
XTV1grat.RE = data.RE;
clear data
[XTV1grat.ODI] = getGratODI(XTV1grat);
%% Glass
WUGlass = 'WU_2eyes_2arrays_GlassPatterns';
XTGlass = 'XT_2eyes_2arrays_GlassPatterns';
WVGlass = 'WV_2eyes_2arrays_GlassPatterns';

load(WUGlass)
WUV1glass.trRE = data.V1.trRE;
WUV1glass.trLE = data.V1.trLE;
WUV4glass.trRE = data.V4.trRE;
WUV4glass.trLE = data.V4.trLE;
clear data

load(WVGlass)
WVV1glass.trRE = data.V1.trRE;
WVV1glass.trLE = data.V1.trLE;
WVV4glass.trRE = data.V4.trRE;
WVV4glass.trLE = data.V4.trLE;
clear data

load(XTGlass)
XTV1glass.trRE = data.V1.trRE;
XTV1glass.trLE = data.V1.trLE;
XTV4glass.trRE = data.V4.trRE;
XTV4glass.trLE = data.V4.trLE;
clear data

load(WUGlass)
WUV1glass.crRE = data.V1.conRadRE;
WUV1glass.crLE = data.V1.conRadLE;
WUV4glass.crRE = data.V4.conRadRE;
WUV4glass.crLE = data.V4.conRadLE;
clear data

load(WVGlass)
WVV1glass.crRE = data.V1.conRadRE;
WVV1glass.crLE = data.V1.conRadLE;
WVV4glass.crRE = data.V4.conRadRE;
WVV4glass.crLE = data.V4.conRadLE;
clear data

load(XTGlass)
XTV1glass.crRE = data.V1.conRadRE;
XTV1glass.crLE = data.V1.conRadLE;
XTV4glass.crRE = data.V4.conRadRE;
XTV4glass.crLE = data.V4.conRadLE;
clear data
%% RF
WUrf = 'WU_BE_radFreq_allSF_bothArrays_stats';
WVrf = 'WV_BE_radFreq_allSF_bothArrays_stats';
XTrf = 'XT_BE_radFreq_allSF_bothArrays_stats';

load(WUrf)
WUV1rf.RE = data.V1.RE;
WUV1rf.LE = data.V1.LE;
WUV4rf.RE = data.V4.RE;
WUV4rf.LE = data.V4.LE;
clear data

load(WVrf)
WVV1rf.RE = data.V1.RElowSF;
WVV1rf.LE = data.V1.LElowSF;
WVV4rf.RE = data.V4.RElowSF;
WVV4rf.LE = data.V4.LElowSF;
clear data

load(XTrf)
XTV1rf.RE = data.V1.REhighSF;
XTV1rf.LE = data.V1.LEhighSF;
XTV4rf.RE = data.V4.REhighSF;
XTV4rf.LE = data.V4.LEhighSF;
%% RF ODIs
[WUV1rf] = getRadFreqODI(WUV1rf);
[WUV4rf] = getRadFreqODI(WUV4rf);

[WVV1rf] = getRadFreqODI(WVV1rf);
[WVV4rf] = getRadFreqODI(WVV4rf);

[XTV1rf] = getRadFreqODI(XTV1rf);
[XTV4rf] = getRadFreqODI(XTV4rf);
%% make ODI comparison figure 

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 900],'PaperSize',[7.5 10])

% glass tr plots
% V4
subplot(8,3,24)
hold on
ODI = WVV4glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.02, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,23)
hold on
ODI = WUV4glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.02, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,22)
hold on
ODI = XTV4glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.02, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

text(-1.9, 0.3, 'V4','FontWeight','bold','FontSize',11) 
text(-2.2, 0.45, 'GlassTR','Rotation',90,'FontWeight','bold','FontSize',12) 
xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI

% V1
subplot(8,3,21)
hold on
ODI = WVV1glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.035, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,20)
hold on
ODI = WUV1glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.035, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,19)
hold on
ODI = XTV1glass.trRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.035, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
text(-1.9, 0.3, 'V1','FontWeight','bold','FontSize',11) 
clear ODI
% glass cr
% V4
subplot(8,3,18)
hold on
ODI = WVV4glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,17)
hold on
ODI = WUV4glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,16)
hold on
ODI = XTV4glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

text(-1.9, 0.3, 'V4','FontWeight','bold','FontSize',11) 
text(-2.2, 0.3, 'Glass con rad','Rotation',90,'FontWeight','bold','FontSize',12) 
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI

% V1
subplot(8,3,15)
hold on
ODI = WVV1glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,14)
hold on
ODI = WUV1glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,13)
hold on
ODI = XTV1glass.crRE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
text(-1.9, 0.3, 'V1','FontWeight','bold','FontSize',11) 
clear ODI
% RF plots 

% V4
subplot(8,3,12)
hold on
ODI = WVV4rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,11)
hold on
ODI = WUV4rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI


subplot(8,3,10)
hold on
ODI = XTV4rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})

text(-1.9, 0.3, 'V4','FontWeight','bold','FontSize',11) 
text(-2.2, 0.3, 'Radial freq','Rotation',90,'FontWeight','bold','FontSize',12) 
% xlabel('ODI','FontSize',11,'FontWeight','bold')
clear ODI

% V1
subplot(8,3,9)
hold on
ODI = WVV1rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,8)
hold on
ODI = WUV1rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

clear ODI


subplot(8,3,7)
hold on
ODI = XTV1rf.RE.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) - 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
text(-1.9, 0.3, 'V1','FontWeight','bold','FontSize',11) 
clear ODI
% gratings plots 

% V4
subplot(8,3,6)
hold on
ODI = WVV4grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')

set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

clear ODI


subplot(8,3,5)
hold on
ODI = WUV4grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})

clear ODI


subplot(8,3,4)
hold on
ODI = XTV4grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})
text(-1.9, 0.3, 'V4','FontWeight','bold','FontSize',11) 
text(-2.2, 0.45, 'Gratings','Rotation',90,'FontWeight','bold','FontSize',12)
clear ODI

% V1
subplot(8,3,3)
hold on
ODI = WVV1grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')

title('A2')
clear ODI


subplot(8,3,2)
hold on
ODI = WUV1grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
title('A1')
clear ODI


subplot(8,3,1)
hold on
ODI = XTV1grat.ODI;

histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
xlim([-1.3 1.3])
ylim([0 0.6])

pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
set(gca,'box', 'off','color', 'none', 'tickdir','out',...
    'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
text(-1.9, 0.3, 'V1','FontWeight','bold','FontSize',11) 
title('Control')
clear ODI

%% Comparisons of # of channels

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 400],'PaperSize',[7.5 10])

subplot(2,2,1)
hold on

ylim([0 100])
xlim([0 8])
bar(0.5,nansum(XTV1grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,nansum(WUV1grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nansum(WVV1grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,sum(XTV1rf.LE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(3,sum(WUV1rf.LE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(3.5,sum(WVV1rf.LE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(4.5,sum(XTV1glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(5,sum(WUV1glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(5.5,sum(WVV1glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(6.5,sum(XTV1glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(7,sum(WUV1glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(7.5,sum(WVV1glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','r')

title('LE/FE')
ylabel('# channels')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})



subplot(2,2,2)
hold on

ylim([0 100])
xlim([0 8])

bar(0.5,nansum(XTV1grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,nansum(WUV1grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nansum(WVV1grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,sum(XTV1rf.RE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(3,sum(WUV1rf.RE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(3.5,sum(WVV1rf.RE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(4.5,sum(XTV1glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(5,sum(WUV1glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(5.5,sum(WVV1glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(6.5,sum(XTV1glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(7,sum(WUV1glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(7.5,sum(WVV1glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','r')

title('RE/AE')
ylabel('# channels')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})

subplot(2,2,3)
hold on

ylim([0 100])
xlim([0 8])
bar(0.5,nansum(XTV4grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,nansum(WUV4grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nansum(WVV4grat.LE.goodCh,'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,sum(XTV4rf.LE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(3,sum(WUV4rf.LE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(3.5,sum(WVV4rf.LE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(4.5,sum(XTV4glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(5,sum(WUV4glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(5.5,sum(WVV4glass.crLE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(6.5,sum(XTV4glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(7,sum(WUV4glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(7.5,sum(WVV4glass.trLE.goodCh),'BarWidth',0.4,'FaceColor','r')

 
ylabel('# channels')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})



subplot(2,2,4)
hold on

ylim([0 100])
xlim([0 8])

bar(0.5,nansum(XTV4grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,nansum(WUV4grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nansum(WVV4grat.RE.goodCh,'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,sum(XTV4rf.RE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(3,sum(WUV4rf.RE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(3.5,sum(WVV4rf.RE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(4.5,sum(XTV4glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(5,sum(WUV4glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(5.5,sum(WVV4glass.crRE.goodCh),'BarWidth',0.4,'FaceColor','r')

bar(6.5,sum(XTV4glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','k')
bar(7,sum(WUV4glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','b')
bar(7.5,sum(WVV4glass.trRE.goodCh),'BarWidth',0.4,'FaceColor','r')

ylabel('# channels')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})
%% Responses


figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 800, 400],'PaperSize',[7.5 10])

subplot(2,2,1)
hold on

ylim([0 20])
xlim([0 8])

bar(0.5,nanmean(squeeze(XTV1grat.LE.stimSpikeCount(XTV1grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,  nanmean(squeeze(WUV1grat.LE.stimSpikeCount(WUV1grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nanmean(squeeze(WVV1grat.LE.stimSpikeCount(WVV1grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,nanmean(squeeze(XTV1rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,XTV1rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','k') 
bar(3,  nanmean(squeeze(WUV1rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,WUV1rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(3.5,nanmean(squeeze(WVV1rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,WVV1rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(4.5,nanmean(squeeze(XTV1glass.crLE.allStimSpikeCount(XTV1glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(5,  nanmean(squeeze(WUV1glass.crLE.allStimSpikeCount(WUV1glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(5.5,nanmean(squeeze(WVV1glass.crLE.allStimSpikeCount(WVV1glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(6.5,nanmean(squeeze(XTV1glass.trLE.allStimSpikeCount(XTV1glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(7,  nanmean(squeeze(WUV1glass.trLE.allStimSpikeCount(WUV1glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(7.5,nanmean(squeeze(WVV1glass.trLE.allStimSpikeCount(WVV1glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

title('LE/FE')
ylabel('mean spike count')
xlabel('Program')
pos = get(gca,'Position');
text(-2, 10,'V1','FontSize',11,'FontWeight','bold')
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})



subplot(2,2,2)
hold on

ylim([0 20])
xlim([0 8])

bar(0.5,nanmean(squeeze(XTV1grat.RE.stimSpikeCount(XTV1grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,  nanmean(squeeze(WUV1grat.RE.stimSpikeCount(WUV1grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nanmean(squeeze(WVV1grat.RE.stimSpikeCount(WVV1grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,nanmean(squeeze(XTV1rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,XTV1rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','k') 
bar(3,  nanmean(squeeze(WUV1rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,WUV1rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(3.5,nanmean(squeeze(WVV1rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,WVV1rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(4.5,nanmean(squeeze(XTV1glass.crRE.allStimSpikeCount(XTV1glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(5,  nanmean(squeeze(WUV1glass.crRE.allStimSpikeCount(WUV1glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(5.5,nanmean(squeeze(WVV1glass.crRE.allStimSpikeCount(WVV1glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(6.5,nanmean(squeeze(XTV1glass.trRE.allStimSpikeCount(XTV1glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(7,  nanmean(squeeze(WUV1glass.trRE.allStimSpikeCount(WUV1glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(7.5,nanmean(squeeze(WVV1glass.trRE.allStimSpikeCount(WVV1glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

title('RE/AE')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})

subplot(2,2,3)
hold on

ylim([0 20])
xlim([0 8])

bar(0.5,nanmean(squeeze(XTV4grat.LE.stimSpikeCount(XTV4grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,  nanmean(squeeze(WUV4grat.LE.stimSpikeCount(WUV4grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nanmean(squeeze(WVV4grat.LE.stimSpikeCount(WVV4grat.LE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,nanmean(squeeze(XTV4rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,XTV4rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','k') 
bar(3,  nanmean(squeeze(WUV4rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,WUV4rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(3.5,nanmean(squeeze(WVV4rf.LE.rfSpikeCountMtx(:,:,:,:,:,:,:,WVV4rf.LE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(4.5,nanmean(squeeze(XTV4glass.crLE.allStimSpikeCount(XTV4glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(5,  nanmean(squeeze(WUV4glass.crLE.allStimSpikeCount(WUV4glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(5.5,nanmean(squeeze(WVV4glass.crLE.allStimSpikeCount(WVV4glass.crLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(6.5,nanmean(squeeze(XTV4glass.trLE.allStimSpikeCount(XTV4glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(7,  nanmean(squeeze(WUV4glass.trLE.allStimSpikeCount(WUV4glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(7.5,nanmean(squeeze(WVV4glass.trLE.allStimSpikeCount(WVV4glass.trLE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

text(-2, 10,'V4','FontSize',11,'FontWeight','bold')
ylabel('mean spike count')
xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})



subplot(2,2,4)
hold on

ylim([0 20])
xlim([0 8])

bar(0.5,nanmean(squeeze(XTV4grat.RE.stimSpikeCount(XTV4grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(1,  nanmean(squeeze(WUV4grat.RE.stimSpikeCount(WUV4grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(1.5,nanmean(squeeze(WVV4grat.RE.stimSpikeCount(WVV4grat.RE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(2.5,nanmean(squeeze(XTV4rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,XTV4rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','k') 
bar(3,  nanmean(squeeze(WUV4rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,WUV4rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(3.5,nanmean(squeeze(WVV4rf.RE.rfSpikeCountMtx(:,:,:,:,:,:,:,WVV4rf.RE.goodCh)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(4.5,nanmean(squeeze(XTV4glass.crRE.allStimSpikeCount(XTV4glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(5,  nanmean(squeeze(WUV4glass.crRE.allStimSpikeCount(WUV4glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(5.5,nanmean(squeeze(WVV4glass.crRE.allStimSpikeCount(WVV4glass.crRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

bar(6.5,nanmean(squeeze(XTV4glass.trRE.allStimSpikeCount(XTV4glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','k')
bar(7,  nanmean(squeeze(WUV4glass.trRE.allStimSpikeCount(WUV4glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','b')
bar(7.5,nanmean(squeeze(WVV4glass.trRE.allStimSpikeCount(WVV4glass.trRE.goodCh,:)),'all'),'BarWidth',0.4,'FaceColor','r')

xlabel('Program')
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2), pos(3), pos(4) - 0.05],'tickdir','out',...
    'XTick',1:2:7,'XTickLabel',{'grat','RF','ConRad','TR'})

%% scatter versions of last two figures

XTV1glassGchLE = sum(XTV1glass.trLE.goodCh & XTV1glass.crLE.goodCh);% & XTV1glass.trLE.inStim & XTV1glass.crLE.inStim);
XTV1glassGchRE = sum(XTV1glass.trRE.goodCh & XTV1glass.crRE.goodCh);% & XTV1glass.trRE.inStim & XTV1glass.crRE.inStim);

XTV4glassGchLE = sum(XTV4glass.trLE.goodCh & XTV4glass.crLE.goodCh);% & XTV4glass.trLE.inStim & XTV4glass.crLE.inStim);
XTV4glassGchRE = sum(XTV4glass.trRE.goodCh & XTV4glass.crRE.goodCh);% & XTV4glass.trRE.inStim & XTV4glass.crRE.inStim);

WUV1glassGchLE = sum(WUV1glass.trLE.goodCh & WUV1glass.crLE.goodCh);% & WUV1glass.trLE.inStim & WUV1glass.crLE.inStim);
WUV1glassGchRE = sum(WUV1glass.trRE.goodCh & WUV1glass.crRE.goodCh);% & WUV1glass.trRE.inStim & WUV1glass.crRE.inStim);

WUV4glassGchLE = sum(WUV4glass.trLE.goodCh & WUV4glass.crLE.goodCh);% & WUV4glass.trLE.inStim & WUV4glass.crLE.inStim);
WUV4glassGchRE = sum(WUV4glass.trRE.goodCh & WUV4glass.crRE.goodCh);% & WUV4glass.trRE.inStim & WUV4glass.crRE.inStim);

WVV1glassGchLE = sum(WVV1glass.trLE.goodCh & WVV1glass.crLE.goodCh);% & WVV1glass.trLE.inStim & WVV1glass.crLE.inStim);
WVV1glassGchRE = sum(WVV1glass.trRE.goodCh & WVV1glass.crRE.goodCh);% & WVV1glass.trRE.inStim & WVV1glass.crRE.inStim);

WVV4glassGchLE = sum(WVV4glass.trLE.goodCh & WVV4glass.crLE.goodCh);% & WVV4glass.trLE.inStim & WVV4glass.crLE.inStim);
WVV4glassGchRE = sum(WVV4glass.trRE.goodCh & WVV4glass.crRE.goodCh);% & WVV4glass.trRE.inStim & WVV4glass.crRE.inStim);

figure(4)
clf

subplot(1,2,1)
hold on
axis square
title('number of included channels')
xlabel('LE/FE')
ylabel('RE/AE')
xlim([50 100])
ylim([50 100])

plot([25 100],[25 100],':k')

scatter(XTV1glassGchLE,XTV1glassGchLE,50,'MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7)
scatter(XTV4glassGchLE,XTV4glassGchLE,55,'MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(WUV1glassGchLE,WUV1glassGchLE,50,'MarkerFaceColor','w','MarkerEdgeColor',[0.2 0.4 1],'MarkerFaceAlpha',0.7)
scatter(WUV1glassGchLE,WUV1glassGchLE,55,'MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(WVV1glassGchLE,WVV1glassGchLE,50,'MarkerFaceColor','w','MarkerEdgeColor','r','MarkerFaceAlpha',0.7)
scatter(WVV1glassGchLE,WVV1glassGchLE,55,'MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(sum(XTV1grat.LE.goodCh),sum(XTV1grat.RE.goodCh),50,'s','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7)
scatter(sum(XTV4grat.LE.goodCh),sum(XTV4grat.RE.goodCh),55,'s','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(sum(WUV1grat.LE.goodCh),sum(WUV1grat.RE.goodCh),50,'s','MarkerFaceColor','w','MarkerEdgeColor',[0.2 0.4 1],'MarkerFaceAlpha',0.7)
scatter(sum(WUV4grat.LE.goodCh),sum(WUV4grat.RE.goodCh),55,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(sum(WVV1grat.LE.goodCh),sum(WVV1grat.RE.goodCh),50,'s','MarkerFaceColor','w','MarkerEdgeColor','r','MarkerFaceAlpha',0.7)
scatter(sum(WVV4grat.LE.goodCh),sum(WVV4grat.RE.goodCh),55,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(sum(XTV1rf.LE.goodCh),sum(XTV1rf.RE.goodCh),50,'d','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7)
scatter(sum(XTV4rf.LE.goodCh),sum(XTV4rf.RE.goodCh),55,'d','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)  

scatter(sum(WUV1rf.LE.goodCh),sum(WUV1rf.RE.goodCh),50,'d','MarkerFaceColor','w','MarkerEdgeColor',[0.2 0.4 1],'MarkerFaceAlpha',0.7)
scatter(sum(WUV4rf.LE.goodCh),sum(WUV4rf.RE.goodCh),55,'d','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7)

scatter(sum(WVV1rf.LE.goodCh),sum(WVV1rf.RE.goodCh),50,'d','MarkerFaceColor','w','MarkerEdgeColor','r','MarkerFaceAlpha',0.7)
scatter(sum(WVV4rf.LE.goodCh),sum(WVV4rf.RE.goodCh),55,'d','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7)