function radFreq_plotFisherDist_RFphase(REdata, LEdata)
%%
location = determineComputer;

if location == 1
    if contains(REdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
elseif location == 0
    if contains(REdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    elseif contains(REdata.programID,'low','IgnoreCase')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    else
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/FisherTransform/%s/',REdata.animal,REdata.array);
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end

cd(figDir)
%%
% (RF,phase,sf,radius,location, ch)
REzTR = REdata.FisherTrCorr;
LEzTR = LEdata.FisherTrCorr;

LEprefLoc = LEdata.prefLoc;
REprefLoc = REdata.prefLoc;

REzPloc = nan(3, 2, 2, 2, 96);
LEzPloc = nan(3, 2, 2, 2, 96);
%% limit to preferred locations

for ch = 1:96
    if REdata.goodCh(ch) == 1
        REzPloc(:,:,:,:,ch) = squeeze(REzTR(:,:,:,:,REprefLoc(ch),ch));
    end
    if LEdata.goodCh(ch) == 1
        LEzPloc(:,:,:,:,ch) = squeeze(LEzTR(:,:,:,:,LEprefLoc(ch),ch));
    end
end
%% Plot distributions for each RF and Phase using preferred location
figure(3)
clf
s = suptitle(sprintf('%s %s Fisher Z distributions RF and Phase at preferred location',REdata.animal, REdata.array));
s.Position(2) = s.Position(2)+ 0.015;

h = subplot(3,4,1);
hold on
zs = squeeze(LEzPloc(1,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 0','FontWeight','normal')
text(4, 0.3, sprintf('%s',LEdata.eye),'FontSize',12,'FontWeight','bold')
text(-7.2,0.125,'RF 4','FontSize',12, 'FontAngle','italic','FontWeight','bold');

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,2);
hold on
zs = squeeze(LEzPloc(1,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

title('phase: 45','FontWeight','normal')

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs
%
h = subplot(3,4,3);
hold on
zs = squeeze(REzPloc(1,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 0','FontWeight','normal')
text(4, 0.3, sprintf('%s',REdata.eye),'FontSize',12,'FontWeight','bold')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,4);
hold on
zs = squeeze(REzPloc(1,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
title('phase: 45','FontWeight','normal')

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,5);
hold on
zs = squeeze(LEzPloc(2,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 0','FontWeight','normal')
text(-7.2,0.125,'RF 8','FontSize',12, 'FontAngle','italic','FontWeight','bold');

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,6);
hold on
zs = squeeze(LEzPloc(2,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 22.5','FontWeight','normal')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs
%
h = subplot(3,4,7);
hold on
zs = squeeze(REzPloc(2,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 0','FontWeight','normal')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,8);
hold on
zs = squeeze(REzPloc(2,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 22.5','FontWeight','normal')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,9);
hold on
zs = squeeze(LEzPloc(3,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 0','FontWeight','normal')
text(-7.2,0.125,'RF 16','FontSize',12, 'FontAngle','italic','FontWeight','bold');

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');
ylabel('probability','FontSize',11,'FontAngle','italic')

ylim([0 0.25])
xlim([-3 3])

h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,10);
hold on
zs = squeeze(LEzPloc(3,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','b','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','b','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 11.25','FontWeight','normal')
xl = xlabel('Fisher transformed z');
xl.Position(1) = xl.Position(1) +3;
xl.Position(2) = xl.Position(2) - 0.03;

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])
h.Position(4) = h.Position(4) - 0.04;
clear zs
%
h = subplot(3,4,11);
hold on
zs = squeeze(REzPloc(3,1,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 11.25','FontWeight','normal')

set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])
h.Position(4) = h.Position(4) - 0.04;
clear zs

h = subplot(3,4,12);
hold on
zs = squeeze(REzPloc(3,2,:,:,:));
zs = reshape(zs,1,numel(zs));

histogram(zs,'Normalization','probability','FaceColor','r','EdgeColor','w','BinWidth',0.25)
yScale = get(gca,'ylim');
ylim([0, yScale(2)+0.02])

plot(nanmean(zs),0.2,'v','MarkerFaceColor','r','MarkerEdgeColor','w','MarkerSize',6)
text(nanmean(zs)+0.15,0.2,sprintf('\\mu %.2f',nanmean(zs)))
plot([0 0],[0,0.23],'-k')

title('phase: 11.25','FontWeight','normal')
set(gca,'tickdir','out','Layer','top','FontSize',10,'FontAngle','italic');

ylim([0 0.25])
xlim([-3 3])
h.Position(4) = h.Position(4) - 0.04;
clear zs

figName = [REdata.animal,'_BE_',REdata.array,'_FisherT_RFphase_dist','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')