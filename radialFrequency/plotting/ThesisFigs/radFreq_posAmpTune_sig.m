function radFreq_posAmpTune_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

% XT
XTsigCorrs4LEv4  = (XTV4LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv4  = (XTV4LE.stimCorrSig(2,:)==1);
XTsigCorrs16LEv4 = (XTV4LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv4  = (squeeze(XTV4LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LEv4;
XTposCorrs8LEv4  = (squeeze(XTV4LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LEv4;
XTposCorrs16LEv4 = (squeeze(XTV4LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LEv4;

[~, XTmaxAmp4LEv4] = max((squeeze(XTV4LE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8LEv4] = max((squeeze(XTV4LE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16LEv4] = max((squeeze(XTV4LE.stimCircDprime(3,:,:))));

XTnumGoodLEv4 = sum(XTV4LE.goodCh);

XTsigCorrs4REv4  = (XTV4RE.stimCorrSig(1,:)==1);
XTsigCorrs8REv4  = (XTV4RE.stimCorrSig(2,:)==1);
XTsigCorrs16REv4 = (XTV4RE.stimCorrSig(3,:)==1);

XTposCorrs4REv4  = (squeeze(XTV4RE.stimCorrs(1,:)) > 0) & XTsigCorrs4REv4;
XTposCorrs8REv4  = (squeeze(XTV4RE.stimCorrs(2,:)) > 0) & XTsigCorrs8REv4;
XTposCorrs16REv4 = (squeeze(XTV4RE.stimCorrs(3,:)) > 0) & XTsigCorrs16REv4;

[~, XTmaxAmp4REv4] = max((squeeze(XTV4RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8REv4] = max((squeeze(XTV4RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16REv4] = max((squeeze(XTV4RE.stimCircDprime(3,:,:))));

XTnumGoodREv4 = sum(XTV4RE.goodCh);

%% WU

WUsigCorrs4LEv4  = (WUV4LE.stimCorrSig(1,:)==1);
WUsigCorrs8LEv4  = (WUV4LE.stimCorrSig(2,:)==1);
WUsigCorrs16LEv4 = (WUV4LE.stimCorrSig(3,:)==1);

WUposCorrs4LEv4  = (squeeze(WUV4LE.stimCorrs(1,:)) > 0) & WUsigCorrs4LEv4;
WUposCorrs8LEv4  = (squeeze(WUV4LE.stimCorrs(2,:)) > 0) & WUsigCorrs8LEv4;
WUposCorrs16LEv4 = (squeeze(WUV4LE.stimCorrs(3,:)) > 0) & WUsigCorrs16LEv4;

[~, WUmaxAmp4LEv4] = max((squeeze(WUV4LE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8LEv4] = max((squeeze(WUV4LE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16LEv4] = max((squeeze(WUV4LE.stimCircDprime(3,:,:))));

WUnumGoodLEv4 = sum(WUV4LE.goodCh);

WUsigCorrs4REv4  = (WUV4RE.stimCorrSig(1,:)==1);
WUsigCorrs8REv4  = (WUV4RE.stimCorrSig(2,:)==1);
WUsigCorrs16REv4 = (WUV4RE.stimCorrSig(3,:)==1);

WUposCorrs4REv4  = (squeeze(WUV4RE.stimCorrs(1,:)) > 0) & WUsigCorrs4REv4;
WUposCorrs8REv4  = (squeeze(WUV4RE.stimCorrs(2,:)) > 0) & WUsigCorrs8REv4;
WUposCorrs16REv4 = (squeeze(WUV4RE.stimCorrs(3,:)) > 0) & WUsigCorrs16REv4;

[~, WUmaxAmp4REv4] = max((squeeze(WUV4RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8REv4] = max((squeeze(WUV4RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16REv4] = max((squeeze(WUV4RE.stimCircDprime(3,:,:))));

WUnumGoodREv4 = sum(WUV4RE.goodCh);

%% WV
WVsigCorrs4LEv4  = (WVV4LE.stimCorrSig(1,:)==1);
WVsigCorrs8LEv4  = (WVV4LE.stimCorrSig(2,:)==1);
WVsigCorrs16LEv4 = (WVV4LE.stimCorrSig(3,:)==1);

WVposCorrs4LEv4  = (squeeze(WVV4LE.stimCorrs(1,:)) > 0) & WVsigCorrs4LEv4;
WVposCorrs8LEv4  = (squeeze(WVV4LE.stimCorrs(2,:)) > 0) & WVsigCorrs8LEv4;
WVposCorrs16LEv4 = (squeeze(WVV4LE.stimCorrs(3,:)) > 0) & WVsigCorrs16LEv4;

[~, WVmaxAmp4LEv4] = max((squeeze(WVV4LE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8LEv4] = max((squeeze(WVV4LE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16LEv4] = max((squeeze(WVV4LE.stimCircDprime(3,:,:))));

WVnumGoodLEv4 = sum(WVV4LE.goodCh);

WVsigCorrs4REv4  = (WVV4RE.stimCorrSig(1,:)==1);
WVsigCorrs8REv4  = (WVV4RE.stimCorrSig(2,:)==1);
WVsigCorrs16REv4 = (WVV4RE.stimCorrSig(3,:)==1);

WVposCorrs4REv4  = (squeeze(WVV4RE.stimCorrs(1,:)) > 0) & WVsigCorrs4REv4;
WVposCorrs8REv4  = (squeeze(WVV4RE.stimCorrs(2,:)) > 0) & WVsigCorrs8REv4;
WVposCorrs16REv4 = (squeeze(WVV4RE.stimCorrs(3,:)) > 0) & WVsigCorrs16REv4;

[~, WVmaxAmp4REv4] = max((squeeze(WVV4RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8REv4] = max((squeeze(WVV4RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16REv4] = max((squeeze(WVV4RE.stimCircDprime(3,:,:))));

WVnumGoodREv4 = sum(WVV4RE.goodCh);
%% V1

% XT
XTsigCorrs4LEv1  = (XTV1LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv1  = (XTV1LE.stimCorrSig(2,:)==1);
XTsigCorrs16LEv1 = (XTV1LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv1  = (squeeze(XTV1LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LEv1;
XTposCorrs8LEv1  = (squeeze(XTV1LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LEv1;
XTposCorrs16LEv1 = (squeeze(XTV1LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LEv1;

[~, XTmaxAmp4LEv1] = max((squeeze(XTV1LE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8LEv1] = max((squeeze(XTV1LE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16LEv1] = max((squeeze(XTV1LE.stimCircDprime(3,:,:))));

XTnumGoodLEv1 = sum(XTV1LE.goodCh);

XTsigCorrs4REv1  = (XTV1RE.stimCorrSig(1,:)==1);
XTsigCorrs8REv1  = (XTV1RE.stimCorrSig(2,:)==1);
XTsigCorrs16REv1 = (XTV1RE.stimCorrSig(3,:)==1);

XTposCorrs4REv1  = (squeeze(XTV1RE.stimCorrs(1,:)) > 0) & XTsigCorrs4REv1;
XTposCorrs8REv1  = (squeeze(XTV1RE.stimCorrs(2,:)) > 0) & XTsigCorrs8REv1;
XTposCorrs16REv1 = (squeeze(XTV1RE.stimCorrs(3,:)) > 0) & XTsigCorrs16REv1;

[~, XTmaxAmp4REv1] = max((squeeze(XTV1RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8REv1] = max((squeeze(XTV1RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16REv1] = max((squeeze(XTV1RE.stimCircDprime(3,:,:))));

XTnumGoodREv1 = sum(XTV1RE.goodCh);

%% WU

WUsigCorrs4LEv1  = (WUV1LE.stimCorrSig(1,:)==1);
WUsigCorrs8LEv1  = (WUV1LE.stimCorrSig(2,:)==1);
WUsigCorrs16LEv1 = (WUV1LE.stimCorrSig(3,:)==1);

WUposCorrs4LEv1  = (squeeze(WUV1LE.stimCorrs(1,:)) > 0) & WUsigCorrs4LEv1;
WUposCorrs8LEv1  = (squeeze(WUV1LE.stimCorrs(2,:)) > 0) & WUsigCorrs8LEv1;
WUposCorrs16LEv1 = (squeeze(WUV1LE.stimCorrs(3,:)) > 0) & WUsigCorrs16LEv1;

[~, WUmaxAmp4LEv1] = max((squeeze(WUV1LE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8LEv1] = max((squeeze(WUV1LE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16LEv1] = max((squeeze(WUV1LE.stimCircDprime(3,:,:))));

WUnumGoodLEv1 = sum(WUV1LE.goodCh);

WUsigCorrs4REv1  = (WUV1RE.stimCorrSig(1,:)==1);
WUsigCorrs8REv1  = (WUV1RE.stimCorrSig(2,:)==1);
WUsigCorrs16REv1 = (WUV1RE.stimCorrSig(3,:)==1);

WUposCorrs4REv1  = (squeeze(WUV1RE.stimCorrs(1,:)) > 0) & WUsigCorrs4REv1;
WUposCorrs8REv1  = (squeeze(WUV1RE.stimCorrs(2,:)) > 0) & WUsigCorrs8REv1;
WUposCorrs16REv1 = (squeeze(WUV1RE.stimCorrs(3,:)) > 0) & WUsigCorrs16REv1;

[~, WUmaxAmp4REv1] = max((squeeze(WUV1RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8REv1] = max((squeeze(WUV1RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16REv1] = max((squeeze(WUV1RE.stimCircDprime(3,:,:))));

WUnumGoodREv1 = sum(WUV1RE.goodCh);

%% WV
WVsigCorrs4LEv1  = (WVV1LE.stimCorrSig(1,:)==1);
WVsigCorrs8LEv1  = (WVV1LE.stimCorrSig(2,:)==1);
WVsigCorrs16LEv1 = (WVV1LE.stimCorrSig(3,:)==1);

WVposCorrs4LEv1  = (squeeze(WVV1LE.stimCorrs(1,:)) > 0) & WVsigCorrs4LEv1;
WVposCorrs8LEv1  = (squeeze(WVV1LE.stimCorrs(2,:)) > 0) & WVsigCorrs8LEv1;
WVposCorrs16LEv1 = (squeeze(WVV1LE.stimCorrs(3,:)) > 0) & WVsigCorrs16LEv1;

[~, WVmaxAmp4LEv1] = max((squeeze(WVV1LE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8LEv1] = max((squeeze(WVV1LE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16LEv1] = max((squeeze(WVV1LE.stimCircDprime(3,:,:))));

WVnumGoodLEv1 = sum(WVV1LE.goodCh);

WVsigCorrs4REv1  = (WVV1RE.stimCorrSig(1,:)==1);
WVsigCorrs8REv1  = (WVV1RE.stimCorrSig(2,:)==1);
WVsigCorrs16REv1 = (WVV1RE.stimCorrSig(3,:)==1);

WVposCorrs4REv1  = (squeeze(WVV1RE.stimCorrs(1,:)) > 0) & WVsigCorrs4REv1;
WVposCorrs8REv1  = (squeeze(WVV1RE.stimCorrs(2,:)) > 0) & WVsigCorrs8REv1;
WVposCorrs16REv1 = (squeeze(WVV1RE.stimCorrs(3,:)) > 0) & WVsigCorrs16REv1;

[~, WVmaxAmp4REv1] = max((squeeze(WVV1RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8REv1] = max((squeeze(WVV1RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16REv1] = max((squeeze(WVV1RE.stimCircDprime(3,:,:))));

WVnumGoodREv1 = sum(WVV1RE.goodCh);
%%
XTmonoInc4LEv4  = (sum(XTposCorrs4LEv4  & (XTmaxAmp4LEv4 >=5)))/XTnumGoodLEv4;
XTmonoInc8LEv4  = (sum(XTposCorrs8LEv4  & (XTmaxAmp8LEv4 >=5)))/XTnumGoodLEv4;
XTmonoInc16LEv4 = (sum(XTposCorrs16LEv4 & (XTmaxAmp16LEv4 >=5)))/XTnumGoodLEv4;

XTmonoInc4LEv1  = (sum(XTposCorrs4LEv1  & (XTmaxAmp4LEv1 >=5)))/XTnumGoodLEv1;
XTmonoInc8LEv1  = (sum(XTposCorrs8LEv1  & (XTmaxAmp8LEv1 >=5)))/XTnumGoodLEv1;
XTmonoInc16LEv1 = (sum(XTposCorrs16LEv1 & (XTmaxAmp16LEv1 >=5)))/XTnumGoodLEv1;


XTmonoInc4REv4  = (sum(XTposCorrs4REv4  & (XTmaxAmp4REv4 >=5)))/XTnumGoodREv4;
XTmonoInc8REv4  = (sum(XTposCorrs8REv4  & (XTmaxAmp8REv4 >=5)))/XTnumGoodREv4;
XTmonoInc16REv4 = (sum(XTposCorrs16REv4 & (XTmaxAmp16REv4 >=5)))/XTnumGoodREv4;

XTmonoInc4REv1  = (sum(XTposCorrs4REv1  & (XTmaxAmp4REv1 >=5)))/XTnumGoodREv1;
XTmonoInc8REv1  = (sum(XTposCorrs8REv1  & (XTmaxAmp8REv1 >=5)))/XTnumGoodREv1;
XTmonoInc16REv1 = (sum(XTposCorrs16REv1 & (XTmaxAmp16REv1 >=5)))/XTnumGoodREv1;

% WU
WUmonoInc4LEv4  = (sum(WUposCorrs4LEv4  & (WUmaxAmp4LEv4 >=5)))/WUnumGoodLEv4;
WUmonoInc8LEv4  = (sum(WUposCorrs8LEv4  & (WUmaxAmp8LEv4 >=5)))/WUnumGoodLEv4;
WUmonoInc16LEv4 = (sum(WUposCorrs16LEv4 & (WUmaxAmp16LEv4 >=5)))/WUnumGoodLEv4;

WUmonoInc4LEv1  = (sum(WUposCorrs4LEv1  & (WUmaxAmp4LEv1 >=5)))/WUnumGoodLEv1;
WUmonoInc8LEv1  = (sum(WUposCorrs8LEv1  & (WUmaxAmp8LEv1 >=5)))/WUnumGoodLEv1;
WUmonoInc16LEv1 = (sum(WUposCorrs16LEv1 & (WUmaxAmp16LEv1 >=5)))/WUnumGoodLEv1;


WUmonoInc4REv4  = (sum(WUposCorrs4REv4  & (WUmaxAmp4REv4 >=5)))/WUnumGoodREv4;
WUmonoInc8REv4  = (sum(WUposCorrs8REv4  & (WUmaxAmp8REv4 >=5)))/WUnumGoodREv4;
WUmonoInc16REv4 = (sum(WUposCorrs16REv4 & (WUmaxAmp16REv4 >=5)))/WUnumGoodREv4;

WUmonoInc4REv1  = (sum(WUposCorrs4REv1  & (WUmaxAmp4REv1 >=5)))/WUnumGoodREv1;
WUmonoInc8REv1  = (sum(WUposCorrs8REv1  & (WUmaxAmp8REv1 >=5)))/WUnumGoodREv1;
WUmonoInc16REv1 = (sum(WUposCorrs16REv1 & (WUmaxAmp16REv1 >=5)))/WUnumGoodREv1;

% WV
WVmonoInc4LEv4  = (sum(WVposCorrs4LEv4  & (WVmaxAmp4LEv4 >=5)))/WVnumGoodLEv4;
WVmonoInc8LEv4  = (sum(WVposCorrs8LEv4  & (WVmaxAmp8LEv4 >=5)))/WVnumGoodLEv4;
WVmonoInc16LEv4 = (sum(WVposCorrs16LEv4 & (WVmaxAmp16LEv4 >=5)))/WVnumGoodLEv4;

WVmonoInc4LEv1  = (sum(WVposCorrs4LEv1  & (WVmaxAmp4LEv1 >=5)))/WVnumGoodLEv1;
WVmonoInc8LEv1  = (sum(WVposCorrs8LEv1  & (WVmaxAmp8LEv1 >=5)))/WVnumGoodLEv1;
WVmonoInc16LEv1 = (sum(WVposCorrs16LEv1 & (WVmaxAmp16LEv1 >=5)))/WVnumGoodLEv1;


WVmonoInc4REv4  = (sum(WVposCorrs4REv4  & (WVmaxAmp4REv4 >=5)))/WVnumGoodREv4;
WVmonoInc8REv4  = (sum(WVposCorrs8REv4  & (WVmaxAmp8REv4 >=5)))/WVnumGoodREv4;
WVmonoInc16REv4 = (sum(WVposCorrs16REv4 & (WVmaxAmp16REv4 >=5)))/WVnumGoodREv4;

WVmonoInc4REv1  = (sum(WVposCorrs4REv1  & (WVmaxAmp4REv1 >=5)))/WVnumGoodREv1;
WVmonoInc8REv1  = (sum(WVposCorrs8REv1  & (WVmaxAmp8REv1 >=5)))/WVnumGoodREv1;
WVmonoInc16REv1 = (sum(WVposCorrs16REv1 & (WVmaxAmp16REv1 >=5)))/WVnumGoodREv1;
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2),750, 450],'PaperSize',[7.5 10])

subplot(2,2,1)
hold on

LEv1 = [XTmonoInc4LEv1 WUmonoInc4LEv1 WVmonoInc4LEv1;...
        XTmonoInc8LEv1 WUmonoInc8LEv1 WVmonoInc8LEv1;...
        XTmonoInc16LEv1 WUmonoInc16LEv1 WVmonoInc16LEv1];

bar(LEv1,1)

title('LE/FE')
ylabel('% channels')

ytks = [0 20 40 60 80];
text(-0.45,0.4,'V1','FontSize',12,'FontWeight','Bold')
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8,'YTickLabel',ytks)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,2,2)
hold on

REv1 = [XTmonoInc4REv1 WUmonoInc4REv1 WVmonoInc4REv1;...
        XTmonoInc8REv1 WUmonoInc8REv1 WVmonoInc8REv1;...
        XTmonoInc16REv1 WUmonoInc16REv1 WVmonoInc16REv1];

bar(REv1,1)

title('RE/AE')

ytks = [0 20 40 60 80];
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8,'YTickLabel',ytks)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,2,3)
hold on

LEv4 = [XTmonoInc4LEv4 WUmonoInc4LEv4 WVmonoInc4LEv4;...
        XTmonoInc8LEv4 WUmonoInc8LEv4 WVmonoInc8LEv4;...
        XTmonoInc16LEv4 WUmonoInc16LEv4 WVmonoInc16LEv4];

bar(LEv4,1)

title('LE/FE')
ylabel('% channels')

ytks = [0 20 40 60 80];
text(-0.45,0.4,'V4','FontSize',12,'FontWeight','Bold')
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8,'YTickLabel',ytks)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,2,4)
hold on

REv4 = [XTmonoInc4REv4 WUmonoInc4REv4 WVmonoInc4REv4;...
        XTmonoInc8REv4 WUmonoInc8REv4 WVmonoInc8REv4;...
        XTmonoInc16REv4 WUmonoInc16REv4 WVmonoInc16REv4];

bar(REv4,1)

title('RE/AE')

ytks = [0 20 40 60 80];
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8,'YTickLabel',ytks)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

legend('XT','WU','WV','Location','best')
%%
