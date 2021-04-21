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
set(gcf,'Position',[34 177 600 1400],'PaperSize',[7.5,10.25],'InnerPosition',[50 1 600 1085]);

t = suptitle('Glass pattern orientation tuning');
t.Position(2) = t.Position(2) +0.042;
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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'XT','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
title('LE/FE','FontSize',14)

s.Position(2) = s.Position(2) - 0.0022;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
title('RE/AE','FontSize',14)

s.Position(2) = s.Position(2) - 0.0022;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.013;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.013;
s.Position(3) = s.Position(3) - 0.008;


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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WU','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.04;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.06;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(2.7,1.75,'WV','FontSize',18,'FontWeight','bold')
text(3.14,1.95,'V1/V2','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})


text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')
%s.Position(1) = %s.Position(1) - 0.1;
s.Position(2) = s.Position(2) - 0.07;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.07;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(3.14,1.5,'V4','FontSize',14,'FontWeight','bold')
set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.085;
s.Position(3) = s.Position(3) - 0.008;

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
%text(cirMuL+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
%text(cirMuL2+0.2,0.5,sprintf('\\mu %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',11,'FontAngle','italic','RTickLabels',{'','',''})
text(0,1.2,sprintf('n %d',length(SIL2)),'FontSize',12,'FontWeight','bold')

s.Position(2) = s.Position(2) - 0.085;
s.Position(3) = s.Position(3) - 0.008;


%%
figName = ['AllMonk_prefOri_bestDprimeSum_port','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')