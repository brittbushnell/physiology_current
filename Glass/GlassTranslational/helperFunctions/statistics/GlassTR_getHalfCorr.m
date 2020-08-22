

%%
[numOris,numDots,numDxs,numCoh,~,orisDeg,dots,dxs,coherences,~] = getGlassTRParameters(dataT);

chSplitHalfCorrDist = nan(numOris,numCoh,numDots,numDxs,96,1000);
chReliabilityIndex = nan(1,96);


for ch = 1:96
    if dataT.inStim(ch) == 1
        for dt = 1:numDots
            for dx = 1:numDxs
                for coh = 1:numCoh
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
                    end
                end
            end
        end
    end
end
%% do reliability metric
for ch = 1:96
    useResps = squeeze(chSplitHalfCorrDist(:,:,:,:,ch,:));
    medParamZch(ch,:) = nanmedian(reshape(useResps,1000,(4*4*2*2)),1);
    chReliabilityIndex(1,ch) = median(medParamZch(ch,:));
end
%%
figure(3)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1200])
set(gcf,'PaperOrientation','Landscape');
for ch = 1:96
    subplot(dataT.amap,10,10,ch)
    hold on
    if dataT.inStim(ch) == 1
        histogram(squeeze(chSplitHalfCorrDist(ch,:)),'BinWidth',0.05,'FaceColor','k','EdgeColor','w');
        %plot([chReliabilityIndex(1,ch) chReliabilityIndex(1,ch)], [0 120],'r-')
        plot(chReliabilityIndex(1,ch),700,'rv','MarkerFaceColor','r','MarkerSize',4)
        set(gca,'tickdir','out','Layer','top','YTick',0:400:800,'XTick',0:0.25:0.75)
        ylim([0 800])
        xlim([-0.1 0.75])
        %title(ch)
        
    else
        axis off
    end
end
if ~isempty(dataT.reThreshold)
    suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
        sprintf('Recorded %s run %s cleaned data',dataT.date, dataT.runNum)})
else
    suptitle({sprintf('%s %s %s half split correlations of the zscore of spike counts for all stimuli',dataT.animal, dataT.eye, dataT.array);...
        sprintf('Recorded %s run %s raw data',dataT.date, dataT.runNum)})
end
%%
figure(4)
hold on
possib = reshape(medParamZch,1,numel(medParamZch));
% plot(chReliabilityIndex,dataT.stimBlankChPvals,'ok')
plot(possib,dataT.stimBlankChPvals,'ok')

% ylim([0 1])
% xlim([0 1.2])
% plot([0.5 0.5], [0 1.],':b')
% plot([0.95 0.95], [0 1],':b')

set(gca,'tickdir','out','Layer','top')

xlabel('Permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split Correlation Reliability Index','FontAngle','italic','FontSize',12)
title(sprintf('%s %s %s Half-split correlation vs Permutation test',dataT.animal, dataT.eye, dataT.array),'FontAngle','italic','FontSize',14)