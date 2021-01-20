function [] = plotQuadHist_conRadDipSep(quadOris, quadRanks)
%Add: Mean of the distributions, and difference between the mean and the expected orientation.


qOris1 = quadOris.q1;
qRanks1 = quadRanks.q1;

qOris2 = quadOris.q2;
qRanks2 = quadRanks.q2;

qOris3 = quadOris.q3;
qRanks3 = quadRanks.q3;

qOris4 = quadOris.q4;
qRanks4 = quadRanks.q4;
%%

% quadrant 2 subplots 1,2,5
conOris = (qOris2(qRanks2 == 1));
radOris = (qOris2(qRanks2 == 2));
dipOris = (qOris2(qRanks2 == 3));

conMu = circ_mean(conOris);
radMu = circ_mean(radOris);
dipMu = circ_mean(dipOris);

if length(radMu) ~= 0
    radDiff = angdiff(135,rad2deg(radMu));
    if radDiff > 90
        radDiff = abs(radDiff - 180);
    end
else
    radDiff = 0;
end

if length(conMu) ~= 0
    conDiff = angdiff(45,rad2deg(conMu));
    if conDiff > 90
        conDiff = abs(conDiff - 180);
    end
else
    conDiff = 0;
end

s1 = subplot(4,4,1,polaraxes);
hold on

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
polarplot([radMu,0 radMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)

text(deg2rad(265),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',radDiff,char(176)))

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(2) = s1.Position(2) - 0.03;

% concentric distributions
s1 = subplot(4,4,2,polaraxes);
hold on

[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
polarplot([conMu,0 conMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',conDiff,char(176)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) - 0.07;
s1.Position(2) = s1.Position(2) - 0.03;

% dipole distributions
s1 = subplot(4,4,5,polaraxes);
hold on
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

text(deg2rad(265),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
polarplot([dipMu,0 dipMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)

ax = gca;
ax.RLim   = [0,0.55]; 
s1.Position(1) = s1.Position(1) + 0.045;
% s1.Position(2) = s1.Position(2) + 0.025;

%% quadrant 3 subplots 9,10,13
conOris = (qOris3(qRanks3 == 1));
radOris = (qOris3(qRanks3 == 2));
dipOris = (qOris3(qRanks3 == 3));

conMu = circ_mean(conOris);
radMu = circ_mean(radOris);
dipMu = circ_mean(dipOris);

if length(radMu) ~= 0
    radDiff = angdiff(45,rad2deg(radMu));
    if radDiff > 90
        radDiff = abs(radDiff - 180);
    end
else
    radDiff = 0;
end

if length(conMu) ~= 0
    conDiff = angdiff(135,rad2deg(conMu));
    if conDiff > 90
        conDiff = abs(conDiff - 180);
    end
else
    conDiff = 0;
end

s1 = subplot(4,4,9,polaraxes);
hold on

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
polarplot([radMu,0 radMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',radDiff,char(176)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(2) = s1.Position(2) - 0.05;

% concentric distributions
s1 = subplot(4,4,10,polaraxes);
hold on

[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
polarplot([conMu,0 conMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
title(sprintf('%.1f%c difference',conDiff,char(176)))
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) - 0.07;
s1.Position(2) = s1.Position(2) - 0.05;

 % dipole distributions
s1 = subplot(4,4,13,polaraxes);
hold on
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

text(deg2rad(265),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
polarplot([dipMu,0 dipMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)

ax = gca;
ax.RLim   = [0,0.55]; 
s1.Position(1) = s1.Position(1) + 0.045;
s1.Position(2) = s1.Position(2) - 0.04;

%% quadrant 1 subplots 3,4,7
conOris = (qOris1(qRanks1 == 1));
radOris = (qOris1(qRanks1 == 2));
dipOris = (qOris1(qRanks1 == 3));

conMu = circ_mean(conOris);
radMu = circ_mean(radOris);
dipMu = circ_mean(dipOris);
if length(radMu) ~= 0
    radDiff = angdiff(45,rad2deg(radMu));
    if radDiff > 90
        radDiff = abs(radDiff - 180);
    end
else
    radDiff = 0;
end

if length(conMu) ~= 0
    conDiff = angdiff(135,rad2deg(conMu));
    if conDiff > 90
        conDiff = abs(conDiff - 180);
    end
else
    conDiff = 0;
end

s1 = subplot(4,4,3,polaraxes);
hold on

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
polarplot([radMu,0 radMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',radDiff,char(176)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) + 0.06;
s1.Position(2) = s1.Position(2) - 0.03;
% concentric distributions
s1 = subplot(4,4,4,polaraxes);
hold on

[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
polarplot([conMu,0 conMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',conDiff,char(176)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) + 0.05;
s1.Position(2) = s1.Position(2) - 0.03;
% dipole distributions
s1 = subplot(4,4,7,polaraxes);
hold on
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

text(deg2rad(265),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
polarplot([dipMu,0 dipMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)

ax = gca;
ax.RLim   = [0,0.55]; 
s1.Position(1) = s1.Position(1) + 0.15;
% s1.Position(2) = s1.Position(2) + 0.025;

%% quadrant 4 subplots 11,12,15
conOris = (qOris4(qRanks4 == 1));
radOris = (qOris4(qRanks4 == 2));
dipOris = (qOris4(qRanks4 == 3));

conMu = circ_mean(conOris);
radMu = circ_mean(radOris);
dipMu = circ_mean(dipOris);
 
if length(radMu) ~= 0
    radDiff = angdiff(135,rad2deg(radMu));
    if radDiff > 90
        radDiff = abs(radDiff - 180);
    end
else
    radDiff = 0;
end

if length(conMu) ~= 0
    conDiff = angdiff(45,rad2deg(conMu));
    if conDiff > 90
        conDiff = abs(conDiff - 180);
    end
else
    conDiff = 0;
end
s1 = subplot(4,4,11,polaraxes);
hold on

% radial distributions
[bins,edges] = histcounts(radOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(radOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0 0.6 0.2],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(135) 0 deg2rad(315)],[0.5 0 0.5],'--','color',[0 0.6 0.2],'LineWidth',0.85)
polarplot([radMu,0 radMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(radOris)),'FontWeight','bold','Color',[0 0.6 0.2],'FontSize',12)

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',radDiff,char(176)))
ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) + 0.06;
s1.Position(2) = s1.Position(2) - 0.05;

% concentric distributions
s1 = subplot(4,4,12,polaraxes);
hold on

[bins,edges] = histcounts(conOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(conOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[0.7 0 0.7],'EdgeColor','w','FaceAlpha',0.5)

polarplot([deg2rad(45) 0 deg2rad(225)],[0.5 0 0.5],'--','color',[0.7 0 0.7],'LineWidth',0.85)
text(deg2rad(265),0.5,sprintf('%d',length(conOris)),'FontWeight','bold','Color',[0.7 0 0.7],'FontSize',12)
polarplot([conMu,0 conMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)
title(sprintf('%.1f%c difference',conDiff,char(176)))

ax = gca;
ax.RLim   = [0,0.55];
s1.Position(1) = s1.Position(1) + 0.05;
s1.Position(2) = s1.Position(2) - 0.05;

% dipole distributions
s1 = subplot(4,4,15,polaraxes);
hold on
[bins,edges] = histcounts(dipOris+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

[bins,edges] = histcounts(dipOris,0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor',[1 0.5 0.1],'EdgeColor','w','FaceAlpha',0.5)

text(deg2rad(265),0.5,sprintf('%d',length(dipOris)),'FontWeight','bold','Color',[1 0.5 0.1],'FontSize',12)
polarplot([dipMu,0 dipMu+pi],[0.5 0 0.5],'-k','LineWidth',0.85)
set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''},'ThetaTick',0:45:360)

ax = gca;
ax.RLim   = [0,0.55]; 
s1.Position(1) = s1.Position(1) + 0.15;
s1.Position(2) = s1.Position(2) - 0.04;
