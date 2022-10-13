function [XTlocPair] = plotRadFreqLoc_relRFs_prefLoc_allMonk(LEdataXT, REdataXT,LEdataWU,REdataWU, LEdataWV, REdataWV)

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
figure%(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 700, 1100],'PaperSize',[7.5, 10])
s = suptitle(sprintf('%s receptive fields and stimuli locations',LEdataXT.array));
s.Position(2) = s.Position(2) +0.025;

% XT
XTlocPair = LEdataXT.locPair;

subplot(3,2,1)
hold on
 title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([XTlocPair(1,1),XTlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(2,1),XTlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(3,1),XTlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if LEdataXT.goodCh(ch)
        scatter(XTrfParamsLE{ch}(1),XTrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(3,2,2)
hold on

title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3)+0.015,pos(4)+0.015])
grid on

viscircles([XTlocPair(1,1),XTlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(2,1),XTlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([XTlocPair(3,1),XTlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if REdataXT.goodCh(ch)
            scatter(XTrfParamsRE{ch}(1),XTrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)


% WU
WUlocPair = LEdataWU.locPair;

subplot(3,2,3)
hold on
% title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([WUlocPair(1,1),WUlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(2,1),WUlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(3,1),WUlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if LEdataWU.goodCh(ch)
        scatter(WUrfParamsLE{ch}(1),WUrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)


subplot(3,2,4)
hold on

% title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3)+0.015,pos(4)+0.015])
grid on

viscircles([WUlocPair(1,1),WUlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(2,1),WUlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WUlocPair(3,1),WUlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if REdataWU.goodCh(ch)
            scatter(WUrfParamsRE{ch}(1),WUrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end

% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

% WV
WVlocPair = LEdataWV.locPair;

subplot(3,2,5)
hold on
% title('LE')
xlim([-10 10])
ylim([-10 10])

set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both','FontSize',10,'FontAngle','italic')

pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2), pos(3)+0.017,pos(4)+0.017])
axis square
grid on

viscircles([WVlocPair(1,1),WVlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(2,1),WVlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(3,1),WVlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if LEdataWV.goodCh(ch)
        scatter(WVrfParamsLE{ch}(1),WVrfParamsLE{ch}(2),27,'MarkerFaceColor','k','MarkerEdgeColor','w',...
            'MarkerFaceAlpha',0.5)
    end
end
clear locPair
% plot(0,0,'ko','MarkerFaceColor','k','MarkerSize',3)

subplot(3,2,6)
hold on

% title('RE')
xlim([-10 10])
ylim([-10 10])
axis square
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both')
pos = get(gca,'Position');
set(gca,'Position',[pos(1),pos(2)-0.033, pos(3)+0.02,pos(4)+0.02])
grid on

viscircles([WVlocPair(1,1),WVlocPair(1,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(2,1),WVlocPair(2,2)],2,...
    'color','k','LineWidth',1);
viscircles([WVlocPair(3,1),WVlocPair(3,2)],2,...
    'color','k','LineWidth',1);

for ch = 1:96
    if REdataWV.goodCh(ch)
            scatter(WVrfParamsRE{ch}(1),WVrfParamsRE{ch}(2),29,'MarkerFaceColor','k','MarkerEdgeColor','w',...
                'MarkerFaceAlpha',0.5)
    end
end
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