function plotGlass_triplot_allMonk(WUV1, WUV4, WVV1, WVV4, XTV1, XTV4)

%%
WUV1dPRE = getGlassDprimeVectTriplots(WUV1.conRadRE.radBlankDprime,WUV1.conRadRE.conBlankDprime,WUV1.conRadRE.noiseBlankDprime, WUV1.conRadRE.goodCh, WUV1.conRadRE.inStim);
WVV1dPRE = getGlassDprimeVectTriplots(WVV1.conRadRE.radBlankDprime,WVV1.conRadRE.conBlankDprime,WVV1.conRadRE.noiseBlankDprime, WVV1.conRadRE.goodCh, WVV1.conRadRE.inStim);
XTV1dPRE = getGlassDprimeVectTriplots(XTV1.conRadRE.radBlankDprime,XTV1.conRadRE.conBlankDprime,XTV1.conRadRE.noiseBlankDprime, XTV1.conRadRE.goodCh, XTV1.conRadRE.inStim);
v1dRE = cat(1,WUV1dPRE,WVV1dPRE);%,XTV1dPLE);
    
WUV1dPLE = getGlassDprimeVectTriplots(WUV1.conRadLE.radBlankDprime,WUV1.conRadLE.conBlankDprime,WUV1.conRadLE.noiseBlankDprime, WUV1.conRadLE.goodCh, WUV1.conRadLE.inStim);
WVV1dPLE = getGlassDprimeVectTriplots(WVV1.conRadLE.radBlankDprime,WVV1.conRadLE.conBlankDprime,WVV1.conRadLE.noiseBlankDprime, WVV1.conRadLE.goodCh, WVV1.conRadLE.inStim);
XTV1dPLE = getGlassDprimeVectTriplots(XTV1.conRadLE.radBlankDprime,XTV1.conRadLE.conBlankDprime,XTV1.conRadLE.noiseBlankDprime, XTV1.conRadLE.goodCh, XTV1.conRadLE.inStim);
v1dLE = cat(1,WUV1dPLE,WVV1dPLE);%,XTV1dPLE);

WUV4dPRE = getGlassDprimeVectTriplots(WUV4.conRadRE.radBlankDprime,WUV4.conRadRE.conBlankDprime,WUV4.conRadRE.noiseBlankDprime, WUV4.conRadRE.goodCh, WUV4.conRadRE.inStim);
WVV4dPRE = getGlassDprimeVectTriplots(WVV4.conRadRE.radBlankDprime,WVV4.conRadRE.conBlankDprime,WVV4.conRadRE.noiseBlankDprime, WVV4.conRadRE.goodCh, WVV4.conRadRE.inStim);
XTV4dPRE = getGlassDprimeVectTriplots(XTV4.conRadRE.radBlankDprime,XTV4.conRadRE.conBlankDprime,XTV4.conRadRE.noiseBlankDprime, XTV4.conRadRE.goodCh, XTV4.conRadRE.inStim);
v4dRE = cat(1,WUV4dPRE,WVV4dPRE);%,XTV1dPLE);

WUV4dPLE = getGlassDprimeVectTriplots(WUV4.conRadLE.radBlankDprime,WUV4.conRadLE.conBlankDprime,WUV4.conRadLE.noiseBlankDprime, WUV4.conRadLE.goodCh, WUV4.conRadLE.inStim);
WVV4dPLE = getGlassDprimeVectTriplots(WVV4.conRadLE.radBlankDprime,WVV4.conRadLE.conBlankDprime,WVV4.conRadLE.noiseBlankDprime, WVV4.conRadLE.goodCh, WVV4.conRadLE.inStim);
XTV4dPLE = getGlassDprimeVectTriplots(XTV4.conRadLE.radBlankDprime,XTV4.conRadLE.conBlankDprime,XTV4.conRadLE.noiseBlankDprime, XTV4.conRadLE.goodCh, XTV4.conRadLE.inStim);
v4dLE = cat(1,WUV4dPLE,WVV4dPLE);%,XTV1dPLE);
%% Amblyopes
% at the end of this section, you end up with a n x 8 matrix.  Each row is
% a channel from one of the 4 eyes/arrays/animals matrices. 
% 
% column 1:3 are the d' to  radial, concentric, and dipole 
% column 4 is the vector sum of columns 1:3
% column 5 is an index for which of the eye/array matrices the data belong
% to
% column 6:8 are the (r,g,b) values for the data based on sorted vector sum

ndx1 = ones(size(v1dLE,1),1);
ndx2 = ones(size(v1dRE,1),1)+1;
ndx3 = ones(size(v4dLE,1),1)+2;
ndx4 = ones(size(v4dRE,1),1)+3;

allDps = cat(1,v1dLE, v1dRE, v4dLE, v4dRE); 
allDps(:,4) = sqrt(allDps(:,1).^2 + allDps(:,2).^2 + allDps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
allDps(:,5) = [ndx1;ndx2;ndx3;ndx4];

[~,sortNdx] = sort(allDps(:,4),'descend');
sortDps = allDps(sortNdx,:);


cmap = gray(length(allDps)); 
sortDps(:,6:8) = cmap; % make black be highest, white lowest
%% break sortDps into smaller matrices for each of the subplots

v1LEsort = sortDps(sortDps(:,5) == 1,:);
v1REsort = sortDps(sortDps(:,5) == 2,:);
v4LEsort = sortDps(sortDps(:,5) == 3,:);
v4REsort = sortDps(sortDps(:,5) == 4,:);
%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600]);
set(gcf,'PaperOrientation','landscape')

t = suptitle('Amblyopic dPrimes for each pattern in V1 and V4');
t.Position(2) = t.Position(2) +0.026;
t.FontWeight = 'bold';
t.FontSize = 18;
%
s = subplot(2,2,1);
hold on

rcd = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,sortDps(1,4))
title(sprintf('FE n: %d',length(v1dLE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;
%
s = subplot(2,2,2);
hold on

rcd = v1REsort(:,1:3);
cmp = v1REsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,sortDps(1,4))
title(sprintf('AE n: %d',length(v1dRE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;
%
s = subplot(2,2,3);
hold on
rcd = v4LEsort(:,1:3);
cmp = v4LEsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,sortDps(1,4))

title(sprintf('n: %d',length(v4dLE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

s = subplot(2,2,4);
hold on
rcd = v4REsort(:,1:3);
cmp = v4REsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,sortDps(1,4))
title(sprintf('n: %d',length(v4dRE)))
s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;

figName = 'triplot_ambly_gray.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%% XT
clear cmap;
clear ndx1; clear ndx2; clear ndx3; clear ndx4;
ndx1 = ones(size(XTV1dPLE,1),1);
ndx2 = ones(size(XTV1dPRE,1),1)+1;
ndx3 = ones(size(XTV4dPLE,1),1)+2;
ndx4 = ones(size(XTV4dPRE,1),1)+3;

XTdps = cat(1,XTV1dPLE, XTV1dPRE, XTV4dPLE, XTV4dPRE); 
XTdps(:,4) = sqrt(XTdps(:,1).^2 + XTdps(:,2).^2 + XTdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
XTdps(:,5) = [ndx1;ndx2;ndx3;ndx4];

[~,sortNdx] = sort(XTdps(:,4),'descend');
XTsortDps = XTdps(sortNdx,:);

cmap = gray(length(XTdps)); 
XTsortDps(:,6:8) = cmap; % make black be highest, white lowest
%% break sortDps into smaller matrices for each of the subplots

XTv1LEsort = XTsortDps(XTsortDps(:,5) == 1,:);
XTv1REsort = XTsortDps(XTsortDps(:,5) == 2,:);
XTv4LEsort = XTsortDps(XTsortDps(:,5) == 3,:);
XTv4REsort = XTsortDps(XTsortDps(:,5) == 4,:);
%%
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600]);
set(gcf,'PaperOrientation','landscape')

t = suptitle('Control dPrimes for each pattern in V1 and V4');
t.Position(2) = t.Position(2) +0.026;
t.FontWeight = 'bold';
t.FontSize = 18;
%
s = subplot(2,2,1);
hold on

rcd = XTv1LEsort(:,1:3);
cmp = XTv1LEsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,XTsortDps(1,4))
title(sprintf('LE n: %d',length(XTV1dPLE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

s = subplot(2,2,2);
hold on

rcd = XTv1REsort(:,1:3);
cmp = XTv1REsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,XTsortDps(1,4))
title(sprintf('RE n: %d',length(XTV1dPRE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

s = subplot(2,2,3);
hold on

rcd = XTv4LEsort(:,1:3);
cmp = XTv4LEsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,XTsortDps(1,4))
title(sprintf('LE n: %d',length(XTV4dPLE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

s = subplot(2,2,4);
hold on

rcd = XTv4REsort(:,1:3);
cmp = XTv4REsort(:,6:8);

triplotter_Glass_allMonk(rcd,cmp,XTsortDps(1,4))
title(sprintf('RE n: %d',length(XTV4dPRE)))

s.Position(1) = s.Position(1) - 0.05;
s.Position(2) = s.Position(2) - 0.05;
s.Position(3) = s.Position(3) + 0.05;
s.Position(4) = s.Position(4) + 0.05;
clear rcd; clear cmp;

figName = 'triplot_control_gray.pdf';
print(gcf, figName,'-dpdf','-bestfit')
%% plot triplot for the amblyopes using red for WV and blue for WU
% % WU
% clear cmap;
% clear ndx1; clear ndx2; clear ndx3; clear ndx4;
% ndx1 = ones(size(WUV1dPLE,1),1);
% ndx2 = ones(size(WUV1dPRE,1),1)+1;
% ndx3 = ones(size(WUV4dPLE,1),1)+2;
% ndx4 = ones(size(WUV4dPRE,1),1)+3;
% 
% WUdps = cat(1,WUV1dPLE, WUV1dPRE, WUV4dPLE, WUV4dPRE); 
% WUdps(:,4) = sqrt(WUdps(:,1).^2 + WUdps(:,2).^2 + WUdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
% WUdps(:,5) = [ndx1;ndx2;ndx3;ndx4];
% 
% [~,sortNdx] = sort(WUdps(:,4),'descend');
% WUsortDps = WUdps(sortNdx,:);
% 
% cmapWU =  flipud(brewermap(length(WUdps),'Blues'));
% WUsortDps(:,6:8) = cmapWU; 
% 
% % WV
% clear cmap;
% clear ndx1; clear ndx2; clear ndx3; clear ndx4;
% ndx1 = ones(size(WVV1dPLE,1),1);
% ndx2 = ones(size(WVV1dPRE,1),1)+1;
% ndx3 = ones(size(WVV4dPLE,1),1)+2;
% ndx4 = ones(size(WVV4dPRE,1),1)+3;
% 
% WVdps = cat(1,WVV1dPLE, WVV1dPRE, WVV4dPLE, WVV4dPRE); 
% WVdps(:,4) = sqrt(WVdps(:,1).^2 + WVdps(:,2).^2 + WVdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
% WVdps(:,5) = [ndx1;ndx2;ndx3;ndx4];
% 
% [~,sortNdx] = sort(WVdps(:,4),'descend');
% WVsortDps = WVdps(sortNdx,:);
% 
% cmapWV =  flipud(brewermap(length(WVdps),'Reds'));
% WVsortDps(:,6:8) = cmapWV; 
% %% break sortDps into smaller matrices for each of the subplots
% 
% WUv1LEsort = WUsortDps(WUsortDps(:,5) == 1,:);
% WUv1REsort = WUsortDps(WUsortDps(:,5) == 2,:);
% WUv4LEsort = WUsortDps(WUsortDps(:,5) == 3,:);
% WUv4REsort = WUsortDps(WUsortDps(:,5) == 4,:);
% 
% WVv1LEsort = WVsortDps(WVsortDps(:,5) == 1,:);
% WVv1REsort = WVsortDps(WVsortDps(:,5) == 2,:);
% WVv4LEsort = WVsortDps(WVsortDps(:,5) == 3,:);
% WVv4REsort = WVsortDps(WVsortDps(:,5) == 4,:);
% %%
% 
% figure(3)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 900 600]);
% set(gcf,'PaperOrientation','landscape')
% % 
% % t = suptitle('Amblyopic dPrimes for each pattern in V1 and V4');
% % t.Position(2) = t.Position(2) +0.026;
% % t.FontWeight = 'bold';
% % t.FontSize = 18;
% %
% s = subplot(2,2,1);
% hold on
% 
% rcdWU = WUv1LEsort(:,1:3);
% cmpWU = WUv1LEsort(:,6:8);
% ax1 = triplotter_Glass_allMonk(rcdWU,cmpWU);
% 
% rcdWV = WVv1LEsort(:,1:3);
% cmpWV = WVv1LEsort(:,6:8);
% ax2 = triplotter_Glass_allMonk(rcdWV,cmpWV);
% 
% linkaxes([ax1,ax2])
% 
% ax2.Visible = 'off';
% set([ax1,ax2],'Position', [0.12889 0.53384 0.28688 0.39116])
% 
% colormap(ax1,flipud(cmpWU));
% c1 = colorbar(ax1,'Position',[0.0859 0.53384 0.017778 0.39]);
% c1.TickDirection = 'out';
% c1.Ticks = 0:0.25:1;
% c1.TickLabels = round(linspace(0,WUsortDps(1,4),5),1);
% c1.Label.String = 'WU Vector sum of dPrimes';
% c1.FontAngle = 'italic';
% c1.FontSize = 11;
% 
% 
% colormap(ax2,flipud(cmpWV)); 
% c2 = colorbar(ax2,'Position',[0.41167 0.53384 0.017778 0.39]);
% c2.TickDirection = 'out';
% c2.Ticks = 0:0.25:1;
% c2.TickLabels = round(linspace(0,WVsortDps(1,4),5),1);
% c2.Label.String = 'WV Vector sum of dPrimes';
% c2.FontAngle = 'italic';
% c2.FontSize = 11;
% 
% 
% 
% 
% title({sprintf('WU FE n: %d',length(WUV1dPLE));...
%    sprintf('WV FE n: %d',length(WVV1dPLE))})
% 
% s.Position(1) = s.Position(1) - 0.05;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.05;
% s.Position(4) = s.Position(4) + 0.05;
% 
% %%
% s = subplot(2,2,2);
% hold on
% 
% rcd = WUv1REsort(:,1:3);
% cmp = WUv1REsort(:,6:8);
% 
% triplotter_Glass_allMonk(rcd,cmp,WUsortDps(1,4))
% title(sprintf('RE n: %d',length(WUV1dPRE)))
% 
% s.Position(1) = s.Position(1) - 0.05;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.05;
% s.Position(4) = s.Position(4) + 0.05;
% clear rcd; clear cmp;
% 
% s = subplot(2,2,3);
% hold on
% 
% rcd = WUv4LEsort(:,1:3);
% cmp = WUv4LEsort(:,6:8);
% 
% triplotter_Glass_allMonk(rcd,cmp,WUsortDps(1,4),'west')
% title(sprintf('LE n: %d',length(WUV4dPLE)))
% 
% s.Position(1) = s.Position(1) - 0.05;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.05;
% s.Position(4) = s.Position(4) + 0.05;
% clear rcd; clear cmp;
% 
% s = subplot(2,2,4);
% hold on
% 
% rcd = WUv4REsort(:,1:3);
% cmp = WUv4REsort(:,6:8);
% 
% triplotter_Glass_allMonk(rcd,cmp,WUsortDps(1,4))
% title(sprintf('RE n: %d',length(WUV4dPRE)))
% 
% s.Position(1) = s.Position(1) - 0.05;
% s.Position(2) = s.Position(2) - 0.05;
% s.Position(3) = s.Position(3) + 0.05;
% s.Position(4) = s.Position(4) + 0.05;
% clear rcd; clear cmp;
% 
% figName = 'triplot_amblyope_redBlue.pdf';
% print(gcf, figName,'-dpdf','-bestfit')









