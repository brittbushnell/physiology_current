function radFreq_plotTuningTypes_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

% XT
XTsigCorrs4LEv4  = (XTV4LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv4  = (XTV4LE.stimCorrSig(2,:)==1);
XTsigCorrs16LEv4 = (XTV4LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv4  = (squeeze(XTV4LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LEv4;
XTposCorrs8LEv4  = (squeeze(XTV4LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LEv4;
XTposCorrs16LEv4 = (squeeze(XTV4LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LEv4;

XTnegCorrs4LEv4  = (squeeze(XTV4LE.stimCorrs(1,:)) < 0) & XTsigCorrs4LEv4;
XTnegCorrs8LEv4  = (squeeze(XTV4LE.stimCorrs(2,:)) < 0) & XTsigCorrs8LEv4;
XTnegCorrs16LEv4 = (squeeze(XTV4LE.stimCorrs(3,:)) < 0) & XTsigCorrs16LEv4;

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

XTnegCorrs4REv4  = (squeeze(XTV4RE.stimCorrs(1,:)) < 0) & XTsigCorrs4REv4;
XTnegCorrs8REv4  = (squeeze(XTV4RE.stimCorrs(2,:)) < 0) & XTsigCorrs8REv4;
XTnegCorrs16REv4 = (squeeze(XTV4RE.stimCorrs(3,:)) < 0) & XTsigCorrs16REv4;

[~, XTmaxAmp4REv4] = max((squeeze(XTV4RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8REv4] = max((squeeze(XTV4RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16REv4] = max((squeeze(XTV4RE.stimCircDprime(3,:,:))));

XTnumGoodREv4 = sum(XTV4RE.goodCh);

% WU

WUsigCorrs4LEv4  = (WUV4LE.stimCorrSig(1,:)==1);
WUsigCorrs8LEv4  = (WUV4LE.stimCorrSig(2,:)==1);
WUsigCorrs16LEv4 = (WUV4LE.stimCorrSig(3,:)==1);

WUposCorrs4LEv4  = (squeeze(WUV4LE.stimCorrs(1,:)) > 0) & WUsigCorrs4LEv4;
WUposCorrs8LEv4  = (squeeze(WUV4LE.stimCorrs(2,:)) > 0) & WUsigCorrs8LEv4;
WUposCorrs16LEv4 = (squeeze(WUV4LE.stimCorrs(3,:)) > 0) & WUsigCorrs16LEv4;

WUnegCorrs4LEv4  = (squeeze(WUV4LE.stimCorrs(1,:)) < 0) & WUsigCorrs4LEv4;
WUnegCorrs8LEv4  = (squeeze(WUV4LE.stimCorrs(2,:)) < 0) & WUsigCorrs8LEv4;
WUnegCorrs16LEv4 = (squeeze(WUV4LE.stimCorrs(3,:)) < 0) & WUsigCorrs16LEv4;

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

WUnegCorrs4REv4  = (squeeze(WUV4RE.stimCorrs(1,:)) < 0) & WUsigCorrs4REv4;
WUnegCorrs8REv4  = (squeeze(WUV4RE.stimCorrs(2,:)) < 0) & WUsigCorrs8REv4;
WUnegCorrs16REv4 = (squeeze(WUV4RE.stimCorrs(3,:)) < 0) & WUsigCorrs16REv4;

[~, WUmaxAmp4REv4] = max((squeeze(WUV4RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8REv4] = max((squeeze(WUV4RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16REv4] = max((squeeze(WUV4RE.stimCircDprime(3,:,:))));

WUnumGoodREv4 = sum(WUV4RE.goodCh);

% WV
WVsigCorrs4LEv4  = (WVV4LE.stimCorrSig(1,:)==1);
WVsigCorrs8LEv4  = (WVV4LE.stimCorrSig(2,:)==1);
WVsigCorrs16LEv4 = (WVV4LE.stimCorrSig(3,:)==1);

WVposCorrs4LEv4  = (squeeze(WVV4LE.stimCorrs(1,:)) > 0) & WVsigCorrs4LEv4;
WVposCorrs8LEv4  = (squeeze(WVV4LE.stimCorrs(2,:)) > 0) & WVsigCorrs8LEv4;
WVposCorrs16LEv4 = (squeeze(WVV4LE.stimCorrs(3,:)) > 0) & WVsigCorrs16LEv4;

WVnegCorrs4LEv4  = (squeeze(WVV4LE.stimCorrs(1,:)) < 0) & WVsigCorrs4LEv4;
WVnegCorrs8LEv4  = (squeeze(WVV4LE.stimCorrs(2,:)) < 0) & WVsigCorrs8LEv4;
WVnegCorrs16LEv4 = (squeeze(WVV4LE.stimCorrs(3,:)) < 0) & WVsigCorrs16LEv4;

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

WVnegCorrs4REv4  = (squeeze(WVV4RE.stimCorrs(1,:)) < 0) & WVsigCorrs4REv4;
WVnegCorrs8REv4  = (squeeze(WVV4RE.stimCorrs(2,:)) < 0) & WVsigCorrs8REv4;
WVnegCorrs16REv4 = (squeeze(WVV4RE.stimCorrs(3,:)) < 0) & WVsigCorrs16REv4;

[~, WVmaxAmp4REv4] = max((squeeze(WVV4RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8REv4] = max((squeeze(WVV4RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16REv4] = max((squeeze(WVV4RE.stimCircDprime(3,:,:))));

WVnumGoodREv4 = sum(WVV4RE.goodCh);
%%
XTmonoInc4LEv4 = (sum(XTposCorrs4LEv4 & XTmaxAmp4LEv4 >= 5))/XTnumGoodLEv4;
XTmonoInc8LEv4 = (sum(XTposCorrs8LEv4 & XTmaxAmp8LEv4 >= 5))/XTnumGoodLEv4;
XTmonoInc16LEv4 = (sum(XTposCorrs16LEv4 & XTmaxAmp16LEv4 >= 5))/XTnumGoodLEv4;

XTmonoDec4LEv4 = (sum(XTnegCorrs4LEv4 & XTmaxAmp4LEv4 == 1))/XTnumGoodLEv4;
XTmonoDec8LEv4 = (sum(XTnegCorrs8LEv4 & XTmaxAmp8LEv4 == 1))/XTnumGoodLEv4;
XTmonoDec16LEv4 = (sum(XTnegCorrs16LEv4 & XTmaxAmp16LEv4 == 1))/XTnumGoodLEv4;

WUmonoInc4LEv4 = (sum(WUposCorrs4LEv4 & WUmaxAmp4LEv4 >= 5))/WUnumGoodLEv4;
WUmonoInc8LEv4 = (sum(WUposCorrs8LEv4 & WUmaxAmp8LEv4 >= 5))/WUnumGoodLEv4;
WUmonoInc16LEv4 = (sum(WUposCorrs16LEv4 & WUmaxAmp16LEv4 >= 5))/WUnumGoodLEv4;

WUmonoDec4LEv4 = (sum(WUnegCorrs4LEv4 & WUmaxAmp4LEv4 == 1))/WUnumGoodLEv4;
WUmonoDec8LEv4 = (sum(WUnegCorrs8LEv4 & WUmaxAmp8LEv4 == 1))/WUnumGoodLEv4;
WUmonoDec16LEv4 = (sum(WUnegCorrs16LEv4 & WUmaxAmp16LEv4 == 1))/WUnumGoodLEv4;

WVmonoInc4LEv4 = (sum(WVposCorrs4LEv4 & WVmaxAmp4LEv4 >= 5))/WVnumGoodLEv4;
WVmonoInc8LEv4 = (sum(WVposCorrs8LEv4 & WVmaxAmp8LEv4 >= 5))/WVnumGoodLEv4;
WVmonoInc16LEv4 = (sum(WVposCorrs16LEv4 & WVmaxAmp16LEv4 >= 5))/WVnumGoodLEv4;

WVmonoDec4LEv4 = (sum(WVnegCorrs4LEv4 & WVmaxAmp4LEv4 == 1))/WVnumGoodLEv4;
WVmonoDec8LEv4 = (sum(WVnegCorrs8LEv4 & WVmaxAmp8LEv4 == 1))/WVnumGoodLEv4;
WVmonoDec16LEv4 = (sum(WVnegCorrs16LEv4 & WVmaxAmp16LEv4 == 1))/WVnumGoodLEv4;

WVmonoSat4LEv4 = (sum(WVposCorrs4LEv4 & WVmaxAmp4LEv4 == 5))/WVnumGoodLEv4;
WVmonoSat8LEv4 = (sum(WVposCorrs8LEv4 & WVmaxAmp4LEv4 == 5))/WVnumGoodLEv4;
WVmonoSat16LEv4 = (sum(WVposCorrs16LEv4 & WVmaxAmp4LEv4 == 5))/WVnumGoodLEv4;

%% RE

XTmonoInc4REv4 = (sum(XTposCorrs4REv4 & XTmaxAmp4REv4 >= 5))/XTnumGoodREv4;
XTmonoInc8REv4 = (sum(XTposCorrs8REv4 & XTmaxAmp8REv4 >= 5))/XTnumGoodREv4;
XTmonoInc16REv4 = (sum(XTposCorrs16REv4 & XTmaxAmp16REv4 >= 5))/XTnumGoodREv4;

XTmonoDec4REv4 = (sum(XTnegCorrs4REv4 & XTmaxAmp4REv4 == 1))/XTnumGoodREv4;
XTmonoDec8REv4 = (sum(XTnegCorrs8REv4 & XTmaxAmp8REv4 == 1))/XTnumGoodREv4;
XTmonoDec16REv4 = (sum(XTnegCorrs16REv4 & XTmaxAmp16REv4 == 1))/XTnumGoodREv4;

XTmonoSat4REv4 = (sum(XTposCorrs4REv4 & XTmaxAmp4REv4 == 5))/XTnumGoodREv4;
XTmonoSat8REv4 = (sum(XTposCorrs8REv4 & XTmaxAmp4REv4 == 5))/XTnumGoodREv4;
XTmonoSat16REv4 = (sum(XTposCorrs16REv4 & XTmaxAmp4REv4 == 5))/XTnumGoodREv4;

WUmonoInc4REv4 = (sum(WUposCorrs4REv4 & WUmaxAmp4REv4 >= 5))/WUnumGoodREv4;
WUmonoInc8REv4 = (sum(WUposCorrs8REv4 & WUmaxAmp8REv4 >= 5))/WUnumGoodREv4;
WUmonoInc16REv4 = (sum(WUposCorrs16REv4 & WUmaxAmp16REv4 >= 5))/WUnumGoodREv4;

WUmonoDec4REv4 = (sum(WUnegCorrs4REv4 & WUmaxAmp4REv4 == 1))/WUnumGoodREv4;
WUmonoDec8REv4 = (sum(WUnegCorrs8REv4 & WUmaxAmp8REv4 == 1))/WUnumGoodREv4;
WUmonoDec16REv4 = (sum(WUnegCorrs16REv4 & WUmaxAmp16REv4 == 1))/WUnumGoodREv4;

WUmonoSat4REv4 = (sum(WUposCorrs4REv4 & WUmaxAmp4REv4 == 5))/WUnumGoodREv4;
WUmonoSat8REv4 = (sum(WUposCorrs8REv4 & WUmaxAmp4REv4 == 5))/WUnumGoodREv4;
WUmonoSat16REv4 = (sum(WUposCorrs16REv4 & WUmaxAmp4REv4 == 5))/WUnumGoodREv4;

WVmonoInc4REv4 = (sum(WVposCorrs4REv4 & WVmaxAmp4REv4 >= 5))/WVnumGoodREv4;
WVmonoInc8REv4 = (sum(WVposCorrs8REv4 & WVmaxAmp8REv4 >= 5))/WVnumGoodREv4;
WVmonoInc16REv4 = (sum(WVposCorrs16REv4 & WVmaxAmp16REv4 >= 5))/WVnumGoodREv4;

WVmonoDec4REv4 = (sum(WVnegCorrs4REv4 & WVmaxAmp4REv4 == 1))/WVnumGoodREv4;
WVmonoDec8REv4 = (sum(WVnegCorrs8REv4 & WVmaxAmp8REv4 == 1))/WVnumGoodREv4;
WVmonoDec16REv4 = (sum(WVnegCorrs16REv4 & WVmaxAmp16REv4 == 1))/WVnumGoodREv4;

WVmonoSat4REv4 = (sum(WVposCorrs4REv4 & WVmaxAmp4REv4 == 5))/WVnumGoodREv4;
WVmonoSat8REv4 = (sum(WVposCorrs8REv4 & WVmaxAmp4REv4 == 5))/WVnumGoodREv4;
WVmonoSat16REv4 = (sum(WVposCorrs16REv4 & WVmaxAmp4REv4 == 5))/WVnumGoodREv4;
%% plot the things!

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2),750, 450],'PaperSize',[7.5 10])
%%
subplot(2,4,3)
hold on

LEv4 = [XTmonoInc4LEv4  WUmonoInc4LEv4  WVmonoInc4LEv4;...
        XTmonoInc8LEv4  WUmonoInc8LEv4  WVmonoInc8LEv4;...
       XTmonoInc16LEv4 WUmonoInc16LEv4 WVmonoInc16LEv4];

bar(LEv4,1)

title('LE/FE')
% ylabel('% channels')
% text(2,1,'% channels with monotonically increasing responses','FontSize',12)
text(4,1.5,'V4','FontSize',12)
ylim([0 0.8])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,4)
hold on

REampv4 = [XTmonoInc4REv4  WUmonoInc4REv4  WVmonoInc4REv4;...
           XTmonoInc8REv4  WUmonoInc8REv4  WVmonoInc8REv4;...
          XTmonoInc16REv4 WUmonoInc16REv4 WVmonoInc16REv4];

bar(REampv4,1)

title('RE/AE')
ylim([0 0.8])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

% circle preferring channels

subplot(2,4,7)
hold on

LEv4Circ = [ XTmonoDec4LEv4  WUmonoDec4LEv4  WVmonoDec4LEv4;...
             XTmonoDec8LEv4  WUmonoDec8LEv4  WVmonoDec8LEv4;...
            XTmonoDec16LEv4 WUmonoDec16LEv4 WVmonoDec16LEv4];

bar(LEv4Circ,1)

ylim([0 0.1])
%xlim([0.25 3.75])
% text(2,0.15,'% channels with monotonically decreasing responses','FontSize',12)
% ylabel('% channels')

set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,8)
hold on

REv4Circ = [XTmonoDec4REv4  WUmonoDec4REv4  WVmonoDec4REv4;...
            XTmonoDec8REv4  WUmonoDec8REv4  WVmonoDec8REv4;...
           XTmonoDec16REv4 WUmonoDec16REv4 WVmonoDec16REv4];

bar(REv4Circ,1)

ylim([0 0.1])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);
%% V1

% XT
XTsigCorrs4LEv1  = (XTV1LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv1  = (XTV1LE.stimCorrSig(2,:)==1);
XTsigCorrs16LEv1 = (XTV1LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv1  = (squeeze(XTV1LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LEv1;
XTposCorrs8LEv1  = (squeeze(XTV1LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LEv1;
XTposCorrs16LEv1 = (squeeze(XTV1LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LEv1;

XTnegCorrs4LEv1  = (squeeze(XTV1LE.stimCorrs(1,:)) < 0) & XTsigCorrs4LEv1;
XTnegCorrs8LEv1  = (squeeze(XTV1LE.stimCorrs(2,:)) < 0) & XTsigCorrs8LEv1;
XTnegCorrs16LEv1 = (squeeze(XTV1LE.stimCorrs(3,:)) < 0) & XTsigCorrs16LEv1;

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

XTnegCorrs4REv1  = (squeeze(XTV1RE.stimCorrs(1,:)) < 0) & XTsigCorrs4REv1;
XTnegCorrs8REv1  = (squeeze(XTV1RE.stimCorrs(2,:)) < 0) & XTsigCorrs8REv1;
XTnegCorrs16REv1 = (squeeze(XTV1RE.stimCorrs(3,:)) < 0) & XTsigCorrs16REv1;

[~, XTmaxAmp4REv1] = max((squeeze(XTV1RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8REv1] = max((squeeze(XTV1RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16REv1] = max((squeeze(XTV1RE.stimCircDprime(3,:,:))));

XTnumGoodREv1 = sum(XTV1RE.goodCh);

% WU

WUsigCorrs4LEv1  = (WUV1LE.stimCorrSig(1,:)==1);
WUsigCorrs8LEv1  = (WUV1LE.stimCorrSig(2,:)==1);
WUsigCorrs16LEv1 = (WUV1LE.stimCorrSig(3,:)==1);

WUposCorrs4LEv1  = (squeeze(WUV1LE.stimCorrs(1,:)) > 0) & WUsigCorrs4LEv1;
WUposCorrs8LEv1  = (squeeze(WUV1LE.stimCorrs(2,:)) > 0) & WUsigCorrs8LEv1;
WUposCorrs16LEv1 = (squeeze(WUV1LE.stimCorrs(3,:)) > 0) & WUsigCorrs16LEv1;

WUnegCorrs4LEv1  = (squeeze(WUV1LE.stimCorrs(1,:)) < 0) & WUsigCorrs4LEv1;
WUnegCorrs8LEv1  = (squeeze(WUV1LE.stimCorrs(2,:)) < 0) & WUsigCorrs8LEv1;
WUnegCorrs16LEv1 = (squeeze(WUV1LE.stimCorrs(3,:)) < 0) & WUsigCorrs16LEv1;

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

WUnegCorrs4REv1  = (squeeze(WUV1RE.stimCorrs(1,:)) < 0) & WUsigCorrs4REv1;
WUnegCorrs8REv1  = (squeeze(WUV1RE.stimCorrs(2,:)) < 0) & WUsigCorrs8REv1;
WUnegCorrs16REv1 = (squeeze(WUV1RE.stimCorrs(3,:)) < 0) & WUsigCorrs16REv1;

[~, WUmaxAmp4REv1] = max((squeeze(WUV1RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8REv1] = max((squeeze(WUV1RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16REv1] = max((squeeze(WUV1RE.stimCircDprime(3,:,:))));

WUnumGoodREv1 = sum(WUV1RE.goodCh);

% WV
WVsigCorrs4LEv1  = (WVV1LE.stimCorrSig(1,:)==1);
WVsigCorrs8LEv1  = (WVV1LE.stimCorrSig(2,:)==1);
WVsigCorrs16LEv1 = (WVV1LE.stimCorrSig(3,:)==1);

WVposCorrs4LEv1  = (squeeze(WVV1LE.stimCorrs(1,:)) > 0) & WVsigCorrs4LEv1;
WVposCorrs8LEv1  = (squeeze(WVV1LE.stimCorrs(2,:)) > 0) & WVsigCorrs8LEv1;
WVposCorrs16LEv1 = (squeeze(WVV1LE.stimCorrs(3,:)) > 0) & WVsigCorrs16LEv1;

WVnegCorrs4LEv1  = (squeeze(WVV1LE.stimCorrs(1,:)) < 0) & WVsigCorrs4LEv1;
WVnegCorrs8LEv1  = (squeeze(WVV1LE.stimCorrs(2,:)) < 0) & WVsigCorrs8LEv1;
WVnegCorrs16LEv1 = (squeeze(WVV1LE.stimCorrs(3,:)) < 0) & WVsigCorrs16LEv1;

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

WVnegCorrs4REv1  = (squeeze(WVV1RE.stimCorrs(1,:)) < 0) & WVsigCorrs4REv1;
WVnegCorrs8REv1  = (squeeze(WVV1RE.stimCorrs(2,:)) < 0) & WVsigCorrs8REv1;
WVnegCorrs16REv1 = (squeeze(WVV1RE.stimCorrs(3,:)) < 0) & WVsigCorrs16REv1;

[~, WVmaxAmp4REv1] = max((squeeze(WVV1RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8REv1] = max((squeeze(WVV1RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16REv1] = max((squeeze(WVV1RE.stimCircDprime(3,:,:))));

WVnumGoodREv1 = sum(WVV1RE.goodCh);
%%
XTmonoInc4LEv1 = (sum(XTposCorrs4LEv1 & XTmaxAmp4LEv1 >= 5))/XTnumGoodLEv1;
XTmonoInc8LEv1 = (sum(XTposCorrs8LEv1 & XTmaxAmp8LEv1 >= 5))/XTnumGoodLEv1;
XTmonoInc16LEv1 = (sum(XTposCorrs16LEv1 & XTmaxAmp16LEv1 >= 5))/XTnumGoodLEv1;

XTmonoDec4LEv1 = (sum(XTnegCorrs4LEv1 & XTmaxAmp4LEv1 == 1))/XTnumGoodLEv1;
XTmonoDec8LEv1 = (sum(XTnegCorrs8LEv1 & XTmaxAmp8LEv1 == 1))/XTnumGoodLEv1;
XTmonoDec16LEv1 = (sum(XTnegCorrs16LEv1 & XTmaxAmp16LEv1 == 1))/XTnumGoodLEv1;

XTmonoSat4LEv1 = (sum(XTposCorrs4LEv1 & XTmaxAmp4LEv1 == 5))/XTnumGoodLEv1;
XTmonoSat8LEv1 = (sum(XTposCorrs8LEv1 & XTmaxAmp4LEv1 == 5))/XTnumGoodLEv1;
XTmonoSat16LEv1 = (sum(XTposCorrs16LEv1 & XTmaxAmp4LEv1 == 5))/XTnumGoodLEv1;


WUmonoInc4LEv1 = (sum(WUposCorrs4LEv1   & WUmaxAmp4LEv1 >= 5))/WUnumGoodLEv1;
WUmonoInc8LEv1 = (sum(WUposCorrs8LEv1   & WUmaxAmp8LEv1 >= 5))/WUnumGoodLEv1;
WUmonoInc16LEv1 = (sum(WUposCorrs16LEv1 & WUmaxAmp16LEv1 >= 5))/WUnumGoodLEv1;

WUmonoDec4LEv1 = (sum(WUnegCorrs4LEv1   & WUmaxAmp4LEv1 == 1))/WUnumGoodLEv1;
WUmonoDec8LEv1 = (sum(WUnegCorrs8LEv1   & WUmaxAmp8LEv1 == 1))/WUnumGoodLEv1;
WUmonoDec16LEv1 = (sum(WUnegCorrs16LEv1 & WUmaxAmp16LEv1 == 1))/WUnumGoodLEv1;

WUmonoSat4LEv1 = (sum(WUposCorrs4LEv1   & WUmaxAmp4LEv1 == 5))/WUnumGoodLEv1;
WUmonoSat8LEv1 = (sum(WUposCorrs8LEv1   & WUmaxAmp4LEv1 == 5))/WUnumGoodLEv1;
WUmonoSat16LEv1 = (sum(WUposCorrs16LEv1 & WUmaxAmp4LEv1 == 5))/WUnumGoodLEv1;

WVmonoInc4LEv1 = (sum(WVposCorrs4LEv1   & WVmaxAmp4LEv1 >= 5))/WVnumGoodLEv1;
WVmonoInc8LEv1 = (sum(WVposCorrs8LEv1   & WVmaxAmp8LEv1 >= 5))/WVnumGoodLEv1;
WVmonoInc16LEv1 = (sum(WVposCorrs16LEv1 & WVmaxAmp16LEv1 >= 5))/WVnumGoodLEv1;

WVmonoDec4LEv1 = (sum(WVnegCorrs4LEv1   & WVmaxAmp4LEv1 == 1))/WVnumGoodLEv1;
WVmonoDec8LEv1 = (sum(WVnegCorrs8LEv1   & WVmaxAmp8LEv1 == 1))/WVnumGoodLEv1;
WVmonoDec16LEv1 = (sum(WVnegCorrs16LEv1 & WVmaxAmp16LEv1 == 1))/WVnumGoodLEv1;

WVmonoSat4LEv1 = (sum(WVposCorrs4LEv1   & WVmaxAmp4LEv1 == 5))/WVnumGoodLEv1;
WVmonoSat8LEv1 = (sum(WVposCorrs8LEv1   & WVmaxAmp4LEv1 == 5))/WVnumGoodLEv1;
WVmonoSat16LEv1 = (sum(WVposCorrs16LEv1 & WVmaxAmp4LEv1 == 5))/WVnumGoodLEv1;

%% RE

XTmonoInc4REv1 = (sum(XTposCorrs4REv1   & XTmaxAmp4REv1 >= 5))/XTnumGoodREv1;
XTmonoInc8REv1 = (sum(XTposCorrs8REv1   & XTmaxAmp8REv1 >= 5))/XTnumGoodREv1;
XTmonoInc16REv1 = (sum(XTposCorrs16REv1 & XTmaxAmp16REv1 >= 5))/XTnumGoodREv1;

XTmonoDec4REv1 = (sum(XTnegCorrs4REv1   & XTmaxAmp4REv1 == 1))/XTnumGoodREv1;
XTmonoDec8REv1 = (sum(XTnegCorrs8REv1   & XTmaxAmp8REv1 == 1))/XTnumGoodREv1;
XTmonoDec16REv1 = (sum(XTnegCorrs16REv1 & XTmaxAmp16REv1 == 1))/XTnumGoodREv1;

XTmonoSat4REv1 = (sum(XTposCorrs4REv1 & XTmaxAmp4REv1 == 5))/XTnumGoodREv1;
XTmonoSat8REv1 = (sum(XTposCorrs8REv1 & XTmaxAmp4REv1 == 5))/XTnumGoodREv1;
XTmonoSat16REv1 = (sum(XTposCorrs16REv1 & XTmaxAmp4REv1 == 5))/XTnumGoodREv1;

WUmonoInc4REv1 = (sum(WUposCorrs4REv1 & WUmaxAmp4REv1 >= 5))/WUnumGoodREv1;
WUmonoInc8REv1 = (sum(WUposCorrs8REv1 & WUmaxAmp8REv1 >= 5))/WUnumGoodREv1;
WUmonoInc16REv1 = (sum(WUposCorrs16REv1 & WUmaxAmp16REv1 >= 5))/WUnumGoodREv1;

WUmonoDec4REv1 = (sum(WUnegCorrs4REv1 & WUmaxAmp4REv1 == 1))/WUnumGoodREv1;
WUmonoDec8REv1 = (sum(WUnegCorrs8REv1 & WUmaxAmp8REv1 == 1))/WUnumGoodREv1;
WUmonoDec16REv1 = (sum(WUnegCorrs16REv1 & WUmaxAmp16REv1 == 1))/WUnumGoodREv1;

WUmonoSat4REv1 = (sum(WUposCorrs4REv1 & WUmaxAmp4REv1 == 5))/WUnumGoodREv1;
WUmonoSat8REv1 = (sum(WUposCorrs8REv1 & WUmaxAmp4REv1 == 5))/WUnumGoodREv1;
WUmonoSat16REv1 = (sum(WUposCorrs16REv1 & WUmaxAmp4REv1 == 5))/WUnumGoodREv1;

WVmonoInc4REv1 = (sum(WVposCorrs4REv1 & WVmaxAmp4REv1 >= 5))/WVnumGoodREv1;
WVmonoInc8REv1 = (sum(WVposCorrs8REv1 & WVmaxAmp8REv1 >= 5))/WVnumGoodREv1;
WVmonoInc16REv1 = (sum(WVposCorrs16REv1 & WVmaxAmp16REv1 >= 5))/WVnumGoodREv1;

WVmonoDec4REv1 = (sum(WVnegCorrs4REv1 & WVmaxAmp4REv1 == 1))/WVnumGoodREv1;
WVmonoDec8REv1 = (sum(WVnegCorrs8REv1 & WVmaxAmp8REv1 == 1))/WVnumGoodREv1;
WVmonoDec16REv1 = (sum(WVnegCorrs16REv1 & WVmaxAmp16REv1 == 1))/WVnumGoodREv1;

WVmonoSat4REv1 = (sum(WVposCorrs4REv1 & WVmaxAmp4REv1 == 5))/WVnumGoodREv1;
WVmonoSat8REv1 = (sum(WVposCorrs8REv1 & WVmaxAmp4REv1 == 5))/WVnumGoodREv1;
WVmonoSat16REv1 = (sum(WVposCorrs16REv1 & WVmaxAmp4REv1 == 5))/WVnumGoodREv1;
%% plot the things!

subplot(2,4,1)
hold on

LEv1 = [ XTmonoInc4LEv1  WUmonoInc4LEv1  WVmonoInc4LEv1;...
         XTmonoInc8LEv1  WUmonoInc8LEv1  WVmonoInc8LEv1;...
        XTmonoInc16LEv1 WUmonoInc16LEv1 WVmonoInc16LEv1];

bar(LEv1,1)

title('LE/FE')
ylabel('% channels')
% text(2,1.5,'% channels with monotonically increasing responses','FontSize',12)
text(4,1.5,'V1','FontSize',12)
ylim([0 0.8])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,2)
hold on

REv1 = [ XTmonoInc4REv1  WUmonoInc4REv1  WVmonoInc4REv1;...
         XTmonoInc8REv1  WUmonoInc8REv1  WVmonoInc8REv1;...
        XTmonoInc16REv1 WUmonoInc16REv1 WVmonoInc16REv1];

bar(REv1,1)

title('RE/AE')
ylim([0 0.8])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

% circle preferring channels

subplot(2,4,5)
hold on

LEv1Circ = [ XTmonoDec4LEv1  WUmonoDec4LEv1  WVmonoDec4LEv1;...
               XTmonoDec8LEv1  WUmonoDec8LEv1  WVmonoDec8LEv1;...
              XTmonoDec16LEv1 WUmonoDec16LEv1 WVmonoDec16LEv1];

bar(LEv1Circ,1)

ylim([0 0.1])
%xlim([0.25 3.75])
% text(2,2.65,'% channels with monotonically decreasing responses','FontSize',12)
ylabel('% channels')

set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,6)
hold on

REv1Circ = [ XTmonoDec4REv1  WUmonoDec4REv1  WVmonoDec4REv1;...
               XTmonoDec8REv1  WUmonoDec8REv1  WVmonoDec8REv1;...
              XTmonoDec16REv1 WUmonoDec16REv1 WVmonoDec16REv1];

bar(REv1Circ,1)

ylim([0 0.1])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

% l = legend('Control','A1','A2','Location','northeast');
% l.Box = 'off';
% l.FontSize = 10;
% l.FontAngle = 'italic';

% (h,patterns,CvBW,Hinvert,colorlist,dpi,hatchsc,linewidth)
% [hatch, otherhatch] = applyhatch_pluscolor(figure(1),'-/\',[],[],3,2);
%%

figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/Tuning';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['TuningTypesFreq_allMonk_bothArrays_Sig','.pdf'];
print(gcf, figName,'-dpdf','-bestfit','-r300');
