function plotPrefDomOriDiffVsOSI_allQuad(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4) 
%% LE
tempRad = struct2cell(WUV1.trLE.radDiff);
wuV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV1.trLE.radDiff);
wvV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV1.trLE.radDiff);
xtV1LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WUV4.trLE.radDiff);
wuV4LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV4.trLE.radDiff);
wvV4LEradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV4.trLE.radDiff);
xtV4LEradDiff = cell2mat(tempRad);

%
tempCon = struct2cell(WUV1.trLE.conDiff);
wuV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV1.trLE.conDiff);
wvV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV1.trLE.conDiff);
xtV1LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WUV4.trLE.conDiff);
wuV4LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV4.trLE.conDiff);
wvV4LEconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV4.trLE.conDiff);
xtV4LEconDiff = cell2mat(tempCon);

%% RE

tempRad = struct2cell(WUV1.trRE.radDiff);
wuV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV1.trRE.radDiff);
wvV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV1.trRE.radDiff);
xtV1REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WUV4.trRE.radDiff);
wuV4REradDiff = cell2mat(tempRad);

tempRad = struct2cell(WVV4.trRE.radDiff);
wvV4REradDiff = cell2mat(tempRad);

tempRad = struct2cell(XTV4.trRE.radDiff);
xtV4REradDiff = cell2mat(tempRad);

%
tempCon = struct2cell(WUV1.trRE.conDiff);
wuV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV1.trRE.conDiff);
wvV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV1.trRE.conDiff);
xtV1REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WUV4.trRE.conDiff);
wuV4REconDiff = cell2mat(tempCon);

tempCon = struct2cell(WVV4.trRE.conDiff);
wvV4REconDiff = cell2mat(tempCon);

tempCon = struct2cell(XTV4.trRE.conDiff);
xtV4REconDiff = cell2mat(tempCon);
%% OSIs
% this should give the OSI for channels that prefer concentric
WUV1LEconOSI= WUV1.trLE.prefParamSI(WUV1.trLE.prefPatternsPrefParams == 1 & WUV1.trLE.inStimCenter == 0 & WUV1.trLE.within2Deg == 1 & WUV1.trLE.goodCh == 1);
WUV1REconOSI= WUV1.trRE.prefParamSI(WUV1.trRE.prefPatternsPrefParams == 1 & WUV1.trRE.inStimCenter == 0 & WUV1.trRE.within2Deg == 1 & WUV1.trRE.goodCh == 1);
WUV4LEconOSI= WUV4.trLE.prefParamSI(WUV4.trLE.prefPatternsPrefParams == 1 & WUV4.trLE.inStimCenter == 0 & WUV4.trLE.within2Deg == 1 & WUV4.trLE.goodCh == 1);
WUV4REconOSI= WUV4.trRE.prefParamSI(WUV4.trRE.prefPatternsPrefParams == 1 & WUV4.trRE.inStimCenter == 0 & WUV4.trRE.within2Deg == 1 & WUV4.trRE.goodCh == 1);

WUV1LEradOSI= WUV1.trLE.prefParamSI(WUV1.trLE.prefPatternsPrefParams == 2 & WUV1.trLE.inStimCenter == 0 & WUV1.trLE.within2Deg == 1 & WUV1.trLE.goodCh == 1);
WUV1REradOSI= WUV1.trRE.prefParamSI(WUV1.trRE.prefPatternsPrefParams == 2 & WUV1.trRE.inStimCenter == 0 & WUV1.trRE.within2Deg == 1 & WUV1.trRE.goodCh == 1);
WUV4LEradOSI= WUV4.trLE.prefParamSI(WUV4.trLE.prefPatternsPrefParams == 2 & WUV4.trLE.inStimCenter == 0 & WUV4.trLE.within2Deg == 1 & WUV4.trLE.goodCh == 1);
WUV4REradOSI= WUV4.trRE.prefParamSI(WUV4.trRE.prefPatternsPrefParams == 2 & WUV4.trRE.inStimCenter == 0 & WUV4.trRE.within2Deg == 1 & WUV4.trRE.goodCh == 1);

% WV
WVV1LEconOSI= WVV1.trLE.prefParamSI(WVV1.trLE.prefPatternsPrefParams == 1 & WVV1.trLE.inStimCenter == 0 & WVV1.trLE.within2Deg == 1 & WVV1.trLE.goodCh == 1);
WVV1REconOSI= WVV1.trRE.prefParamSI(WVV1.trRE.prefPatternsPrefParams == 1 & WVV1.trRE.inStimCenter == 0 & WVV1.trRE.within2Deg == 1 & WVV1.trRE.goodCh == 1);
WVV4LEconOSI= WVV4.trLE.prefParamSI(WVV4.trLE.prefPatternsPrefParams == 1 & WVV4.trLE.inStimCenter == 0 & WVV4.trLE.within2Deg == 1 & WVV4.trLE.goodCh == 1);
WVV4REconOSI= WVV4.trRE.prefParamSI(WVV4.trRE.prefPatternsPrefParams == 1 & WVV4.trRE.inStimCenter == 0 & WVV4.trRE.within2Deg == 1 & WVV4.trRE.goodCh == 1);

WVV1LEradOSI= WVV1.trLE.prefParamSI(WVV1.trLE.prefPatternsPrefParams == 2 & WVV1.trLE.inStimCenter == 0 & WVV1.trLE.within2Deg == 1 & WVV1.trLE.goodCh == 1);
WVV1REradOSI= WVV1.trRE.prefParamSI(WVV1.trRE.prefPatternsPrefParams == 2 & WVV1.trRE.inStimCenter == 0 & WVV1.trRE.within2Deg == 1 & WVV1.trRE.goodCh == 1);
WVV4LEradOSI= WVV4.trLE.prefParamSI(WVV4.trLE.prefPatternsPrefParams == 2 & WVV4.trLE.inStimCenter == 0 & WVV4.trLE.within2Deg == 1 & WVV4.trLE.goodCh == 1);
WVV4REradOSI= WVV4.trRE.prefParamSI(WVV4.trRE.prefPatternsPrefParams == 2 & WVV4.trRE.inStimCenter == 0 & WVV4.trRE.within2Deg == 1 & WVV4.trRE.goodCh == 1);

% XT 
XTV1LEconOSI= XTV1.trLE.prefParamSI(XTV1.trLE.prefPatternsPrefParams == 1 & XTV1.trLE.inStimCenter == 0 & XTV1.trLE.within2Deg == 1 & XTV1.trLE.goodCh == 1);
XTV1REconOSI= XTV1.trRE.prefParamSI(XTV1.trRE.prefPatternsPrefParams == 1 & XTV1.trRE.inStimCenter == 0 & XTV1.trRE.within2Deg == 1 & XTV1.trRE.goodCh == 1);
XTV4LEconOSI= XTV4.trLE.prefParamSI(XTV4.trLE.prefPatternsPrefParams == 1 & XTV4.trLE.inStimCenter == 0 & XTV4.trLE.within2Deg == 1 & XTV4.trLE.goodCh == 1);
XTV4REconOSI= XTV4.trRE.prefParamSI(XTV4.trRE.prefPatternsPrefParams == 1 & XTV4.trRE.inStimCenter == 0 & XTV4.trRE.within2Deg == 1 & XTV4.trRE.goodCh == 1);

XTV1LEradOSI= XTV1.trLE.prefParamSI(XTV1.trLE.prefPatternsPrefParams == 2 & XTV1.trLE.inStimCenter == 0 & XTV1.trLE.within2Deg == 1 & XTV1.trLE.goodCh == 1);
XTV1REradOSI= XTV1.trRE.prefParamSI(XTV1.trRE.prefPatternsPrefParams == 2 & XTV1.trRE.inStimCenter == 0 & XTV1.trRE.within2Deg == 1 & XTV1.trRE.goodCh == 1);
XTV4LEradOSI= XTV4.trLE.prefParamSI(XTV4.trLE.prefPatternsPrefParams == 2 & XTV4.trLE.inStimCenter == 0 & XTV4.trLE.within2Deg == 1 & XTV4.trLE.goodCh == 1);
XTV4REradOSI= XTV4.trRE.prefParamSI(XTV4.trRE.prefPatternsPrefParams == 2 & XTV4.trRE.inStimCenter == 0 & XTV4.trRE.within2Deg == 1 & XTV4.trRE.goodCh == 1);
%% mean OSIs
meanLEConOSIV1 = mean([XTV1LEconOSI;WUV1LEconOSI;WVV1LEconOSI]);
meanREConOSIV1 = mean([XTV1REconOSI;WUV1REconOSI;WVV1REconOSI]);

meanLEConOSIV4 = mean([XTV4LEconOSI;WUV4LEconOSI;WVV4LEconOSI]);
meanREConOSIV4 = mean([XTV4REconOSI;WUV4REconOSI;WVV4REconOSI]);

meanLERadOSIV1 = mean([XTV1LEradOSI;WUV1LEradOSI;WVV1LEradOSI]);
meanRERadOSIV1 = mean([XTV1REradOSI;WUV1REradOSI;WVV1REradOSI]);

meanLERadOSIV4 = mean([XTV4LEradOSI;WUV4LEradOSI;WVV4LEradOSI]);
meanRERadOSIV4 = mean([XTV4REradOSI;WUV4REradOSI;WVV4REradOSI]);
%% OSI standard deviation
stdLEConOSIV1 = std([XTV1LEconOSI;WUV1LEconOSI;WVV1LEconOSI]);
stdREConOSIV1 = std([XTV1REconOSI;WUV1REconOSI;WVV1REconOSI]);

stdLEConOSIV4 = std([XTV4LEconOSI;WUV4LEconOSI;WVV4LEconOSI]);
stdREConOSIV4 = std([XTV4REconOSI;WUV4REconOSI;WVV4REconOSI]);

stdLERadOSIV1 = std([XTV1LEradOSI;WUV1LEradOSI;WVV1LEradOSI]);
stdRERadOSIV1 = std([XTV1REradOSI;WUV1REradOSI;WVV1REradOSI]);

stdLERadOSIV4 = std([XTV4LEradOSI;WUV4LEradOSI;WVV4LEradOSI]);
stdRERadOSIV4 = std([XTV4REradOSI;WUV4REradOSI;WVV4REradOSI]);
%%
figure(4)
clf
t = suptitle('Difference between preferred and dominant orientations in concentric patterns as a function of OSI');
t.Position(2) = t.Position(2)+0.03;

subplot(2,2,1)
osi = [WUV1LEconOSI; WVV1LEconOSI; XTV1LEconOSI];
dif = [wuV1LEconDiff; wvV1LEconDiff; xtV1LEconDiff];
v1LEconCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV1LEconOSI, wuV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV1LEconOSI, wvV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV1LEconOSI, xtV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v1LEconCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanLEConOSIV1),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdLEConOSIV1),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V1 LE concentric','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')

subplot(2,2,3)
osi = [WUV4LEconOSI; WVV4LEconOSI; XTV4LEconOSI];
dif = [wuV4LEconDiff; wvV4LEconDiff; xtV4LEconDiff];
v4LEconCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4LEconOSI, wuV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV4LEconOSI, wvV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV4LEconOSI, xtV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7) 
text(0.8, 98, sprintf('r = %.2f',v4LEconCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanLEConOSIV4),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdLEConOSIV4),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V4 LE concentric','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')
subplot(2,2,2)
osi = [WUV1REconOSI; WVV1REconOSI; XTV1REconOSI];
dif = [wuV1REconDiff; wvV1REconDiff; xtV1REconDiff];
v1REconCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k');
scatter(WUV1REconOSI, wuV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV1REconOSI, wvV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV1REconOSI, xtV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v1REconCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanREConOSIV1),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdREConOSIV1),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V1 RE concentric','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
%
subplot(2,2,4)
osi = [WUV4REconOSI; WVV4REconOSI; XTV4REconOSI];
dif = [wuV4REconDiff; wvV4REconDiff; xtV4REconDiff];
v4REconCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4REconOSI, wuV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV4REconOSI, wvV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV4REconOSI, xtV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v4REconCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanREConOSIV4),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdREConOSIV4),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V4 RE concentric','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

figName = 'AllMonk_allQuad_ConOriDiffPrefVsDom.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%%
figure(5)
clf
t = suptitle('Difference between preferred and dominant orientations in radial patterns as a function of OSI');
t.Position(2) = t.Position(2)+0.03;

subplot(2,2,1)
osi = [WUV1LEradOSI; WVV1LEradOSI; XTV1LEradOSI];
dif = [wuV1LEradDiff; wvV1LEradDiff; xtV1LEradDiff];
v1LEradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV1LEradOSI, wuV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV1LEradOSI, wvV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV1LEradOSI, xtV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v1LEradCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanLERadOSIV1),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdLERadOSIV1),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V1 LE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')

subplot(2,2,3)
osi = [WUV4LEradOSI; WVV4LEradOSI; XTV4LEradOSI];
dif = [wuV4LEradDiff; wvV4LEradDiff; xtV4LEradDiff];
v4LEradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4LEradOSI, wuV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV4LEradOSI, wvV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV4LEradOSI, xtV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7) 
text(0.8, 98, sprintf('r = %.2f',v4LEradCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanLERadOSIV4),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdLERadOSIV4),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V4 LE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')
subplot(2,2,2)
osi = [WUV1REradOSI; WVV1REradOSI; XTV1REradOSI];
dif = [wuV1REradDiff; wvV1REradDiff; xtV1REradDiff];
v1REradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k');
scatter(WUV1REradOSI, wuV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV1REradOSI, wvV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV1REradOSI, xtV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v1REradCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanRERadOSIV1),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdRERadOSIV1),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V1 RE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
%
subplot(2,2,4)
osi = [WUV4REradOSI; WVV4REradOSI; XTV4REradOSI];
dif = [wuV4REradDiff; wvV4REradDiff; xtV4REradDiff];
v4REradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4REradOSI, wuV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV4REradOSI, wvV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV4REradOSI, xtV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
text(0.8, 98, sprintf('r = %.2f',v4REradCorr),'FontSize',12)
text(0.8, 91, sprintf('\\mu = %.2f',meanRERadOSIV4),'FontSize',12)
text(0.8, 84, sprintf('\\sigma = %.2f',stdRERadOSIV4),'FontSize',12)
ylim([0 100])
xlim([0 1])

t = title('V4 RE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')

figName = 'AllMonk_allQuad_RadOriDiffPrefVsDom.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%%
figure(6)
clf

t = suptitle('Difference between preferred and dominant orientations as a function of OSI');
t.Position(2) = t.Position(2)+0.03;

subplot(2,2,1)
osi = [WUV1LEradOSI; WVV1LEradOSI; XTV1LEradOSI];
dif = [wuV1LEradDiff; wvV1LEradDiff; xtV1LEradDiff];
v1LEradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV1LEradOSI, wuV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV1LEradOSI, wvV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV1LEradOSI, xtV1LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)


scatter(WUV1LEconOSI, wuV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV1LEconOSI, wvV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV1LEconOSI, xtV1LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)

text(0.8, 98, sprintf('\\mu = %.2f',meanLEConOSIV1),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 92, sprintf('\\mu = %.2f',meanLERadOSIV1),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 82, sprintf('\\sigma = %.2f',stdLEConOSIV1),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 77, sprintf('\\sigma = %.2f',stdLERadOSIV1),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 68, sprintf('r = %.2f',v1LEradCorr),'FontSize',12,'Color',[0 0.6 0.2])
text(0.8, 62, sprintf('r = %.2f',v1LEconCorr),'FontSize',12,'Color',[0.7 0 0.7])

ylim([0 100])
xlim([0 1])

t = title('V1 LE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')

subplot(2,2,3)
osi = [WUV4LEradOSI; WVV4LEradOSI; XTV4LEradOSI];
dif = [wuV4LEradDiff; wvV4LEradDiff; xtV4LEradDiff];
v4LEradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4LEradOSI, wuV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV4LEradOSI, wvV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV4LEradOSI, xtV4LEradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7) 


scatter(WUV4LEconOSI, wuV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV4LEconOSI, wvV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV4LEconOSI, xtV4LEconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7) 

text(0.8, 98, sprintf('\\mu = %.2f',meanLEConOSIV4),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 92, sprintf('\\mu = %.2f',meanLERadOSIV4),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 82, sprintf('\\sigma = %.2f',stdLEConOSIV4),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 77, sprintf('\\sigma = %.2f',stdLERadOSIV4),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 68, sprintf('r = %.2f',v4LEradCorr),'FontSize',12,'Color',[0 0.6 0.2])
text(0.8, 62, sprintf('r = %.2f',v4LEconCorr),'FontSize',12,'Color',[0.7 0 0.7])
ylim([0 100])
xlim([0 1])

t = title('V4 LE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')
ylabel('|pref Ori - dom Ori|','FontSize',14,'FontWeight','bold','FontAngle','italic')


subplot(2,2,2)
osi = [WUV1REradOSI; WVV1REradOSI; XTV1REradOSI];
dif = [wuV1REradDiff; wvV1REradDiff; xtV1REradDiff];
v1REradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k');
scatter(WUV1REradOSI, wuV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV1REradOSI, wvV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV1REradOSI, xtV1REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

scatter(WUV1REconOSI, wuV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV1REconOSI, wvV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV1REconOSI, xtV1REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)

text(0.8, 98, sprintf('\\mu = %.2f',meanREConOSIV1),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 92, sprintf('\\mu = %.2f',meanRERadOSIV1),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 82, sprintf('\\sigma = %.2f',stdREConOSIV1),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 77, sprintf('\\sigma = %.2f',stdRERadOSIV1),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 68, sprintf('r = %.2f',v1REradCorr),'FontSize',12,'Color',[0 0.6 0.2])
text(0.8, 62, sprintf('r = %.2f',v1REconCorr),'FontSize',12,'Color',[0.7 0 0.7])

ylim([0 100])
xlim([0 1])

t = title('V1 RE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
%
subplot(2,2,4)
osi = [WUV4REradOSI; WVV4REradOSI; XTV4REradOSI];
dif = [wuV4REradDiff; wvV4REradDiff; xtV4REradDiff];
v4REradCorr = corr2(osi,dif);

hold on

plot([0 1],[100 0],':k')
scatter(WUV4REradOSI, wuV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(WVV4REradOSI, wvV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)
scatter(XTV4REradOSI, xtV4REradDiff,'filled','MarkerFaceColor',[0 0.6 0.2],'MarkerFaceAlpha',0.7)

scatter(WUV4REconOSI, wuV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(WVV4REconOSI, wvV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)
scatter(XTV4REconOSI, xtV4REconDiff,'filled','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.7)

text(0.8, 98, sprintf('\\mu = %.2f',meanREConOSIV4),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 92, sprintf('\\mu = %.2f',meanRERadOSIV4),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 82, sprintf('\\sigma = %.2f',stdREConOSIV4),'FontSize',12,'Color',[0.7 0 0.7])
text(0.8, 77, sprintf('\\sigma = %.2f',stdRERadOSIV4),'FontSize',12,'Color',[0 0.6 0.2])

text(0.8, 68, sprintf('r = %.2f',v4REradCorr),'FontSize',12,'Color',[0 0.6 0.2])
text(0.8, 62, sprintf('r = %.2f',v4REconCorr),'FontSize',12,'Color',[0.7 0 0.7])

ylim([0 100])
xlim([0 1])

t = title('V4 RE radial','FontSize',14,'FontWeight','bold','FontAngle','italic');
t.Position(2) = t.Position(2)+1;
xlabel('OSI','FontSize',14,'FontWeight','bold','FontAngle','italic')
