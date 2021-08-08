%plotReceptiveFieldLocations
%%
clear
close all
clc
%%
location = determineComputer;
if location == 1
    figDir =  '~/bushnell-local/Dropbox/Figures/CrossAnimals';
elseif location == 0
    figDir = '~/Dropbox//Figures/CrossAnimals';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
WUV1LE.animal = 'WU';       WUV1RE.animal = 'WU';
WUV1LE.eye = 'LE';          WUV1RE.eye = 'RE';
WUV1LE.array = 'V1';        WUV1RE.array = 'V1';

WUV4LE.animal = 'WU';       WUV4RE.animal = 'WU';
WUV4LE.eye = 'LE';          WUV4RE.eye = 'RE';
WUV4LE.array = 'V4';        WUV4RE.array = 'V4';

WVV1LE.animal = 'WV';       WVV1RE.animal = 'WV';
WVV1LE.eye = 'LE';          WVV1RE.eye = 'RE';
WVV1LE.array = 'V1';        WVV1RE.array = 'V1';

WVV4LE.animal = 'WV';       WVV4RE.animal = 'WV';
WVV4LE.eye = 'LE';          WVV4RE.eye = 'RE';
WVV4LE.array = 'V4';        WVV4RE.array = 'V4';

XTV1.animal = 'XT';         XTV4.animal = 'XT';
XTV1.eye = 'BE';            XTV4.eye = 'BE';
XTV1.array = 'V1';          XTV4.array = 'V4';
%%
WUV1RE = callReceptiveFieldParameters(WUV1RE);
WUV4RE = callReceptiveFieldParameters(WUV4RE);
WUV1LE = callReceptiveFieldParameters(WUV1LE);
WUV4LE = callReceptiveFieldParameters(WUV4LE);

WVV1RE = callReceptiveFieldParameters(WVV1RE);
WVV4RE = callReceptiveFieldParameters(WVV4RE);
WVV1LE = callReceptiveFieldParameters(WVV1LE);
WVV4LE = callReceptiveFieldParameters(WVV4LE);

XTV1 = callReceptiveFieldParameters(XTV1);
XTV4 = callReceptiveFieldParameters(XTV4);
%%
XTV1rfParams = XTV1.chReceptiveFieldParamsBE;
XTV4rfParams = XTV4.chReceptiveFieldParamsBE;

WVV4rfParamsLE = WVV4LE.chReceptiveFieldParams;
WVV4rfParamsRE = WVV4RE.chReceptiveFieldParams;
WVV1rfParamsLE = WVV1LE.chReceptiveFieldParams;
WVV1rfParamsRE = WVV1RE.chReceptiveFieldParams;

WUV4rfParamsLE = WUV4LE.chReceptiveFieldParams;
WUV4rfParamsRE = WUV4RE.chReceptiveFieldParams;
WUV1rfParamsLE = WUV1LE.chReceptiveFieldParams;
WUV1rfParamsRE = WUV1RE.chReceptiveFieldParams;
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 900, 900])
s = suptitle('Receptive field locations');
s.Position(2) = s.Position(2)+0.025;
s.FontSize = 14;

s = subplot(3,2,1);
hold on

title('V1/V2','FontSize',12,'FontWeight','bold')
xlim([-15 15])
ylim([-15 15])
text(-22, 0 ,'Control','FontSize',12,'FontWeight','bold')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(XTV1rfParams{ch}(1),XTV1rfParams{ch}(2),'MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end
s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.035;
s.Position(4) = s.Position(4) + 0.035;

s = subplot(3,2,2);
hold on

xlim([-15 15])
ylim([-15 15])
title('V4','FontSize',12,'FontWeight','bold')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(XTV4rfParams{ch}(1),XTV4rfParams{ch}(2),'MarkerEdgeColor','w','MarkerFaceColor',[0.7 0 0.7],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end
s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.035;
s.Position(4) = s.Position(4) + 0.035;

s = subplot(3,2,3);
hold on

xlim([-15 15])
ylim([-15 15])
text(-20, 0 ,'A1','FontSize',12,'FontWeight','bold')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WVV1rfParamsRE{ch}(1),WVV1rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WVV1rfParamsLE{ch}(1),WVV1rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end
s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.035;
s.Position(4) = s.Position(4) + 0.035;

s = subplot(3,2,4);
hold on

xlim([-15 15])
ylim([-15 15])
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WUV4rfParamsRE{ch}(1),WUV4rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WUV4rfParamsLE{ch}(1),WUV4rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end
s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.035;
s.Position(4) = s.Position(4) + 0.035;

s = subplot(3,2,5);
hold on

xlim([-15 15])
ylim([-15 15])
text(-20, 0 ,'A2','FontSize',12,'FontWeight','bold')
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WUV1rfParamsRE{ch}(1),WVV1rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WUV1rfParamsLE{ch}(1),WVV1rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end
s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) + 0.035;
s.Position(4) = s.Position(4) + 0.035;

s = subplot(3,2,6);
hold on

xlim([-15 15])
ylim([-15 15])
set(gca,'XAxisLocation','origin','YAxisLocation','origin','tickdir','both',...
    'XTick',-15:5:15,'YTick',-15:5:15,'tickdir','both','FontAngle','italic','FontSize',10)
grid on
axis square
for ch = 1:96
    scatter(WVV4rfParamsRE{ch}(1),WVV4rfParamsRE{ch}(2),'r','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
    scatter(WVV4rfParamsLE{ch}(1),WVV4rfParamsLE{ch}(2),'b','filled','MarkerEdgeColor','w','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
end

s.Position(2) = s.Position(2) - 0.055;
s.Position(3) = s.Position(3) +0.035;
s.Position(4) = s.Position(4) +0.035;

%%


set(gcf,'InvertHardcopy','off','Color','w')
figName = ['AllMonk_RFloc_BE_Barrays','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')