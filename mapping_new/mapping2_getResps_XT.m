clear all
close all
clc
%%

LE = 'XT_LE_mapNoiseRight_nsp2_Nov2018_all_thresh35_resps';
RE = 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3_resps';


load(LE);
dataLE = data.LE;
clear data;

load(RE);
dataRE = data.RE;
%% get info from data structures

LEresps = dataLE.stimZscore;
LEx = unique(dataLE.pos_x);
LEy = unique(dataLE.pos_y);

REresps = dataRE.stimZscore;
REy = unique(dataRE.pos_y);
REx = unique(dataRE.pos_x);

RErepeats = size(REresps,4);
LErepeats = size(LEresps,4);
LErespSample = datasample(LEresps,RErepeats,4);
%%
allXs = [REx,LEx];
[sortXs, xInd] = sort(allXs); 
allYs = [REy,LEy];
[sortYs, yInd] = sort(allYs,'descend');
eyeRef = [1 1 1 1 1 2 2 2 2 2];
eyeXsort = eyeRef(xInd);
eyeYsort = eyeRef(yInd);
%%
BEmtx = nan(10,10,96,55); % setup empty matrix

for ch = 1%:96
    for y = 1:10
        for x = 1:10
            if eyeXsort(x) == 1 && eyeYsort(y) == 1
                BEmtx(y,x,ch) = nanmean(REresps(yInd(y),xInd(x),ch,:));
            elseif eyeXsort(x) == 2 && eyeYsort(y) == 2
                BEmtx(y,x,ch) = nanmean(LErespSample(yInd(y)-5,xInd(x)-5,ch,:));
            end
        end        
    end
end
%%
for ch = 1:96
    BEZs = squeeze(BEmtx(:,:,ch));
    [params,rhat,errorsum,cf] = fit_gaussianrf_z2(sortXs,sortYs,BEZs);
    chFit{ch} = cf.paramsadj;
end
%%
location = determineComputer;
if location == 1
    figDir =  ('~/bushnell-local/Dropbox/Figures/XT/mapNoiseRight/');
elseif location == 0
    figDir =  ('~/Dropbox/Figures/XT/mapNoiseRight/');
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
figure%(6)
clf
hold on
for ch = 1:96
    scatter(dataRE.chReceptiveFieldParams{ch}(1),dataRE.chReceptiveFieldParams{ch}(2),35,[0.8 0 0.4],'filled','MarkerFaceAlpha',0.3);
    scatter(dataLE.chReceptiveFieldParams{ch}(1),dataLE.chReceptiveFieldParams{ch}(2),35,[0.2 0.4 1],'filled','MarkerFaceAlpha',0.3);
    scatter(chFit{ch}(1),chFit{ch}(2),35,[0.7 0 0.7],'filled','MarkerFaceAlpha',0.8);
    
    grid on;
    xlim([-15,15])
    ylim([-15,15])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);
text(10,10,'RE','Color',[0.8 0 0.4],'FontWeight','bold','FontSize',14)
text(10,11,'LE','Color',[0.2 0.4 1],'FontWeight','bold','FontSize',14)
text(10,12,'summed LE and RE','Color',[0.7 0 0.7],'FontWeight','bold','FontSize',14)

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',8)
title('XT V4 recepive field centers','FontSize',14,'FontWeight','Bold')

figName = ['XT_V4_receptiveFields_sumLEandRE','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure%(6)
clf
hold on
for ch = 1:96
    scatter(chFit{ch}(1),chFit{ch}(2),35,[0.7 0 0.7],'filled','MarkerFaceAlpha',0.7);
    
    grid on;
    xlim([-15,15])
    ylim([-15,15])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',8)
title('XT V4 recepive field centers','FontSize',14,'FontWeight','Bold')
figName = ['XT_V4_BE_receptiveFields','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
figure%(6)
clf
hold on
for ch = 1:96
    draw_ellipse(chFit{ch},[0.7 0 0.7])

    grid on;
    xlim([-15,15])
    ylim([-15,15])
    set(gca,'YAxisLocation','origin','XAxisLocation','origin',...
        'Layer','top','FontWeight','bold','FontSize',14,'FontAngle','italic')
    axis square
end

viscircles([0,0],0.75, 'color',[0.2 0.2 0.2]);

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',8)
title('XT V4 recepive field bounds','FontSize',14,'FontWeight','Bold')
figName = ['XT_V4_receptiveFields_sumLEandRE_bounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
data.RE = dataRE;
data.LE = dataLE;
data.chReceptiveFieldParams = chFit;

if location == 1
    outputDir =  '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/GratMapRF/';
    
elseif location == 0
    outputDir = '~/Dropbox/ArrayData/matFiles/V4/GratMapRF/';
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

saveName = [outputDir 'XT_BE_mapNoiseRight_V4', '.mat'];
save(saveName,'data');
fprintf('%s saved\n', saveName)