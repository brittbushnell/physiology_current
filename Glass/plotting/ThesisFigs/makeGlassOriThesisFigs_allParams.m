function [XTV1,XTV4,WUV1, WUV4,WVV1, WVV4] = makeGlassOriThesisFigs_allParams(XTV1,XTV4,WUV1, WUV4,WVV1, WVV4)

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

XTuseChV1LE = find(XTV1.conRadLE.goodCh & XTV1.conRadLE.inStim);
XTuseChV1RE = find(XTV1.conRadRE.goodCh & XTV1.conRadRE.inStim);

XTuseChV4LE = find(XTV4.conRadLE.goodCh & XTV4.conRadLE.inStim);
XTuseChV4RE = find(XTV4.conRadRE.goodCh & XTV4.conRadRE.inStim);

WUuseChV1LE = find(WUV1.conRadLE.goodCh & WUV1.conRadLE.inStim);
WUuseChV1RE = find(WUV1.conRadRE.goodCh & WUV1.conRadRE.inStim);

WUuseChV4LE = find(WUV4.conRadLE.goodCh & WUV4.conRadLE.inStim);
WUuseChV4RE = find(WUV4.conRadRE.goodCh & WUV4.conRadRE.inStim);

WVuseChV1LE = find(WVV1.conRadLE.goodCh & WVV1.conRadLE.inStim);
WVuseChV1RE = find(WVV1.conRadRE.goodCh & WVV1.conRadRE.inStim);

WVuseChV4LE = find(WVV4.conRadLE.goodCh & WVV4.conRadLE.inStim);
WVuseChV4RE = find(WVV4.conRadRE.goodCh & WVV4.conRadRE.inStim);
%%

figure%(1)
clf
set(gcf,'Position',[34 177 600 1400],'PaperSize',[7.5,10],'InnerPosition',[50 1 600 1085]);

t = suptitle('Glass pattern orientation tuning all dt,dx');
t.Position(2) = t.Position(2) +0.042;
t.FontSize = 20;
axis off

% XT
s = subplot(6,2,1,polaraxes);
hold on
pOris = squeeze(XTV1.trLE.prefOri(end,:,:,XTuseChV1LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
XTv1LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'XT','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
title('LE/FE','FontSize',14)

s.Position(2) = s.Position(2) - 0.0022;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,2,polaraxes);
hold on
pOris = squeeze(XTV1.trRE.prefOri(end,:,:,XTuseChV1RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
XTv1REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
title('RE/AE','FontSize',14)

s.Position(2) = s.Position(2) - 0.0022;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,3,polaraxes);
hold on
pOris = squeeze(XTV4.trLE.prefOri(end,:,:,XTuseChV4LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
XTv4LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.013;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,4,polaraxes);
hold on
pOris = squeeze(XTV4.trRE.prefOri(end,:,:,XTuseChV4RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
XTv4REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.013;
s.Position(3) = s.Position(3) - 0.008;

% WU
s = subplot(6,2,5,polaraxes);
hold on
pOris = squeeze(WUV1.trLE.prefOri(end,:,:,WUuseChV1LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WUv1LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WU','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,6,polaraxes);
hold on
pOris = squeeze(WUV1.trRE.prefOri(end,:,:,WUuseChV1RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WUv1REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,7,polaraxes);
hold on
pOris = (WUV4.trLE.prefOri(end,:,:,WUuseChV4LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WUv4LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,8,polaraxes);
hold on
pOris = squeeze(WUV4.trRE.prefOri(end,:,:,WUuseChV4RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WUv4REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
s.Position(3) = s.Position(3) - 0.008;

% WV
s = subplot(6,2,9,polaraxes);
hold on
pOris = squeeze(WVV1.trLE.prefOri(end,:,:,WVuseChV1LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WVv1LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WV','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.07;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,10,polaraxes);
hold on
pOris = squeeze(WVV1.trRE.prefOri(end,:,:,WVuseChV1RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = []; 

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WVv1REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.07;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,11,polaraxes);
hold on
pOris = squeeze(WVV4.trLE.prefOri(end,:,:,WVuseChV4LE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WVv4LEmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.085;
s.Position(3) = s.Position(3) - 0.008;

s = subplot(6,2,12,polaraxes);
hold on
pOris = squeeze(WVV4.trRE.prefOri(end,:,:,WVuseChV4RE));
pOris = reshape(pOris,[1,numel(pOris)]);
pOris(pOris<0) = pOris(pOris<0)+180;
pOr = pOris;
pOr(isnan(pOr)) = [];

cirMuL = circ_mean(deg2rad(pOr(:)*2))/2;
cirMuL2 = cirMuL+pi;
WVv4REmu = cirMuL;

[bins,edges] = histcounts(deg2rad(pOr),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(pOr)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(pOr)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.085;
s.Position(3) = s.Position(3) - 0.008;

XTv1LEmu = rad2deg(XTv1LEmu);   XTv1REmu = rad2deg(XTv1REmu);
XTv4LEmu = rad2deg(XTv4LEmu);   XTv4REmu = rad2deg(XTv4REmu);

WUv1LEmu = rad2deg(WUv1LEmu);   WUv1REmu = rad2deg(WUv1REmu);
WUv4LEmu = rad2deg(WUv4LEmu);   WUv4REmu = rad2deg(WUv4REmu);

WVv1LEmu = rad2deg(WVv1LEmu);   WVv1REmu = rad2deg(WVv1REmu);
WVv4LEmu = rad2deg(WVv4LEmu);   WVv4REmu = rad2deg(WVv4REmu);
%%
figName = ['AllMonk_prefOri_allParams','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%



XTV1.meanOriDegDifAllStim = abs(XTv1LEmu - XTv1REmu)
XTV4.meanOriDegDifAllStim = abs(XTv4LEmu - XTv4REmu)

WUV1.meanOriDegDifAllStim = abs(WUv1LEmu - WUv1REmu)
WUV4.meanOriDegDifAllStim = abs(WUv4LEmu - WUv4REmu)

WVV1.meanOriDegDifAllStim = abs(WVv1LEmu - WVv1REmu)
WVV4.meanOriDegDifAllStim = abs(WVv4LEmu - WVv4REmu)

% out = angdiff(ang1,ang2)

% XTv1AngDif = angdiff(abs(XTv1LEmu),XTv1REmu)
% XTv4AngDif = angdiff(XTv4LEmu,XTv4REmu)
% 
% WUv1AngDif = angdiff(WUv1LEmu,WUv1REmu)
% WUv4AngDif = angdiff(WUv4LEmu,WUv4REmu)
% 
% WVv1AngDif = angdiff(WVv1LEmu,WVv1REmu)
% WVv4AngDif = angdiff(WVv4LEmu,WVv4REmu)
