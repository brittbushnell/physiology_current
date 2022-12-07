% SFN 2022 physio figures
tic
load('AllMonkRFdata.mat')
%% Extract for ease
XTV4RE = XT.V4.RE;
XTV4LE = XT.V4.LE;
XTV1RE = XT.V1.RE;
XTV1LE = XT.V1.LE;

WUV4RE = WU.V4.RE;
WUV4LE = WU.V4.LE;
WUV1RE = WU.V1.RE;
WUV1LE = WU.V1.LE;

WVV4RE = WV.V4.RE;
WVV4LE = WV.V4.LE;
WVV1RE = WV.V1.RE;
WVV1LE = WV.V1.LE;
%% Make RF & stim maps
fg = figure(2);
clf
pos = fg.Position;
fg.Position = [pos(1) pos(2) 1200 600];
 
plotRadFreqLoc_allMonk_sfn2022(XTV1LE, WUV1LE, WUV1RE, WVV1LE, WVV1RE)
plotRadFreqLoc_allMonk_sfn2022(XTV4LE, WUV4LE, WUV4RE, WVV4LE, WVV4RE)
%% Make "heatmaps" of tuning types
plotRFarrayTuning(XTV1LE, XTV1RE)
plotRFarrayTuning(XTV4LE, XTV4RE)

plotRFarrayTuning(WUV1LE, WUV1RE)
plotRFarrayTuning(WUV4LE, WUV4RE) 

plotRFarrayTuning(WVV1LE, WVV1RE)
plotRFarrayTuning(WVV4LE, WVV4RE)
%%

plotRFarrayTuning1RF(XTV1LE, XTV1RE)
plotRFarrayTuning1RF(XTV4LE, XTV4RE)

plotRFarrayTuning1RF(WUV1LE, WUV1RE)
plotRFarrayTuning1RF(WUV4LE, WUV4RE) 

plotRFarrayTuning1RF(WVV1LE, WVV1RE)
plotRFarrayTuning1RF(WVV4LE, WVV4RE)
%% Summary figures
figure(12)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),800,400])
suptitle('Preferred RFs when only 1 is preferred')
hold on

plotNumChsPref1RF(XTV1LE,XTV1RE);
plotNumChsPref1RF(XTV4LE,XTV4RE);

plotNumChsPref1RF(WUV1LE,WUV1RE);
plotNumChsPref1RF(WUV4LE,WUV4RE);
plotNumChsPref1RF(WVV1LE,WVV1RE);
plotNumChsPref1RF(WVV4LE,WVV4RE);
% [XTv1rf4LE, XTv1rf8LE, XTv1rf16LE, XTv1rf4RE, XTv1rf8RE, XTv1rf16RE ] = plotNumChsPref1RF(XTV1LE,XTV1RE);
% [XTv4rf4LE, XTv4rf8LE, XTv4rf16LE, XTv4rf4RE, XTv4rf8RE, XTv4rf16RE ] = plotNumChsPref1RF(XTV4LE,XTV4RE);
% 
% [WUv1rf4LE, WUv1rf8LE, WUv1rf16LE, WUv1rf4RE, WUv1rf8RE, WUv1rf16RE ] = plotNumChsPref1RF(WUV1LE,WUV1RE);
% [WUv4rf4LE, WUv4rf8LE, WUv4rf16LE, WUv4rf4RE, WUv4rf8RE, WUv4rf16RE ] = plotNumChsPref1RF(WUV4LE,WUV4RE);
% 
% [WVv1rf4LE, WVv1rf8LE, WVv1rf16LE, WVv1rf4RE, WVv1rf8RE, WVv1rf16RE ] = plotNumChsPref1RF(WVV1LE,WVV1RE);
% [WVv4rf4LE, WVv4rf8LE, WVv4rf16LE, WVv4rf4RE, WVv4rf8RE, WVv4rf16RE ] = plotNumChsPref1RF(WVV4LE,WVV4RE);

% save
figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['distRFprefsNarrowTuning','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6 5],'Color','w')
print(figure(12), figName,'-dpdf','-bestfit')
%% same, but all sig correlations
figure(13)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),800,400])
suptitle('RFs with significant correlations')
hold on

[XTv1rf4LE, XTv1rf8LE, XTv1rf16LE, XTv1rf4RE, XTv1rf8RE, XTv1rf16RE ] = plotNumChsPrefRFcorrs(XTV1LE,XTV1RE);
[XTv4rf4LE, XTv4rf8LE, XTv4rf16LE, XTv4rf4RE, XTv4rf8RE, XTv4rf16RE ] = plotNumChsPrefRFcorrs(XTV4LE,XTV4RE);

[WUv1rf4LE, WUv1rf8LE, WUv1rf16LE, WUv1rf4RE, WUv1rf8RE, WUv1rf16RE ] = plotNumChsPrefRFcorrs(WUV1LE,WUV1RE);
[WUv4rf4LE, WUv4rf8LE, WUv4rf16LE, WUv4rf4RE, WUv4rf8RE, WUv4rf16RE ] = plotNumChsPrefRFcorrs(WUV4LE,WUV4RE);

[WVv1rf4LE, WVv1rf8LE, WVv1rf16LE, WVv1rf4RE, WVv1rf8RE, WVv1rf16RE ] = plotNumChsPrefRFcorrs(WVV1LE,WVV1RE);
[WVv4rf4LE, WVv4rf8LE, WVv4rf16LE, WVv4rf4RE, WVv4rf8RE, WVv4rf16RE ] = plotNumChsPrefRFcorrs(WVV4LE,WVV4RE);

% save
figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['distRFprefsSigCorr','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6 5],'Color','w')
print(figure(13), figName,'-dpdf','-bestfit')
%% 
figure(14)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1),pos(2),800,400])
suptitle('RFs with highest significant d''')
hold on

plotMaxDprimeDist(XTV1LE, XTV1RE)
plotMaxDprimeDist(XTV4LE, XTV4RE)

plotMaxDprimeDist(WUV1LE, WUV1RE)
plotMaxDprimeDist(WUV4LE, WUV4RE)

plotMaxDprimeDist(WVV1LE, WVV1RE)
plotMaxDprimeDist(WVV4LE, WVV4RE)

figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['distRFprefsSigDprime','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6 5],'Color','w')
print(figure(14), figName,'-dpdf','-bestfit')
%% get behavior data
[amblySubs,amblyRFdata, amblyVernData, amblyPeriphoData,...
          ctrlSubs,ctrlRFdata, ctrlVernData, ctrlPeriphoData] = BehavAnalysis_AllTasks; 
      
%%
fprintf('%.2f to run all analyses and plots for SfN... \n so far...\n ', toc/60)