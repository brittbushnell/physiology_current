function [] = plotGlassChiSquareDistribution(REdata,LEdata)

%%
REchiVals = REdata.chiVals;
LEchiVals = LEdata.chiVals;
%%
location = determineComputer;


if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/stats',REdata.animal,REdata.programID,REdata.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/stats',REdata.animal,REdata.programID,REdata.array);
end


if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
% LEbins = logspace(-1,1,20);
% REbins = logspace(-1,1,20);

figure(3)
clf

subplot(2,1,1)
hold on
histogram(log10(LEchiVals),-1.5:0.25:1.5,'Normalization','probability','FaceColor',[0 0.6 1],'FaceAlpha',1,'edgecolor','w');
plot((nanmean(log10(LEdata.chiVals))),0.45,'vc','MarkerFaceColor',[0 0.6 1],'MarkerEdgeColor',[0 0.6 1],'MarkerSize',9)

text((nanmean(log10(LEdata.chiVals)))+0.2,0.45,sprintf('mean %.2f',(nanmean(log10(LEdata.chiVals)))),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold',...
    'XTick',-1.5:1.5:1.5,'XTickLabel',[])

ylabel('Probability')
if contains(LEdata.animal,'XT')
    title('LE')
else
    title('FE')
end


subplot(2,1,2)
hold on
histogram(log10(REchiVals),-1.5:0.25:1.5,'Normalization','probability','FaceColor','r','FaceAlpha',1,'edgecolor','w')
plot((nanmean(log10(REdata.chiVals))),0.45,'vr','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',9)

text((nanmean(log10(REdata.chiVals)))+0.2,0.45,sprintf('mean %.2f',(nanmean(log10(REdata.chiVals)))),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold',...
    'XTick',-1.5:1.5:1.5,'XTickLabel',{'homogenous','0','inhomogenous'})
ylabel('Probability')
xlabel('Log chi square')
xlim([-2 2])
if contains(REdata.animal,'XT')
    title('RE')
else
    title('AE')
end

suptitle(sprintf('%s %s Chi square homogeneity values cleaned and merged data',REdata.animal, REdata.array))
%% WU_ChiSquareDistributionLog
figName = [REdata.animal,'_',REdata.array,'_',REdata.programID,'_chiSquareDistLog_cleanedMerged'];
print(gcf, figName,'-dpdf','-fillpage')










