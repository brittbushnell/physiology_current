function plotPrefDomOriDiffVsOSI_noID(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

%% quadrant 2

% V1 LE
s1 = subplot(4,4,1); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trLE.within2OSI.q2(WUV1.trLE.within2Ranks.q2 == 2), WUV1.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q2(WVV1.trLE.within2Ranks.q2 == 2), WVV1.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q2(XTV1.trLE.within2Ranks.q2 == 2), XTV1.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trLE.within2OSI.q2(WUV1.trLE.within2Ranks.q2 == 1), WUV1.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q2(WVV1.trLE.within2Ranks.q2 == 1), WVV1.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q2(XTV1.trLE.within2Ranks.q2 == 1), XTV1.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('LE/FE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

y = ylabel('V1','FontSize',14,'FontWeight','bold','FontAngle','italic');

s1.Position(1) = s1.Position(1) - 0.09;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 LE
s1 = subplot(4,4,5); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trLE.within2OSI.q2(WUV4.trLE.within2Ranks.q2 == 2), WUV4.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q2(WVV4.trLE.within2Ranks.q2 == 2), WVV4.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q2(XTV4.trLE.within2Ranks.q2 == 2), XTV4.trLE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trLE.within2OSI.q2(WUV4.trLE.within2Ranks.q2 == 1), WUV4.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q2(WVV4.trLE.within2Ranks.q2 == 1), WVV4.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q2(XTV4.trLE.within2Ranks.q2 == 1), XTV4.trLE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])

xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
ylabel('V4','FontSize',14,'FontWeight','bold','FontAngle','italic');
s1.Position(1) = s1.Position(1) - 0.09;
s1.Position(2) = s1.Position(2) + 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;


% V1 RE
s1 = subplot(4,4,2); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trRE.within2OSI.q2(WUV1.trRE.within2Ranks.q2 == 2), WUV1.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q2(WVV1.trRE.within2Ranks.q2 == 2), WVV1.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q2(XTV1.trRE.within2Ranks.q2 == 2), XTV1.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trRE.within2OSI.q2(WUV1.trRE.within2Ranks.q2 == 1), WUV1.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q2(WVV1.trRE.within2Ranks.q2 == 1), WVV1.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q2(XTV1.trRE.within2Ranks.q2 == 1), XTV1.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('RE/AE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 RE
s1 = subplot(4,4,6); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trRE.within2OSI.q2(WUV4.trRE.within2Ranks.q2 == 2), WUV4.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q2(WVV4.trRE.within2Ranks.q2 == 2), WVV4.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q2(XTV4.trRE.within2Ranks.q2 == 2), XTV4.trRE.radDiff.q2,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trRE.within2OSI.q2(WUV4.trRE.within2Ranks.q2 == 1), WUV4.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q2(WVV4.trRE.within2Ranks.q2 == 1), WVV4.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q2(XTV4.trRE.within2Ranks.q2 == 1), XTV4.trRE.conDiff.q2,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(2) = s1.Position(2) + 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

%% Quadrant 1

% V1 LE
s1 = subplot(4,4,3); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trLE.within2OSI.q1(WUV1.trLE.within2Ranks.q1 == 2), WUV1.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q1(WVV1.trLE.within2Ranks.q1 == 2), WVV1.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q1(XTV1.trLE.within2Ranks.q1 == 2), XTV1.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trLE.within2OSI.q1(WUV1.trLE.within2Ranks.q1 == 1), WUV1.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q1(WVV1.trLE.within2Ranks.q1 == 1), WVV1.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q1(XTV1.trLE.within2Ranks.q1 == 1), XTV1.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('LE/FE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1)+ 0.016;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 LE
s1 = subplot(4,4,7); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trLE.within2OSI.q1(WUV4.trLE.within2Ranks.q1 == 2), WUV4.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q1(WVV4.trLE.within2Ranks.q1 == 2), WVV4.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q1(XTV4.trLE.within2Ranks.q1 == 2), XTV4.trLE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trLE.within2OSI.q1(WUV4.trLE.within2Ranks.q1 == 1), WUV4.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q1(WVV4.trLE.within2Ranks.q1 == 1), WVV4.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q1(XTV4.trLE.within2Ranks.q1 == 1), XTV4.trLE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])

xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
s1.Position(1) = s1.Position(1) + 0.016;
s1.Position(2) = s1.Position(2) + 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V1 RE
s1 = subplot(4,4,4); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trRE.within2OSI.q1(WUV1.trRE.within2Ranks.q1 == 2), WUV1.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q1(WVV1.trRE.within2Ranks.q1 == 2), WVV1.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q1(XTV1.trRE.within2Ranks.q1 == 2), XTV1.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trRE.within2OSI.q1(WUV1.trRE.within2Ranks.q1 == 1), WUV1.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q1(WVV1.trRE.within2Ranks.q1 == 1), WVV1.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q1(XTV1.trRE.within2Ranks.q1 == 1), XTV1.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('RE/AE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;
s1.Position(1) = s1.Position(1) + 0.055;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 RE
s1 = subplot(4,4,8); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trRE.within2OSI.q1(WUV4.trRE.within2Ranks.q1 == 2), WUV4.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q1(WVV4.trRE.within2Ranks.q1 == 2), WVV4.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q1(XTV4.trRE.within2Ranks.q1 == 2), XTV4.trRE.radDiff.q1,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trRE.within2OSI.q1(WUV4.trRE.within2Ranks.q1 == 1), WUV4.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q1(WVV4.trRE.within2Ranks.q1 == 1), WVV4.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q1(XTV4.trRE.within2Ranks.q1 == 1), XTV4.trRE.conDiff.q1,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
s1.Position(1) = s1.Position(1) + 0.055;
s1.Position(2) = s1.Position(2) + 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

%% quadrant 3
% V1 LE
s1 = subplot(4,4,9); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trLE.within2OSI.q3(WUV1.trLE.within2Ranks.q3 == 2), WUV1.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q3(WVV1.trLE.within2Ranks.q3 == 2), WVV1.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q3(XTV1.trLE.within2Ranks.q3 == 2), XTV1.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trLE.within2OSI.q3(WUV1.trLE.within2Ranks.q3 == 1), WUV1.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q3(WVV1.trLE.within2Ranks.q3 == 1), WVV1.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q3(XTV1.trLE.within2Ranks.q3 == 1), XTV1.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('LE/FE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

y = ylabel('V1','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1) - 0.09;
s1.Position(2) = s1.Position(2) - 0.06;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 LE
s1 = subplot(4,4,13); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trLE.within2OSI.q3(WUV4.trLE.within2Ranks.q3 == 2), WUV4.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q3(WVV4.trLE.within2Ranks.q3 == 2), WVV4.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q3(XTV4.trLE.within2Ranks.q3 == 2), XTV4.trLE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trLE.within2OSI.q3(WUV4.trLE.within2Ranks.q3 == 1), WUV4.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q3(WVV4.trLE.within2Ranks.q3 == 1), WVV4.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q3(XTV4.trLE.within2Ranks.q3 == 1), XTV4.trLE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
ylabel('V4','FontSize',14,'FontWeight','bold','FontAngle','italic');

s1.Position(1) = s1.Position(1) - 0.09;
s1.Position(2) = s1.Position(2) - 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V1 RE
s1 = subplot(4,4,10); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trRE.within2OSI.q3(WUV1.trRE.within2Ranks.q3 == 2), WUV1.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q3(WVV1.trRE.within2Ranks.q3 == 2), WVV1.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q3(XTV1.trRE.within2Ranks.q3 == 2), XTV1.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trRE.within2OSI.q3(WUV1.trRE.within2Ranks.q3 == 1), WUV1.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q3(WVV1.trRE.within2Ranks.q3 == 1), WVV1.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q3(XTV1.trRE.within2Ranks.q3 == 1), XTV1.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('RE/AE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(2) = s1.Position(2) - 0.06;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 RE
s1 = subplot(4,4,14); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trRE.within2OSI.q3(WUV4.trRE.within2Ranks.q3 == 2), WUV4.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q3(WVV4.trRE.within2Ranks.q3 == 2), WVV4.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q3(XTV4.trRE.within2Ranks.q3 == 2), XTV4.trRE.radDiff.q3,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trRE.within2OSI.q3(WUV4.trRE.within2Ranks.q3 == 1), WUV4.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q3(WVV4.trRE.within2Ranks.q3 == 1), WVV4.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q3(XTV4.trRE.within2Ranks.q3 == 1), XTV4.trRE.conDiff.q3,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');
s1.Position(1) = s1.Position(1) - 0.05;
s1.Position(2) = s1.Position(2) - 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;
%% Quadrant 4

% V1 LE
s1 = subplot(4,4,11); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trLE.within2OSI.q4(WUV1.trLE.within2Ranks.q4 == 2), WUV1.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q4(WVV1.trLE.within2Ranks.q4 == 2), WVV1.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q4(XTV1.trLE.within2Ranks.q4 == 2), XTV1.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trLE.within2OSI.q4(WUV1.trLE.within2Ranks.q4 == 1), WUV1.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trLE.within2OSI.q4(WVV1.trLE.within2Ranks.q4 == 1), WVV1.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trLE.within2OSI.q4(XTV1.trLE.within2Ranks.q4 == 1), XTV1.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('LE/FE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1)+ 0.016;
s1.Position(2) = s1.Position(2) - 0.06;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;


% V4 LE
s1 = subplot(4,4,15); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trLE.within2OSI.q4(WUV4.trLE.within2Ranks.q4 == 2), WUV4.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q4(WVV4.trLE.within2Ranks.q4 == 2), WVV4.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q4(XTV4.trLE.within2Ranks.q4 == 2), XTV4.trLE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trLE.within2OSI.q4(WUV4.trLE.within2Ranks.q4 == 1), WUV4.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trLE.within2OSI.q4(WVV4.trLE.within2Ranks.q4 == 1), WVV4.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trLE.within2OSI.q4(XTV4.trLE.within2Ranks.q4 == 1), XTV4.trLE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');

s1.Position(1) = s1.Position(1) + 0.016;
s1.Position(2) = s1.Position(2) - 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V1 RE
s1 = subplot(4,4,12); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV1.trRE.within2OSI.q4(WUV1.trRE.within2Ranks.q4 == 2), WUV1.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q4(WVV1.trRE.within2Ranks.q4 == 2), WVV1.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q4(XTV1.trRE.within2Ranks.q4 == 2), XTV1.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV1.trRE.within2OSI.q4(WUV1.trRE.within2Ranks.q4 == 1), WUV1.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV1.trRE.within2OSI.q4(WVV1.trRE.within2Ranks.q4 == 1), WVV1.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV1.trRE.within2OSI.q4(XTV1.trRE.within2Ranks.q4 == 1), XTV1.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
t = title('RE/AE','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2) + 10;

s1.Position(1) = s1.Position(1) + 0.055;
s1.Position(2) = s1.Position(2) - 0.06;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;

% V4 RE
s1 = subplot(4,4,16); 
hold on
plot([0 1],[100 0],':k')
scatter(WUV4.trRE.within2OSI.q4(WUV4.trRE.within2Ranks.q4 == 2), WUV4.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q4(WVV4.trRE.within2Ranks.q4 == 2), WVV4.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q4(XTV4.trRE.within2Ranks.q4 == 2), XTV4.trRE.radDiff.q4,'MarkerEdgeColor',[0 0.6 0.2],'MarkerEdgeAlpha',0.7)

scatter(WUV4.trRE.within2OSI.q4(WUV4.trRE.within2Ranks.q4 == 1), WUV4.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(WVV4.trRE.within2OSI.q4(WVV4.trRE.within2Ranks.q4 == 1), WVV4.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)
scatter(XTV4.trRE.within2OSI.q4(XTV4.trRE.within2Ranks.q4 == 1), XTV4.trRE.conDiff.q4,'MarkerEdgeColor',[0.7 0 0.7],'MarkerEdgeAlpha',0.7)

xlim([0 1])
ylim([0 90])
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic');

s1.Position(1) = s1.Position(1) + 0.055;
s1.Position(2) = s1.Position(2) - 0.03;
s1.Position(3) = s1.Position(3) + 0.03;
s1.Position(4) = s1.Position(4) - 0.035;
%%
text(-1.95,-35, 'Radial','Color',[0 0.6 0.2], 'fontWeight','bold','FontSize',14)
text(-1.5, -35, 'Concentric','Color',[0.7 0 0.7], 'fontWeight','bold','FontSize',14)

