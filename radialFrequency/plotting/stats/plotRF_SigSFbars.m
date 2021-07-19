function plotRF_SigSFbars(LEdata,REdata)
%%
location = determineComputer;

if location == 1
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V1')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get the summary info
LE4  = squeeze(LEdata.sigSF(1,:));       RE4  = squeeze(REdata.sigSF(1,:));
LE8  = squeeze(LEdata.sigSF(2,:));       RE8  = squeeze(REdata.sigSF(2,:));
LE16 = squeeze(LEdata.sigSF(3,:));       RE16 = squeeze(REdata.sigSF(3,:));

LEgCh = sum(LEdata.goodCh);
REgCh = sum(REdata.goodCh);

LERF4pref1 = sum(squeeze(LEdata.SFcorrDiff(1,:)) > 0 & LE4 == 1);
LERF4pref2 = sum(squeeze(LEdata.SFcorrDiff(1,:)) < 0 & LE4 == 1);

LERF8pref1 = sum(squeeze(LEdata.SFcorrDiff(2,:)) > 0 & LE8 == 1);
LERF8pref2 = sum(squeeze(LEdata.SFcorrDiff(2,:)) < 0 & LE8 == 1);

LERF16pref1 = sum(squeeze(LEdata.SFcorrDiff(3,:)) > 0 & LE16 == 1);
LERF16pref2 = sum(squeeze(LEdata.SFcorrDiff(3,:)) < 0 & LE16 == 1);

LEy = [LERF4pref1/LEgCh, LERF4pref2/LEgCh; LERF8pref1/LEgCh, LERF8pref2/LEgCh; LERF16pref1/LEgCh, LERF16pref2/LEgCh];
LEx = [0.05 4.15 8.3];

RERF4pref1 = sum(squeeze(REdata.SFcorrDiff(1,:)) > 0 & RE4 == 1);
RERF4pref2 = sum(squeeze(REdata.SFcorrDiff(1,:)) < 0 & RE4 == 1);

RERF8pref1 = sum(squeeze(REdata.SFcorrDiff(2,:)) > 0 & RE8 == 1);
RERF8pref2 = sum(squeeze(REdata.SFcorrDiff(2,:)) < 0 & RE8 == 1);

RERF16pref1 = sum(squeeze(REdata.SFcorrDiff(3,:)) > 0 & RE16 == 1);
RERF16pref2 = sum(squeeze(REdata.SFcorrDiff(3,:)) < 0 & RE16 == 1);

REy = [RERF4pref1/REgCh, RERF4pref2/REgCh; RERF8pref1/REgCh, RERF8pref2/REgCh; RERF16pref1/REgCh, RERF16pref2/REgCh];
REx = [1.8 5.87 10];
%%
figure(5)
clf
hold on
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2), pos(3), 500],'PaperOrientation','landscape');

bLE = bar(LEx,LEy,'Stacked','BarWidth',0.4);

bLE(1).FaceColor = [0 0 1];
bLE(2).FaceColor = [0 0 1];
bLE(1).FaceAlpha = 0.7;   bLE(2).FaceAlpha = 0.5;
bLE(1).EdgeColor = [0 0 1];
bLE(2).EdgeColor = [0 0 1];
bLE(1).EdgeAlpha = 0.7;   bLE(2).EdgeAlpha = 0.5;

bRE = bar(REx,REy,'Stacked','BarWidth',0.4);

bRE(1).FaceColor = [1 0 0];
bRE(2).FaceColor = [1 0 0];
bRE(1).FaceAlpha = 0.7;   bRE(2).FaceAlpha = 0.5;
bRE(1).EdgeColor = [1 0 0];
bRE(2).EdgeColor = [1 0 0];
bRE(1).EdgeAlpha = 0.7;   bRE(2).EdgeAlpha = 0.5;

xlim([-1 11])
set(gca,'TickDir','out','layer','top','XTick',[0.92 5. 9.2], 'XTickLabel',{'RF4','RF8','RF16'},...
    'FontSize',10,'FontAngle','italic')
pos2 = get(gca,'Position');
set(gca,'Position',[pos2(1),pos2(2)+0.1,pos2(3),pos2(4) - 0.2])

ylabel('Proportion of included channels','FontSize',11)
t = title(sprintf('%s %s %s Proportion of channels with significant SF preferences',REdata.animal, REdata.array,REdata.programID), 'FontSize',14);
t.Position(2) = t.Position(2) +0.012;

l = legend('LE SF1','LE SF2', 'RE SF1', 'RE SF2');
l.Box = 'off'; l.NumColumns = 2;
l.FontSize = 10;

if contains(LEdata.animal,'WU')
    figName = [LEdata.animal,'_BE_',LEdata.array,'_sigSF','.pdf'];
else
    figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_sigSF','.pdf'];
end
print(gcf, figName,'-dpdf','-bestfit')