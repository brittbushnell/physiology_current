clear all
close all
clc
tic
%%

% LE = 'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35_info3_resps';
% RE = 'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35_info3_resps';

% LE = 'WV_LE_MapNoise_nsp1_Jan2019_all_thresh35_info3_resps';
% RE = 'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info3_resps';
 
% LE = 'XT_LE_mapNoiseRight_nsp2_Nov2018_all_thresh35_resps';
% RE = 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3_resps';

% LE = 'XT_LE_mapNoise_nsp1_Oct2018_all_thresh35_resps';
% RE = 'XT_RE_mapNoise_nsp1_Oct2018_all_thresh35_resps';

% LE = 'WU_LE_GratingsMapRF_nsp2_20170426_003_thresh35_info3_resps';
% RE = 'WU_RE_GratingsMapRF_nsp2_20170426_001_thresh35_info3_resps';

% LE = 'WU_LE_GratingsMapRF_nsp1_20170426_003_thresh35_info3_resps';
% RE = 'WU_RE_GratingsMapRF_nsp1_20170426_001_thresh35_info3_resps';

%%
load(LE);
dataLE = data.LE;
clear data;

load(RE);
dataRE = data.RE;
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/',dataRE.animal,dataRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/',dataRE.animal, dataRE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%%
figure(1)
clf
hold on
for ch = 1:96 
    scatter(dataRE.chReceptiveFieldParams{ch}(1),dataRE.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
    scatter(dataLE.chReceptiveFieldParams{ch}(1),dataLE.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end
if contains(dataRE.animal,'WU')
    viscircles([0,0],1.5, 'color',[0.2 0.2 0.2]);
else
    viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
end
plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)
text(10,10,'RE','Color',[0.8 0 0.4],'FontWeight','bold','FontSize',12)
text(10,11,'LE','Color',[0.2 0.4 1],'FontWeight','bold','FontSize',12)

title(sprintf('%s %s recepive field centers',dataRE.animal, dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = [dataRE.animal,'_',dataRE.array,'_LEvRE','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%% figures with RF bounds
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 950 650])
set(gcf,'PaperOrientation','Landscape');
t = suptitle(sprintf('%s %s receptive fields',dataRE.animal,dataRE.array));
t.Position(1) = t.Position(1)+0.015;
t.Position(2) = t.Position(2)+0.015;
t.FontSize = 16;
s = subplot(2,3,1);
hold on
s.Position(1) = s.Position(1)-0.032;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;

for ch = 1:96 
    scatter(dataLE.chReceptiveFieldParams{ch}(1),dataLE.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);

    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('LE recepive field centers','FontSize',12)
%
s = subplot(2,3,2);
hold on
s.Position(1) = s.Position(1)-0.015;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;

for ch = 1:96 
    scatter(dataRE.chReceptiveFieldParams{ch}(1),dataRE.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);
    scatter(dataLE.chReceptiveFieldParams{ch}(1),dataLE.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.7);
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('recepive field centers','FontSize',14,'FontWeight','Bold')
%
s = subplot(2,3,3);
hold on
s.Position(1) = s.Position(1)+0.015;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;
for ch = 1:96 
    scatter(dataRE.chReceptiveFieldParams{ch}(1),dataRE.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.7);

    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('RE recepive field centers','FontSize',14,'FontWeight','Bold')
%

s = subplot(2,3,4);
hold on
s.Position(1) = s.Position(1)-0.032;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;

for ch = 1:96 
    draw_ellipse(dataLE.chReceptiveFieldParams{ch},[0.2 0.4 1])

    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('LE recepive field centers','FontSize',14,'FontWeight','Bold')
%
s = subplot(2,3,5);
hold on
s.Position(1) = s.Position(1)-0.015;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;

for ch = 1:96    
    draw_ellipse(dataRE.chReceptiveFieldParams{ch},[0.8 0 0.4])
    draw_ellipse(dataLE.chReceptiveFieldParams{ch},[0.2 0.4 1])
    
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('recepive field bounds','FontSize',14,'FontWeight','Bold')
%
s = subplot(2,3,6);
hold on

% s.Position(1) = s.Position(1)+0.015;
s.Position(2) = s.Position(2)-0.05;
s.Position(3) = s.Position(3)+0.045;
s.Position(4) = s.Position(4)+0.035;

for ch = 1:96 
    draw_ellipse(dataRE.chReceptiveFieldParams{ch},[0.8 0 0.4])
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)

title('RE recepive field bounds','FontSize',14,'FontWeight','Bold')

%
figName = [dataRE.animal,'_',dataRE.array,'_LEvRE_centerBounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(3)

hold on
for ch = 1:96 
    draw_ellipse(dataRE.chReceptiveFieldParams{ch},[0.8 0 0.4])
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)
title(sprintf('%s %s RE recepive field bounds',dataRE.animal, dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = [dataRE.animal,'_',dataRE.array,'_RE_RFbounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')

%%
figure(4)

hold on
for ch = 1:96 
    draw_ellipse(dataLE.chReceptiveFieldParams{ch},[0.2 0.4 1])
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)
title(sprintf('%s %s LE recepive field bounds',dataRE.animal, dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = [dataRE.animal,'_',dataRE.array,'_LE_RFbounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure(5)

hold on
for ch = 1:96 
    draw_ellipse(dataLE.chReceptiveFieldParams{ch},[0.2 0.4 1])
    draw_ellipse(dataRE.chReceptiveFieldParams{ch},[0.8 0 0.4])
    grid on;
    xlim([-14,14])
    ylim([-14,14])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',6)
title(sprintf('%s %s recepive field bounds',dataRE.animal, dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = [dataRE.animal,'_',dataRE.array,'_BE_RFbounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
