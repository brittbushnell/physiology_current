function radFreq_plotAllFisherZs(REdata,LEdata)
%% plot distribution of everything
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 600, 500],'PaperOrientation','landscape')
hold on

suptitle({sprintf('%s %s Fisher transformed correlations for all parameters in included channels', REdata.animal, REdata.array);...
    'spike counts with circle response subtracted'});

s = subplot(2,1,1);
hold on
zTr = LEdata.FisherTrCorr;
allZs = reshape(zTr,1,numel(zTr));
zm1 = abs(max(allZs));
zm2 = abs(min(allZs));

zmax = max(zm1,zm2)+0.5;
xlim([-1*(zmax), zmax])

histogram(allZs,'Normalization','probability','BinWidth',0.125,'FaceColor','b','EdgeColor','w');
yScale = get(gca,'ylim');
xScale = get(gca,'xlim');

ylim([0, yScale(2)+0.02])

plot(nanmean(allZs),yScale(2),'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(allZs)+0.15,yScale(2),sprintf('\\mu %.2f',nanmean(allZs)))

pos = get(gca,'Position');
set(gca,'tickdir','out', 'Position',[pos(1), pos(2), pos(3), pos(4) - 0.15],'Layer','top','FontSize',10,'FontAngle','italic');

text(xScale(1)+ 0.5, yScale(2)+0.01, sprintf('n ch: %d',sum(REdata.goodCh)))
ylabel('probability','FontSize',11,'FontAngle','italic')
title(sprintf('%s', LEdata.eye))

s.Position(1) = s.Position(1) + 0.04;
s.Position(2) = s.Position(2) - 0.04;

s = subplot(2,1,2);
hold on
zTr = REdata.FisherTrCorr;
allZs = reshape(zTr,1,numel(zTr));
zm1 = abs(max(allZs));
zm2 = abs(min(allZs));

zmax = max(zm1,zm2)+0.5;
xlim([-1*(zmax), zmax])

histogram(allZs,'Normalization','probability','BinWidth',0.125,'FaceColor','r','EdgeColor','w');
yScale = get(gca,'ylim');
xScale = get(gca,'xlim');

ylim([0, yScale(2)+0.02])

plot(nanmean(allZs),yScale(2),'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',9)
text(nanmean(allZs)+0.15,yScale(2),sprintf('\\mu %.2f',nanmean(allZs)))

pos = get(gca,'Position');
set(gca,'tickdir','out', 'Position',[pos(1), pos(2), pos(3), pos(4) - 0.15],'Layer','top','FontSize',10,'FontAngle','italic');

text(xScale(1)+ 0.5, yScale(2)+0.01, sprintf('n ch: %d',sum(REdata.goodCh)))
ylabel('probability','FontSize',11,'FontAngle','italic')
xlabel('Fisher transformed r to z','FontSize',11,'FontAngle','italic')
title(sprintf('%s', REdata.eye))

s.Position(1) = s.Position(1) + 0.04;
s.Position(2) = s.Position(2) + 0.04;

%%
location = determineComputer;

if location == 1
    if contains(REdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    end
elseif location == 0
    if contains(REdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/',REdata.animal,REdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)

%%
figName = [REdata.animal,'_BE_',REdata.array,'_FisherTransform_Everything','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')