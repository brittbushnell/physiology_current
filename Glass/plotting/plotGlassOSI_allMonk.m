function [WUV1, WUV4, WVV1, WVV4, XTV1, XTV4] = plotGlassOSI_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)
XTv1LEOSI = squeeze(XTV1.trLE.OSI(end,:,:,XTV1.trLE.inStim==1));
XTv1LEOSI = reshape(XTv1LEOSI,[1,numel(XTv1LEOSI)]);

XTv1REOSI = squeeze(XTV1.trRE.OSI(end,:,:,XTV1.trRE.inStim==1));
XTv1REOSI = reshape(XTv1REOSI,[1,numel(XTv1REOSI)]);

XTv4LEOSI = squeeze(XTV4.trLE.OSI(end,:,:,XTV4.trLE.inStim==1));
XTv4LEOSI = reshape(XTv4LEOSI,[1,numel(XTv4LEOSI)]);

XTv4REOSI = squeeze(XTV4.trRE.OSI(end,:,:,XTV4.trRE.inStim==1));
XTv4REOSI = reshape(XTv4REOSI,[1,numel(XTv4REOSI)]);

XTV1.trLE.prefOSIinStim = XTv1LEOSI;
XTV1.trRE.prefOSIinStim = XTv1REOSI;

XTV4.trLE.prefOSIinStim = XTv4LEOSI;
XTV4.trRE.prefOSIinStim = XTv4REOSI;
%% WV
WVv1LEOSI = squeeze(WVV1.trLE.OSI(end,:,:,WVV1.trLE.inStim==1));
WVv1LEOSI = reshape(WVv1LEOSI,[1,numel(WVv1LEOSI)]);

WVv1REOSI = squeeze(WVV1.trRE.OSI(end,:,:,WVV1.trRE.inStim==1));
WVv1REOSI = reshape(WVv1REOSI,[1,numel(WVv1REOSI)]);

WVv4LEOSI = squeeze(WVV4.trLE.OSI(end,:,:,WVV4.trLE.inStim==1));
WVv4LEOSI = reshape(WVv4LEOSI,[1,numel(WVv4LEOSI)]);

WVv4REOSI = squeeze(WVV4.trRE.OSI(end,:,:,WVV4.trRE.inStim==1));
WVv4REOSI = reshape(WVv4REOSI,[1,numel(WVv4REOSI)]);

WVV1.trLE.prefOSIinStim = WVv1LEOSI;
WVV1.trRE.prefOSIinStim = WVv1REOSI;

WVV4.trLE.prefOSIinStim = WVv4LEOSI;
WVV4.trRE.prefOSIinStim = WVv4REOSI;
%% WU
WUv1LEOSI = squeeze(WUV1.trLE.OSI(end,:,:,WUV1.trLE.inStim==1));
WUv1LEOSI = reshape(WUv1LEOSI,[1,numel(WUv1LEOSI)]);

WUv1REOSI = squeeze(WUV1.trRE.OSI(end,:,:,WUV1.trRE.inStim==1));
WUv1REOSI = reshape(WUv1REOSI,[1,numel(WUv1REOSI)]);

WUv4LEOSI = squeeze(WUV4.trLE.OSI(end,:,:,WUV4.trLE.inStim==1));
WUv4LEOSI = reshape(WUv4LEOSI,[1,numel(WUv4LEOSI)]);

WUv4REOSI = squeeze(WUV4.trRE.OSI(end,:,:,WUV4.trRE.inStim==1));
WUv4REOSI = reshape(WUv4REOSI,[1,numel(WUv4REOSI)]);

WUV1.trLE.prefOSIinStim = WUv1LEOSI;
WUV1.trRE.prefOSIinStim = WUv1REOSI;

WUV4.trLE.prefOSIinStim = WUv4LEOSI;
WUV4.trRE.prefOSIinStim = WUv4REOSI;
%% get max and minimum OSIs

allOSI = [XTv1LEOSI, XTv4LEOSI, XTv1REOSI, XTv4REOSI,...
          WUv1LEOSI, WUv4LEOSI, WUv1REOSI, WUv4REOSI,...
          WVv1LEOSI, WVv4LEOSI, WVv1REOSI, WVv4REOSI];
minOSI = min(allOSI);
maxOSI = max(allOSI); 
%%
figure(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1100 500])
set(gcf,'PaperOrientation','Landscape');
suptitle({'OSI distributions for channels within 2 degrees across all dt dx combinations';...
    'dotted lines denote medians'})

% XT
s = subplot(2,6,1);
hold on
histogram(XTv1LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(XTv1LEOSI),nanmedian(XTv1LEOSI)],[0 0.3],':k')
text(nanmedian(XTv1LEOSI),0.25,sprintf('%.2f',nanmedian(XTv1LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv1LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv1LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('LE','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylabel('V1','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;


s = subplot(2,6,2);
hold on
histogram(XTv1REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(XTv1REOSI),nanmedian(XTv1REOSI)],[0 0.3],':k')
text(nanmedian(XTv1REOSI),0.25,sprintf('%.2f',nanmedian(XTv1REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv1REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv1REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('RE','FontSize',14,'FontWeight','bold','FontAngle','italic')

text(-0.25,0.5,'XT','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.06;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,7);
hold on
histogram(XTv4LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(XTv4LEOSI),nanmedian(XTv4LEOSI)],[0 0.3],':k')
text(nanmedian(XTv4LEOSI),0.25,sprintf('%.2f',nanmedian(XTv4LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv4LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv4LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
ylabel('V4','FontSize',14,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,8);
hold on
histogram(XTv4REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(XTv4REOSI),nanmedian(XTv4REOSI)],[0 0.3],':k')
text(nanmedian(XTv4REOSI),0.25,sprintf('%.2f',nanmedian(XTv4REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv4REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv4REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.06;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

% WV
s = subplot(2,6,3);
hold on
histogram(WVv1LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WVv1LEOSI),nanmedian(WVv1LEOSI)],[0 0.3],':k')
text(nanmedian(WVv1LEOSI),0.25,sprintf('%.2f',nanmedian(WVv1LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv1LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv1LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('FE','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.015;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,4);
hold on
histogram(WVv1REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WVv1REOSI),nanmedian(WVv1REOSI)],[0 0.3],':k')
text(nanmedian(WVv1REOSI),0.25,sprintf('%.2f',nanmedian(WVv1REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv1REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv1REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('AE','FontSize',14,'FontWeight','bold','FontAngle','italic')
text(-0.25,0.5,'WV','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([0 0.3])
xlim([-0.05,1])
s.Position(1) = s.Position(1) - 0.005;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,9);
hold on
histogram(WVv4LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WVv4LEOSI),nanmedian(WVv4LEOSI)],[0 0.3],':k')
text(nanmedian(WVv4LEOSI),0.25,sprintf('%.2f',nanmedian(WVv4LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv4LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv4LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.015;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,10);
hold on
histogram(WVv4REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WVv4REOSI),nanmedian(WVv4REOSI)],[0 0.3],':k')
text(nanmedian(WVv4REOSI),0.25,sprintf('%.2f',nanmedian(WVv4REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv4REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv4REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])
s.Position(1) = s.Position(1) - 0.005;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

% WU
s = subplot(2,6,6);
hold on
histogram(WUv1REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WUv1REOSI),nanmedian(WUv1REOSI)],[0 0.3],':k')
text(nanmedian(WUv1REOSI),0.25,sprintf('%.2f',nanmedian(WUv1REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv1REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv1REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('AE','FontSize',14,'FontWeight','bold','FontAngle','italic')
text(-0.25,0.5,'WU','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.055;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,5);
hold on
histogram(WUv1LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WUv1LEOSI),nanmedian(WUv1LEOSI)],[0 0.3],':k')
text(nanmedian(WUv1LEOSI),0.25,sprintf('%.2f',nanmedian(WUv1LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv1LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv1LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('FE','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.042;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

%
s = subplot(2,6,12);
hold on
histogram(WUv4REOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WUv4REOSI),nanmedian(WUv4REOSI)],[0 0.3],':k')
text(nanmedian(WUv4REOSI),0.25,sprintf('%.2f',nanmedian(WUv4REOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv4REOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv4REOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.055;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,11);
hold on
histogram(WUv4LEOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WUv4LEOSI),nanmedian(WUv4LEOSI)],[0 0.3],':k')
text(nanmedian(WUv4LEOSI),0.25,sprintf('%.2f',nanmedian(WUv4LEOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv4LEOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv4LEOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.042;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

 figName = 'OSIdistributions_allMonks_allParams.pdf';
 print(gcf, figName,'-dpdf','-fillpage')
%%
XTv1LEprefOSI = (XTV1.trLE.prefParamSI(XTV1.trLE.inStim==1));
XTv1REprefOSI = (XTV1.trRE.prefParamSI(XTV1.trRE.inStim==1));
XTv4LEprefOSI = (XTV4.trLE.prefParamSI(XTV4.trLE.inStim==1));
XTv4REprefOSI = (XTV4.trRE.prefParamSI(XTV4.trRE.inStim==1));

WVv1LEprefOSI = (WVV1.trLE.prefParamSI(WVV1.trLE.inStim==1));
WVv1REprefOSI = (WVV1.trRE.prefParamSI(WVV1.trRE.inStim==1));
WVv4LEprefOSI = (WVV4.trLE.prefParamSI(WVV4.trLE.inStim==1));
WVv4REprefOSI = (WVV4.trRE.prefParamSI(WVV4.trRE.inStim==1));

WUv1LEprefOSI = (WUV1.trLE.prefParamSI(WUV1.trLE.inStim==1));
WUv1REprefOSI = (WUV1.trRE.prefParamSI(WUV1.trRE.inStim==1));
WUv4LEprefOSI = (WUV4.trLE.prefParamSI(WUV4.trLE.inStim==1));
WUv4REprefOSI = (WUV4.trRE.prefParamSI(WUV4.trRE.inStim==1));
%% get max and minimum OSIs

allPrefOSI = [XTv1LEprefOSI; XTv4LEprefOSI; XTv1REprefOSI; XTv4REprefOSI;...
          WUv1LEprefOSI; WUv4LEprefOSI; WUv1REprefOSI; WUv4REprefOSI;...
          WVv1LEprefOSI; WVv4LEprefOSI; WVv1REprefOSI; WVv4REprefOSI];
minOSI = min(allPrefOSI);
maxOSI = max(allPrefOSI); 
%%
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1100 500])
set(gcf,'PaperOrientation','Landscape');
suptitle({'OSI distributions for channels within 2 degrees across preferred dt dx combinations';...
    'dotted lines denote medians'})

% XT
s = subplot(2,6,1);
hold on
histogram(XTv1LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(XTv1LEprefOSI),nanmedian(XTv1LEprefOSI)],[0 0.3],':k')
text(nanmedian(XTv1LEprefOSI),0.25,sprintf('%.2f',nanmedian(XTv1LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv1LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv1LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('LE','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylabel('V1','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;


s = subplot(2,6,2);
hold on
histogram(XTv1REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(XTv1REprefOSI),nanmedian(XTv1REprefOSI)],[0 0.3],':k')
text(nanmedian(XTv1REprefOSI),0.25,sprintf('%.2f',nanmedian(XTv1REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv1REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv1REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('RE','FontSize',14,'FontWeight','bold','FontAngle','italic')

text(-0.25,0.5,'XT','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.06;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,7);
hold on
histogram(XTv4LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(XTv4LEprefOSI),nanmedian(XTv4LEprefOSI)],[0 0.3],':k')
text(nanmedian(XTv4LEprefOSI),0.25,sprintf('%.2f',nanmedian(XTv4LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv4LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv4LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
ylabel('V4','FontSize',14,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.078;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,8);
hold on
histogram(XTv4REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(XTv4REprefOSI),nanmedian(XTv4REprefOSI)],[0 0.3],':k')
text(nanmedian(XTv4REprefOSI),0.25,sprintf('%.2f',nanmedian(XTv4REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(XTv4REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(XTv4REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.06;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

% WV
s = subplot(2,6,3);
hold on
histogram(WVv1LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WVv1LEprefOSI),nanmedian(WVv1LEprefOSI)],[0 0.3],':k')
text(nanmedian(WVv1LEprefOSI),0.25,sprintf('%.2f',nanmedian(WVv1LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv1LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv1LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('FE','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.015;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,4);
hold on
histogram(WVv1REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WVv1REprefOSI),nanmedian(WVv1REprefOSI)],[0 0.3],':k')
text(nanmedian(WVv1REprefOSI),0.25,sprintf('%.2f',nanmedian(WVv1REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv1REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv1REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('AE','FontSize',14,'FontWeight','bold','FontAngle','italic')
text(-0.25,0.5,'WV','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([0 0.3])
xlim([-0.05,1])
s.Position(1) = s.Position(1) - 0.005;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,9);
hold on
histogram(WVv4LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WVv4LEprefOSI),nanmedian(WVv4LEprefOSI)],[0 0.3],':k')
text(nanmedian(WVv4LEprefOSI),0.25,sprintf('%.2f',nanmedian(WVv4LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv4LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv4LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) - 0.015;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,10);
hold on
histogram(WVv4REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WVv4REprefOSI),nanmedian(WVv4REprefOSI)],[0 0.3],':k')
text(nanmedian(WVv4REprefOSI),0.25,sprintf('%.2f',nanmedian(WVv4REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WVv4REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WVv4REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])
s.Position(1) = s.Position(1) - 0.005;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

% WU
s = subplot(2,6,6);
hold on
histogram(WUv1REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WUv1REprefOSI),nanmedian(WUv1REprefOSI)],[0 0.3],':k')
text(nanmedian(WUv1REprefOSI),0.25,sprintf('%.2f',nanmedian(WUv1REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv1REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv1REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('AE','FontSize',14,'FontWeight','bold','FontAngle','italic')
text(-0.25,0.5,'WU','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.055;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,5);
hold on
histogram(WUv1LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WUv1LEprefOSI),nanmedian(WUv1LEprefOSI)],[0 0.3],':k')
text(nanmedian(WUv1LEprefOSI),0.25,sprintf('%.2f',nanmedian(WUv1LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv1LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv1LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
title('FE','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.042;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

%
s = subplot(2,6,12);
hold on
histogram(WUv4REprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor','r','EdgeColor','w')
plot([nanmedian(WUv4REprefOSI),nanmedian(WUv4REprefOSI)],[0 0.3],':k')
text(nanmedian(WUv4REprefOSI),0.25,sprintf('%.2f',nanmedian(WUv4REprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv4REprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv4REprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.055;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

s = subplot(2,6,11);
hold on
histogram(WUv4LEprefOSI,minOSI:0.035:maxOSI,'normalization','probability','FaceColor',[0 0.6 1],'EdgeColor','w')
plot([nanmedian(WUv4LEprefOSI),nanmedian(WUv4LEprefOSI)],[0 0.3],':k')
text(nanmedian(WUv4LEprefOSI),0.25,sprintf('%.2f',nanmedian(WUv4LEprefOSI)))
text(0.04,0.29,sprintf('\\sigma %.2f',nanstd(WUv4LEprefOSI)))
text(0.04,0.25,sprintf('k %.2f',kurtosis(WUv4LEprefOSI)))
set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'Layer','top','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic')
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

ylim([0 0.3])
xlim([-0.05,1])

s.Position(1) = s.Position(1) + 0.042;
s.Position(2) = s.Position(2) + 0.12;
s.Position(3) = s.Position(3) + 0.025;
s.Position(4) = s.Position(4) - 0.2;

figName = 'OSIdistributions_allMonks_PrefParams.pdf';
print(gcf, figName,'-dpdf','-fillpage')
 %%
 
 
 
 
 