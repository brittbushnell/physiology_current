function makeGlassFigs_dPrimeScatter_binocOnly(V1data, V4data)
%%
[V1conLE,V1conRE,V1radLE,V1radRE,V1nozLE,V1nozRE,V1trLE,V1trRE,V1trLEnoz,V1trREnoz] = getBinocGlassdPrimeBlankMats(V1data,1);
[V4conLE,V4conRE,V4radLE,V4radRE,V4nozLE,V4nozRE,V4trLE,V4trRE,V4trLEnoz,V4trREnoz] = getBinocGlassdPrimeBlankMats(V4data,1);
LEV1chs = V1data.conRadLE.inStim & V1data.conRadLE.goodCh;
REV1chs = V1data.conRadRE.inStim & V1data.conRadRE.goodCh;

LEV1chstr = V1data.trLE.inStim & V1data.trLE.goodCh;
REV1chstr = V1data.trRE.inStim & V1data.trRE.goodCh;

LEV4chs = V4data.conRadLE.inStim & V4data.conRadLE.goodCh;
REV4chs = V4data.conRadRE.inStim & V4data.conRadRE.goodCh;

LEV4chstr = V4data.trLE.inStim & V4data.trLE.goodCh;
REV4chstr = V4data.trRE.inStim & V4data.trRE.goodCh;

%%

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 500]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s d'' vs blank between eyes for stumuli and arrays',V1data.conRadRE.animal));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.025;

s = subplot(2,4,1);
le =  reshape(V1conLE,numel(V1conLE),1);
re = reshape(V1conRE,numel(V1conRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,conRes,~,conReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',conReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(conRes)),'FontSize',12)

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])
axis square

if contains(V1data.conRadRE.animal,'XT')
    ylabel('RE d''')
else
    ylabel('AE d''')
end

text(-4.25,2,'V1','FontSize',20,'FontWeight','bold')
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,2);
le = reshape(V1radLE,numel(V1radLE),1);
re = reshape(V1radRE,numel(V1radRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,radRes,~,radReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',radReg(1)),'FontSize',12)
% text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])
axis square

s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,3);
le =  reshape(V1nozLE,numel(V1nozLE),1);
re = reshape(V1nozRE,numel(V1nozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,nozRes,~,nozReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',nozReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(nozRes)),'FontSize',12)

title('Dipole')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])

axis square
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,5);
le =  reshape(V4conLE,numel(V4conLE),1);
re = reshape(V4conRE,numel(V4conRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,conRes,~,conReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',conReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f', nanmedian(conRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    xlabel('LE d''')
    ylabel('RE d''')
else
    xlabel('FE d''')
    ylabel('AE d''')
end

text(-4.5,2,'V4','FontSize',20,'FontWeight','bold')

s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,6);
le = reshape(V4radLE,numel(V4radLE),1);
re = reshape(V4radRE,numel(V4radRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,radRes,~,radReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',radReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])
axis square

s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,7);
le =  reshape(V4nozLE,numel(V4nozLE),1);
re = reshape(V4nozRE,numel(V4nozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,nozRes,~,nozReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',nozReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(nozRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1.2 5])
ylim([-1.2 5])
axis square
s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

% add translational figures

s = subplot(2,4,4);

le =  reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trLEReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',trLEReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1.2 5])
ylim([-1.2 5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);

s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
title('Translational')

s = subplot(2,4,8);
hold on
le =  reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trLEReg] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',trLEReg(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1.2 5])
ylim([-1.2 5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);

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

figName = [V1data.conRadRE.animal '_glassdPrimeScatters_vsBlank_binocOnly','.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-bestfit')
