function [stimBlankR2] = makeGlassFigs_dPrimeScatter_bothProgs(V1data, V4data, stimBlankR2)
%%
[V1conLE,V1conRE,V1radLE,V1radRE,V1nozLE,V1nozRE,V1trLE,V1trRE] = getBinocGlassdPrimeBlankMats(V1data,0);
[V4conLE,V4conRE,V4radLE,V4radRE,V4nozLE,V4nozRE,V4trLE,V4trRE] = getBinocGlassdPrimeBlankMats(V4data,0);
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
[~,~,conRes,~,conRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',conRegV1(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(conRes)),'FontSize',12)

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square

if contains(V1data.conRadRE.animal,'XT')
    ylabel('RE d''')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
else
    ylabel('AE d''')
    text(3.7,-0.3,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
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
[~,~,radRes,~,radRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',radRegV1(1)),'FontSize',12)
% text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V1data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
end
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,4);
le =  reshape(V1nozLE,numel(V1nozLE),1);
re = reshape(V1nozRE,numel(V1nozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,nozRes,~,nozRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2 %.3f',nozRegV1(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(nozRes)),'FontSize',12)

title('Dipole')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])

if contains(V1data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV1chs)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
end
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
[~,~,conRes,~,conRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',conRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f', nanmedian(conRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    xlabel('LE d''')
    ylabel('RE d''')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
else
    xlabel('FE d''')
    ylabel('AE d''')
    text(3.7,-0.3,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
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
[~,~,radRes,~,radRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',radRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(radRes)),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
end
s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

s = subplot(2,4,8);
le =  reshape(V4nozLE,numel(V4nozLE),1);
re = reshape(V4nozRE,numel(V4nozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,nozRes,~,nozRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',nozRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(nozRes)),'FontSize',12)
if contains(V4data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV4chs)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
end
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
s.Position(2) = s.Position(2) + 0.02;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
clear le; clear re; clear regX;

% add translational figures

s = subplot(2,4,3);

le =  reshape(V1trLE,numel(V1trLE),1);
re = reshape(V1trRE,numel(V1trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trRegV1] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',trRegV1(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1 5])
ylim([-1 5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
if contains(V4data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV1chstr)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV1chstr)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV1chstr)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV1chstr)),'FontSize',12)
end
s.Position(2) = s.Position(2) - 0.025;
s.Position(3) = s.Position(3) + 0.01;
s.Position(4) = s.Position(4) + 0.01;
title('Translational')

s = subplot(2,4,7);
hold on
le =  reshape(V4trLE,numel(V4trLE),1);
re = reshape(V4trRE,numel(V4trRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,trRes,~,trRegV4] = regress(le,regX);

hold on
plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.55, 4.25,sprintf('R2: %.3f',trRegV4(1)),'FontSize',12)
%text(-0.55, 4.75,sprintf('med res %.3f',nanmedian(trRes)),'FontSize',12)

xlim([-1 5])
ylim([-1 5])
axis square
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
if contains(V4data.conRadRE.animal,'XT')
    text(3.7,-0.3,sprintf('LE %d',sum(LEV4chstr)),'FontSize',12)
    text(3.6,-0.75,sprintf('RE %d',sum(REV4chstr)),'FontSize',12)
else
    text(3.7,-0.3,sprintf('FE %d',sum(LEV4chstr)),'FontSize',12)
    text(3.6,-0.75,sprintf('AE %d',sum(REV4chstr)),'FontSize',12)
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

figName = [V1data.conRadRE.animal '_glassdPrimeScatters_vsBlank','.pdf'];
set(gcf,'InvertHardCopy','off')
print(gcf, figName, '-dpdf', '-bestfit')
%% 
% 
% figure(3)
% clf
% s = suptitle(sprintf('%s d'' for dipole stimuli in both programs',V1data.conRadRE.animal));
% s.FontSize = 20;
% s.Position(2) = s.Position(2)+0.025;
% 
% subplot(2,1,1)
% hold on
% le =  reshape(V1trLE,numel(V1trLEnoz),1);
% re = reshape(V1trRE,numel(V1trREnoz),1);
% oneMtx = ones(length(re),1);
% regX = [oneMtx,re];
% [~,~,trRes,~,trLEReg] = regress(le,regX);
% 
% leCr =  reshape(V1trLE,numel(V1nozLE),1);
% reCr = reshape(V1trRE,numel(V1nozRE),1);
% oneMtx = ones(length(reCr),1);
% regX = [oneMtx,reCr];
% [~,~,Res,~,LEReg] = regress(leCr,regX);
% 
% plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
% scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
% scatter(leCr,reCr,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
% text(-0.55, 4.25,sprintf('tr R2: %.3f',trLEReg(1)),'FontSize',12)
% text(-0.55, 4.75,sprintf('con rad R2: %.3f',trLEReg(1)),'FontSize',12)
% 
% xlim([-1 5])
% ylim([-1 5])
% axis square
% set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
%     'layer','top','XTick',0:2:4,'YTick',0:2:4);
% if contains(V4data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE tr %d',sum(LEV1chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE tr %d',sum(REV1chstr)),'FontSize',12)
%     text(3.7,-0.15,sprintf('LE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,0,sprintf('RE %d',sum(REV1chs)),'FontSize',12)    
% else
%     text(3.7,-0.3,sprintf('FE tr %d',sum(LEV1chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE tr %d',sum(REV1chstr)),'FontSize',12)
%     text(3.7,-0.15,sprintf('FE %d',sum(LEV1chs)),'FontSize',12)
%     text(3.6,0,sprintf('AE %d',sum(REV1chs)),'FontSize',12)
% end
% 
% 
% subplot(2,1,2)
% hold on
% le =  reshape(V4trLE,numel(V4trLEnoz),1);
% re = reshape(V4trRE,numel(V4trREnoz),1);
% oneMtx = ones(length(re),1);
% regX = [oneMtx,re];
% [~,~,trRes,~,trLEReg] = regress(le,regX);
% 
% leCr =  reshape(V4trLE,numel(V4nozLE),1);
% reCr = reshape(V4trRE,numel(V4nozRE),1);
% oneMtx = ones(length(reCr),1);
% regX = [oneMtx,reCr];
% [~,~,Res,~,LEReg] = regress(leCr,regX);
% 
% plot([-2 5],[-2 5],'color',[0.2 0.2 0.2])
% scatter(le,re,40,'markerfacecolor', [0.2 0.4 1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
% scatter(leCr,reCr,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
% text(-0.55, 4.25,sprintf('tr R2: %.3f',trLEReg(1)),'FontSize',12)
% text(-0.55, 4.75,sprintf('con rad R2: %.3f',trLEReg(1)),'FontSize',12)
% 
% xlim([-1 5])
% ylim([-1 5])
% axis square
% set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
%     'layer','top','XTick',0:2:4,'YTick',0:2:4);
% if contains(V4data.conRadRE.animal,'XT')
%     text(3.7,-0.3,sprintf('LE tr %d',sum(LEV4chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('RE tr %d',sum(REV4chstr)),'FontSize',12)
%     text(3.7,-0.15,sprintf('LE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,0,sprintf('RE %d',sum(REV4chs)),'FontSize',12)    
% else
%     text(3.7,-0.3,sprintf('FE tr %d',sum(LEV4chstr)),'FontSize',12)
%     text(3.6,-0.75,sprintf('AE tr %d',sum(REV4chstr)),'FontSize',12)
%     text(3.7,-0.15,sprintf('FE %d',sum(LEV4chs)),'FontSize',12)
%     text(3.6,0,sprintf('AE %d',sum(REV4chs)),'FontSize',12)
% end
%%
stimBlankR2.monoc.conRegV1 = conRegV1;
stimBlankR2.monoc.radRegV1 = radRegV1;
stimBlankR2.monoc.nozRegV1 = nozRegV1;
stimBlankR2.monoc.trRegV1 = trRegV1;

stimBlankR2.monoc.conRegV4 = conRegV4;
stimBlankR2.monoc.radRegV4 = radRegV4;
stimBlankR2.monoc.nozRegV4 = nozRegV4;
stimBlankR2.monoc.trRegV4 = trRegV4;
%%
% figure (90) % DO NOT CLF THIS FIGURE, WANT TO ADD EACH ANIMAL TO IT
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 400 900])
% hold on
% makeGlassR2CompFig(conRegV1,conRegV4,radRegV1,radRegV4,trRegV1,trRegV4,V4data.conRadRE.animal)
% suptitle('R2 values for stim vs blank screen all channels')



