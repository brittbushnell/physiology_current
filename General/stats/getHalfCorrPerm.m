function [reliabilityIndex, pVals,sigChs,reliabilityIndexPerm] = getHalfCorrPerm(varargin)
%  This function will do the split half correlation tests as well as the
%  permutation test to check for significant reliability across
%  runs/sessions/days depending on what you put into it.
%
%  INPUT
%   conditionZscores:  3-D matrix that is:
%           (conditions x repeats x channels)
%
%  OPTIONAL INPUTS
%    By default, the program will do the true split-half correlations 1,000
%    times. For the permutation test it will do 500 split-half correlations
%    2,000 times to compute 2,000 permuted reliability indices.
%
%   defaults:
%         conditionZscores = varargin{1};  <- must pass in this matrix
%         numPerm = 2000;
%         numBoot = 1000;
%         plotFlag = 1;
%
%
%   OUTPUT
%    Reliability index: vector of measured reliability indexes for each
%    channel
%
%    pVals: p values of the permutation test on the inidces
%
%    sigChs: logical vector of whether each channel's reliability index is
%    significant or not.  (0 = no, 1 = yes)
%
%    reliabilityIndexPerm:  96x2000 matrix of the permuted reliability
%    indices calcultaed.
%
%    Default plot shows the distribution of the permuted reliability
%    indices for each channel and the observed index plotted as a red line.
%    This is a sanity check figure that's not saved anywhere by default.
%
%
%  Brittany Bushnell 9/24/2020
%%
switch nargin
    case 0
        error ('Must pass in your data matrix at a minimum')
    case 1
        conditionZscores = varargin{1};
        numPerm = 2000;
        numBoot = 1000;
        plotFlag = 1;
    case 2
        conditionZscores = varargin{1};
        numPerm = varargin{2};
        numBoot = 1000;
        plotFlag = 1;
    case 3
        conditionZscores = varargin{1};
        numPerm = varargin{2};
        numBoot = varargin{3};
        plotFlag = 1;
    case 4
        conditionZscores = varargin{1};
        numPerm = varargin{2};
        numBoot = varargin{3};
        plotFlag = varargin{4};
end

if ndims(conditionZscores) ~= 3
    error(fprintf('Input to getHalfCorrPerm should be a 3 dimensional matrix. Your input has %d dimensions',ndims(conditionZscores)))
end
%%
splitHalf = nan(96,numBoot);
splitHalfPerm = nan(96,numBoot);
reliabilityIndexPerm = nan(96,numPerm);
numRepeats = size(conditionZscores,2);

for boot = 1:numBoot
    sample1 = randperm(numRepeats,round(numRepeats/2)); % randomly choose half of the repeats
    sample2 = datasample(setdiff([1:numRepeats]',sample1),round(numRepeats/2),1); % find the repeats not in sample1
    
    set1 = squeeze(nanmean(conditionZscores(:,sample1,:),2));
    set2 = squeeze(nanmean(conditionZscores(:,sample2,:),2));
    
    splitHalf(:,boot) = diag(corr(set1,set2)); %96xnb
end
reliabilityIndex = nanmedian(splitHalf,2);

%% get permutations
numCond = size(conditionZscores,1);
for perm = 1:numPerm
    for boot = 1:(numBoot/2)
        sample1 = randperm(numCond,round(numCond/2)); % randomly choose half of the repeats
        sample2 = datasample(setdiff([1:numCond]',sample1),round(numCond/2),1); % find the repeats not in sample1
        
        set1 = squeeze(nanmean(conditionZscores(sample1,:,:),2));
        set2 = squeeze(nanmean(conditionZscores(sample2,:,:),2));
        
        splitHalfPerm(:,boot) = diag(corr(set1,set2)); %96xnb
    end
    reliabilityIndexPerm(:,perm) = nanmedian(splitHalfPerm,2); % since the reliability index is the "true" value you're comparing against, that's the value you have to permute
end
%% do permutation test
[pVals,sigChs] = glassGetPermutationStatsAndGoodCh(reliabilityIndex,reliabilityIndexPerm,1);
%% sanity check figure
if plotFlag == 1
    figure(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1200 900])
    set(gcf,'PaperOrientation','Landscape');
    
    for ch = 1:96
        subplot(10,10,ch)
        hold on
        histogram(reliabilityIndexPerm(ch,:),8,'FaceColor','b','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability')
        plot([reliabilityIndex(ch), reliabilityIndex(ch)], [0, 0.7],'-r')
        %xlim([-0.1 0.55])
        ylim([0 1])
        t = title(ch);
        t.Position(2) = t.Position(2)-0.25; % move the title down a bit so it doesn't hit the x axis from figures above
        if ch >= 91
            xlabel('reliability index')
        end
        
        if ch == 91
            ylabel('probability')
        end
    end
    suptitle('reliability index permutation distributions vs observed (red line)')
end
