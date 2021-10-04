clear
close all
tic
%% Gratings
load('WU_LE_Gratings_nsp2_20170704_004_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WUV4grat.LE = data.LE;
clear data

load('WU_RE_Gratings_nsp2_20170704_001_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WUV4grat.RE = data.RE;
clear data

% [WUV4grat.ODI] = getGratODI(WUV4grat);

load('WU_LE_Gratings_nsp1_20170704_004_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WUV1grat.LE = data.LE;
clear data

load('WU_RE_Gratings_nsp1_20170704_001_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WUV1grat.RE = data.RE;
clear data
% [WUV1grat.ODI] = getGratODI(WUV1grat);
%% WV gratings
load('WV_LE_gratings_nsp2_20190422_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WVV4grat.LE = data.LE;
clear data

load('WV_RE_gratings_nsp2_20190422_003_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WVV4grat.RE = data.RE;
clear data
% [WVV4grat.ODI] = getGratODI(WVV4grat);

load('WV_LE_gratings_nsp1_20190422_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
WVV1grat.LE = data.LE;
clear data

load('WV_RE_gratings_nsp1_20190422_003_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
WVV1grat.RE = data.RE;
clear data
% [WVV1grat.ODI] = getGratODI(WVV1grat);
%% XT gratings
load('XT_LE_Gratings_nsp2_20190131_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
XTV4grat.LE = data.LE;
clear data

load('XT_RE_Gratings_nsp2_20190122_002_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
XTV4grat.RE = data.RE;
clear data
% [XTV4grat.ODI] = getGratODI(XTV4grat);

load('XT_LE_Gratings_nsp1_20190131_002_goodCh')
[data.LE.blankSpikeCount,data.LE.stimSpikeCount] = getGratSpikeCount(data.LE);
XTV1grat.LE = data.LE;
clear data

load('XT_RE_Gratings_nsp1_20190122_002_goodCh')
[data.RE.blankSpikeCount,data.RE.stimSpikeCount] = getGratSpikeCount(data.RE);
XTV1grat.RE = data.RE;
clear data
% [XTV1grat.ODI] = getGratODI(XTV1grat);
%% reshape all stim d' to be (ori,sf,ch)
sfs  = unique(WUV1grat.RE.spatial_frequency);
oris = unique(WUV1grat.RE.rotation);

for s = 1:length(sfs)
    WUV1REsfNdx = WUV1grat.RE.spatial_frequency == sfs(s);
    WUV1LEsfNdx = WUV1grat.LE.spatial_frequency == sfs(s);
    WUV4REsfNdx = WUV4grat.RE.spatial_frequency == sfs(s);
    WUV4LEsfNdx = WUV4grat.LE.spatial_frequency == sfs(s);
    
    WVV1REsfNdx = WVV1grat.RE.spatial_frequency == sfs(s);
    WVV1LEsfNdx = WVV1grat.LE.spatial_frequency == sfs(s);
    WVV4REsfNdx = WVV4grat.RE.spatial_frequency == sfs(s);
    WVV4LEsfNdx = WVV4grat.LE.spatial_frequency == sfs(s);
    
    XTV1REsfNdx = XTV1grat.RE.spatial_frequency == sfs(s);
    XTV1LEsfNdx = XTV1grat.LE.spatial_frequency == sfs(s);
    XTV4REsfNdx = XTV4grat.RE.spatial_frequency == sfs(s);
    XTV4LEsfNdx = XTV4grat.LE.spatial_frequency == sfs(s);
    
    for or = 1:length(oris)
        WUV1REoriNdx = WUV1grat.RE.rotation == oris(or);
        WUV1LEoriNdx = WUV1grat.LE.rotation == oris(or);
        WUV4REoriNdx = WUV4grat.RE.rotation == oris(or);
        WUV4LEoriNdx = WUV4grat.LE.rotation == oris(or);
        
        WVV1REoriNdx = WVV1grat.RE.rotation == oris(or);
        WVV1LEoriNdx = WVV1grat.LE.rotation == oris(or);
        WVV4REoriNdx = WVV4grat.RE.rotation == oris(or);
        WVV4LEoriNdx = WVV4grat.LE.rotation == oris(or);
        
        XTV1REoriNdx = XTV1grat.RE.rotation == oris(or);
        XTV1LEoriNdx = XTV1grat.LE.rotation == oris(or);
        XTV4REoriNdx = XTV4grat.RE.rotation == oris(or);
        XTV4LEoriNdx = XTV4grat.LE.rotation == oris(or);

        for ch = 1:96
            WUV1REblank = WUV1grat.RE.blankSpikeCount(ch,:);
            WUV1LEblank = WUV1grat.LE.blankSpikeCount(ch,:);
            WUV4REblank = WUV4grat.RE.blankSpikeCount(ch,:);
            WUV4LEblank = WUV4grat.LE.blankSpikeCount(ch,:);

            WVV1REblank = WVV1grat.RE.blankSpikeCount(ch,:);
            WVV1LEblank = WVV1grat.LE.blankSpikeCount(ch,:);
            WVV4REblank = WVV4grat.RE.blankSpikeCount(ch,:);
            WVV4LEblank = WVV4grat.LE.blankSpikeCount(ch,:);

            XTV1REblank = XTV1grat.RE.blankSpikeCount(ch,:);
            XTV1LEblank = XTV1grat.LE.blankSpikeCount(ch,:);
            XTV4REblank = XTV4grat.RE.blankSpikeCount(ch,:);
            XTV4LEblank = XTV4grat.LE.blankSpikeCount(ch,:);

            WUV1REstim = sum(WUV1grat.RE.bins(WUV1REoriNdx & WUV1REsfNdx , 5:25, ch),2);
            WUV1LEstim = sum(WUV1grat.LE.bins(WUV1LEoriNdx & WUV1LEsfNdx, 5:25, ch),2);
            WUV4REstim = sum(WUV4grat.RE.bins(WUV4REoriNdx & WUV4REsfNdx, 5:25, ch),2);
            WUV4LEstim = sum(WUV4grat.LE.bins(WUV4LEoriNdx & WUV4LEsfNdx, 5:25, ch),2);

            WVV1REstim = sum(WVV1grat.RE.bins(WVV1REoriNdx & WVV1REsfNdx, 5:25, ch),2);
            WVV1LEstim = sum(WVV1grat.LE.bins(WVV1LEoriNdx & WVV1LEsfNdx, 5:25, ch),2);
            WVV4REstim = sum(WVV4grat.RE.bins(WVV4REoriNdx & WVV4REsfNdx, 5:25, ch),2);
            WVV4LEstim = sum(WVV4grat.LE.bins(WVV4LEoriNdx & WVV4LEsfNdx, 5:25, ch),2);

            XTV1REstim = sum(XTV1grat.RE.bins(XTV1REoriNdx & XTV1REsfNdx, 5:25, ch),2);
            XTV1LEstim = sum(XTV1grat.LE.bins(XTV1LEoriNdx & XTV1LEsfNdx, 5:25, ch),2);
            XTV4REstim = sum(XTV4grat.RE.bins(XTV4REoriNdx & XTV4REsfNdx, 5:25, ch),2);
            XTV4LEstim = sum(XTV4grat.LE.bins(XTV4LEoriNdx & XTV4LEsfNdx, 5:25, ch),2);

            WUV1REstimBlankDprime(or,s,ch) = simpleDiscrim(WUV1REblank,WUV1REstim);
            WUV1LEstimBlankDprime(or,s,ch) = simpleDiscrim(WUV1LEblank,WUV1LEstim);
            WUV4REstimBlankDprime(or,s,ch) = simpleDiscrim(WUV4REblank,WUV4REstim);
            WUV4LEstimBlankDprime(or,s,ch) = simpleDiscrim(WUV4LEblank,WUV4LEstim);

            WVV1REstimBlankDprime(or,s,ch) = simpleDiscrim(WVV1REblank,WVV1REstim);
            WVV1LEstimBlankDprime(or,s,ch) = simpleDiscrim(WVV1LEblank,WVV1LEstim);
            WVV4REstimBlankDprime(or,s,ch) = simpleDiscrim(WVV4REblank,WVV4REstim);
            WVV4LEstimBlankDprime(or,s,ch) = simpleDiscrim(WVV4LEblank,WVV4LEstim);
            
            XTV1REstimBlankDprime(or,s,ch) = simpleDiscrim(XTV1REblank,XTV1REstim);
            XTV1LEstimBlankDprime(or,s,ch) = simpleDiscrim(XTV1LEblank,XTV1LEstim);
            XTV4REstimBlankDprime(or,s,ch) = simpleDiscrim(XTV4REblank,XTV4REstim);
            XTV4LEstimBlankDprime(or,s,ch) = simpleDiscrim(XTV4LEblank,XTV4LEstim);
            
            WUV1REstimMtx(or,s,ch) = nanmean(WUV1REstim);
            WUV1LEstimMtx(or,s,ch) = nanmean(WUV1LEstim);
            WUV4REstimMtx(or,s,ch) = nanmean(WUV4REstim);
            WUV4LEstimMtx(or,s,ch) = nanmean(WUV4LEstim);

            WVV1REstimMtx(or,s,ch) = nanmean(WVV1REstim);
            WVV1LEstimMtx(or,s,ch) = nanmean(WVV1LEstim);
            WVV4REstimMtx(or,s,ch) = nanmean(WVV4REstim);
            WVV4LEstimMtx(or,s,ch) = nanmean(WVV4LEstim);

            XTV1REstimMtx(or,s,ch) = nanmean(XTV1REstim);
            XTV1LEstimMtx(or,s,ch) = nanmean(XTV1LEstim);
            XTV4REstimMtx(or,s,ch) = nanmean(XTV4REstim);
            XTV4LEstimMtx(or,s,ch) = nanmean(XTV4LEstim);
        end
        
    end
end
%% Save matrices
% spike count
WUV1grat.RE.stimBlankSpikeCountMtx = WUV1REstimMtx;
WUV1grat.LE.stimBlankSpikeCountMtx = WUV1LEstimMtx;
WUV4grat.RE.stimBlankSpikeCountMtx = WUV4REstimMtx;
WUV4grat.LE.stimBlankSpikeCountMtx = WUV4LEstimMtx;

WVV1grat.RE.stimBlankSpikeCountMtx = WVV1REstimMtx;
WVV1grat.LE.stimBlankSpikeCountMtx = WVV1LEstimMtx;
WVV4grat.RE.stimBlankSpikeCountMtx = WVV4REstimMtx;
WVV4grat.LE.stimBlankSpikeCountMtx = WVV4LEstimMtx;

XTV1grat.RE.stimBlankSpikeCountMtx = XTV1REstimMtx;
XTV1grat.LE.stimBlankSpikeCountMtx = XTV1LEstimMtx;
XTV4grat.RE.stimBlankSpikeCountMtx = XTV4REstimMtx;
XTV4grat.LE.stimBlankSpikeCountMtx = XTV4LEstimMtx;

% d'
WUV1grat.RE.stimBlankDprimeMtx = WUV1REstimBlankDprime;
WUV1grat.LE.stimBlankDprimeMtx = WUV1LEstimBlankDprime;
WUV4grat.RE.stimBlankDprimeMtx = WUV4REstimBlankDprime;
WUV4grat.LE.stimBlankDprimeMtx = WUV4LEstimBlankDprime;

WVV1grat.RE.stimBlankDprimeMtx = WVV1REstimBlankDprime;
WVV1grat.LE.stimBlankDprimeMtx = WVV1LEstimBlankDprime;
WVV4grat.RE.stimBlankDprimeMtx = WVV4REstimBlankDprime;
WVV4grat.LE.stimBlankDprimeMtx = WVV4LEstimBlankDprime;

XTV1grat.RE.stimBlankDprimeMtx = XTV1REstimBlankDprime;
XTV1grat.LE.stimBlankDprimeMtx = XTV1LEstimBlankDprime;
XTV4grat.RE.stimBlankDprimeMtx = XTV4REstimBlankDprime;
XTV4grat.LE.stimBlankDprimeMtx = XTV4LEstimBlankDprime;
%% ODI
[XTV1grat.ODI] = getGratODI(XTV1LEstimBlankDprime,XTV1grat.LE.goodCh,XTV1REstimBlankDprime,XTV1grat.RE.goodCh);
[XTV4grat.ODI] = getGratODI(XTV4LEstimBlankDprime,XTV4grat.LE.goodCh,XTV4REstimBlankDprime,XTV4grat.RE.goodCh);

[WUV1grat.ODI] = getGratODI(WUV1LEstimBlankDprime,WUV1grat.LE.goodCh,WUV1REstimBlankDprime,WUV1grat.RE.goodCh);
[WUV4grat.ODI] = getGratODI(WUV4LEstimBlankDprime,WUV4grat.LE.goodCh,WUV4REstimBlankDprime,WUV4grat.RE.goodCh);

[WVV1grat.ODI] = getGratODI(WVV1LEstimBlankDprime,WVV1grat.LE.goodCh,WVV1REstimBlankDprime,WVV1grat.RE.goodCh);
[WVV4grat.ODI] = getGratODI(WVV4LEstimBlankDprime,WVV4grat.LE.goodCh,WVV4REstimBlankDprime,WVV4grat.RE.goodCh);
%% plot ODI
% V4
% figure(1)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1), pos(2), 800, 900],'PaperSize',[7.5 10])
% 
% subplot(8,3,6)
% hold on
% ODI = WVV4grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
% 
% set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% 
% clear ODI
% 
% 
% subplot(8,3,5)
% hold on
% ODI = WUV4grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
% set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'AE','','Binoc','','FE'})
% 
% clear ODI
% 
% 
% subplot(8,3,4)
% hold on
% ODI = XTV4grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2)+0.013, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabelRotation', 45,'FontAngle','italic','FontSize',10,'layer','top')
% set(gca,'XTick',[-1 -0.5 0 0.5 1],'XTickLabel',{'Contra','','Binoc','','Ipsi'})
% text(-1.9, 0.3, 'V4','FontWeight','bold','FontSize',11) 
% text(-2.2, 0.45, 'Gratings','Rotation',90,'FontWeight','bold','FontSize',12)
% clear ODI
% 
% % V1
% subplot(8,3,3)
% hold on
% ODI = WVV1grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
% 
% title('A2')
% clear ODI
% 
% 
% subplot(8,3,2)
% hold on
% ODI = WUV1grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
% title('A1')
% clear ODI
% 
% 
% subplot(8,3,1)
% hold on
% ODI = XTV1grat.ODI;
% 
% histogram(ODI,'Normalization','probability','facealpha',1,'BinWidth',0.4,'FaceColor','k','edgecolor','w');
% plot([0 0], [0 0.6], 'k:','LineWidth',1.5)
% plot(nanmedian(ODI),0.55,'vk','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',8)
% text(nanmedian(ODI+0.1),0.55,sprintf('%.2f',nanmedian(ODI)),'FontSize',10)
% xlim([-1.3 1.3])
% ylim([0 0.6])
% 
% pos = get(gca,'Position');
% set(gca,'Position',[pos(1), pos(2) + 0.0175, pos(3) + 0.02, pos(4) - 0.02])
% set(gca,'box', 'off','color', 'none', 'tickdir','out',...
%     'XTickLabel',{'','','','',''},'FontAngle','italic','FontSize',10,'layer','top')
% text(-1.9, 0.3, 'V1','FontWeight','bold','FontSize',11) 
% title('Control')
% clear ODI
%%  make figures

figure(1)
clf

hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        XTV1RE = squeeze(mean(XTV1REstimBlankDprime(or,s,:),3));
        XTV1LE = squeeze(mean(XTV1LEstimBlankDprime(or,s,:),3));
        
        WUV1RE = squeeze(mean(WUV1REstimBlankDprime(or,s,:),3));
        WUV1LE = squeeze(mean(WUV1LEstimBlankDprime(or,s,:),3));
        
        WVV1RE = squeeze(mean(WVV1REstimBlankDprime(or,s,:),3));
        WVV1LE = squeeze(mean(WVV1LEstimBlankDprime(or,s,:),3));
        
        scatter(ndx,XTV1RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,XTV1LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        scatter(ndx,WUV1RE,70,'^','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,WUV1LE,70,'^','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        scatter(ndx,WVV1RE,70,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,WVV1LE,70,'v','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        ndx = ndx+1;
    end
end
title('V1/V2')
set(gca,'tickdir','out','XTick',1:ndx-1,'XTickLabel',...
{'0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180',...
 '0','','60','','120','','180'},'XTickLabelRotation',90,...
 'FontName','Arial','FontSize',10,'FontAngle','italic')

ylabel('mean d''')
xlabel('stimulus')
xlim([0 42])
ylim([-0.5 1.5])
set(gcf,'InvertHardcopy','off','color','w')

figure(2)
clf
hold on
ndx = 1;
for s = 4:length(sfs)
% sfs(s)
    for or = 1:length(oris)
% oris(or)
        XTV4RE = squeeze(mean(XTV4REstimBlankDprime(or,s,:),3));
        XTV4LE = squeeze(mean(XTV4LEstimBlankDprime(or,s,:),3));
        
        WUV4RE = squeeze(mean(WUV4REstimBlankDprime(or,s,:),3));
        WUV4LE = squeeze(mean(WUV4LEstimBlankDprime(or,s,:),3));
        
        WVV4RE = squeeze(mean(WVV4REstimBlankDprime(or,s,:),3));
        WVV4LE = squeeze(mean(WVV4LEstimBlankDprime(or,s,:),3));
        
        
        scatter(ndx,XTV4RE,75,'s','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,XTV4LE,75,'s','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        scatter(ndx,WUV4RE,70,'^','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,WUV4LE,70,'^','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        scatter(ndx,WVV4RE,70,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        scatter(ndx,WVV4LE,70,'v','MarkerFaceColor',[0.2 0.4 1],'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
        
        ndx = ndx+1;
    end
end

set(gca,'tickdir','out','XTick',1:ndx-1,'XTickLabel',...
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