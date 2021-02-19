s = subplot(2,3,4);
le =  reshape(v4ConLE,numel(v4ConLE),1);
re = reshape(v4ConRE,numel(v4ConRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,nozReg] = regress(le,regX);

hold on
scatter(le,re,40,'markerfacecolor', [0.7 0 0.7],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',nozReg(1))) 
plot([-2 5],[-2 5],'k')

title('Concentric')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
if contains(V4data.conRadRE.animal,'XT')
    xlabel('LE')
    ylabel('RE')
else
    xlabel('FE')
    ylabel('AE')
end

text(-3.5,2,'V4','FontSize',20,'FontWeight','bold') 
clear le; clear re; clear regX;

s = subplot(2,3,5);
le = reshape(v4RadLE,numel(v4RadLE),1);
re = reshape(v4RadRE,numel(v4RadRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,radReg] = regress(le,regX);

hold on
scatter(le,re,40,'markerfacecolor', [0 0.6 0.2],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',radReg(1))) 
plot([-2 5],[-2 5],'k')

title('Radial')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
clear le; clear re; clear regX;

s = subplot(2,3,6);
le =  reshape(v4NozLE,numel(v4NozLE),1);
re = reshape(v4NozRE,numel(v4NozRE),1);
oneMtx = ones(length(re),1);
regX = [oneMtx,re];
[~,~,~,~,nozReg] = regress(le,regX);
hold on
scatter(le,re,40,'markerfacecolor', [1 0.5 0.1],'markeredgecolor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
text(-0.5, 4.5,sprintf('R2: %.3f',nozReg(1))) 
plot([-2 5],[-2 5],'k')

title('Dipole')
set(gca,'color','none','tickdir','out','box','off','FontSize',12,'FontWeight','bold','FontAngle','italic',...
    'layer','top','XTick',0:2:4,'YTick',0:2:4);
xlim([-1 5])
ylim([-1 5])
axis square
clear le; clear re; clear regX;