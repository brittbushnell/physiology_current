function [reliabilityIndex,split_half_correlation] = GlassTR_getHalfCorr(dataT)
%%
for nb = 1:1000
    %rearrange_spkcnt = permute(dataT.GlassTRSpikeCount,[1 2 3 4 6 5]);
    rearrange_spkcnt = permute(dataT.GlassTRZscore,[1 2 3 4 6 5]);
    reshape_spkcnt = reshape(rearrange_spkcnt,64,36,96);
    sample1 = randi(36,18,1);
    sample2 = datasample(setdiff([1:36]',sample1),18,1);
    
    set1 = squeeze(nanmean(reshape_spkcnt(:,sample1,:),2));
    set2 = squeeze(nanmean(reshape_spkcnt(:,sample2,:),2));
    
    split_half_correlation(:,nb) = diag(corr(set1,set2));
end
reliabilityIndex = median(split_half_correlation,2);
%%
figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/GlassTR/%s/distributions/halfCorr/',dataT.animal, dataT.array);
cd(figDir)
%%

%%
figure
hold on
rectangle('Position',[0.05 0 0.9 1],'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
plot([0.05 0.05], [0 1.03],'-r')
plot([0.95 0.95], [0 1.03],'-r')
plot(dataT.stimBlankChPvals,reliabilityIndex,'ok')

ylim([0 1.05])
xlim([-0.1 1.1])

set(gca,'tickdir','out','Layer','top','YTick',0:0.25:1,'XTick',0:0.2:1)

xlabel('Permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split Correlation Reliability Index','FontAngle','italic','FontSize',12)


if isempty(dataT.reThreshold)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_ReliabilityXpermTest_raw.pdf'];
    title({sprintf('%s %s %s median Half-split correlation for each channel vs Permutation test p-value',dataT.animal, dataT.eye, dataT.array);...
        'raw data'},'FontAngle','italic','FontSize',14)
else
        title({sprintf('%s %s %s median Half-split correlation for each channel vs Permutation test p-value',dataT.animal, dataT.eye, dataT.array);...
        'cleaned data'},'FontAngle','italic','FontSize',14)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_ReliabilityXpermTest_cleaned.pdf'];
end
print(gcf, figName,'-dpdf','-fillpage')
 %%
% figure%(3)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1400 1200])
% set(gcf,'PaperOrientation','Landscape');
% for ch = 1:96
%     subplot(dataT.amap,10,10,ch)
%     hold on
%     if dataT.inStim(ch) == 1
%         histogram(squeeze(splitHalfCorrDist(ch,:)),'BinWidth',0.025,'FaceColor','k','EdgeColor','w');
%         plot(reliabilityIndex(1,ch),700,'rv','MarkerFaceColor','r','MarkerSize',4)
%         set(gca,'tickdir','out','Layer','top','YTick',0:400:800)%,'XTick',0:0.25:0.75)
%         ylim([0 800])
%         %xlim([-0.1 0.75])
%         %title(ch)
%         
%     else
%         
%     end
% end
% if ~isempty(dataT.reThreshold)
%     suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
%         sprintf('Recorded %s run %s cleaned data',dataT.date, dataT.runNum)})
% else
%     suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
%         sprintf('Recorded %s run %s raw data',dataT.date, dataT.runNum)})
% end
% print(gcf, figName,'-dpdf','-fillpage')
% %%
% 
% figure%(3)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1200 1200])
% set(gcf,'PaperOrientation','Landscape');
% 
% for ch = 1:96
%     subplot(dataT.amap,10,10,ch)
%     hold on
%     if dataT.inStim(ch) == 1
%         plot(splitHalfCorrDist(ch,:),'.','Color',[0.8, 0, 0.2],'MarkerSize',4);
%         
%         set(gca,'tickDir','out','Layer','top')
%        ylim([-0.25 1])
% 
% %         ylabel('reliability metric')
% %         xlabel('ch')
%     end
% end
% 
% if isempty(dataT.reThreshold)
%     suptitle({sprintf('%s %s %s split half correlations across orientations for each stimulus at 100%% coherence raw data',dataT.animal,dataT.eye, dataT.array);...
%         sprintf('R: 0%c  G: 45%c  B: 90%c  P: 135%c',char(176),char(176),char(176),char(176))});
%     
%     figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_splitCorrByStim_raw_ch',num2str(ch),'.pdf'];
% else
%     suptitle({sprintf('%s %s %s split half correlations across orientations for each stimulus at 100%% coherence clean data',dataT.animal,dataT.eye, dataT.array);...
%         sprintf('R: 0%c  G: 45%c  B: 90%c  P: 135%c',char(176),char(176),char(176),char(176))});
%     
%     figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_splitCorrByStim_clean_ch',num2str(ch),'.pdf'];
% end
% print(gcf, figName,'-dpdf','-fillpage')
