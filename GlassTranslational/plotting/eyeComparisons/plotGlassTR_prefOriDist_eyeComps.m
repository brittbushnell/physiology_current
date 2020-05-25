function [] = plotGlassTR_prefOriDist_eyeComps(data)
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassTR/%s/EyeComps/prefOri/',data.RE.animal, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassTR/%s/EyeComps/prefOri/',data.RE.animal, data.RE.array);
end

cd(figDir)
% go to date specific folder, if it doesn't exist, make it
folder = data.RE.date2;
mkdir(folder)
cd(sprintf('%s',folder))
%% BE 360 all good channels fig 9
figure (9)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500])
set(gcf,'PaperOrientation','Landscape');

if contains(data.RE.animal,'XT')
    pOriR = (squeeze(data.RE.prefOri2thetaNoise(end,2:end,2:end,data.RE.goodCh == 1)));
else
    pOriR = (squeeze(data.RE.prefOri2thetaNoise(end,:,:,data.RE.goodCh == 1)));
end

pOriR = reshape(pOriR,[1,numel(pOriR)]);
pOriR(isnan(pOriR)) = [];
SIR2 = pOriR;
SIR2(SIR2<0) = SIR2(SIR2<0)+180;

cirMuR = circ_mean(deg2rad(SIR2(:)*2))/2;
cirMuR2 = cirMuR+pi;

if contains(data.RE.animal,'XT')
    pOriL = (squeeze(data.LE.prefOri2thetaNoise(end,2:end,2:end,data.LE.goodCh == 1)));
else
    pOriL = (squeeze(data.LE.prefOri2thetaNoise(end,:,:,data.LE.goodCh == 1)));
end

pOriL = reshape(pOriL,[1,numel(pOriL)]);
pOriL(isnan(pOriL)) = [];
SIL2 = pOriL;
SIL2(SIL2<0) = SIL2(SIL2<0)+180;

cirMuL = circ_mean(deg2rad(SIL2(:)*2))/2;
cirMuL2 = cirMuL+pi;

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
ax.RLim   = [0,0.3];
text(cirMuL+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuL),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuL2+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuL2),char(176)),'FontSize',11,'HorizontalAlignment','center')

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
ax.RLim   = [0,0.3];
text(cirMuR+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuR),char(176)),'FontSize',11,'HorizontalAlignment','center')
text(cirMuR2+0.2,0.25,sprintf('mean: %.1f%c',rad2deg(cirMuR2),char(176)),'FontSize',11,'HorizontalAlignment','center')

set(gca,'FontSize',12,'FontAngle','italic','RTickLabels',{'','',''})

if contains(data.LE.animal,'XT')
    title(sprintf('RE n: %d',length(SIR2)))
else
    title(sprintf('AE n: %d',length(SIR2)))
end

suptitle({sprintf('%s %s %s distribution of preferred orientations square root transformed radius',data.LE.animal, data.LE.eye, data.LE.array);...
    'All parameters across any visually responsive channel'});

figName = [data.RE.animal,'_',data.RE.array,'_BE_prefOriDistribition_allChs_allParams','.pdf'];
print(gcf, figName,'-dpdf','-fillpage')
%%

