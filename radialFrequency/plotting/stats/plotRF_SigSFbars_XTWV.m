function plotRF_SigSFbars_XTWV(dataT)
%%
location = determineComputer;

if location == 1
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/', dataT.LEhighSF.animal, dataT.LEhighSF.array);
elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/', dataT.LEhighSF.animal, dataT.LEhighSF.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get the summary info
LE4  = squeeze(dataT.LESF.corrSigCh(1,:));       RE4  = squeeze(dataT.RESF.corrSigCh(1,:));
LE8  = squeeze(dataT.LESF.corrSigCh(2,:));       RE8  = squeeze(dataT.RESF.corrSigCh(2,:));
LE16 = squeeze(dataT.LESF.corrSigCh(3,:));       RE16 = squeeze(dataT.RESF.corrSigCh(3,:));

trueHighLE = dataT.LEhighSF.stimCorrs;
trueLowLE = dataT.LElowSF.stimCorrs;
trueCorrDiffLE = trueHighLE - trueLowLE;

trueHighRE = dataT.REhighSF.stimCorrs;
trueLowRE = dataT.RElowSF.stimCorrs;
trueCorrDiffRE = trueHighRE - trueLowRE;

LEgCh = sum(dataT.LEhighSF.goodCh & dataT.LElowSF.goodCh);
REgCh = sum(dataT.REhighSF.goodCh & dataT.RElowSF.goodCh);
 
LERF4pref1 = sum(squeeze(trueCorrDiffLE(1,:)) > 0 & LE4 == 1);
LERF4pref2 = sum(squeeze(trueCorrDiffLE(1,:)) < 0 & LE4 == 1);

LERF8pref1 = sum(squeeze(trueCorrDiffLE(2,:)) > 0 & LE8 == 1);
LERF8pref2 = sum(squeeze(trueCorrDiffLE(2,:)) < 0 & LE8 == 1);

LERF16pref1 = sum(squeeze(trueCorrDiffLE(3,:)) > 0 & LE16 == 1);
LERF16pref2 = sum(squeeze(trueCorrDiffLE(3,:)) < 0 & LE16 == 1);

LEy = [LERF4pref1/LEgCh, LERF4pref2/LEgCh; LERF8pref1/LEgCh, LERF8pref2/LEgCh; LERF16pref1/LEgCh, LERF16pref2/LEgCh]; 
LEx = [0.05 4.15 8.3];

RERF4pref1 = sum(squeeze(trueCorrDiffRE(1,:)) > 0 & RE4 == 1);
RERF4pref2 = sum(squeeze(trueCorrDiffRE(1,:)) < 0 & RE4 == 1);

RERF8pref1 = sum(squeeze(trueCorrDiffRE(2,:)) > 0 & RE8 == 1);
RERF8pref2 = sum(squeeze(trueCorrDiffRE(2,:)) < 0 & RE8 == 1);

RERF16pref1 = sum(squeeze(trueCorrDiffRE(3,:)) > 0 & RE16 == 1);
RERF16pref2 = sum(squeeze(trueCorrDiffRE(3,:)) < 0 & RE16 == 1);

REy = [RERF4pref1/REgCh, RERF4pref2/REgCh; RERF8pref1/REgCh, RERF8pref2/REgCh; RERF16pref1/REgCh, RERF16pref2/REgCh];  
REx = [1.8 5.87 10];
%%
figure(4)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2), pos(3), 500],'PaperOrientation','landscape');


bLE = bar(LEx,LEy,'Stacked','BarWidth',0.4);

bLE(1).FaceColor = [0 0 1];
bLE(2).FaceColor = [0 0 1];
bLE(1).FaceAlpha = 0.8;   bLE(2).FaceAlpha = 0.5;
bLE(1).EdgeColor = [0 0 1];
bLE(2).EdgeColor = [0 0 1];
bLE(1).EdgeAlpha = 0.8;   bLE(2).EdgeAlpha = 0.5;

bRE = bar(REx,REy,'Stacked','BarWidth',0.4);

bRE(1).FaceColor = [1 0 0];
bRE(2).FaceColor = [1 0 0];
bRE(1).FaceAlpha = 0.8;   bRE(2).FaceAlpha = 0.5;
bRE(1).EdgeColor = [1 0 0];
bRE(2).EdgeColor = [1 0 0];
bRE(1).EdgeAlpha = 0.8;   bRE(2).EdgeAlpha = 0.5;

xlim([-1 11])
set(gca,'TickDir','out','layer','top','XTick',[0.92 5. 9.2], 'XTickLabel',{'RF4','RF8','RF16'},...
    'FontSize',10,'FontAngle','italic')
pos2 = get(gca,'Position');
set(gca,'Position',[pos2(1),pos2(2)+0.1,pos2(3),pos2(4) - 0.2])

ylabel('Proportion of included channels','FontSize',11)

t = title(sprintf('%s %s proportion of channels with significant SF preferences',dataT.LEhighSF.animal, dataT.LEhighSF.array), 'FontSize',14);
t.Position(2) = t.Position(2) +0.012;

l = legend('LE SF1','LE SF2', 'RE SF1', 'RE SF2','Location','best');
l.Box = 'off'; l.NumColumns = 2;
l.FontSize = 10;

figName = [dataT.LEhighSF.animal,'_BE_',dataT.LEhighSF.array,'_sigSF','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')