function [locPair] = plotRadFreqLoc_relRFs_prefLoc(dataT)
%%
LEdata = dataT.LE;
REdata = dataT.RE;
%% get receptive fields
LEdata = callReceptiveFieldParameters(LEdata);
REdata = callReceptiveFieldParameters(REdata);

if contains(LEdata.animal,'XT')
    rfParamsLE = LEdata.chReceptiveFieldParamsBE;
    rfParamsRE = REdata.chReceptiveFieldParamsBE;
else
    rfParamsLE = LEdata.chReceptiveFieldParams;
    rfParamsRE = REdata.chReceptiveFieldParams;
end
%% plot receptive fields relative to stimulus locations
xPoss = unique(LEdata.pos_x);
yPoss = unique(LEdata.pos_y);
locPair = nan(1,2);

for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((LEdata.pos_x == xPoss(xs)) & (LEdata.pos_y == yPoss(ys)));
        if flerp >1
            locPair(end+1,:) = [xPoss(xs), yPoss(ys)];
        end
    end
end
locPair = locPair(2:end,:);

figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 700, 600],'PaperSize',[7.5, 10])

s = suptitle(sprintf('%s %s receptive fields and preferred radial frequency locations',LEdata.animal, LEdata.array));
s.Position(2) = s.Position(2) +0.025; 
s.FontSize = 14;
s.FontWeight = 'bold';

subplot(2,2,1)
hold on
title('LE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
set(gca,'Position',[pos(1)-0.07,pos(2)-0.09, pos(3)+0.09,pos(4)+0.09])
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if LEdata.goodCh(ch)
        scatter(rfParamsLE{ch}(1),rfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(2,2,3)
hold on
prefLoc1 = sum(LEdata.prefLoc == 1);
prefLoc2 = sum(LEdata.prefLoc == 2);
prefLoc3 = sum(LEdata.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2)+0.1,pos(3), pos(4) - 0.2])
xlabel('Preferred location')
ylabel('# channels')

subplot(2,2,2)
hold on

title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
set(gca,'Position',[pos(1)+0.01,pos(2)-0.09, pos(3)+0.09,pos(4)+0.09])
grid on

viscircles([locPair(1,1),locPair(1,2)],2,...
    'color',[0.7 0 0.7],'LineWidth',1);
viscircles([locPair(2,1),locPair(2,2)],2,...
    'color',[0 0.4 0.2],'LineWidth',1);
viscircles([locPair(3,1),locPair(3,2)],2,...
    'color',[1 0.4 0],'LineWidth',1);

for ch = 1:96
    if REdata.goodCh(ch)
            scatter(rfParamsRE{ch}(1),rfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(2,2,4)
hold on
prefLoc1 = sum(REdata.prefLoc == 1);
prefLoc2 = sum(REdata.prefLoc == 2);
prefLoc3 = sum(REdata.prefLoc == 3);

bar(1,prefLoc1,'BarWidth', 0.45,'FaceColor',[0.7 0 0.7],'FaceAlpha',0.7)
bar(2,prefLoc2,'BarWidth', 0.45,'FaceColor',[0 0.4 0.2],'FaceAlpha',0.7)
bar(3,prefLoc3,'BarWidth', 0.45,'FaceColor',[1 0.4 0],'FaceAlpha',0.7)

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'XTick',1:3);
pos = get(gca,'Position');
set(gca,'Position',[pos(1), pos(2)+0.1,pos(3), pos(4) - 0.2])
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

figName = [LEdata.animal,'_',LEdata.array,'_RFandPrefLoc_','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')