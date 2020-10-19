function [] = plotGlassChiSquareDistribution(data)

%%
REchiVals = data.RE.chiVals;
LEchiVals = data.LE.chiVals;
%%
location = determineComputer;

if length(dataT.inStim) > 96
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/stats/singleSession/',data.RE.animal,data.RE.programID,data.RE.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/stats/singleSession/',data.RE.animal,data.RE.programID,data.RE.array);
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/stats',data.RE.animal,data.RE.programID,data.RE.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/stats',data.RE.animal,data.RE.programID,data.RE.array);
    end
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
plot((nanmean(log10(data.LE.chiVals))),0.45,'vc','MarkerFaceColor',[0 0.6 1],'MarkerEdgeColor',[0 0.6 1],'MarkerSize',9)

text((nanmean(log10(data.LE.chiVals)))+0.2,0.45,sprintf('mean %.2f',(nanmean(log10(data.LE.chiVals)))),'FontSize',12)

set(gca,'color','none','tickdir','out','box','off','FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold',...
    'XTick',-1.5:1.5:1.5,'XTickLabel',[])

ylabel('Probability')
if contains(data.LE.animal,'XT')
    title('LE')
else
    title('FE')
end


subplot(2,1,2)
hold on
histogram(log10(REchiVals),-1.5:0.25:1.5,'Normalization','probability','FaceColor','r','FaceAlpha',1,'edgecolor','w')
plot((nanmean(log10(data.RE.chiVals))),0.45,'vr','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',9)

text((nanmean(log10(data.RE.chiVals)))+0.2,0.45,sprintf('mean %.2f',(nanmean(log10(data.RE.chiVals)))),'FontSize',12)
set(gca,'color','none','tickdir','out','box','off','FontAngle','italic','FontSize',12,'layer','top','FontWeight','Bold',...
    'XTick',-1.5:1.5:1.5,'XTickLabel',{'homogenous','0','inhomogenous'})
ylabel('Probability')
xlabel('Log chi square')
xlim([-2 2])
if contains(data.RE.animal,'XT')
    title('RE')
else
    title('AE')
end

suptitle(sprintf('%s %s Chi square homogeneity values cleaned and merged data',data.RE.animal, data.RE.array))
%% WU_ChiSquareDistributionLog
figName = [data.RE.animal,'_',data.RE.array,'_',data.RE.programID,'_chiSquareDistLog_cleanedMerged'];
print(gcf, figName,'-dpdf','-fillpage')










