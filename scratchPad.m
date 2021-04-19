cDiff1 = WVV1.trLE.conDiff.q1;
cDiff2 = WVV1.trLE.conDiff.q2;
cDiff3 = WVV1.trLE.conDiff.q3;
cDiff4 = WVV1.trLE.conDiff.q4;

cDiffLEv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = WVV1.trLE.radDiff.q1;
rDiff2 = WVV1.trLE.radDiff.q2;
rDiff3 = WVV1.trLE.radDiff.q3;
rDiff4 = WVV1.trLE.radDiff.q4;

rDiffLEv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = WVV1.trRE.conDiff.q1;
cDiff2 = WVV1.trRE.conDiff.q2;
cDiff3 = WVV1.trRE.conDiff.q3;
cDiff4 = WVV1.trRE.conDiff.q4;

cDiffREv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = WVV1.trRE.radDiff.q1;
rDiff2 = WVV1.trRE.radDiff.q2;
rDiff3 = WVV1.trRE.radDiff.q3;
rDiff4 = WVV1.trRE.radDiff.q4;

rDiffREv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);

%%

figure(1)
clf
hold on
plot(mean(cDiffLEv1),mean(cDiffREv4),'d','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceColor','w','MarkerSize',9)
plot(mean(rDiffLEv1),mean(rDiffREv4),'d','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceColor','w','MarkerSize',9)

xlim([0 90])
ylim([0 90])
xlabel('LE/FE')
ylabel('RE/AE')