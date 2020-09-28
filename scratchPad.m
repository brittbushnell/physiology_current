% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
tic
zScored_chLast = permute(dataT.GlassTRSpikeCount,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
numRepeats = size(dataT.GlassTRSpikeCount,6);
spikeCountReshape = reshape(zScored_chLast,64,numRepeats,96); % reshape into a vector. 64 = number of conditions.

[RIspikeCount, RIspikeCountPvals,splitHalfSigChsSpikeCount,reliabilityIndexPermSpikeCount] = getHalfCorrPerm(spikeCountReshape);
toc/60

zScored_chLast = permute(dataT.GlassTRZscore,[1 2 3 4 6 5]);% rearrange so number of channels is the last thing.
numRepeats = size(dataT.GlassTRZscore,6);
zScoreReshape = reshape(zScored_chLast,64,numRepeats,96); % reshape 64 = number of conditions.

[RIzScore, RIzScorePvals,splitHalfSigChsZscore,reliabilityIndexPermzScore] = getHalfCorrPerm(zScoreReshape);
toc/60
%%
figure
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    subplot(10,10,ch)
    hold on
    histogram(reliabilityIndexPermzScore(ch,:),10,'FaceColor','b','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability','FaceAlpha',0.5)
    histogram(reliabilityIndexPermSpikeCount(ch,:),10,'FaceColor','r','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability','FaceAlpha',0.5)

    xlim([-0.04 0.04])
    ylim([0 0.7])
    t = title(ch);
    t.Position(2) = t.Position(2)-0.25; % move the title down a bit so it doesn't hit the x axis from figures above
    if ch >= 91
        xlabel('reliability index')
    end
    
    if ch == 91
        ylabel('probability')
    end
end
suptitle('reliability index permutations using zscore (blue) and spike counts (red)')
%%
figure
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 900])
set(gcf,'PaperOrientation','Landscape');

for ch = 1:96
    subplot(10,10,ch)
    hold on
    histogram(zScoreSplitHalf(ch,:),10,'FaceColor','b','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability','FaceAlpha',0.5)
    histogram(spikeCountSplitHalf(ch,:),10,'FaceColor','r','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability','FaceAlpha',0.5)

    %xlim([-0.04 0.04])
    ylim([0 0.7])
    t = title(ch);
    t.Position(2) = t.Position(2)-0.25; % move the title down a bit so it doesn't hit the x axis from figures above
%     if ch >= 91
%         xlabel('reliability index')
%     end
    
    if ch == 91
        ylabel('probability')
    end
end
suptitle('split-half correlations using zscore (blue) and spike counts (red)')
