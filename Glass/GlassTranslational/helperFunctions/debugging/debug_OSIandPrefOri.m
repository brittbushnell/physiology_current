clear all
close all
clc
tic
%%
load('WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k')
dataT = data.LE;
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/tuningCurves/%s/polar/',dataT.animal, dataT.array,dataT.eye);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder2 = 'spikeCounts';
mkdir(folder2)
cd(sprintf('%s',folder2))
%%
ch = 11;
dt = 1;
dx = 1;
co = 4;
holdout = 0.9;

newFig = 0;
%%
[numOris,numDots,numDxs,numCoh,~,orisDeg,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(orisDeg);

linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
dtNdx = (dataT.numDots == dots(1));
dxNdx = (dataT.dx == dxs(1));
coNdx = (dataT.coh == coherences(1));
orNdx = (dataT.rotation == orisDeg(1));

numStimTrials = round(length(find(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,1)))*holdout);
numNoiseTrials = round(length(find(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,1)))*holdout);
%%
for or = 1:numOris
    
    dtNdx = (dataT.numDots == dots(dt));
    dxNdx = (dataT.dx == dxs(dx));
    coNdx = (dataT.coh == coherences(co));
    orNdx = (dataT.rotation == orisDeg(or));
    
    noiseNdx2 = subsampleBlanks((noiseNdx & dtNdx & dxNdx), numNoiseTrials);
    stimNdx = subsampleBlanks((linNdx & dtNdx & dxNdx & coNdx & orNdx), numStimTrials);
    
    noiseResp = mean(mean(squeeze(dataT.bins(noiseNdx2,5:25,ch))))./0.01;
    linResp = mean(mean(squeeze((dataT.bins((stimNdx),5:25,ch)))))./0.01;
    baseSub = linResp;% - noiseResp;
    
    % get inputs for calculating orientation
    % selectivity
    ori2 = 2*(radOri(or));
    expon = 1i*(ori2);
    exVar = exp(expon);
    respVect(or,:) = baseSub*exVar;
    denomVect(or,:) = (abs(baseSub));
    
    % preferred orientation
    prefNum(or,:) = baseSub .* (sin(ori2));
    prefDenom(or,:) = baseSub .* (cos(ori2));
    
    %clear noiseResp; clear linResp; clear baseSub;
    
end
v = sum(respVect);
denom = sum((denomVect));
SItmp = abs(v) / denom;

% preferred orientation
sumPrefNum = sum(prefNum);
sumPrefDenom = sum(prefDenom);
%fra = sumPrefNum/sumPrefDenom;
ot = (atan2d(sumPrefNum,sumPrefDenom))/2;

% ot2 = mod(rad2deg(ot),180)/2; % convert back to degrees, and bring back to being between 0 and 180

% if ot < 0
%     oriTmp(nb,1) = ot +180;
% else
%     oriTmp(nb,1) = ot;
% end
%% plot prep
linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
blankNdx = dataT.numDots == 0;
%for ch = 72%1:96
% if dataT.goodCh(ch) == 1
blankMean(1,ch) = mean(mean(squeeze(dataT.bins((blankNdx),5:25,ch))))./0.01;
spikeCountPerTrial = nan(numOris,36);

for or = 1:numOris 
    dtNdx = dataT.numDots == dots(dt);
    dxNdx = dataT.dx == dxs(dx);
    coNdx = dataT.coh == 1;
    orNdx = dataT.rotation == orisDeg(or);
    
    stimMean(or,1) = mean(mean(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch))))./0.01;
    noiseMean = mean(mean(squeeze(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,ch))))./0.01;
    stimMeanBaseSub(or,1) = stimMean(or,1);% - noiseMean(dt,dx,ch);
    spikeCountPerTrial(or,:) = sum(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch)),2)';
end

% polar plot limits
orisRad = 0:45:315;
orisRad(end+1) = 0;
orisRad = deg2rad(orisRad);

lin = (stimMean);
noise = (noiseMean);
blank = (blankMean);

linMax = max(lin(:));
noiseMax = max(noise(:));
maxData = max([linMax,noiseMax,blank]);
minData = min([linMax,noiseMax,blank]);
extremes = max([abs(minData),maxData]);
extremes = extremes+(extremes/2);

minLim = round(extremes*-1);
maxLim = round(extremes);
max10 = max(lin(:))+(max(lin(:))/10);

% histogram limits
tp = (spikeCountPerTrial);
tp(isnan(tp)) = [];
tp = squeeze(tp);
maxSpikesCh = max(tp(:))+1;

%[~,maxTrialsCh] = mode(tp)+2;
%% polar plot
if newFig == 1
    figure
else
    figure(13)
    clf
end
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 300])
set(gcf,'PaperOrientation','Landscape');
ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch)});
ttl.Position = [0.5,-0.025,0];
axis off

linResps = repmat(squeeze(stimMean),[2,1]);
linResps(end+1) = linResps(1);
noiseResp = (squeeze(noiseMean));
noiseVect = repmat(noiseResp,[1,length(orisRad)]);
blankResp = (squeeze(blankMean(ch)));
blankVect = repmat(blankResp,[1,length(orisRad)]);
%%
sp = subplot(1,5,1,polaraxes); %position = [left bottom width height]
sp.Position(1) = sp.Position(1)-0.02;
sp.Position(2) = sp.Position(2)-0.025;
sp.Position(3) = sp.Position(3);%-0.02;
sp.Position(4) = sp.Position(4);%-0.02;

hold on
l = polarplot(orisRad',linResps,'-o','MarkerSize',4);
l.LineWidth = 1;

if contains(dataT.eye,'LE')
    l.Color = [0 0 1 0.8];
else
    l.Color = [1 0 0 0.8];
end

pOri = (ot);
pOriRad = deg2rad(ot);
pOri180 = (ot+180);
pOriRad180 = deg2rad(ot+180);

polarplot(pOriRad,max10,'.k','MarkerSize',13);
polarplot(pOriRad180,max10,'.k','MarkerSize',13);

text(pOriRad-0.1,max10+2,sprintf('%.1f',pOri),'FontSize',9)
text(pOriRad180-0.1,max10+2,sprintf('%.1f',pOri180),'FontSize',9)

n = polarplot(orisRad,noiseVect,'-o','MarkerSize',4);
n.Color = [1 0.5 0.1 0.8];
n.LineWidth = 1;

b = polarplot(orisRad,blankVect,'-o','MarkerSize',4);
b.Color = [0.5 0.5 0.5 0.8];
b.LineWidth = 1;
set(gca,'color','none')

ax = gca;
ax.RLim  = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];
set(gca,'ThetaTick',0:45:315)

tO = title(sprintf('OSI: %.3f',SItmp));
tO.Position(2) = tO.Position(2)-0.01;
tO.FontSize = 10;
dtString = sprintf('%d dots',dots(dt));
text(2*pi-.15,-(max10*3),dtString,'FontSize',12,'FontWeight','Bold','HorizontalAlignment','center'); % because it's on a polar axis, needs to be theta,rho
dxString = sprintf('dx %.2f',dxs(dx));
text((2*pi),-(max10*3),dxString,'FontSize',12,'FontWeight','Bold','HorizontalAlignment','center');
%%
orisDeg = unique(dataT.rotation);

for or = 1:numOris
    orNdx = (dataT.rotation == orisDeg(or));
    dtNdx = dataT.numDots == dots(dt);
    dxNdx = dataT.dx == dxs(dx);
    
    hp = subplot(1,5,or+1);
    hp.Position(4) = hp.Position(4)-0.25; % position = [left bottom width height]
    hp.Position(3) = hp.Position(3)+0.015;
    hp.Position(2) = hp.Position(2)+0.015;
    hp.Position(1) = hp.Position(1)+0.02;
    
    hold on
    h = histogram(spikeCountPerTrial(or,:),'binWidth',1,'FaceColor','k','EdgeColor','w');
    ylim([0 20])
    xlim([-1 maxSpikesCh])
    histBins = [h.Values;h.BinEdges(2:end)];
    a = find(histBins(1,:) == 0); % find the number of bins in the histogram that = 0
    
    set(gca,'tickdir','out','Layer','top')
    
    
    title(orisDeg(or))
    xlabel('spike count')
    ylabel('# trials')
    
    if length(a)>10 % if there are more than 5 channels with bins that equal zero, then break the x axis
        breakStart = a(2);
        breakEnd = a(end-1);
        breakxaxis2([breakStart breakEnd]);
    end
    
    if max(h.BinEdges)< maxSpikesCh/2
        breakStart = h.BinEdges(end)+1;
        breakEnd = maxSpikesCh-1;
        breakxaxis2([breakStart breakEnd]);
    end
    
end