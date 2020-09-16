function [dataT] = Glass_getHalfCorrPerm(dataT)
%% Get real half-split correlations
splitHalf = nan(96,1000);
splitHalfPerm = nan(96,2000);
    rearrange_spkcnt = permute(dataT.GlassSpikeCount,[1 2 3 5 4]);% rearrange so number of channels is the last thing.
    %rearrange_spkcnt = permute(dataT.GlassZscore,[1 2 3 4 6 5]);
    numRepeats = size(dataT.GlassZscore,5);
    reshape_spkcnt = reshape(rearrange_spkcnt,16,numRepeats,96); 
for nb = 1:1000

    sample1 = randperm(numRepeats,round(numRepeats/2));
    sample2 = datasample(setdiff([1:numRepeats]',sample1),round(numRepeats/2),1);
    
    set1 = squeeze(nanmean(reshape_spkcnt(:,sample1,:),2));
    set2 = squeeze(nanmean(reshape_spkcnt(:,sample2,:),2));
    
    splitHalf(:,nb) = diag(corr(set1,set2));
end
reliabilityIndex = median(splitHalf,2);
reliabilityIndex = reliabilityIndex';
%% permute half-split
for boot = 1:2000
    sample1 = randperm(numRepeats,round(numRepeats/2)); % randomly choose half of the repeats
    sample2 = datasample(setdiff([1:numRepeats]',sample1),round(numRepeats/2),1); % find the repeats not in sample1
    
    set1 = squeeze(nanmean(reshape_spkcnt(sample1,:,:),2));
    set2 = squeeze(nanmean(reshape_spkcnt(sample2,:,:),2));
    
    splitHalfPerm(:,boot) = diag(corr(set1,set2)); %96xnb
end
  %% do permutation test
 [pVals,sigChs] = glassGetPermutationStatsAndGoodCh(reliabilityIndex',splitHalfPerm);
 %%
 dataT.splitHalfCorr = splitHalf;
 dataT.splitHalfPerm = splitHalfPerm;
 dataT.reliabilityIndex = reliabilityIndex;
 dataT.splitHalfPvals = pVals;
 dataT.splitHalfSigChs = sigChs;   
%%
location = determineComputer;
if location == 0
    figDir =  sprintf( '/Users/brittany/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal,dataT.programID, dataT.array);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
else
    figDir =  sprintf( '/Local/Users/bushnell/Dropbox/Figures/%s/%s/%s/stats/halfCorr/',dataT.animal, dataT.programID,dataT.array);
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
end
cd(figDir)
%%
figure(1)
clf
hold on
rectangle('Position',[0.05 0.05 0.9 0.9],'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])

plot(dataT.stimBlankChPvals(dataT.inStim == 1),reliabilityIndex(dataT.inStim == 1),'o','MarkerFaceColor',[0.2 0.2 0.2],'MarkerEdgeColor',[0.2 0.2 0.2])
plot(dataT.stimBlankChPvals(dataT.inStim == 0),reliabilityIndex(dataT.inStim == 0),'o','MarkerEdgeColor',[0.2 0.2 0.2])

ylim([-0.1 1.1])
xlim([-0.1 1.1])

set(gca,'tickdir','out','Layer','top','YTick',0:0.25:1,'XTick',0:0.2:1)

xlabel('Permutation p-value','FontAngle','italic','FontSize',12)
ylabel('Half-Split Correlation permutation p-value','FontAngle','italic','FontSize',12)


if isempty(dataT.reThreshold)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_halfSplit_raw',dataT.date2,'_',dataT.runNum,'.pdf'];
    title({sprintf('%s %s %s median Half-split correlation for each channel vs Permutation test p-value',dataT.animal, dataT.eye, dataT.array);...
        'raw data'},'FontAngle','italic','FontSize',14)
else
        title({sprintf('%s %s %s median Half-split correlation for each channel vs Permutation test p-value',dataT.animal, dataT.eye, dataT.array);...
        'cleaned data'},'FontAngle','italic','FontSize',14)
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_',dataT.programID,'_halSplit_clean_',dataT.date2,'_',dataT.runNum,'.pdf'];
end
print(gcf, figName,'-dpdf','-fillpage')