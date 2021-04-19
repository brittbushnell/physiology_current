
cDiff1 = XTV1.trLE.conDiff.q1;
cDiff2 = XTV1.trLE.conDiff.q2;
cDiff3 = XTV1.trLE.conDiff.q3;
cDiff4 = XTV1.trLE.conDiff.q4;

XTcDiffLEv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = XTV1.trLE.radDiff.q1;
rDiff2 = XTV1.trLE.radDiff.q2;
rDiff3 = XTV1.trLE.radDiff.q3;
rDiff4 = XTV1.trLE.radDiff.q4;

XTrDiffLEv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = XTV1.trRE.conDiff.q1;
cDiff2 = XTV1.trRE.conDiff.q2;
cDiff3 = XTV1.trRE.conDiff.q3;
cDiff4 = XTV1.trRE.conDiff.q4;

XTcDiffREv1 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = XTV1.trRE.radDiff.q1;
rDiff2 = XTV1.trRE.radDiff.q2;
rDiff3 = XTV1.trRE.radDiff.q3;
rDiff4 = XTV1.trRE.radDiff.q4;

XTrDiffREv1 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
%%
cDiff1 = XTV4.trLE.conDiff.q1;
cDiff2 = XTV4.trLE.conDiff.q2;
cDiff3 = XTV4.trLE.conDiff.q3;
cDiff4 = XTV4.trLE.conDiff.q4;

XTcDiffLEv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);
clear cDiff1; clear cDiff2; clear cDiff3; clear cDiff4;

rDiff1 = XTV4.trLE.radDiff.q1;
rDiff2 = XTV4.trLE.radDiff.q2;
rDiff3 = XTV4.trLE.radDiff.q3;
rDiff4 = XTV4.trLE.radDiff.q4;

XTrDiffLEv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);
clear rDiff1; clear rDiff2; clear rDiff3; clear rDiff4;

cDiff1 = XTV4.trRE.conDiff.q1;
cDiff2 = XTV4.trRE.conDiff.q2;
cDiff3 = XTV4.trRE.conDiff.q3;
cDiff4 = XTV4.trRE.conDiff.q4;

XTcDiffREv4 = vertcat(cDiff1, cDiff2, cDiff3, cDiff4);

rDiff1 = XTV4.trRE.radDiff.q1;
rDiff2 = XTV4.trRE.radDiff.q2;
rDiff3 = XTV4.trRE.radDiff.q3;
rDiff4 = XTV4.trRE.radDiff.q4;

XTrDiffREv4 = vertcat(rDiff1, rDiff2, rDiff3, rDiff4);

%%


plot(mean(XTcDiffLEv1),mean(XTcDiffREv1),'o','MarkerEdgeColor',[0.7 0 0.7],'MarkerFaceColor','w','MarkerSize',9)
plot(mean(XTrDiffLEv1),mean(XTrDiffREv1),'o','MarkerEdgeColor',[0 0.6 0.2],'MarkerFaceColor','w','MarkerSize',9)
plot(mean(XTcDiffLEv4),mean(XTcDiffREv4),'o','MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerSize',9)
plot(mean(XTrDiffLEv4),mean(XTrDiffREv4),'o','MarkerEdgeColor','w','MarkerFaceColor',[0 0.6 0.2],'MarkerSize',9)

