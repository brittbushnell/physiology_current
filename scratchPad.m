% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%

% clear
% close all
% clc
% location = determineComputer;
%%
%% sanity check figure

    figure%(1)
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 1200 900])
    set(gcf,'PaperOrientation','Landscape');
    
    for ch = 1:96
        subplot(10,10,ch)
        hold on
        histogram(dataT.zScoreReliabilityIndexPerm(ch,:),10,'FaceColor','b','EdgeColor',[0.5 0.5 0.5],'EdgeAlpha',0.3,'Normalization','probability')
        plot([dataT.zScoreReliabilityIndex(ch), dataT.zScoreReliabilityIndex(ch)], [0, 0.7],'-r')
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
