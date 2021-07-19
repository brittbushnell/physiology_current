function plotRF_SigOriBars(LEdata,REdata)
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
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
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
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
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
LE4  = squeeze(LEdata.sigOri(1,:,:));       RE4  = squeeze(REdata.sigOri(1,:,:));
LE8  = squeeze(LEdata.sigOri(2,:,:));       RE8  = squeeze(REdata.sigOri(2,:,:));
LE16 = squeeze(LEdata.sigOri(3,:,:));       RE16 = squeeze(REdata.sigOri(3,:,:));

% remove nan
LE4(isnan(LE4))   = [];    RE4(isnan(RE4)) = [];
LE8(isnan(LE8))   = [];    RE8(isnan(RE8)) = [];
LE16(isnan(LE16)) = [];    RE16(isnan(RE16)) = [];

% significant differences by RF
LE4sig  = sum(LE4);      RE4sig = sum(RE4);
LE8sig  = sum(LE8);      RE8sig = sum(RE8);
LE16sig = sum(LE16);     RE16sig = sum(RE16);
%%
%     figure(3);
%     clf
%
%     pos = get(gcf,'Position');
%     set(gcf,'Position',[pos(1) pos(2) pos(3) 500])
%
%     h = subplot(2,1,1);
%     hold on
%
%     xlim([0 9])
%     set(gca,'TickDir','out','layer','top','XTick',[1.5 4.5 7.5], 'XTickLabel',{'RF4','RF8','RF16'},...
%         'FontSize',10,'FontAngle','italic')
%
%     bar(1,LE4sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
%     bar(2,RE4sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
%
%     bar(4,LE8sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
%     bar(5,RE8sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
%
%     bar(7,LE16sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
%     bar(8,RE16sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
%
%     ylabel('# significant differences','FontSize',11);
%     xlabel('Radial frequency','FontSize',11)
%
%     t = title(sprintf('%s %s significant orientation differences',REdata.animal, REdata.array),'FontSize',14,'FontAngle','italic');
%     t.Position(2) = t.Position(2) + 2;
%
%     if contains(REdata.animal,'XT')
%     l = legend('LE','RE','Location','northeast');
%     else
%         l = legend('FE','AE','Location','northeast');
%     end
%     l.Box = 'off'; l.FontWeight = 'bold';
%     h.Position(2) = h.Position(2) - 0.25;
%
%     figName = [LEdata.animal,'_BE_',LEdata.array,'_sigOris','.pdf'];
%     print(gcf, figName,'-dpdf','-bestfit')
%% get the summary info
LE4  = squeeze(LEdata.sigOri(1,:));       RE4  = squeeze(REdata.sigOri(1,:));
LE8  = squeeze(LEdata.sigOri(2,:));       RE8  = squeeze(REdata.sigOri(2,:));
LE16 = squeeze(LEdata.sigOri(3,:));       RE16 = squeeze(REdata.sigOri(3,:));

% get difference in correlations between orientations.
RE0 = squeeze(REdata.oriCorrDiff(:,1,:));
RE2 = squeeze(REdata.oriCorrDiff(:,2,:));
REcorrDiff = RE0 - RE2;

LE0 = squeeze(LEdata.oriCorrDiff(:,1,:));
LE2 = squeeze(LEdata.oriCorrDiff(:,2,:));
LEcorrDiff = LE0 - LE2;

LERF4pref0  = sum(REcorrDiff(1,:) > 0 & RE4 == 1);
LERF4pref45 = sum(REcorrDiff(1,:) < 0 & RE4 == 1);

LERF8pref0  = sum(REcorrDiff(2,:) > 0 & RE8 == 1);
LERF8pref22 = sum(REcorrDiff(2,:) < 0 & RE8 == 1);

LERF16pref0  = sum(REcorrDiff(3,:) > 0 & RE16 == 1);
LERF16pref11 = sum(REcorrDiff(3,:) < 0 & RE16 == 1);

y = [LERF4pref0, LERF4pref45; LERF8pref0, LERF8pref22; LERF16pref0, LERF16pref11];

%%     figure(4)
%     clf
%     s = suptitle(sprintf('%s %s significant orientation differences',REdata.animal, REdata.array));
%     s.Position(2) = s.Position(2) + 0.02;
%
%     s = subplot(1,2,2);
%     hold on
%     bLE = bar(y,'Stacked');
%     bLE(1).FaceColor = [0.7 0 0.7];
%     bLE(2).FaceColor = [0 0.6 0.2];
%     bLE(1).FaceAlpha = 0.6;   bLE(2).FaceAlpha = 0.6;
%
%     set(gca,'TickDir','out','layer','top','XTick',[1 2 3], 'XTickLabel',{'RF4','RF8','RF16'},...
%         'YTick',0:0.05:0.2,'FontSize',10,'FontAngle','italic')
%
%     l = legend('Prefers 0','Prefers other');
%     l.Box = 'off';  l.FontSize = 10;
% %     ylim([0 0.2])
%     s.Position(2) = s.Position(2) + 0.1;
%     s.Position(4) = s.Position(4) - 0.2;
%
%     if contains(REdata.animal,'XT')
%         title('RE')
%     else
%         title('AE')
%     end
%
%
%     LERF4pref0  = sum(LEcorrDiff(1,:) > 0 & LE4 == 1);
%     LERF4pref45 = sum(LEcorrDiff(1,:) < 0 & LE4 == 1);
%
%     LERF8pref0  = sum(LEcorrDiff(2,:) > 0 & LE8 == 1);
%     LERF8pref22 = sum(LEcorrDiff(2,:) < 0 & LE8 == 1);
%
%     LERF16pref0  = sum(LEcorrDiff(3,:) > 0 & LE16 == 1);
%     LERF16pref11 = sum(LEcorrDiff(3,:) < 0 & LE16 == 1);
%
%     y = [LERF4pref0, LERF4pref45; LERF8pref0, LERF8pref22; LERF16pref0, LERF16pref11];
%
%     s = subplot(1,2,1);
%     hold on
%     bLE = bar(y,'Stacked');
%
%     bLE(1).FaceColor = [0.7 0 0.7];
%     bLE(2).FaceColor = [0 0.6 0.2];
%     bLE(1).FaceAlpha = 0.6;   bLE(2).FaceAlpha = 0.6;
%
%     set(gca,'TickDir','out','layer','top','XTick',[1 2 3], 'XTickLabel',{'RF4','RF8','RF16'},...
%        'FontSize',10,'FontAngle','italic')
%
% %     ylim([0 0.2])
%     ylabel('# of channels','FontSize',11)
%
%     if contains(REdata.animal,'XT')
%         title('LE','FontSize',12)
%     else
%         title('FE','FontSize',12)
%     end
%     s.Position(2) = s.Position(2) + 0.1;
%     s.Position(4) = s.Position(4) - 0.2;
%
%     figName = [LEdata.animal,'_BE_',LEdata.array,'_sigOris_stacked','.pdf'];
%     print(gcf, figName,'-dpdf','-bestfit')
%%
LEgCh = sum(LEdata.goodCh);
REgCh = sum(REdata.goodCh);

LERF4pref0  = sum(LEcorrDiff(1,:) > 0 & LE4 == 1);
LERF4pref45 = sum(LEcorrDiff(1,:) < 0 & LE4 == 1);

LERF8pref0  = sum(LEcorrDiff(2,:) > 0 & LE8 == 1);
LERF8pref22 = sum(LEcorrDiff(2,:) < 0 & LE8 == 1);

LERF16pref0  = sum(LEcorrDiff(3,:) > 0 & LE16 == 1);
LERF16pref11 = sum(LEcorrDiff(3,:) < 0 & LE16 == 1);

LEy = [LERF4pref0/LEgCh, LERF4pref45/LEgCh; LERF8pref0/LEgCh, LERF8pref22/LEgCh; LERF16pref0/LEgCh, LERF16pref11/LEgCh];
LEx = [0.05 4.15 8.3];

RERF4pref0  = sum(REcorrDiff(1,:) > 0 & RE4 == 1);
RERF4pref45 = sum(REcorrDiff(1,:) < 0 & RE4 == 1);

RERF8pref0  = sum(REcorrDiff(2,:) > 0 & RE8 == 1);
RERF8pref22 = sum(REcorrDiff(2,:) < 0 & RE8 == 1);

RERF16pref0  = sum(REcorrDiff(3,:) > 0 & RE16 == 1);
RERF16pref11 = sum(REcorrDiff(3,:) < 0 & RE16 == 1);

REy = [RERF4pref0/REgCh, RERF4pref45/REgCh; RERF8pref0/REgCh, RERF8pref22/REgCh; RERF16pref0/REgCh, RERF16pref11/REgCh];
REx = [1.8 5.87 10];

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
t = title(sprintf('%s %s %s Proportion of channels with significant orientation preferences',REdata.animal, REdata.array, REdata.programID), 'FontSize',14);
t.Position(2) = t.Position(2) +0.012;

l = legend('LE 0 deg','LE other ori', 'RE 0 deg', 'RE other ori');
l.Box = 'off'; l.NumColumns = 2;
l.FontSize = 10;

if contains(LEdata.animal,'WU')
    figName = [LEdata.animal,'_BE_',LEdata.array,'_sigOris_stacked1Fig','.pdf'];
else
    figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_sigOris_stacked1Fig','.pdf'];
end
print(gcf, figName,'-dpdf','-bestfit')