function plotRadFreq_tuningIOD(LEdata, REdata)
LEtuned = LEdata.numTunedChs;
REtuned = REdata.numTunedChs;

LEuntuned = LEdata.numUntunedChs;
REuntuned = REdata.numUntunedChs;

LEhighAmp = LEdata.numChsTunedHighAmp;
REhighAmp = REdata.numChsTunedHighAmp;

LEcircle  = LEdata.numChsTunedCircle;
REcircle  = REdata.numChsTunedCircle;
%%
untunedIOD = LEuntuned - REuntuned;
highAmpIOD = LEhighAmp - REhighAmp;
circleIOD  = LEcircle  - REcircle;
%%

LEhighAmpTunedChs = LEdata.numSigChsHighAmpPerRF./LEtuned;
LEcircleTunedChs  = LEdata.numSigChsCirclePerRF./LEtuned;

REhighAmpTunedChs = REdata.numSigChsHighAmpPerRF./REtuned;
REcircleTunedChs  = REdata.numSigChsCirclePerRF./REtuned;

highAmp = [LEhighAmpTunedChs, REhighAmpTunedChs];
circles = [LEcircleTunedChs, REcircleTunedChs];

maxY = max([highAmp,circles],[],'all');
ySpacing = (0:0.2:maxY);

%% bar plot
figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), pos(3),400])
s = suptitle(sprintf('%s %s significant tuning preferences by RF for each eye',LEdata.animal, LEdata.array));

h = subplot(1,2,1);
hold on

b = bar(highAmp,1);
b(1).FaceColor = [0.2 0.4 1];
b(2).FaceColor = [1 0 0];

ylim([0 maxY])
ylabel('% tuned channels')
title('Channels with significant preference for high amplitudes')
set(gca,'TickDir','out','FontAngle','italic','FontSize',10,...
    'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},'YTick',ySpacing,'YTickLabel',ySpacing.*100)
h.Position(4) = h.Position(4) - 0.5;
h.Position(2) = h.Position(2) +0.3;

h = subplot(1,2,2);
hold on

b = bar(circles,1);
b(1).FaceColor = [0.2 0.4 1];
b(2).FaceColor = [1 0 0];

ylim([0 maxY])
title('Channels with significant preference for circles')
set(gca,'TickDir','out','FontAngle','italic','FontSize',10,...
    'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},'YTick',ySpacing,'YTickLabel',ySpacing.*100)
h.Position(4) = h.Position(4) - 0.5;
h.Position(2) = h.Position(2) +0.3;

if contains(LEdata.animal,'XT')
    text(0.5, maxY-0.1, 'LE','Color',[0.2 0.4 1],'FontWeight','bold','FontAngle','italic')
    text(0.5, maxY-0.15,'RE','Color','r','FontWeight','bold','FontAngle','italic')
else
    text(0.5, maxY-0.1, 'FE','Color',[0.2 0.4 1],'FontWeight','bold','FontAngle','italic')
    text(0.5, maxY-0.15,'AE','Color','r','FontWeight','bold','FontAngle','italic')
end
%%
figDir = sprintf('~/Dropbox/Thesis/radialFrequency/Figures/Results/TuningBars');

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [LEdata.animal,'_',LEdata.array,'_highAmpCircles_LEvsRE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% tuning width

LEnumSigHighPerRF = LEdata.numRFsSigHighAmp;
LEnumSigCirclePerRF = LEdata.numRFsSigCircle;

REnumSigHighPerRF = REdata.numRFsSigHighAmp;
REnumSigCirclePerRF = REdata.numRFsSigCircle;

LEhigh = nan(4,1);  REhigh = nan(4,1);

LEhigh(1,1) = sum(LEnumSigHighPerRF == 0);
LEhigh(2,1) = sum(LEnumSigHighPerRF == 1);
LEhigh(3,1) = sum(LEnumSigHighPerRF == 2);
LEhigh(4,1) = sum(LEnumSigHighPerRF == 3);

REhigh(1,1) = sum(REnumSigHighPerRF == 0);
REhigh(2,1) = sum(REnumSigHighPerRF == 1);
REhigh(3,1) = sum(REnumSigHighPerRF == 2);
REhigh(4,1) = sum(REnumSigHighPerRF == 3);

LEcirc = nan(4,1);  REcirc = nan(4,1);

LEcirc(1,1) = sum(LEnumSigCirclePerRF == 0);
LEcirc(2,1) = sum(LEnumSigCirclePerRF == 1);
LEcirc(3,1) = sum(LEnumSigCirclePerRF == 2);
LEcirc(4,1) = sum(LEnumSigCirclePerRF == 3);

REcirc(1,1) = sum(REnumSigCirclePerRF == 0);
REcirc(2,1) = sum(REnumSigCirclePerRF == 1);
REcirc(3,1) = sum(REnumSigCirclePerRF == 2);
REcirc(4,1) = sum(REnumSigCirclePerRF == 3);
%%
figure%(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), pos(3),400])
s = suptitle(sprintf('%s %s tuning width',LEdata.animal, LEdata.array));

subplot(2,2,1)
hold on
axis off
axis square
title('LE')

p = pie(LEhigh);
p(1).FaceColor = [0.4 0.8 1];
if LEhigh(2) > 0
    p(3).FaceColor = [1 0.8 1];
elseif LEhigh(3) > 0
    p(5).FaceColor = [0.6 0.8 0.6];
elseif LEhigh(4) > 0
    p(7).FaceColor = [1 0.8 0.2];
end

text(-2, 0.2, 'High Amp','FontWeight','bold','FontSize',12)
legend('0','1','2','3')

subplot(2,2,2)
hold on
axis off
axis square
title('RE')

p = pie(REhigh);
p(1).FaceColor = [0.4 0.8 1];
if REhigh(2) > 0
    p(3).FaceColor = [1 0.8 1];
elseif REhigh(3) > 0
    p(5).FaceColor = [0.6 0.8 0.6];
elseif REhigh(4) > 0
    p(7).FaceColor = [1 0.8 0.2];
end

subplot(2,2,3)
hold on
axis off
axis square

p = pie(LEcirc);
p(1).FaceColor = [0.4 0.8 1];
if LEcirc(2) > 0
    p(3).FaceColor = [1 0.8 1];
elseif LEcirc(3) > 0
    p(5).FaceColor = [0.6 0.8 0.6];
elseif LEcirc(4) > 0
    p(7).FaceColor = [1 0.8 0.2];
end
text(-2, 0.2, 'circle','FontWeight','bold','FontSize',12)

subplot(2,2,4)
hold on
axis off
axis square

p = pie(REcirc);
p(1).FaceColor = [0.4 0.8 1];
if REcirc(2) > 0
    p(3).FaceColor = [1 0.8 1];
elseif REcirc(3) > 0
    p(5).FaceColor = [0.6 0.8 0.6];
elseif REcirc(4) > 0
    p(7).FaceColor = [1 0.8 0.2];
end
%%
figDir = sprintf('~/Dropbox/Thesis/radialFrequency/Figures/Results/TuningPies');

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [LEdata.animal,'_',LEdata.array,'_TuningWidthPies','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')