clear all
%close all
clc
%%
load('WU_LE_GlassTR_nsp2_20170825_002_s1_perm2k')
dataT = data.LE;
%%
ch = 72;
dt = 2;
dx = 2;
co = 4;
holdout = 0.9;

%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
radOri = deg2rad(oris);

linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
dtNdx = (dataT.numDots == dots(dt));
dxNdx = (dataT.dx == dxs(dx));
coNdx = (dataT.coh == coherences(co));
orNdx = (dataT.rotation == oris(1));

numStimTrials = round(length(find(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,1)))*holdout);
numNoiseTrials = round(length(find(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,1)))*holdout);
%%

for or = 1:numOris
    
    dtNdx = (dataT.numDots == dots(dt));
    dxNdx = (dataT.dx == dxs(dx));
    coNdx = (dataT.coh == coherences(co));
    orNdx = (dataT.rotation == oris(or));
    
    noiseNdx2 = subsampleBlanks((noiseNdx & dtNdx & dxNdx), numNoiseTrials);
    stimNdx = subsampleBlanks((linNdx & dtNdx & dxNdx & coNdx & orNdx), numStimTrials);
    
    noiseResp = mean(mean(squeeze(dataT.bins(noiseNdx2,5:25,ch))))./0.01;
    linResp = mean(mean(squeeze((dataT.bins((stimNdx),5:25,ch)))))./0.01;
    baseSub = linResp - noiseResp;
    
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

sumPrefNum = sum(prefNum);
sumPrefDenom = sum(prefDenom);
fra = sumPrefNum/sumPrefDenom;
ot = (atand(fra))/2;

% ot2 = mod(rad2deg(ot),180)/2; % convert back to degrees, and bring back to being between 0 and 180

% if ot < 0
%     oriTmp(nb,1) = ot +180;
% else
%     oriTmp(nb,1) = ot;
% end
%% plot preparation
linNdx = dataT.type == 3;
noiseNdx = dataT.type == 0;
blankNdx = dataT.numDots == 0;
%for ch = 72%1:96
% if dataT.goodCh(ch) == 1
blankMean(1,ch) = mean(mean(squeeze(dataT.bins((blankNdx),5:25,ch))))./0.01;
for or = 1:numOris

            dtNdx = dataT.numDots == dots(dt);
            dxNdx = dataT.dx == dxs(dx);
            coNdx = dataT.coh == 1;
            orNdx = dataT.rotation == oris(or);
            
            stimMean(or,dt,dx,ch) = mean(mean(squeeze(dataT.bins((linNdx & dtNdx & dxNdx & coNdx & orNdx),5:25,ch))))./0.01;
            noiseMean(dt,dx,ch) = mean(mean(squeeze(dataT.bins((noiseNdx & dtNdx & dxNdx),5:25,ch))))./0.01;
            stimMeanBaseSub(or,dt,dx,ch) = stimMean(or,dt,dx,ch) - noiseMean(dt,dx,ch);
end
%   end
%end
%% figure 13 plot with noise
oris = 0:45:315;
oris(end+1) = 0;
oris = deg2rad(oris);

%for ch = 72 %1:96
%    if dataT.goodCh(ch) == 1
lin = (squeeze(stimMean(:,:,:,ch)));
noise = (squeeze(noiseMean(:,:,ch)));
blank = (squeeze(blankMean(ch)));

linMax = max(lin(:));
noiseMax = max(noise(:));
maxData = max([linMax,noiseMax,blank]);
minData = min([linMax,noiseMax,blank]);
extremes = max([abs(minData),maxData]);
extremes = extremes+(extremes/2);

minLim = round(extremes*-1);
maxLim = round(extremes);
max10 = max(lin(:))+(max(lin(:))/10);

figure(13)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

if contains(dataT.eye,'LE')
    text(-0.14,1.1,'Translational Glass','color',[0 0 1],'FontSize',12,'FontWeight','bold');
else
    text(-0.14,1.1,'Translational Glass','color',[1 0 0],'FontSize',12,'FontWeight','bold');
end
text(-0.14,1.08,'Random dipole','color',[1 0.5 0.1],'FontSize',12,'FontWeight','bold');
text(-0.14,1.06,'Blank','color',[0.5 0.5 0.5],'FontSize',12,'FontWeight','bold');


axis off

linResps = repmat(squeeze(stimMean(:,dt,dx,ch)),[2,1]);
linResps(end+1) = linResps(1);
noiseResp = (squeeze(noiseMean(dt,dx,ch)));
noiseVect = repmat(noiseResp,[1,length(oris)]);
blankResp = (squeeze(blankMean(ch)));
blankVect = repmat(blankResp,[1,length(oris)]);

subplot(1,1,1,polaraxes);

hold on
l = polarplot(oris',linResps,'-o');
l.LineWidth = 1.2;

if contains(dataT.eye,'LE')
    l.Color = [0 0 1 0.8];
else
    l.Color = [1 0 0 0.8];
end

pOri = (ot);
pOriRad = deg2rad(ot);
pOri180 = (ot+180);
pOriRad180 = deg2rad(ot+180);

polarplot(pOriRad,max10,'.k','MarkerSize',15);
polarplot(pOriRad180,max10,'.k','MarkerSize',15);

text(pOriRad,max10+2,sprintf('%.1f',pOri),'FontSize',12)
text(pOriRad180,max10+2,sprintf('%.1f',pOri180),'FontSize',12)

n = polarplot(oris,noiseVect,'-o');
n.Color = [1 0.5 0.1 0.8];
n.LineWidth = 1.2;

b = polarplot(oris,blankVect,'-o');
b.Color = [0.5 0.5 0.5 0.8];
b.LineWidth = 1.2;
set(gca,'color','none')

ax = gca;
ax.RLim   = [0,maxLim];
ax.RTick = [0,maxLim/2,maxLim];
set(gca,'ThetaTick',0:45:315)

title(sprintf('OSI: %.3f',SItmp))

ttl = suptitle({sprintf('%s %s %s Glass orientation tuning curves ch %d',dataT.animal, dataT.eye, dataT.array,ch)});
ttl.Position = [0.5,-0.025,0];

figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_oriRespsPolar_noise_',num2str(ch),'.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
