                       clear
close all
clc
%%
% LE = 'XT_LE_mapNoiseRight_nsp2_Nov2018_all_thresh35';
% RE = 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info4';

LE = 'XT_LE_mapNoise_nsp1_Oct2018_all_thresh35';
RE = 'XT_RE_mapNoise_nsp1_Oct2018_all_thresh35';

if contains(RE,'nsp2')
    dataLE = load(LE);
    load(RE)
    dataRE = data.RE;
else
    dataLE = load(LE);
    dataRE = load(RE);
end

plotChs = 0;
%% get receptive field centers and boundaries

dataLE = getReceptiveFields_zScore(dataLE);
dataRE = getReceptiveFields_zScore(dataRE);
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
BEmtx = zeros(10,10,96,55); % setup empty matrix

for ch = 1:96
    for y = 1:10
        for x = 1:10
            if eyeXsort(x) == 1 && eyeYsort(y) == 1 %RE
                BEmtx(y,x,ch) = nanmean(REresps(yInd(y),xInd(x),ch,:));
            elseif eyeXsort(x) == 2 && eyeYsort(y) == 2
                BEmtx(y,x,ch) = nanmean(LErespSample(yInd(y)-5,xInd(x)-5,ch,:));
            end
        end
    end
end
%% PSTHs of BEmtx info
if plotChs == 1
outputDir = sprintf('/Users/brittany/Dropbox/Figures/XT/Mapping/%s/PSTH/ch/',dataRE.array);

if ~exist(outputDir,'dir')
    mkdir(outputDir)
end
cd(outputDir)

stimNdxRE  = dataRE.stimulus ~=0;
blankNdxRE  = dataRE.stimulus ==0;

stimNdxLE  = dataLE.stimulus ~=0;
blankNdxLE  = dataLE.stimulus ==0;

for ch = 1:96
    figure(3)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1000 800])
    set(gcf,'PaperOrientation','Landscape');
    
    nx = 1;
    for y = 1:10
        for x = 1:10
            subplot(10, 10, nx)
            hold on
            if eyeXsort(x) == 1 && eyeYsort(y) == 1 %RE
                xNdx = dataRE.pos_x == sortXs(x);
                yNdx = dataRE.pos_y == sortYs(y);
                stimTrials  = stimNdxRE & yNdx & xNdx;
                
                bK = nanmean(smoothdata(dataRE.bins(blankNdxRE, 1:35 ,ch),'gaussian',3))./0.01;
                sK = nanmean(smoothdata(dataRE.bins(stimNdxRE & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
                
                plot(bK,'-','color',[0.2 0.2 0.2],'LineWidth',0.5)
                plot(sK,'-r','LineWidth',1.25)
                title(sprintf('\n\n\n(%.1f,%.1f)',sortXs(x),sortYs(y)),'FontWeight','normal')
                ylim([0, 300]);
                if nx< 91
                    set(gca,'XTickLabel','')
                end
                
                nx = nx+1;
                clear yNdx;
                clear xNdx;
                clear bK;
                clear sK;
            elseif eyeXsort(x) == 2 && eyeYsort(y) == 2
                xNdx = dataLE.pos_x == sortXs(x);
                yNdx = dataLE.pos_y == sortYs(y);
                stimTrials  = stimNdxLE & yNdx & xNdx;
                
                bK = nanmean(smoothdata(dataLE.bins(blankNdxLE, 1:35 ,ch),'gaussian',3))./0.01;
                sK = nanmean(smoothdata(dataLE.bins(stimNdxLE & xNdx & yNdx, 1:35 ,ch),'gaussian',3))./0.01;
                
                plot(bK,'-','color',[0.2 0.2 0.2],'LineWidth',0.5)
                plot(sK,'-b','LineWidth',1.25)
                title(sprintf('\n\n\n(%.1f,%.1f)',sortXs(x),sortYs(y)),'FontWeight','normal')
                ylim([0, 300]);
                if nx< 91
                    set(gca,'XTickLabel','')
                end
                nx = nx+1;
                clear yNdx;
                clear xNdx;
                clear bK;
                clear sK;
            else % isnan
                axis off
                nx = nx+1;
            end
        end
    end
    
    suptitle(sprintf('%s %s %s channel %d',dataRE.animal, dataRE.array,dataRE.programID, ch))
    figName = ['XT_BE_mappNoiseRight_',dataRE.array,'_PSTHbyLocationCh',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
end
%% heat maps
figDir =  '/Users/brittany/Dropbox/Figures/XT/Mapping/V4/heatmap/ch/';
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir);

BEvect = reshape(BEmtx,[1,numel(BEmtx)]);
minZ = min(BEvect);
maxZ = max(BEvect);
clim = [minZ, maxZ];
cmap = gray(20);
cmap = flipud(cmap);


for ch = 1:96
    figure(4)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 700 700])
    set(gcf,'PaperOrientation','Landscape');

    %s = subplot(dataRE.amap,10,10,ch);
    %s.Position(3) = s.Position(3)+0.02;
    hold on
    imagesc(BEmtx(:,:,ch),clim)
    c = colorbar;
    c.Label.String = 'z score';
    c.FontSize = 12;
    c.FontWeight = 'bold';
    c.FontAngle = 'italic';
    
    
    axis ij;
    colormap(cmap) 
    axis square
    axis tight 
    
    xlabel('x coordinate relative to fixation at (0,0)')
    ylabel('y coordinate relative to fixation at (0,0)')
    set(gca,'tickdir','out','XTick',...
        1:1:length(sortXs),'XTickLabel',sortXs,'YTick',1:1:length(sortYs),'YTickLabel',sortYs)
    title(sprintf('XT %s z scores for both eyes by location channel %d',dataRE.array,ch),...
        'FontSize',14,'FontAngle','italic')
    
    figName = ['XT_BE_mappNoiseRight_',dataRE.array,'_PSTHbyLocationCh',num2str(ch),'.pdf'];
   print(gcf, figName,'-dpdf','-fillpage')
end
end
%%

for ch = 1:96
    BEZs = squeeze(BEmtx(:,:,ch));
    BEZs = inpaint_nans(BEZs);
    [params,rhat,errorsum,cf] = fit_gaussianrf_z2(sortXs,sortYs,BEZs);
    chFit{ch} = cf.paramsadj;
end
%%
location = determineComputer;
if location == 1
    figDir =  ('~/bushnell-local/Dropbox/Figures/XT/Mapping/V4/');
elseif location == 0
    figDir =  ('~/Dropbox/Figures/XT/Mapping/V4/');
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
text(8,12,'missing = interpolated LE and RE','Color',[0.7 0 0.7],'FontWeight','bold','FontSize',14)

plot(0,0,'ok','MarkerFaceColor','k','MarkerSize',8)
title(sprintf('XT %s recepive field centers',dataRE.array),'FontSize',14,'FontWeight','Bold')

figName = ['XT_',dataRE.array,'_receptiveFields_nanInterp','.pdf'];
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
title(sprintf('XT %s recepive field centers',dataRE.array),'FontSize',14,'FontWeight','Bold')
figName = ['XT_',dataRE.array,'_BE_receptiveFields_nancombined','.pdf'];
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
title(sprintf('XT %s recepive field bounds',dataRE.array),'FontSize',14,'FontWeight','Bold')
figName = ['XT_',dataRE.array,'_receptiveFields_nancombined_bounds','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
data.RE = dataRE;
data.LE = dataLE;
data.chReceptiveFieldParams = chFit;
data.chReceptiveFieldParamsBE = chFit;

if location == 1
    outputDir =  '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Mapping/';
    
elseif location == 0
    outputDir = '~/Dropbox/ArrayData/matFiles/V4/Mapping/';
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

saveName = [outputDir 'XT_BE_',data.RE.programID,'_',data.RE.array,'_comboEyes', '.mat'];
save(saveName,'data');
fprintf('%s saved\n', saveName)