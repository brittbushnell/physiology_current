function [] = makeGlassFigs_dPrimeScatter_stimVnoise_binocOnly(V1data,V4data)
[V1conLE,V1conRE,V1radLE,V1radRE,V1trLE,V1trRE] = getBinocGlassdPrimeDipoleMats(V1data,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4trLE,V4trRE] = getBinocGlassdPrimeDipoleMats(V4data,1);

LEV1chs = V1data.conRadLE.inStim & V1data.conRadLE.goodCh;
REV1chs = V1data.conRadRE.inStim & V1data.conRadRE.goodCh;

LEV1chstr = V1data.trLE.inStim & V1data.trLE.goodCh;
REV1chstr = V1data.trRE.inStim & V1data.trRE.goodCh;

LEV4chs = V4data.conRadLE.inStim & V4data.conRadLE.goodCh;
REV4chs = V4data.conRadRE.inStim & V4data.conRadRE.goodCh;

LEV4chstr = V4data.trLE.inStim & V4data.trLE.goodCh;
REV4chstr = V4data.trRE.inStim & V4data.trRE.goodCh;
%% fig 3
figure(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 500]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s d'' vs dipole between eyes for binocular channels',V1data.conRadRE.animal));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.025;

s = subplot(2,3,1);
le =  reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,conRes,~,conRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.55, 2.35,sprintf('R2 %.3f',conRegV1(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(conRes)),'FontSize',12)

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square

if contains(V1data.conRadRE.animal,'XT')
    ylabel('RE d''')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
else
    ylabel('AE d''')
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
end

text(-4.25,2,'V1','FontSize',20,'FontWeight','bold')
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,3,2);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,radRes,~,radRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.55, 2.35,sprintf('R2 %.3f',radRegV1(1)),'FontSize',12)
% text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square
if contains(V1data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
else
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
end
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;


s = subplot(2,3,4);
le =  reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,conRes,~,conRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.8,'MarkerEdgeAlpha',0.8)
text(-0.55, 2.35,sprintf('R2: %.3f',conRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f', nanmedian(conRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    xlabel('LE d''')
    ylabel('RE d''')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
else
    xlabel('FE d''')
    ylabel('AE d''')
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
end

text(-4.5,2,'V4','FontSize',20,'FontWeight','bold')

s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,3,5);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,radRes,~,radRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 2.35,sprintf('R2: %.3f',radRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square
if contains(V4data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
else
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
end
s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

% add translational figures

s = subplot(2,3,3);

le =  reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trLERegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 2.35,sprintf('R2: %.3f',trLERegV1(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1 2.5])
ylim([-1 2.5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
if contains(V4data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV1chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV1chstr)),'FontSize',12)
else
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV1chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV1chstr)),'FontSize',12)
end
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
title('Translational')

s = subplot(2,3,6);
hold on
le =  reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trLERegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 2.35,sprintf('R2: %.3f',trLERegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1 2.5])
ylim([-1 2.5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
if contains(V4data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE %d',sum(LEV4chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE %d',sum(REV4chstr)),'FontSize',12)
else
%     text(3.7,-0.3,sprintf('FE %d',sum(LEV4chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE %d',sum(REV4chstr)),'FontSize',12)
end
s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/',V1data.conRadRE.animal);
end

if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [V1data.conRadRE.animal '_glassdPrimeScatters_vsNoise_binocOnly','.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-bestfit')
%%
% trying to plot V1 and V4 on the same figure. V1 will be open symbols, V4
% will be filled

figure(6)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 400]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s d'' vs dipole between eyes binocular channels',V1data.conRadRE.animal));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.025;

subplot(1,3,1)
hold on
leV1 =  reshape(V1conLE,numel(V1conLE),1);
reV1 = reshape(V1conRE,numel(V1conRE),1);
oneMtx = ones(length(reV1),1);
regX = [oneMtx,reV1];
[~,~,conResV1,~,conRegV1] = regress(leV1,regX);

leV4 =  reshape(V4conLE,numel(V4conLE),1);
reV4 = reshape(V4conRE,numel(V4conRE),1);
oneMtx = ones(length(reV4),1);
regX = [oneMtx,reV4];
[~,~,conResV4,~,conRegV4] = regress(leV4,regX);
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])


scatter(leV4,reV4,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor',[0.99 0.99 0.99],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.5)
scatter(leV1,reV1,40,'markerfacecolor', [0.7 0.7 0.7],'markeredgecolor',[0.7 0 0.7],'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.5)

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square

plot(-0.7, 2.15, 'o','markerfacecolor', [0.7 0 0.7],'markeredgecolor',[0.7 0 0.7])
plot(-0.7, 2.35, 'o','markerfacecolor', 'none','markeredgecolor',[0.7 0 0.7])
text(-0.55, 2.35,sprintf('V1 R2 %.2f',conRegV1(1)),'FontSize',12)
text(-0.55, 2.15,sprintf('V4 R2 %.2f',conRegV4(1)),'FontSize',12)

if contains(V1data.conRadRE.animal,'XT')
    ylabel('RE d''')
    xlabel('LE d''')
else
    ylabel('AE d''')
    xlabel('FE d''')
end

subplot(1,3,2)
hold on
leV1 =  reshape(V1radLE,numel(V1radLE),1);
reV1 = reshape(V1radRE,numel(V1radRE),1);
oneMtx = ones(length(reV1),1);
regX = [oneMtx,reV1];
[~,~,radResV1,~,radRegV1] = regress(leV1,regX);

leV4 =  reshape(V4radLE,numel(V4radLE),1);
reV4 = reshape(V4radRE,numel(V4radRE),1);
oneMtx = ones(length(reV4),1);
regX = [oneMtx,reV4];
[~,~,radResV4,~,radRegV4] = regress(leV4,regX);
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])

scatter(leV4,reV4,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor',[0.99 0.99 0.99],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(leV1,reV1,40,'markerfacecolor', [0.7 0.7 0.7],'markeredgecolor',[0 0.6 0.2],'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.5)

plot(-0.7, 2.15, 'o','markerfacecolor', [0 0.6 0.2],'markeredgecolor',[0 0.6 0.2])
plot(-0.7, 2.35, 'o','markerfacecolor', 'none','markeredgecolor',[0 0.6 0.2])
text(-0.55, 2.35,sprintf('V1 R2 %.2f',radRegV1(1)),'FontSize',12)
text(-0.55, 2.15,sprintf('V4 R2 %.2f',radRegV4(1)),'FontSize',12)

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square

subplot(1,3,3)
hold on
leV1 =  reshape(V1trLE,numel(V1trLE),1);
reV1 = reshape(V1trRE,numel(V1trRE),1);
oneMtx = ones(length(reV1),1);
regX = [oneMtx,reV1];
[~,~,trResV1,~,trRegV1] = regress(leV1,regX);

leV4 =  reshape(V4trLE,numel(V4trLE),1);
reV4 = reshape(V4trRE,numel(V4trRE),1);
oneMtx = ones(length(reV4),1);
regX = [oneMtx,reV4];
[~,~,trResV4,~,trRegV4] = regress(leV4,regX);
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])

scatter(leV4,reV4,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor',[0.99 0.99 0.99],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5)
scatter(leV1,reV1,40,'markerfacecolor', [0.7 0.7 0.7],'markeredgecolor',[0.2 0.4 1],'MarkerFaceAlpha',0.2,'MarkerEdgeAlpha',0.5)

plot(-0.7, 2.15, 'o','markerfacecolor', [0.2 0.4 1],'markeredgecolor',[0.2 0.4 1])
plot(-0.7, 2.35, 'o','markerfacecolor', 'none','markeredgecolor',[0.2 0.4 1])
text(-0.55, 2.35,sprintf('V1 R2 %.2f',trRegV1(1)),'FontSize',12)
text(-0.55, 2.15,sprintf('V4 R2 %.2f',trRegV4(1)),'FontSize',12)

title('Translational')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 2.5])
ylim([-1 2.5])
axis square
%%
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/',V1data.conRadRE.animal);
end

if~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [V1data.conRadRE.animal '_glassdPrimeScatters_vsNoise_3plot_binocOnly','.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-bestfit')
%% 
figure (88) % DO NOT CLF THIS FIGURE, WANT TO ADD EACH ANIMAL TO IT
hold on
makeGlassR2CompFig(conRegV1,conRegV4,radRegV1,radRegV4,trRegV1,trRegV4,V4data.conRadRE.animal)
suptitle('R2 values stimulus vs noise binocular channels')
