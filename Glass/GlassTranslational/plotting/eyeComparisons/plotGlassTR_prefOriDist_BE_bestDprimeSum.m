function [data] = plotGlassTR_prefOriDist_BE_bestDprimeSum(data)
%% 
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/EyeComps/prefOri/',data.RE.animal, data.RE.programID, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/EyeComps/prefOri/',data.RE.animal, data.RE.programID, data.RE.array);
end
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
pOrisR = nan(96,1);
pOrisL = nan(96,1);
SIR = nan(96,1);
SIL = nan(96,1);
%%
vSumRE = nan(2,2,96);
vSumLE = nan(2,2,96);

dpRE = squeeze(data.RE.linBlankDprime(:,end,:,:,:));
dpLE = squeeze(data.LE.linBlankDprime(:,end,:,:,:));


for dt = 1:2
    for dx = 1:2
        REtmp = squeeze(dpRE(:,dt,dx,:));
        LEtmp = squeeze(dpLE(:,dt,dx,:));
        vSumRE(dt,dx,:) = sqrt(REtmp(1,:).^2 + REtmp(2,:).^2 + REtmp(3,:).^2+ REtmp(4,:).^2);
        vSumLE(dt,dx,:) = sqrt(LEtmp(1,:).^2 + LEtmp(2,:).^2 + LEtmp(3,:).^2+ LEtmp(4,:).^2);
    end
end
%%
pOris = squeeze(data.RE.prefOri(end,:,:,:)); % get the preferred orientations for all 100% coherence stimuli
rSI = squeeze(data.RE.OSI(end,:,:,:));

siA = [squeeze(vSumRE(1,1,:)),squeeze(vSumRE(1,2,:)),squeeze(vSumRE(2,1,:)),squeeze(vSumRE(2,2,:))]; % rearrange the dPrimess so each row is a ch and each dt,dx is a column
[~,indR] = max(siA,[],2);% get the indices for the dt,dx that gives the highest summed d'

for ch = 1:96
    if data.RE.goodCh(ch) == 1
        % go through each of the parameter combinations and figure out
        % which one is preferred for that channel. 
    if indR(ch) == 1
        pOrisR(ch) = pOris(1,1,ch); 
        SIR(ch) = rSI(1,1,ch);
    elseif indR(ch) == 2
        pOrisR(ch) = pOris(1,2,ch);
        SIR(ch) = rSI(1,2,ch);
    elseif indR(ch) == 3
        pOrisR(ch) = pOris(2,1,ch);
        SIR(ch) = rSI(2,1,ch);
    elseif indR(ch) == 4
        pOrisR(ch) = pOris(2,2,ch);
        SIR(ch) = rSI(2,2,ch);
    end
    else
        pOrisR(ch) = nan;
        SIR(ch) = nan;
    end
end

pOrisR(isnan(pOrisR)) = [];
SIR2 = pOrisR;
SIR2(SIR2<0) = SIR2(SIR2<0)+180;

% get preferred orientation for the distribution using circular mean
cirMuR = circ_mean(deg2rad(SIR2(:)*2))/2;
cirMuR2 = cirMuR+pi;

% LE

pOris = squeeze(data.LE.prefOri(end,:,:,:)); % get the preferred orientations for all 100% coherence stimuli
lSI = squeeze(data.LE.OSI(end,:,:,:));
siA = [squeeze(vSumLE(1,1,:)),squeeze(vSumLE(1,2,:)),squeeze(vSumLE(2,1,:)),squeeze(vSumLE(2,2,:))];
[~,indL] = max(siA,[],2);

for ch = 1:96
    if data.LE.goodCh(ch) == 1
    if indL(ch) == 1
        pOrisL(ch) = pOris(1,1,ch);
        SIL(ch) = lSI(1,1,ch);
    elseif indL(ch) == 2
        pOrisL(ch) = pOris(1,2,ch);
        SIL(ch) = lSI(1,2,ch);
    elseif indL(ch) == 3
        pOrisL(ch) = pOris(2,1,ch);
        SIL(ch) = lSI(2,1,ch);
    elseif indL(ch) == 4
        pOrisL(ch) = pOris(2,2,ch);
        SIL(ch) = lSI(2,2,ch);
    end
    else
        pOrisL(ch) = nan;
        SIL(ch) = nan;
    end
end

pOrisL(isnan(pOrisL)) = [];
SIL2 = pOrisL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

%%  
figure (10)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

subplot(1,2,1,polaraxes)
hold on

[bins,edges] = histcounts(deg2rad(SIL2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')

[bins,edges] = histcounts(deg2rad(SIL2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','b','EdgeColor','w')
polarplot([cirMuL 0 cirMuL2],[1.5 0 1.5],'b-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.7];
text(cirMuL+0.2,0.5,sprintf('mean: %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.5,sprintf('mean: %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

if contains(data.LE.animal,'XT')
    title(sprintf('LE n: %d',length(SIL2)))
else
    title(sprintf('FE n: %d',length(SIL2)))
end

subplot(1,2,2,polaraxes)
hold on

[bins,edges] = histcounts(deg2rad(SIR2),0:pi/6:pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')


[bins,edges] = histcounts(deg2rad(SIR2)+pi,[0:pi/6:pi]+pi);
bins2 = sqrt(bins);
polarhistogram('BinEdges',edges,'BinCounts',bins2,'normalization','probability','FaceColor','r','EdgeColor','w')
polarplot([cirMuR 0 cirMuR2],[1.5 0 1.5],'r-','LineWidth',.85)
polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])

ax = gca;
ax.RLim   = [0,0.5];
text(cirMuR+0.2,0.5,sprintf('mean: %.1f%c',rad2deg(cirMuR),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuR2+0.2,0.5,sprintf('mean: %.1f%c',rad2deg(cirMuR2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

if contains(data.LE.animal,'XT')
    title(sprintf('RE n: %d',length(SIR2)))
else
    title(sprintf('AE n: %d',length(SIR2)))
end

suptitle({sprintf('%s %s %s distribution of preferred orientations square root transformed radius',data.LE.animal, data.LE.eye, data.LE.array);...
    'Best parameters based on dPrime Sum for each visually responsive channel'});

figName = [data.RE.animal,'_',data.RE.array,'_BE_prefOriDist_bestDprimeSum','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')

%%
figure(13)
clf
subplot(2,1,1)
hold on
histogram(indL(data.LE.goodCh==1,:),'normalization','probability','FaceColor','b','EdgeColor','w');
set(gca,'tickdir','out','XTick',1:4,'XTickLabel',{'200 0.02','200 0.03','400 0.02','400 0.03'})
xlim([0 5])
ylim([0 .6])
xtickangle(45)
%xlabel('density dx combination')
ylabel('proportion')
title('LE')

subplot(2,1,2)
hold on
histogram(indR(data.RE.goodCh==1,:),'normalization','probability','FaceColor','r','EdgeColor','w');
set(gca,'tickdir','out','XTick',1:4,'XTickLabel',{'200 0.02','200 0.03','400 0.02','400 0.03'})
xlim([0 5])
ylim([0 .6])
xtickangle(45)
xlabel('density dx combination')
ylabel('proportion')
title('RE')

suptitle(sprintf('%s %s distribution of highest dPrimes across density and dx',data.RE.animal, data.RE.array))
figName = [data.RE.animal,'_',data.RE.array,'_BE_bestDprimeDistributions','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
cd ../../
% go to date specific folder, if it doesn't exist, make it
% go to date specific folder, if it doesn't exist, make it
folder = 'OSI';
mkdir(folder)
cd(sprintf('%s',folder))

figure
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

xmax = max([SIR; SIL])+0.05;
xmin = xmax*-1;

subplot(2,1,1)
hold on

histogram(SIL,xmin:.02:xmax,'normalization','probability','FaceColor','b','EdgeColor','w')
plot(nanmean(SIL),0.28,'vw','MarkerFaceColor','b','MarkerSize',7.5)

text(nanmean(SIL)+0.02,0.28,sprintf('mean %.2f',nanmean(SIL)),'FontSize',11)
text(xmax-0.1, 0.28, sprintf('num good channels: %d',sum(data.LE.goodCh)));


set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'box','off','Layer','top')

xlim([-0.05,xmax])
ylim([0 0.3])

ylabel('probability','FontSize',12)
title(sprintf('%s LE',data.LE.animal))

subplot(2,1,2)
hold on

histogram(SIR,xmin:.02:xmax,'normalization','probability','FaceColor','r','EdgeColor','w')
plot(nanmean(SIR),0.28,'vw','MarkerFaceColor','r','MarkerSize',7.5)

text(nanmean(SIR)+0.02,0.28,sprintf('mean %.2f',nanmean(SIR)),'FontSize',11)
text(xmax-0.1, 0.28, sprintf('num good channels: %d',sum(data.RE.goodCh)));

set(gca,'tickdir', 'out','YTick',0:0.1:0.5,'box','off','Layer','top')
xlim([-0.05,xmax])
ylim([0 0.3])

ylabel('probability','FontSize',12)
xlabel('OSI','FontSize',12)
title(sprintf('%s RE',data.RE.animal))

suptitle(sprintf('%s %s distribtion of OSIs for each ch greatest norm dPrime',data.RE.animal, data.RE.array));

figName = [data.RE.animal,'_',data.RE.array,'_BE_OSIdist_bestDprime','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%
pOrisR(pOrisR<0) = pOrisR(pOrisR<0)+180;
pOrisL(pOrisL<0) = pOrisL(pOrisL<0)+180;
data.RE.prefOriBestDprime = pOrisR;
data.LE.prefOriBestDprime = pOrisL;
