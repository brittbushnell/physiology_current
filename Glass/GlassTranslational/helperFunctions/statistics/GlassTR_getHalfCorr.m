function [reliabilityMetricByCond,chSplitHalfCorrDist,chReliabilityIndex] = GlassTR_getHalfCorr(dataT)

%%
[numOris,numDots,numDxs,numCoh,~,orientations,dots,dxs,coherences,~] = getGlassTRParameters(dataT);

chSplitHalfCorrDist = nan(numOris,numCoh,numDots,numDxs,96,1000);
chReliabilityIndex = nan(1,96);
reliabilityMetricByCond = nan(numOris,numCoh,numDots,numDxs,96);

for ch = 1:96
    if dataT.inStim(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        corrBoot = nan(1,1000);
                        for nb = 1:1000
                            relTrials = squeeze(dataT.RFinStimGlassZscore(or,co,dt,dx,ch,:));
                            [randA,randB] = subsampleStimuli(relTrials,round(length(relTrials)/2));
                            countA = squeeze(relTrials(randA));
                            countB = squeeze(relTrials(randB));
                            corrBoot(1,nb) = corr2(countA,countB);
                        end
                        chSplitHalfCorrDist(or,co,dt,dx,ch,:) = corrBoot;
                        reliabilityMetricByCond(or,co,dt,dx,ch) = median(corrBoot);
                    end 
                end
            end
        end
    end
    chVect = reshape(reliabilityMetricByCond(:,:,:,:,ch),1,numel(reliabilityMetricByCond(:,:,:,:,ch)));
    chReliabilityIndex(1,ch) = median(chVect); % get the median of that.
end


%% 
% for ch = 1%:96
%     chReliabilityIndex(1,ch) = median(reliabilityMetricByCond(ch,:)); % get the median of that.
%     
%     
%     figure(1)
%     clf
%     pos = get(gcf,'Position');
%     set(gcf,'Position',[pos(1) pos(2) 1200 1200])
%     set(gcf,'PaperOrientation','Landscape');
%     ndx = 1;
%     
%     for dt = 1:numDots
%         for dx = 1:numDxs
%             
%             subplot(2,2,ndx)
%             hold on
%             for or = 1:numOris
%                 randTrials = randi(1000,[1,300]);
%                 useCorrs = squeeze(chSplitHalfCorrDist(or,end,dt,dx,ch,randTrials));
%                 
%                 if or == 1
%                     plot(useCorrs,'o','MarkerEdgeColor',[0.8, 0, 0.2]);
%                     
%                 elseif or == 2
%                     plot(useCorrs,'o','MarkerEdgeColor',[0, 0.4, 0.2]);
%                 elseif or == 3
%                     plot(useCorrs,'o','MarkerEdgeColor',[0, 0.4, 1]);
%                 else
%                     plot(useCorrs,'o','MarkerEdgeColor',[0.6, 0, 0.6])
%                 end
%                 ylim([-1 1])
%                 %xlim([-1 1001])
%             end 
%             
%             if ndx >=3
%                 xlabel('permutation number')
%             end
%             if ndx == 1 || ndx == 3
%                 ylabel('split half correlation value')
%             end
%             set(gca,'tickDir','out')
%             
%             ndx = ndx+1;
%         end
%     end
%     suptitle(sprintf('%s %s %s split half correlations across orientations at 100%% coherence',dataT.animal,dataT.eye, dataT.array))
% end
%%
figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/GlassTR/%s/distributions/',dataT.animal, dataT.array);
cd(figDir)

folder = 'halfCorr';
mkdir(folder)
cd(sprintf('%s',folder))

folder = dataT.date2;
mkdir(folder)
cd(sprintf('%s',folder))

folder = dataT.eye;
mkdir(folder)
cd(sprintf('%s',folder))

if isempty(dataT.reThreshold)
    folder = 'raw';
    mkdir(folder)
    cd(sprintf('%s',folder))
else
    folder = 'reThreshold';
    mkdir(folder)
    cd(sprintf('%s',folder))
end
%%
for ch = 1:96
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 800 1200])
    set(gcf,'PaperOrientation','Landscape');
    ndx = 1;
    
    for dt = 1:numDots
        for dx = 1:numDxs
            for or = 1:numOris
                subplot(4,4,ndx)
                hold on
                useCorrs = squeeze(chSplitHalfCorrDist(or,end,dt,dx,ch,:));
                rel = reliabilityMetricByCond(or,end,dt,dx,ch);
                
                histogram(useCorrs,'BinWidth',0.05,'FaceColor','k','EdgeColor','w');
                plot([rel rel], [0 110], '-r','LineWidth',1.3)
                text(rel,120,sprintf('%.2f',rel),'HorizontalAlignment','center')
                ylim([0 130])
                xlim([-1 1])
                title(sprintf('%d%c %d dots %.2f dx',orientations(or),char(176),dots(dt),dxs(dx)));
                
                if ndx >=13
                    xlabel('split half correlation')
                end
                if ndx == 1 || ndx == 5 || ndx == 9 || ndx == 13
                    ylabel('# occurrances')
                end
                set(gca,'tickDir','out','Layer','top')
                ndx = ndx+1;
            end
            
        end
    end
    suptitle({sprintf('%s %s %s split half correlations across orientations at 100%% coherence',dataT.animal,dataT.eye, dataT.array);...
        sprintf('ch %d',ch)})
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_splitCorrByStim_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
end
%%
figure(3)
clf
ndx = 1;
for dt = 1:numDots
    for dx = 1:numDxs
        subplot(2,2,ndx)
        hold on
        for or = 1:numOris
            rel = squeeze(reliabilityMetricByCond(or,end,dt,dx,:));
            if or == 1
                plot(rel,'o','MarkerEdgeColor',[0.8, 0, 0.2]);
                
            elseif or == 2
                plot(rel,'o','MarkerEdgeColor',[0, 0.4, 0.2]);
            elseif or == 3
                plot(rel,'o','MarkerEdgeColor',[0, 0.4, 1]);
            else
                plot(rel,'o','MarkerEdgeColor',[0.6, 0, 0.6])
            end
        end
         set(gca,'tickDir','out','Layer','top')
        ylim([-0.25 1])
        title(sprintf('%d dots %.2f dx',dots(dt),dxs(dx)))
        ndx = ndx+1;
        ylabel('reliability metric')
        xlabel('ch')
    end
end
    suptitle({sprintf('%s %s %s split half correlations across orientations for each stimulus at 100%% coherence',dataT.animal,dataT.eye, dataT.array);...
        sprintf('R: 0%c  G: 45%c  B: 90%c  P: 135%c',char(176),char(176),char(176),char(176))});
    
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_splitCorrByStim_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-fillpage')
%%
% figure%(3)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 1200 1200])
% set(gcf,'PaperOrientation','Landscape');
% for ch = 1:96
%     subplot(dataT.amap,10,10,ch)
%     hold on
%     if dataT.inStim(ch) == 1
%         histogram(squeeze(chSplitHalfCorrDist(ch,:)),'BinWidth',0.05,'FaceColor','k','EdgeColor','w');
%         %plot([chReliabilityIndex(1,ch) chReliabilityIndex(1,ch)], [0 120],'r-')
%         plot(chReliabilityIndex(1,ch),700,'rv','MarkerFaceColor','r','MarkerSize',4)
%         set(gca,'tickdir','out','Layer','top','YTick',0:400:800,'XTick',0:0.25:0.75)
%         ylim([0 800])
%         xlim([-0.1 0.75])
%         %title(ch)
%         
%     else
%         axis off
%     end
% end
% if ~isempty(dataT.reThreshold)
%     suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
%         sprintf('Recorded %s run %s cleaned data',dataT.date, dataT.runNum)})
% else
%     suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
%         sprintf('Recorded %s run %s raw data',dataT.date, dataT.runNum)})
% end
%%
figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/GlassTR/%s/distributions/halfCorr/',dataT.animal, dataT.array);
cd(figDir)

figure
hold on

plot(chReliabilityIndex,dataT.stimBlankChPvals,'ok')

ylim([0 1.05])
%xlim([-0.1 .75])
plot([0.05 0.05], [0 1.03],':r')
% plot([0.95 0.95], [0 1.03],':b')

set(gca,'tickdir','out','Layer','top','YTick',0:0.25:1,'XTick',0:0.2:1)

xlabel('Permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split Correlation Reliability Index','FontAngle','italic','FontSize',12)
title(sprintf('%s %s %s median Half-split correlation for each channel vs Permutation test p-value',dataT.animal, dataT.eye, dataT.array),'FontAngle','italic','FontSize',14)

if isempty(dataT.reThreshold)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_ReliabilityXpermTest_raw.pdf'];
else
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_ReliabilityXpermTest_cleaned.pdf'];
end
print(gcf, figName,'-dpdf','-fillpage')
