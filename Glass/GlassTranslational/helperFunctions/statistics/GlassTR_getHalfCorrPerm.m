function [dataT] = GlassTR_getHalfCorrPerm(dataT)
%%
splitHalf = nan(96,1000);
%splitHalfPerm = nan(96,2000);

rearrange_spkcnt = permute(dataT.GlassTRSpikeCount,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
numRepeats = size(dataT.GlassTRZscore,6);
reshape_spkcnt = reshape(rearrange_spkcnt,64,numRepeats,96); % reshape into a vector. 64 = number of conditions.

for nb = 1:1000
    sample1 = randperm(numRepeats,round(numRepeats/2)); % randomly choose half of the repeats
    sample2 = datasample(setdiff([1:numRepeats]',sample1),round(numRepeats/2),1); % find the repeats not in sample1
    
    set1 = squeeze(nanmean(reshape_spkcnt(:,sample1,:),2));
    set2 = squeeze(nanmean(reshape_spkcnt(:,sample2,:),2));
    
    splitHalf(:,nb) = diag(corr(set1,set2)); %96xnb
end
reliabilityIndex = median(splitHalf,2);

%% get permutations
numPerm = size(reshape_spkcnt,1);
for boot = 1:2000
    for nb = 1:1000
    sample1 = randperm(numPerm,round(numPerm/2)); % randomly choose half of the repeats
    sample2 = datasample(setdiff([1:numPerm]',sample1),round(numPerm/2),1); % find the repeats not in sample1
    
    set1 = squeeze(nanmean(reshape_spkcnt(sample1,:,:),2));
    set2 = squeeze(nanmean(reshape_spkcnt(sample2,:,:),2));
    
    splitHalfPerm(:,nb) = diag(corr(set1,set2)); %96xnb
    end
    reliabilityIndexPerm(:,boot) = median(splitHalfPerm,2); % since the reliability index is the "true" value you're comparing against, that's the value you have to permute
end
 %% do permutation test
 [pVals,sigChs] = glassGetPermutationStatsAndGoodCh(reliabilityIndex,reliabilityIndexPerm);
 %%
 dataT.splitHalfCorr = splitHalf;
 dataT.splitHalfPerm = splitHalfPerm;
 dataT.reliabilityIndex = reliabilityIndex;
 dataT.splitHalfPvals = pVals;
 dataT.splitHalfSigChs = sigChs;
 %%
location = determineComputer;
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal, dataT.programID, dataT.array);
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal, dataT.programID, dataT.array);
end
cd(figDir)
%%
figure(1)
clf
hold on
rectangle('Position',[-0.1 0.05 1.4 0.9],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
rectangle('Position',[0.05 -0.1 0.9 1.5],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])

plot([-0.1 1.1], [0.05 0.05], '--b')
plot([-0.1 1.1], [0.95 0.95], '--b')
plot([0.05 0.05], [-0.1 1.1], '--b')
plot([0.95 0.95], [-0.1 1.1], '--b')
ylim([-0.1 1.1])
xlim([-0.1 1.1])

plot(dataT.stimBlankChPvals(dataT.inStim == 1),pVals(dataT.inStim == 1),'o','MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor',[0.2 0.2 0.2])
plot(dataT.stimBlankChPvals(dataT.inStim == 0),pVals(dataT.inStim == 0),'o','MarkerEdgeColor',[0.2 0.2 0.2])


set(gca,'tickdir','out','Layer','top','YTick',0:0.25:1,'XTick',0:0.2:1)

xlabel('Visual response permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split permutation p-value','FontAngle','italic','FontSize',12)



title({sprintf('%s %s %s Half-split p-value vs visual response p-value',dataT.animal, dataT.eye, dataT.array);...
    'data in gray areas are excluded'},'FontAngle','italic','FontSize',14)
figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_ReliabilityXpermTest_clean_',dataT.date2,'_',dataT.runNum,'.pdf'];

print(gcf, figName,'-dpdf','-fillpage')