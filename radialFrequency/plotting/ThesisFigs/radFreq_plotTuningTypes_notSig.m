function radFreq_plotTuningTypes_notSig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)
% XT

XTposCorrs4LE  = (squeeze(XTV4LE.stimCorrs(1,:)) > 0);
XTposCorrs8LE  = (squeeze(XTV4LE.stimCorrs(2,:)) > 0);
XTposCorrs16LE = (squeeze(XTV4LE.stimCorrs(3,:)) > 0);

XTnegCorrs4LE  = (squeeze(XTV4LE.stimCorrs(1,:)) < 0);
XTnegCorrs8LE  = (squeeze(XTV4LE.stimCorrs(2,:)) < 0);
XTnegCorrs16LE = (squeeze(XTV4LE.stimCorrs(3,:)) < 0);

[~, XTmaxAmp4LE] = max(abs(squeeze(XTV4LE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8LE] = max(abs(squeeze(XTV4LE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16LE] = max(abs(squeeze(XTV4LE.stimCircDprime(3,:,:))));

XTnumGoodLE = sum(XTV4LE.goodCh);

XTposCorrs4RE  = (squeeze(XTV4RE.stimCorrs(1,:)) > 0);
XTposCorrs8RE  = (squeeze(XTV4RE.stimCorrs(2,:)) > 0);
XTposCorrs16RE = (squeeze(XTV4RE.stimCorrs(3,:)) > 0);

XTnegCorrs4RE  = (squeeze(XTV4RE.stimCorrs(1,:)) < 0);
XTnegCorrs8RE  = (squeeze(XTV4RE.stimCorrs(2,:)) < 0);
XTnegCorrs16RE = (squeeze(XTV4RE.stimCorrs(3,:)) < 0);

[~, XTmaxAmp4RE] = max(abs(squeeze(XTV4RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8RE] = max(abs(squeeze(XTV4RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16RE] = max(abs(squeeze(XTV4RE.stimCircDprime(3,:,:))));

XTnumGoodRE = sum(XTV4RE.goodCh);

% WU

WUposCorrs4LE  = (squeeze(WUV4LE.stimCorrs(1,:)) > 0);
WUposCorrs8LE  = (squeeze(WUV4LE.stimCorrs(2,:)) > 0);
WUposCorrs16LE = (squeeze(WUV4LE.stimCorrs(3,:)) > 0);

WUnegCorrs4LE  = (squeeze(WUV4LE.stimCorrs(1,:)) < 0);
WUnegCorrs8LE  = (squeeze(WUV4LE.stimCorrs(2,:)) < 0);
WUnegCorrs16LE = (squeeze(WUV4LE.stimCorrs(3,:)) < 0);

[~, WUmaxAmp4LE] = max(abs(squeeze(WUV4LE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8LE] = max(abs(squeeze(WUV4LE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16LE] = max(abs(squeeze(WUV4LE.stimCircDprime(3,:,:))));

WUnumGoodLE = sum(WUV4LE.goodCh);

WUposCorrs4RE  = (squeeze(WUV4RE.stimCorrs(1,:)) > 0);
WUposCorrs8RE  = (squeeze(WUV4RE.stimCorrs(2,:)) > 0);
WUposCorrs16RE = (squeeze(WUV4RE.stimCorrs(3,:)) > 0);

WUnegCorrs4RE  = (squeeze(WUV4RE.stimCorrs(1,:)) < 0);
WUnegCorrs8RE  = (squeeze(WUV4RE.stimCorrs(2,:)) < 0);
WUnegCorrs16RE = (squeeze(WUV4RE.stimCorrs(3,:)) < 0);

[~, WUmaxAmp4RE] = max(abs(squeeze(WUV4RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8RE] = max(abs(squeeze(WUV4RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16RE] = max(abs(squeeze(WUV4RE.stimCircDprime(3,:,:))));

WUnumGoodRE = sum(WUV4RE.goodCh);

% WV
WVposCorrs4LE  = (squeeze(WVV4LE.stimCorrs(1,:)) > 0);
WVposCorrs8LE  = (squeeze(WVV4LE.stimCorrs(2,:)) > 0);
WVposCorrs16LE = (squeeze(WVV4LE.stimCorrs(3,:)) > 0);

WVnegCorrs4LE  = (squeeze(WVV4LE.stimCorrs(1,:)) < 0);
WVnegCorrs8LE  = (squeeze(WVV4LE.stimCorrs(2,:)) < 0);
WVnegCorrs16LE = (squeeze(WVV4LE.stimCorrs(3,:)) < 0);

[~, WVmaxAmp4LE] = max(abs(squeeze(WVV4LE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8LE] = max(abs(squeeze(WVV4LE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16LE] = max(abs(squeeze(WVV4LE.stimCircDprime(3,:,:))));

WVnumGoodLE = sum(WVV4LE.goodCh);

WVposCorrs4RE  = (squeeze(WVV4RE.stimCorrs(1,:)) > 0);
WVposCorrs8RE  = (squeeze(WVV4RE.stimCorrs(2,:)) > 0);
WVposCorrs16RE = (squeeze(WVV4RE.stimCorrs(3,:)) > 0);

WVnegCorrs4RE  = (squeeze(WVV4RE.stimCorrs(1,:)) < 0);
WVnegCorrs8RE  = (squeeze(WVV4RE.stimCorrs(2,:)) < 0);
WVnegCorrs16RE = (squeeze(WVV4RE.stimCorrs(3,:)) < 0);

[~, WVmaxAmp4RE] = max(abs(squeeze(WVV4RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8RE] = max(abs(squeeze(WVV4RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16RE] = max(abs(squeeze(WVV4RE.stimCircDprime(3,:,:))));

WVnumGoodRE = sum(WVV4RE.goodCh);
%%
XTmonoInc4LE = (sum(XTposCorrs4LE & XTmaxAmp4LE == 6))/XTnumGoodLE;
XTmonoInc8LE = (sum(XTposCorrs8LE & XTmaxAmp8LE == 6))/XTnumGoodLE;
XTmonoInc16LE = (sum(XTposCorrs16LE & XTmaxAmp16LE == 6))/XTnumGoodLE;

XTmonoDec4LE = (sum(XTnegCorrs4LE & XTmaxAmp4LE == 1))/XTnumGoodLE;
XTmonoDec8LE = (sum(XTnegCorrs8LE & XTmaxAmp8LE == 1))/XTnumGoodLE;
XTmonoDec16LE = (sum(XTnegCorrs16LE & XTmaxAmp16LE == 1))/XTnumGoodLE;


WUmonoInc4LE = (sum(WUposCorrs4LE & WUmaxAmp4LE == 6))/WUnumGoodLE;
WUmonoInc8LE = (sum(WUposCorrs8LE & WUmaxAmp8LE == 6))/WUnumGoodLE;
WUmonoInc16LE = (sum(WUposCorrs16LE & WUmaxAmp16LE == 6))/WUnumGoodLE;

WUmonoDec4LE = (sum(WUnegCorrs4LE & WUmaxAmp4LE == 1))/WUnumGoodLE;
WUmonoDec8LE = (sum(WUnegCorrs8LE & WUmaxAmp8LE == 1))/WUnumGoodLE;
WUmonoDec16LE = (sum(WUnegCorrs16LE & WUmaxAmp16LE == 1))/WUnumGoodLE;


WVmonoInc4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE == 6))/WVnumGoodLE;
WVmonoInc8LE = (sum(WVposCorrs8LE & WVmaxAmp8LE == 6))/WVnumGoodLE;
WVmonoInc16LE = (sum(WVposCorrs16LE & WVmaxAmp16LE == 6))/WVnumGoodLE;

WVmonoDec4LE = (sum(WVnegCorrs4LE & WVmaxAmp4LE == 1))/WVnumGoodLE;
WVmonoDec8LE = (sum(WVnegCorrs8LE & WVmaxAmp8LE == 1))/WVnumGoodLE;
WVmonoDec16LE = (sum(WVnegCorrs16LE & WVmaxAmp16LE == 1))/WVnumGoodLE;

%% RE

XTmonoInc4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE == 6))/XTnumGoodRE;
XTmonoInc8RE = (sum(XTposCorrs8RE & XTmaxAmp8RE == 6))/XTnumGoodRE;
XTmonoInc16RE = (sum(XTposCorrs16RE & XTmaxAmp16RE == 6))/XTnumGoodRE;

XTmonoDec4RE = (sum(XTnegCorrs4RE & XTmaxAmp4RE == 1))/XTnumGoodRE;
XTmonoDec8RE = (sum(XTnegCorrs8RE & XTmaxAmp8RE == 1))/XTnumGoodRE;
XTmonoDec16RE = (sum(XTnegCorrs16RE & XTmaxAmp16RE == 1))/XTnumGoodRE;

WUmonoInc4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE == 6))/WUnumGoodRE;
WUmonoInc8RE = (sum(WUposCorrs8RE & WUmaxAmp8RE == 6))/WUnumGoodRE;
WUmonoInc16RE = (sum(WUposCorrs16RE & WUmaxAmp16RE == 6))/WUnumGoodRE;

WUmonoDec4RE = (sum(WUnegCorrs4RE & WUmaxAmp4RE == 1))/WUnumGoodRE;
WUmonoDec8RE = (sum(WUnegCorrs8RE & WUmaxAmp8RE == 1))/WUnumGoodRE;
WUmonoDec16RE = (sum(WUnegCorrs16RE & WUmaxAmp16RE == 1))/WUnumGoodRE;

WVmonoInc4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE == 6))/WVnumGoodRE;
WVmonoInc8RE = (sum(WVposCorrs8RE & WVmaxAmp8RE == 6))/WVnumGoodRE;
WVmonoInc16RE = (sum(WVposCorrs16RE & WVmaxAmp16RE == 6))/WVnumGoodRE;

WVmonoDec4RE = (sum(WVnegCorrs4RE & WVmaxAmp4RE == 1))/WVnumGoodRE;
WVmonoDec8RE = (sum(WVnegCorrs8RE & WVmaxAmp8RE == 1))/WVnumGoodRE;
WVmonoDec16RE = (sum(WVnegCorrs16RE & WVmaxAmp16RE == 1))/WVnumGoodRE;
%% plot the things!

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2),750, 450],'PaperSize',[7.5 10])
%%
subplot(2,4,3)
hold on

rf = [XTmonoInc4LE WUmonoInc4LE WVmonoInc4LE;...
   XTmonoInc8LE WUmonoInc8LE WVmonoInc8LE;...
   XTmonoInc16LE WUmonoInc16LE WVmonoInc16LE];

bar(rf,1)

title('LE/FE')
text(4,1.5,'V4','FontSize',12)
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,4)
hold on

rf = [XTmonoInc4RE WUmonoInc4RE WVmonoInc4RE;...
   XTmonoInc8RE WUmonoInc8RE WVmonoInc8RE;...
   XTmonoInc16RE WUmonoInc16RE WVmonoInc16RE];

bar(rf,1)

title('RE/AE')
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

% circle preferring channels

subplot(2,4,7)
hold on

rf = [XTmonoDec4LE WUmonoDec4LE WVmonoDec4LE;...
   XTmonoDec8LE WUmonoDec8LE WVmonoDec8LE;...
   XTmonoDec16LE WUmonoDec16LE WVmonoDec16LE];

bar(rf,1)

ylim([0 0.1])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,8)
hold on

rf = [XTmonoDec4RE WUmonoDec4RE WVmonoDec4RE;...
   XTmonoDec8RE WUmonoDec8RE WVmonoDec8RE;...
   XTmonoDec16RE WUmonoDec16RE WVmonoDec16RE];

bar(rf,1)

ylim([0 0.1])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);
%% V1

% XT

XTposCorrs4LE  = (squeeze(XTV1LE.stimCorrs(1,:)) > 0);
XTposCorrs8LE  = (squeeze(XTV1LE.stimCorrs(2,:)) > 0);
XTposCorrs16LE = (squeeze(XTV1LE.stimCorrs(3,:)) > 0);

XTnegCorrs4LE  = (squeeze(XTV1LE.stimCorrs(1,:)) < 0);
XTnegCorrs8LE  = (squeeze(XTV1LE.stimCorrs(2,:)) < 0);
XTnegCorrs16LE = (squeeze(XTV1LE.stimCorrs(3,:)) < 0);

[~, XTmaxAmp4LE] = max(abs(squeeze(XTV1LE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8LE] = max(abs(squeeze(XTV1LE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16LE] = max(abs(squeeze(XTV1LE.stimCircDprime(3,:,:))));

XTnumGoodLE = sum(XTV1LE.goodCh);

XTposCorrs4RE  = (squeeze(XTV1RE.stimCorrs(1,:)) > 0);
XTposCorrs8RE  = (squeeze(XTV1RE.stimCorrs(2,:)) > 0);
XTposCorrs16RE = (squeeze(XTV1RE.stimCorrs(3,:)) > 0);

XTnegCorrs4RE  = (squeeze(XTV1RE.stimCorrs(1,:)) < 0);
XTnegCorrs8RE  = (squeeze(XTV1RE.stimCorrs(2,:)) < 0);
XTnegCorrs16RE = (squeeze(XTV1RE.stimCorrs(3,:)) < 0);

[~, XTmaxAmp4RE] = max(abs(squeeze(XTV1RE.stimCircDprime(1,:,:))));
[~, XTmaxAmp8RE] = max(abs(squeeze(XTV1RE.stimCircDprime(2,:,:))));
[~, XTmaxAmp16RE] = max(abs(squeeze(XTV1RE.stimCircDprime(3,:,:))));

XTnumGoodRE = sum(XTV1RE.goodCh);

% WU

WUposCorrs4LE  = (squeeze(WUV1LE.stimCorrs(1,:)) > 0);
WUposCorrs8LE  = (squeeze(WUV1LE.stimCorrs(2,:)) > 0);
WUposCorrs16LE = (squeeze(WUV1LE.stimCorrs(3,:)) > 0);

WUnegCorrs4LE  = (squeeze(WUV1LE.stimCorrs(1,:)) < 0);
WUnegCorrs8LE  = (squeeze(WUV1LE.stimCorrs(2,:)) < 0);
WUnegCorrs16LE = (squeeze(WUV1LE.stimCorrs(3,:)) < 0);

[~, WUmaxAmp4LE] = max(abs(squeeze(WUV1LE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8LE] = max(abs(squeeze(WUV1LE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16LE] = max(abs(squeeze(WUV1LE.stimCircDprime(3,:,:))));

WUnumGoodLE = sum(WUV1LE.goodCh);

WUposCorrs4RE  = (squeeze(WUV1RE.stimCorrs(1,:)) > 0);
WUposCorrs8RE  = (squeeze(WUV1RE.stimCorrs(2,:)) > 0);
WUposCorrs16RE = (squeeze(WUV1RE.stimCorrs(3,:)) > 0);

WUnegCorrs4RE  = (squeeze(WUV1RE.stimCorrs(1,:)) < 0);
WUnegCorrs8RE  = (squeeze(WUV1RE.stimCorrs(2,:)) < 0);
WUnegCorrs16RE = (squeeze(WUV1RE.stimCorrs(3,:)) < 0);

[~, WUmaxAmp4RE] = max(abs(squeeze(WUV1RE.stimCircDprime(1,:,:))));
[~, WUmaxAmp8RE] = max(abs(squeeze(WUV1RE.stimCircDprime(2,:,:))));
[~, WUmaxAmp16RE] = max(abs(squeeze(WUV1RE.stimCircDprime(3,:,:))));

WUnumGoodRE = sum(WUV1RE.goodCh);

% WV

WVposCorrs4LE  = (squeeze(WVV1LE.stimCorrs(1,:)) > 0);
WVposCorrs8LE  = (squeeze(WVV1LE.stimCorrs(2,:)) > 0);
WVposCorrs16LE = (squeeze(WVV1LE.stimCorrs(3,:)) > 0);

WVnegCorrs4LE  = (squeeze(WVV1LE.stimCorrs(1,:)) < 0);
WVnegCorrs8LE  = (squeeze(WVV1LE.stimCorrs(2,:)) < 0);
WVnegCorrs16LE = (squeeze(WVV1LE.stimCorrs(3,:)) < 0);

[~, WVmaxAmp4LE] = max(abs(squeeze(WVV1LE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8LE] = max(abs(squeeze(WVV1LE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16LE] = max(abs(squeeze(WVV1LE.stimCircDprime(3,:,:))));

WVnumGoodLE = sum(WVV1LE.goodCh);

WVposCorrs4RE  = (squeeze(WVV1RE.stimCorrs(1,:)) > 0);
WVposCorrs8RE  = (squeeze(WVV1RE.stimCorrs(2,:)) > 0);
WVposCorrs16RE = (squeeze(WVV1RE.stimCorrs(3,:)) > 0);

WVnegCorrs4RE  = (squeeze(WVV1RE.stimCorrs(1,:)) < 0);
WVnegCorrs8RE  = (squeeze(WVV1RE.stimCorrs(2,:)) < 0);
WVnegCorrs16RE = (squeeze(WVV1RE.stimCorrs(3,:)) < 0);

[~, WVmaxAmp4RE] = max(abs(squeeze(WVV1RE.stimCircDprime(1,:,:))));
[~, WVmaxAmp8RE] = max(abs(squeeze(WVV1RE.stimCircDprime(2,:,:))));
[~, WVmaxAmp16RE] = max(abs(squeeze(WVV1RE.stimCircDprime(3,:,:))));

WVnumGoodRE = sum(WVV1RE.goodCh);
%%
XTmonoInc4LE = (sum(XTposCorrs4LE & XTmaxAmp4LE == 6))/XTnumGoodLE;
XTmonoInc8LE = (sum(XTposCorrs8LE & XTmaxAmp8LE == 6))/XTnumGoodLE;
XTmonoInc16LE = (sum(XTposCorrs16LE & XTmaxAmp16LE == 6))/XTnumGoodLE;

XTmonoDec4LE = (sum(XTnegCorrs4LE & XTmaxAmp4LE == 1))/XTnumGoodLE;
XTmonoDec8LE = (sum(XTnegCorrs8LE & XTmaxAmp8LE == 1))/XTnumGoodLE;
XTmonoDec16LE = (sum(XTnegCorrs16LE & XTmaxAmp16LE == 1))/XTnumGoodLE;


WUmonoInc4LE = (sum(WUposCorrs4LE & WUmaxAmp4LE == 6))/WUnumGoodLE;
WUmonoInc8LE = (sum(WUposCorrs8LE & WUmaxAmp8LE == 6))/WUnumGoodLE;
WUmonoInc16LE = (sum(WUposCorrs16LE & WUmaxAmp16LE == 6))/WUnumGoodLE;

WUmonoDec4LE = (sum(WUnegCorrs4LE & WUmaxAmp4LE == 1))/WUnumGoodLE;
WUmonoDec8LE = (sum(WUnegCorrs8LE & WUmaxAmp8LE == 1))/WUnumGoodLE;
WUmonoDec16LE = (sum(WUnegCorrs16LE & WUmaxAmp16LE == 1))/WUnumGoodLE;

WVmonoInc4LE = (sum(WVposCorrs4LE & WVmaxAmp4LE == 6))/WVnumGoodLE;
WVmonoInc8LE = (sum(WVposCorrs8LE & WVmaxAmp8LE == 6))/WVnumGoodLE;
WVmonoInc16LE = (sum(WVposCorrs16LE & WVmaxAmp16LE == 6))/WVnumGoodLE;

WVmonoDec4LE = (sum(WVnegCorrs4LE & WVmaxAmp4LE == 1))/WVnumGoodLE;
WVmonoDec8LE = (sum(WVnegCorrs8LE & WVmaxAmp8LE == 1))/WVnumGoodLE;
WVmonoDec16LE = (sum(WVnegCorrs16LE & WVmaxAmp16LE == 1))/WVnumGoodLE;
%% RE

XTmonoInc4RE = (sum(XTposCorrs4RE & XTmaxAmp4RE == 6))/XTnumGoodRE;
XTmonoInc8RE = (sum(XTposCorrs8RE & XTmaxAmp8RE == 6))/XTnumGoodRE;
XTmonoInc16RE = (sum(XTposCorrs16RE & XTmaxAmp16RE == 6))/XTnumGoodRE;

XTmonoDec4RE = (sum(XTnegCorrs4RE & XTmaxAmp4RE == 1))/XTnumGoodRE;
XTmonoDec8RE = (sum(XTnegCorrs8RE & XTmaxAmp8RE == 1))/XTnumGoodRE;
XTmonoDec16RE = (sum(XTnegCorrs16RE & XTmaxAmp16RE == 1))/XTnumGoodRE;

WUmonoInc4RE = (sum(WUposCorrs4RE & WUmaxAmp4RE == 6))/WUnumGoodRE;
WUmonoInc8RE = (sum(WUposCorrs8RE & WUmaxAmp8RE == 6))/WUnumGoodRE;
WUmonoInc16RE = (sum(WUposCorrs16RE & WUmaxAmp16RE == 6))/WUnumGoodRE;

WUmonoDec4RE = (sum(WUnegCorrs4RE & WUmaxAmp4RE == 1))/WUnumGoodRE;
WUmonoDec8RE = (sum(WUnegCorrs8RE & WUmaxAmp8RE == 1))/WUnumGoodRE;
WUmonoDec16RE = (sum(WUnegCorrs16RE & WUmaxAmp16RE == 1))/WUnumGoodRE;

WVmonoInc4RE = (sum(WVposCorrs4RE & WVmaxAmp4RE == 6))/WVnumGoodRE;
WVmonoInc8RE = (sum(WVposCorrs8RE & WVmaxAmp8RE == 6))/WVnumGoodRE;
WVmonoInc16RE = (sum(WVposCorrs16RE & WVmaxAmp16RE == 6))/WVnumGoodRE;

WVmonoDec4RE = (sum(WVnegCorrs4RE & WVmaxAmp4RE == 1))/WVnumGoodRE;
WVmonoDec8RE = (sum(WVnegCorrs8RE & WVmaxAmp8RE == 1))/WVnumGoodRE;
WVmonoDec16RE = (sum(WVnegCorrs16RE & WVmaxAmp16RE == 1))/WVnumGoodRE;
%% plot the things!

subplot(2,4,1)
hold on

rf = [XTmonoInc4LE WUmonoInc4LE WVmonoInc4LE;...
   XTmonoInc8LE WUmonoInc8LE WVmonoInc8LE;...
   XTmonoInc16LE WUmonoInc16LE WVmonoInc16LE];

bar(rf,1)

title('LE/FE')
ylabel('% channels')
text(4,1.5,'V1','FontSize',12)
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,2)
hold on

rf = [XTmonoInc4RE WUmonoInc4RE WVmonoInc4RE;...
   XTmonoInc8RE WUmonoInc8RE WVmonoInc8RE;...
   XTmonoInc16RE WUmonoInc16RE WVmonoInc16RE];

bar(rf,1)

title('RE/AE')
ylim([0 0.8])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top','YTick',0:.2:.8)
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);

% circle preferring channels

subplot(2,4,5)
hold on

rf = [XTmonoDec4LE WUmonoDec4LE WVmonoDec4LE;...
   XTmonoDec8LE WUmonoDec8LE WVmonoDec8LE;...
   XTmonoDec16LE WUmonoDec16LE WVmonoDec16LE];

bar(rf,1)

ylim([0 0.1])

ylabel('% channels')

set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);


subplot(2,4,6)
hold on

rf = [XTmonoDec4RE WUmonoDec4RE WVmonoDec4RE;...
   XTmonoDec8RE WUmonoDec8RE WVmonoDec8RE;...
   XTmonoDec16RE WUmonoDec16RE WVmonoDec16RE];

bar(rf,1)

ylim([0 0.1])
set(gca,'tickdir','out','FontAngle','italic','fontSize',10,'XTick',1:3,'XTickLabel',{'RF4','RF8','RF16'},...
    'Layer','top')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3) + 0.015, pos(4) - 0.2]);
%%

figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/Tuning/fromMatlab';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['TuningTypesFreq_allMonk_bothArrays_inSig','.pdf'];
print(gcf, figName,'-dpdf','-bestfit','-r300');
