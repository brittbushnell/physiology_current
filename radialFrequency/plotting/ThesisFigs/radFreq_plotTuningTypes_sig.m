% function radFreq_plotTuningTypes_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

% XT
XTsigCorrs4LEv4  = (XTV4LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv4  = (XTV4LE.stimCorrSig(2,:)==1);
XTsigCorrs16LEv4 = (XTV4LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv4  = (squeeze(XTV4LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LEv4;
XTposCorrs8LEv4  = (squeeze(XTV4LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LEv4;
XTposCorrs16LEv4 = (squeeze(XTV4LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LEv4;

% XTnegCorrs4LEv4  = (squeeze(XTV4LE.stimCorrs(1,:)) < 0) & XTsigCorrs4LEv4;
% XTnegCorrs8LEv4  = (squeeze(XTV4LE.stimCorrs(2,:)) < 0) & XTsigCorrs8LEv4;
% XTnegCorrs16LEv4 = (squeeze(XTV4LE.stimCorrs(3,:)) < 0) & XTsigCorrs16LEv4;

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

% XTnegCorrs4REv4  = (squeeze(XTV4RE.stimCorrs(1,:)) < 0) & XTsigCorrs4REv4;
% XTnegCorrs8REv4  = (squeeze(XTV4RE.stimCorrs(2,:)) < 0) & XTsigCorrs8REv4;
% XTnegCorrs16REv4 = (squeeze(XTV4RE.stimCorrs(3,:)) < 0) & XTsigCorrs16REv4;

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

% WUnegCorrs4LEv4  = (squeeze(WUV4LE.stimCorrs(1,:)) < 0) & WUsigCorrs4LEv4;
% WUnegCorrs8LEv4  = (squeeze(WUV4LE.stimCorrs(2,:)) < 0) & WUsigCorrs8LEv4;
% WUnegCorrs16LEv4 = (squeeze(WUV4LE.stimCorrs(3,:)) < 0) & WUsigCorrs16LEv4;

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

% WVnegCorrs4LEv4  = (squeeze(WVV4LE.stimCorrs(1,:)) < 0) & WVsigCorrs4LEv4;
% WVnegCorrs8LEv4  = (squeeze(WVV4LE.stimCorrs(2,:)) < 0) & WVsigCorrs8LEv4;
% WVnegCorrs16LEv4 = (squeeze(WVV4LE.stimCorrs(3,:)) < 0) & WVsigCorrs16LEv4;

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
XTmonoInc4LE = (sum(XTposCorrs4LE & XTmaxAmp4LE>=5))/XTnumGoodLEv4;
XTmonoInc8LE = (sum(XTposCorrs8LE & XTmaxAmp8LE>=5))/XTnumGoodLEv4;
XTmonoInc16LE = (sum(XTposCorrs16LE & XTmaxAmp16LE>=5))/XTnumGoodLEv4;

XTmonoDec4LE = (sum(XTnegCorrs4LE & XTmaxAmp4LE == 1))/XTnumGoodLEv4;
XTmonoDec8LE = (sum(XTnegCorrs8LE & XTmaxAmp8LE == 1))/XTnumGoodLEv4;
XTmonoDec16LE = (sum(XTnegCorrs16LE & XTmaxAmp16LE == 1))/XTnumGoodLEv4;

WUmonoInc4LE = (sum(WUposCorrs4LE & WUmaxAmp4LE>=5))/WUnumGoodLE;
WUmonoInc8LE = (sum(WUposCorrs8LE & WUmaxAmp8LE>=5))/WUnumGoodLE;
WUmonoInc16LE = (sum(WUposCorrs16LE & WUmaxAmp16LE>=5))/WUnumGoodLE;

WUmonoDec4LE = (sum(WUnegCorrs4LE & WUmaxAmp4LE == 1))/WUnumGoodLE;
WUmonoDec8LE = (sum(WUnegCorrs8LE & WUmaxAmp8LE == 1))/WUnumGoodLE;
WUmonoDec16LE = (sum(WUnegCorrs16LE & WUmaxAmp16LE == 1))/WUnumGoodLE;

WVmonoInc4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE>=5))/WVnumGoodLE;
WVmonoInc8LE = (sum(WVposCorrs8LE & WVmaxAmp8LE>=5))/WVnumGoodLE;
WVmonoInc16LE = (sum(WVposCorrs16LE & WVmaxAmp16LE>=5))/WVnumGoodLE;

WVmonoDec4LE = (sum(WVnegCorrs4LE & WVmaxAmp4LE == 1))/WVnumGoodLE;
WVmonoDec8LE = (sum(WVnegCorrs8LE & WVmaxAmp8LE == 1))/WVnumGoodLE;
WVmonoDec16LE = (sum(WVnegCorrs16LE & WVmaxAmp16LE == 1))/WVnumGoodLE;

% WVmonoSat4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE == 5))/WVnumGoodLE;
% WVmonoSat8LE = (sum(WVposCorrs8LE & WVmaxAmp4LE == 5))/WVnumGoodLE;
% WVmonoSat16LE = (sum(WVposCorrs16LE & WVmaxAmp4LE == 5))/WVnumGoodLE;

%% RE

XTmonoInc4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE>=5))/XTnumGoodREv4;
XTmonoInc8RE = (sum(XTposCorrs8RE & XTmaxAmp8RE>=5))/XTnumGoodREv4;
XTmonoInc16RE = (sum(XTposCorrs16RE & XTmaxAmp16RE>=5))/XTnumGoodREv4;

XTmonoDec4RE = (sum(XTnegCorrs4RE & XTmaxAmp4RE == 1))/XTnumGoodREv4;
XTmonoDec8RE = (sum(XTnegCorrs8RE & XTmaxAmp8RE == 1))/XTnumGoodREv4;
XTmonoDec16RE = (sum(XTnegCorrs16RE & XTmaxAmp16RE == 1))/XTnumGoodREv4;

% XTmonoSat4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE == 5))/XTnumGoodRE;
% XTmonoSat8RE = (sum(XTposCorrs8RE & XTmaxAmp4RE == 5))/XTnumGoodRE;
% XTmonoSat16RE = (sum(XTposCorrs16RE & XTmaxAmp4RE == 5))/XTnumGoodRE;


WUmonoInc4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE>=5))/WUnumGoodRE;
WUmonoInc8RE = (sum(WUposCorrs8RE & WUmaxAmp8RE>=5))/WUnumGoodRE;
WUmonoInc16RE = (sum(WUposCorrs16RE & WUmaxAmp16RE>=5))/WUnumGoodRE;

WUmonoDec4RE = (sum(WUnegCorrs4RE & WUmaxAmp4RE == 1))/WUnumGoodRE;
WUmonoDec8RE = (sum(WUnegCorrs8RE & WUmaxAmp8RE == 1))/WUnumGoodRE;
WUmonoDec16RE = (sum(WUnegCorrs16RE & WUmaxAmp16RE == 1))/WUnumGoodRE;

% WUmonoSat4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE == 5))/WUnumGoodRE;
% WUmonoSat8RE = (sum(WUposCorrs8RE & WUmaxAmp4RE == 5))/WUnumGoodRE;
% WUmonoSat16RE = (sum(WUposCorrs16RE & WUmaxAmp4RE == 5))/WUnumGoodRE;

WVmonoInc4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE>=5))/WVnumGoodRE;
WVmonoInc8RE = (sum(WVposCorrs8RE & WVmaxAmp8RE>=5))/WVnumGoodRE;
WVmonoInc16RE = (sum(WVposCorrs16RE & WVmaxAmp16RE>=5))/WVnumGoodRE;

WVmonoDec4RE = (sum(WVnegCorrs4RE & WVmaxAmp4RE == 1))/WVnumGoodRE;
WVmonoDec8RE = (sum(WVnegCorrs8RE & WVmaxAmp8RE == 1))/WVnumGoodRE;
WVmonoDec16RE = (sum(WVnegCorrs16RE & WVmaxAmp16RE == 1))/WVnumGoodRE;

% WVmonoSat4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
% WVmonoSat8RE = (sum(WVposCorrs8RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
% WVmonoSat16RE = (sum(WVposCorrs16RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
%% plot the things!

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2),750, 450],'PaperSize',[7.5 10])
%%
subplot(2,4,3)
hold on

LEv4 = [XTmonoInc4LE WUmonoInc4LE WVmonoInc4LE;...
   XTmonoInc8LE WUmonoInc8LE WVmonoInc8LE;...
   XTmonoInc16LE WUmonoInc16LE WVmonoInc16LE];

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

REamp = [XTmonoInc4RE WUmonoInc4RE WVmonoInc4RE;...
   XTmonoInc8RE WUmonoInc8RE WVmonoInc8RE;...
   XTmonoInc16RE WUmonoInc16RE WVmonoInc16RE];

bar(REamp,1)

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

LEv4Circ = [XTmonoDec4LE WUmonoDec4LE WVmonoDec4LE;...
   XTmonoDec8LE WUmonoDec8LE WVmonoDec8LE;...
   XTmonoDec16LE WUmonoDec16LE WVmonoDec16LE];

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

REv4Circ = [XTmonoDec4RE WUmonoDec4RE WVmonoDec4RE;...
   XTmonoDec8RE WUmonoDec8RE WVmonoDec8RE;...
   XTmonoDec16RE WUmonoDec16RE WVmonoDec16RE];

bar(REv4Circ,1)

ylim([0 0.1])
%xlim([0.25 3.75])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);
%% V1

% XT
XTsigCorrs4LEv4  = (XTV1LE.stimCorrSig(1,:)==1);
XTsigCorrs8LEv4  = (XTV1LE.stimCorrSig(2,:)==1);
XTsigCorrs16LE = (XTV1LE.stimCorrSig(3,:)==1);

XTposCorrs4LEv4  = (squeeze(XTV1LE.stimCorrs(1,:)) > 0) & XTsigCorrs4LE;
XTposCorrs8LEv4  = (squeeze(XTV1LE.stimCorrs(2,:)) > 0) & XTsigCorrs8LE;
XTposCorrs16LE = (squeeze(XTV1LE.stimCorrs(3,:)) > 0) & XTsigCorrs16LE;

XTnegCorrs4LEv4  = (squeeze(XTV1LE.stimCorrs(1,:)) < 0) & XTsigCorrs4LE;
XTnegCorrs8LEv4  = (squeeze(XTV1LE.stimCorrs(2,:)) < 0) & XTsigCorrs8LE;
XTnegCorrs16LE = (squeeze(XTV1LE.stimCorrs(3,:)) < 0) & XTsigCorrs16LE;

[~, XTmaxAmp4LE] = max((squeeze(XTV1LE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8LE] = max((squeeze(XTV1LE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16LE] = max((squeeze(XTV1LE.stimCircDprime(3,:,:))));

XTnumGoodLEv4 = sum(XTV1LE.goodCh);


XTsigCorrs4RE  = (XTV1RE.stimCorrSig(1,:)==1);
XTsigCorrs8RE  = (XTV1RE.stimCorrSig(2,:)==1);
XTsigCorrs16RE = (XTV1RE.stimCorrSig(3,:)==1);

XTposCorrs4RE  = (squeeze(XTV1RE.stimCorrs(1,:)) > 0) & XTsigCorrs4RE;
XTposCorrs8RE  = (squeeze(XTV1RE.stimCorrs(2,:)) > 0) & XTsigCorrs8RE;
XTposCorrs16RE = (squeeze(XTV1RE.stimCorrs(3,:)) > 0) & XTsigCorrs16RE;

XTnegCorrs4RE  = (squeeze(XTV1RE.stimCorrs(1,:)) < 0) & XTsigCorrs4RE;
XTnegCorrs8RE  = (squeeze(XTV1RE.stimCorrs(2,:)) < 0) & XTsigCorrs8RE;
XTnegCorrs16RE = (squeeze(XTV1RE.stimCorrs(3,:)) < 0) & XTsigCorrs16RE;

[~, XTmaxAmp4RE] = max((squeeze(XTV1RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8RE] = max((squeeze(XTV1RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16RE] = max((squeeze(XTV1RE.stimCircDprime(3,:,:))));

XTnumGoodREv4 = sum(XTV1RE.goodCh);

% WU

WUsigCorrs4LEv4  = (WUV1LE.stimCorrSig(1,:)==1);
WUsigCorrs8LEv4  = (WUV1LE.stimCorrSig(2,:)==1);
WUsigCorrs16LE = (WUV1LE.stimCorrSig(3,:)==1);

WUposCorrs4LEv4  = (squeeze(WUV1LE.stimCorrs(1,:)) > 0) & WUsigCorrs4LE;
WUposCorrs8LEv4  = (squeeze(WUV1LE.stimCorrs(2,:)) > 0) & WUsigCorrs8LE;
WUposCorrs16LE = (squeeze(WUV1LE.stimCorrs(3,:)) > 0) & WUsigCorrs16LE;

WUnegCorrs4LEv4  = (squeeze(WUV1LE.stimCorrs(1,:)) < 0) & WUsigCorrs4LE;
WUnegCorrs8LEv4  = (squeeze(WUV1LE.stimCorrs(2,:)) < 0) & WUsigCorrs8LE;
WUnegCorrs16LE = (squeeze(WUV1LE.stimCorrs(3,:)) < 0) & WUsigCorrs16LE;

[~, WUmaxAmp4LE] = max((squeeze(WUV1LE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8LE] = max((squeeze(WUV1LE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16LE] = max((squeeze(WUV1LE.stimCircDprime(3,:,:))));

WUnumGoodLE = sum(WUV1LE.goodCh);

WUsigCorrs4REv4  = (WUV1RE.stimCorrSig(1,:)==1);
WUsigCorrs8RE  = (WUV1RE.stimCorrSig(2,:)==1);
WUsigCorrs16RE = (WUV1RE.stimCorrSig(3,:)==1);

WUposCorrs4RE  = (squeeze(WUV1RE.stimCorrs(1,:)) > 0) & WUsigCorrs4REv4;
WUposCorrs8RE  = (squeeze(WUV1RE.stimCorrs(2,:)) > 0) & WUsigCorrs8RE;
WUposCorrs16RE = (squeeze(WUV1RE.stimCorrs(3,:)) > 0) & WUsigCorrs16RE;

WUnegCorrs4RE  = (squeeze(WUV1RE.stimCorrs(1,:)) < 0) & WUsigCorrs4REv4;
WUnegCorrs8RE  = (squeeze(WUV1RE.stimCorrs(2,:)) < 0) & WUsigCorrs8RE;
WUnegCorrs16RE = (squeeze(WUV1RE.stimCorrs(3,:)) < 0) & WUsigCorrs16RE;

[~, WUmaxAmp4RE] = max((squeeze(WUV1RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8RE] = max((squeeze(WUV1RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16RE] = max((squeeze(WUV1RE.stimCircDprime(3,:,:))));

WUnumGoodRE = sum(WUV1RE.goodCh);

% WV
WVsigCorrs4LEv4  = (WVV1LE.stimCorrSig(1,:)==1);
WVsigCorrs8LEv4  = (WVV1LE.stimCorrSig(2,:)==1);
WVsigCorrs16LE = (WVV1LE.stimCorrSig(3,:)==1);

WVposCorrs4LEv4  = (squeeze(WVV1LE.stimCorrs(1,:)) > 0) & WVsigCorrs4LE;
WVposCorrs8LEv4  = (squeeze(WVV1LE.stimCorrs(2,:)) > 0) & WVsigCorrs8LE;
WVposCorrs16LE = (squeeze(WVV1LE.stimCorrs(3,:)) > 0) & WVsigCorrs16LE;

WVnegCorrs4LEv4  = (squeeze(WVV1LE.stimCorrs(1,:)) < 0) & WVsigCorrs4LE;
WVnegCorrs8LEv1  = (squeeze(WVV1LE.stimCorrs(2,:)) < 0) & WVsigCorrs8LE;
WVnegCorrs16LE = (squeeze(WVV1LE.stimCorrs(3,:)) < 0) & WVsigCorrs16LE;

[~, WVmaxAmp4LE] = max((squeeze(WVV1LE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8LE] = max((squeeze(WVV1LE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16LE] = max((squeeze(WVV1LE.stimCircDprime(3,:,:))));

WVnumGoodLE = sum(WVV1LE.goodCh);

WVsigCorrs4RE  = (WVV1RE.stimCorrSig(1,:)==1);
WVsigCorrs8RE  = (WVV1RE.stimCorrSig(2,:)==1);
WVsigCorrs16RE = (WVV1RE.stimCorrSig(3,:)==1);

WVposCorrs4RE  = (squeeze(WVV1RE.stimCorrs(1,:)) > 0) & WVsigCorrs4RE;
WVposCorrs8RE  = (squeeze(WVV1RE.stimCorrs(2,:)) > 0) & WVsigCorrs8RE;
WVposCorrs16RE = (squeeze(WVV1RE.stimCorrs(3,:)) > 0) & WVsigCorrs16RE;

WVnegCorrs4RE  = (squeeze(WVV1RE.stimCorrs(1,:)) < 0) & WVsigCorrs4RE;
WVnegCorrs8RE  = (squeeze(WVV1RE.stimCorrs(2,:)) < 0) & WVsigCorrs8RE;
WVnegCorrs16RE = (squeeze(WVV1RE.stimCorrs(3,:)) < 0) & WVsigCorrs16RE;

[~, WVmaxAmp4RE] = max((squeeze(WVV1RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8RE] = max((squeeze(WVV1RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16RE] = max((squeeze(WVV1RE.stimCircDprime(3,:,:))));

WVnumGoodRE = sum(WVV1RE.goodCh);
%%
XTmonoInc4LE = (sum(XTposCorrs4LE & XTmaxAmp4LE>=5))/XTnumGoodLEv4;
XTmonoInc8LE = (sum(XTposCorrs8LE & XTmaxAmp8LE>=5))/XTnumGoodLEv4;
XTmonoInc16LE = (sum(XTposCorrs16LE & XTmaxAmp16LE>=5))/XTnumGoodLEv4;

XTmonoDec4LE = (sum(XTnegCorrs4LE & XTmaxAmp4LE == 1))/XTnumGoodLEv4;
XTmonoDec8LE = (sum(XTnegCorrs8LE & XTmaxAmp8LE == 1))/XTnumGoodLEv4;
XTmonoDec16LE = (sum(XTnegCorrs16LE & XTmaxAmp16LE == 1))/XTnumGoodLEv4;

% XTmonoSat4LE = (sum(XTposCorrs4LE & XTmaxAmp4LE == 5))/XTnumGoodLE;
% XTmonoSat8LE = (sum(XTposCorrs8LE & XTmaxAmp4LE == 5))/XTnumGoodLE;
% XTmonoSat16LE = (sum(XTposCorrs16LE & XTmaxAmp4LE == 5))/XTnumGoodLE;


WUmonoInc4LE = (sum(WUposCorrs4LE & WUmaxAmp4LE>=5))/WUnumGoodLE;
WUmonoInc8LE = (sum(WUposCorrs8LE & WUmaxAmp8LE>=5))/WUnumGoodLE;
WUmonoInc16LE = (sum(WUposCorrs16LE & WUmaxAmp16LE>=5))/WUnumGoodLE;

WUmonoDec4LE = (sum(WUnegCorrs4LE & WUmaxAmp4LE == 1))/WUnumGoodLE;
WUmonoDec8LE = (sum(WUnegCorrs8LE & WUmaxAmp8LE == 1))/WUnumGoodLE;
WUmonoDec16LE = (sum(WUnegCorrs16LE & WUmaxAmp16LE == 1))/WUnumGoodLE;

% WUmonoSat4LE = (sum(WUposCorrs4LE & WUmaxAmp4LE == 5))/WUnumGoodLE;
% WUmonoSat8LE = (sum(WUposCorrs8LE & WUmaxAmp4LE == 5))/WUnumGoodLE;
% WUmonoSat16LE = (sum(WUposCorrs16LE & WUmaxAmp4LE == 5))/WUnumGoodLE;

WVmonoInc4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE>=5))/WVnumGoodLE;
WVmonoInc8LE = (sum(WVposCorrs8LE & WVmaxAmp8LE>=5))/WVnumGoodLE;
WVmonoInc16LE = (sum(WVposCorrs16LE & WVmaxAmp16LE>=5))/WVnumGoodLE;

WVmonoDec4LE = (sum(WVnegCorrs4LE & WVmaxAmp4LE == 1))/WVnumGoodLE;
WVmonoDec8LE = (sum(WVnegCorrs8LE & WVmaxAmp8LE == 1))/WVnumGoodLE;
WVmonoDec16LE = (sum(WVnegCorrs16LE & WVmaxAmp16LE == 1))/WVnumGoodLE;

% WVmonoSat4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE == 5))/WVnumGoodLE;
% WVmonoSat8LE = (sum(WVposCorrs8LE & WVmaxAmp4LE == 5))/WVnumGoodLE;
% WVmonoSat16LE = (sum(WVposCorrs16LE & WVmaxAmp4LE == 5))/WVnumGoodLE;

%% RE

XTmonoInc4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE>=5))/XTnumGoodREv4;
XTmonoInc8RE = (sum(XTposCorrs8RE & XTmaxAmp8RE>=5))/XTnumGoodREv4;
XTmonoInc16RE = (sum(XTposCorrs16RE & XTmaxAmp16RE>=5))/XTnumGoodREv4;

XTmonoDec4RE = (sum(XTnegCorrs4RE & XTmaxAmp4RE == 1))/XTnumGoodREv4;
XTmonoDec8RE = (sum(XTnegCorrs8RE & XTmaxAmp8RE == 1))/XTnumGoodREv4;
XTmonoDec16RE = (sum(XTnegCorrs16RE & XTmaxAmp16RE == 1))/XTnumGoodREv4;

% XTmonoSat4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE == 5))/XTnumGoodRE;
% XTmonoSat8RE = (sum(XTposCorrs8RE & XTmaxAmp4RE == 5))/XTnumGoodRE;
% XTmonoSat16RE = (sum(XTposCorrs16RE & XTmaxAmp4RE == 5))/XTnumGoodRE;


WUmonoInc4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE>=5))/WUnumGoodRE;
WUmonoInc8RE = (sum(WUposCorrs8RE & WUmaxAmp8RE>=5))/WUnumGoodRE;
WUmonoInc16RE = (sum(WUposCorrs16RE & WUmaxAmp16RE>=5))/WUnumGoodRE;

WUmonoDec4RE = (sum(WUnegCorrs4RE & WUmaxAmp4RE == 1))/WUnumGoodRE;
WUmonoDec8RE = (sum(WUnegCorrs8RE & WUmaxAmp8RE == 1))/WUnumGoodRE;
WUmonoDec16RE = (sum(WUnegCorrs16RE & WUmaxAmp16RE == 1))/WUnumGoodRE;

% WUmonoSat4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE == 5))/WUnumGoodRE;
% WUmonoSat8RE = (sum(WUposCorrs8RE & WUmaxAmp4RE == 5))/WUnumGoodRE;
% WUmonoSat16RE = (sum(WUposCorrs16RE & WUmaxAmp4RE == 5))/WUnumGoodRE;

WVmonoInc4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE>=5))/WVnumGoodRE;
WVmonoInc8RE = (sum(WVposCorrs8RE & WVmaxAmp8RE>=5))/WVnumGoodRE;
WVmonoInc16RE = (sum(WVposCorrs16RE & WVmaxAmp16RE>=5))/WVnumGoodRE;

WVmonoDec4RE = (sum(WVnegCorrs4RE & WVmaxAmp4RE == 1))/WVnumGoodRE;
WVmonoDec8RE = (sum(WVnegCorrs8RE & WVmaxAmp8RE == 1))/WVnumGoodRE;
WVmonoDec16RE = (sum(WVnegCorrs16RE & WVmaxAmp16RE == 1))/WVnumGoodRE;

% WVmonoSat4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
% WVmonoSat8RE = (sum(WVposCorrs8RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
% WVmonoSat16RE = (sum(WVposCorrs16RE & WVmaxAmp4RE == 5))/WVnumGoodRE;
%% plot the things!

subplot(2,4,1)
hold on

LEv1 = [XTmonoInc4LE WUmonoInc4LE WVmonoInc4LE;...
   XTmonoInc8LE WUmonoInc8LE WVmonoInc8LE;...
   XTmonoInc16LE WUmonoInc16LE WVmonoInc16LE];

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

LEv1 = [XTmonoInc4RE WUmonoInc4RE WVmonoInc4RE;...
   XTmonoInc8RE WUmonoInc8RE WVmonoInc8RE;...
   XTmonoInc16RE WUmonoInc16RE WVmonoInc16RE];

bar(LEv1,1)

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

LEv1Circ = [XTmonoDec4LE WUmonoDec4LE WVmonoDec4LE;...
   XTmonoDec8LE WUmonoDec8LE WVmonoDec8LE;...
   XTmonoDec16LE WUmonoDec16LE WVmonoDec16LE];

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

LEv1Circ = [XTmonoDec4RE WUmonoDec4RE WVmonoDec4RE;...
   XTmonoDec8RE WUmonoDec8RE WVmonoDec8RE;...
   XTmonoDec16RE WUmonoDec16RE WVmonoDec16RE];

bar(LEv4,1)

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
