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
close all
figure(1)
clf
set(gcf,'Position',[34 177 670 1400]);

t = suptitle('Glass pattern orientation tuning');
t.Position(2) = t.Position(2) +0.04;
t.FontSize = 20;
axis off

% XT
s = subplot(6,2,1,polaraxes);
hold on
pOrisL = XTV1.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'XT','FontSize',18,'FontWeight','bold')
text(3.14,1.5,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('LE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.0025;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,2,polaraxes);
hold on
pOrisL = XTV1.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('RE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.0025;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,3,polaraxes);
hold on
pOrisL = XTV4.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.015;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,4,polaraxes);
hold on
pOrisL = XTV4.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.015;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;


% WU
s = subplot(6,2,5,polaraxes);
hold on
pOrisL = WUV1.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WU','FontSize',18,'FontWeight','bold')
text(3.14,1.5,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('FE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.04;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,6,polaraxes);
hold on
pOrisL = WUV1.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('AE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.04;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,7,polaraxes);
hold on
pOrisL = WUV4.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,8,polaraxes);
hold on
pOrisL = WUV4.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

% WV
s = subplot(6,2,9,polaraxes);
hold on
pOrisL = WVV1.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WV','FontSize',18,'FontWeight','bold')
text(3.14,1.5,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('FE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.07;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,10,polaraxes);
hold on
pOrisL = WVV1.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180; 

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('AE n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.07;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,11,polaraxes);
hold on
pOrisL = WVV4.trLE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.08;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

s = subplot(6,2,12,polaraxes);
hold on
pOrisL = WVV4.trRE.prefOriBestDprime;
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


title(sprintf('n %d',length(SIL2)),'FontSize',12)
s.Position(1) = s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.08;
% s.Position(3) = s.Position(3) + 0.008;
% s.Position(4) = s.Position(4) + 0.01;

%%
figName = ['AllMonk_prefOri_bestDprimeSum_port','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')