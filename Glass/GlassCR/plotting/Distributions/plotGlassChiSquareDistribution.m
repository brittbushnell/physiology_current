function [] = plotGlassChiSquareDistribution(data)

%%
REchiVals = data.RE.chiVals;
LEchiVals = data.LE.chiVals;
%%
location = determineComputer;
if contains(data.RE.animal,'WV')
    if contains(data.RE.programID,'Small')
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/stats',data.RE.animal,data.RE.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/stats',data.RE.animal,data.RE.array);
        end
    else
        if location == 1
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/stats',data.RE.animal,data.RE.array);
        elseif location == 0
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/stats',data.RE.animal,data.RE.array);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/stats',data.RE.animal,data.RE.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/stats',data.RE.animal,data.RE.array);
    end
end
cd(figDir)
%%
% LEbins = logspace(-1,1,20);
% REbins = logspace(-1,1,20);

figure(12)
clf

subplot(2,1,1)
hold on
histogram(log10(LEchiVals),-1.5:0.25:1.5,'Normalization','probability','FaceColor','c','FaceAlpha',1,'edgecolor','w');
plot((nanmean(log10(data.LE.chiVals))),0.5,'vc','MarkerFaceColor','c','MarkerEdgeColor','c','MarkerSize',8)

text(1,0.4,sprintf('mean %.2f',(nanmean(log10(data.LE.chiVals)))),'FontWeight','Bold')

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
plot((nanmean(log10(data.RE.chiVals))),0.5,'vr','MarkerFaceColor','r','MarkerEdgeColor','r','MarkerSize',8)

text(1,0.4,sprintf('mean %.2f',(nanmean(log10(data.RE.chiVals)))),'FontWeight','Bold')
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

suptitle(sprintf('%s %s Chi square values best time windows',data.RE.animal, data.RE.array))
%% WU_ChiSquareDistributionLog
figName = [data.RE.animal,'_',data.RE.array,'_',data.RE.programID,'_chiSquareDistLog_prefWin_',data.RE.date2,'_',data.RE.runNum];
print(gcf, figName,'-dpdf','-fillpage')










