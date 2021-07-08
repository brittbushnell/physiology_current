function plotRF_SigOriBars(LEdata,REdata)    
%%
    figDir = sprintf('/Users/brittany/Dropbox/Figures/%s/RadialFrequency/%s/stats/',REdata.animal, REdata.array);
    
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
    
    figure(3);
    clf
    
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) pos(3) 500])
    
    h = subplot(2,1,1);
    hold on
    
    xlim([0 9])
    set(gca,'TickDir','out','layer','top','XTick',[1.5 4.5 7.5], 'XTickLabel',{'RF4','RF8','RF16'},...
        'FontSize',10,'FontAngle','italic')
    
    bar(1,LE4sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    bar(2,RE4sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    
    bar(4,LE8sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    bar(5,RE8sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    
    bar(7,LE16sig,'BarWidth',1,'FaceColor',[0.2 0.4 0.8],'EdgeColor','w')
    bar(8,RE16sig,'BarWidth',1,'FaceColor',[1.0 0.0 0.2],'EdgeColor','w')
    
    ylabel('# significant differences','FontSize',11);
    xlabel('Radial frequency','FontSize',11)
    
    t = title(sprintf('%s %s significant orientation differences',REdata.animal, REdata.array),'FontSize',14,'FontAngle','italic');
    t.Position(2) = t.Position(2) + 2;
    
    if contains(REdata.animal,'XT')
    l = legend('LE','RE','Location','northeast');
    else
        l = legend('FE','AE','Location','northeast');
    end
    l.Box = 'off'; l.FontWeight = 'bold';
    h.Position(2) = h.Position(2) - 0.25;
    
    figName = [LEdata.animal,'_BE_',LEdata.array,'_sigOris','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
    %% get the summary info
    LE4  = squeeze(LEdata.sigOri(1,:));       RE4  = squeeze(REdata.sigOri(1,:));
    LE8  = squeeze(LEdata.sigOri(2,:));       RE8  = squeeze(REdata.sigOri(2,:));
    LE16 = squeeze(LEdata.sigOri(3,:));       RE16 = squeeze(REdata.sigOri(3,:));
    
    % get difference in correlations between orientations.
    RE0 = squeeze(REdata.stimCorr(:,1,:));
    RE2 = squeeze(REdata.stimCorr(:,2,:));
    REcorrDiff = RE0 - RE2;
    
    LE0 = squeeze(LEdata.stimCorr(:,1,:));
    LE2 = squeeze(LEdata.stimCorr(:,2,:));
    LEcorrDiff = LE0 - LE2;
    
    RF4pref0  = sum(REcorrDiff(1,:) > 0 & RE4 == 1);
    RF4pref45 = sum(REcorrDiff(1,:) < 0 & RE4 == 1);
    
    RF8pref0  = sum(REcorrDiff(2,:) > 0 & RE8 == 1);
    RF8pref22 = sum(REcorrDiff(2,:) < 0 & RE8 == 1);
    
    RF16pref0  = sum(REcorrDiff(3,:) > 0 & RE16 == 1);
    RF16pref11 = sum(REcorrDiff(3,:) < 0 & RE16 == 1);
    
    y = [RF4pref0/96, RF4pref45/96; RF8pref0/96, RF8pref22/96; RF16pref0/96, RF16pref11/96];
    
    figure(4)
    clf
    s = suptitle(sprintf('%s %s significant orientation differences',REdata.animal, REdata.array));
    s.Position(2) = s.Position(2) + 0.02;
    
    s = subplot(1,2,2);
    hold on
    B = bar(y,'Stacked');
    B(1).FaceColor = [0.7 0 0.7];
    B(2).FaceColor = [0 0.6 0.2];
    B(1).FaceAlpha = 0.6;   B(2).FaceAlpha = 0.6;
    
    set(gca,'TickDir','out','layer','top','XTick',[1 2 3], 'XTickLabel',{'RF4','RF8','RF16'},...
        'YTick',0:0.05:0.2,'FontSize',10,'FontAngle','italic')
    
    l = legend('Prefers 0','Prefers other');
    l.Box = 'off';  l.FontSize = 10;
    ylim([0 0.2])
    s.Position(2) = s.Position(2) + 0.1;
    s.Position(4) = s.Position(4) - 0.2;
    
    if contains(REdata.animal,'XT')
        title('RE')
    else
        title('AE')
    end
    
    
    RF4pref0  = sum(LEcorrDiff(1,:) > 0 & LE4 == 1);
    RF4pref45 = sum(LEcorrDiff(1,:) < 0 & LE4 == 1);
    
    RF8pref0  = sum(LEcorrDiff(2,:) > 0 & LE8 == 1);
    RF8pref22 = sum(LEcorrDiff(2,:) < 0 & LE8 == 1);
    
    RF16pref0  = sum(LEcorrDiff(3,:) > 0 & LE16 == 1);
    RF16pref11 = sum(LEcorrDiff(3,:) < 0 & LE16 == 1);
    
    y = [RF4pref0/96, RF4pref45/96; RF8pref0/96, RF8pref22/96; RF16pref0/96, RF16pref11/96];
    
    s = subplot(1,2,1);
    hold on
    B = bar(y,'Stacked');
    
    B(1).FaceColor = [0.7 0 0.7];
    B(2).FaceColor = [0 0.6 0.2];
    B(1).FaceAlpha = 0.6;   B(2).FaceAlpha = 0.6;
    
    set(gca,'TickDir','out','layer','top','XTick',[1 2 3], 'XTickLabel',{'RF4','RF8','RF16'},...
        'YTick',0:0.05:0.2,'FontSize',10,'FontAngle','italic')
    
    ylim([0 0.2])
    ylabel('Proportion of channels','FontSize',11)
    
    if contains(REdata.animal,'XT')
        title('LE','FontSize',12)
    else
        title('FE','FontSize',12)
    end
    s.Position(2) = s.Position(2) + 0.1;
    s.Position(4) = s.Position(4) - 0.2;
    
    figName = [LEdata.animal,'_BE_',LEdata.array,'_sigOris_stacked','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')