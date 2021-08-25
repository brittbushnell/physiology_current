function [locPair] = plotRadFreqLoc_relRFs_prefLoc_allMonk(LEdataXT, REdataXT,LEdataWU,REdataWU, LEdataWV, REdataWV)

%% get receptive fields
LEdataXT = callReceptiveFieldParameters(LEdataXT);
REdataXT = callReceptiveFieldParameters(REdataXT);

XTrfParamsLE = LEdataXT.chReceptiveFieldParamsBE;
XTrfParamsRE = REdataXT.chReceptiveFieldParamsBE;


LEdataWU = callReceptiveFieldParameters(LEdataWU);
REdataWU = callReceptiveFieldParameters(REdataWU);

WUrfParamsLE = LEdataWU.chReceptiveFieldParams;
WUrfParamsRE = REdataWU.chReceptiveFieldParams;

LEdataWV = callReceptiveFieldParameters(LEdataWV);
REdataWV = callReceptiveFieldParameters(REdataWV);

WVrfParamsLE = LEdataWV.chReceptiveFieldParams;
WVrfParamsRE = REdataWV.chReceptiveFieldParams;
%% plot receptive fields relative to stimulus locations
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 700, 1100],'PaperSize',[7.5, 10])
% XT
xPoss = unique(LEdataXT.pos_x);
yPoss = unique(LEdataXT.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((LEdataXT.pos_x == xPoss(xs)) & (LEdataXT.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);

subplot(6,2,1)
hold on
% title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
%set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if LEdataXT.goodCh(ch)
        scatter(XTrfParamsLE{ch}(1),XTrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,3)
hold on
prefLoc1 = sum(LEdataXT.prefLoc == 1);
prefLoc2 = sum(LEdataXT.prefLoc == 2);
prefLoc3 = sum(LEdataXT.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
%set(gca,'Position',[pos(1), pos(2), pos(3)- 0.02, pos(4) - 0.025])
xlabel('Preferred location')
ylabel('# channels')

subplot(6,2,2)
hold on

% title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
%set(gca,'Position',[pos(1),pos(2), pos(3)+0.015,pos(4)+0.015])
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if REdataXT.goodCh(ch)
            scatter(XTrfParamsRE{ch}(1),XTrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,4)
hold on
prefLoc1 = sum(REdataXT.prefLoc == 1);
prefLoc2 = sum(REdataXT.prefLoc == 2);
prefLoc3 = sum(REdataXT.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
%set(gca,'Position',[pos(1), pos(2),pos(3)-0.04, pos(4) - 0.03])
xlabel('Preferred location')
ylabel('# channels')

% WU
xPoss = unique(LEdataWU.pos_x);
yPoss = unique(LEdataWU.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((LEdataWU.pos_x == xPoss(xs)) & (LEdataWU.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);

subplot(6,2,5)
hold on
% title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
%set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if LEdataWU.goodCh(ch)
        scatter(WUrfParamsLE{ch}(1),WUrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,7)
hold on
prefLoc1 = sum(LEdataWU.prefLoc == 1);
prefLoc2 = sum(LEdataWU.prefLoc == 2);
prefLoc3 = sum(LEdataWU.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
%set(gca,'Position',[pos(1), pos(2), pos(3)- 0.02, pos(4) - 0.025])
xlabel('Preferred location')
ylabel('# channels')

subplot(6,2,6)
hold on

% title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
%set(gca,'Position',[pos(1),pos(2), pos(3)+0.015,pos(4)+0.015])
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if REdataWU.goodCh(ch)
            scatter(WUrfParamsRE{ch}(1),WUrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,8)
hold on
prefLoc1 = sum(REdataWU.prefLoc == 1);
prefLoc2 = sum(REdataWU.prefLoc == 2);
prefLoc3 = sum(REdataWU.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
%set(gca,'Position',[pos(1), pos(2),pos(3)-0.04, pos(4) - 0.03])
xlabel('Preferred location')
ylabel('# channels')

% WV
xPoss = unique(LEdataWV.pos_x);
yPoss = unique(LEdataWV.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((LEdataWV.pos_x == xPoss(xs)) & (LEdataWV.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);

subplot(6,2,9)
hold on
% title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
%set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if LEdataWV.goodCh(ch)
        scatter(WVrfParamsLE{ch}(1),WVrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,11)
hold on
prefLoc1 = sum(LEdataWV.prefLoc == 1);
prefLoc2 = sum(LEdataWV.prefLoc == 2);
prefLoc3 = sum(LEdataWV.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
set(gca,'Position',[pos(1)-0.02, pos(2)-0.02,pos(3)-0.05, pos(4) - 0.035])
xlabel('Preferred location')
ylabel('# channels')

subplot(6,2,10)
hold on

% title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2)-0.033, pos(3)+0.02,pos(4)+0.02])
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if REdataWV.goodCh(ch)
            scatter(WVrfParamsRE{ch}(1),WVrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end

% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(6,2,12)
hold on
prefLoc1 = sum(REdataWV.prefLoc == 1);
prefLoc2 = sum(REdataWV.prefLoc == 2);
prefLoc3 = sum(REdataWV.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
set(gca,'Position',[pos(1)+0.02, pos(2)-0.02,pos(3)-0.05, pos(4) - 0.035])
xlabel('Preferred location')
ylabel('# channels')
%%
location = determineComputer;
if location == 1
    figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/LocationPrefs';
elseif location == 0
    figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/LocationPrefs';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [LEdataXT.animal,'_',LEdataXT.array,'_RFandPrefLoc_','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')