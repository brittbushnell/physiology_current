    subplot(3,2,2)
    hold on
    axis square
    
    if contains(REdata.animal,'XT')
        title('RE')
    else
        title('AE')
    end
    
    xlim([-1 1])
    ylim([yMin, yMax])
    for ch = 1:96
        y = max(REdata.StimCircDprime(1,:,ch));
        x = REdata.stimCorrs(1,ch);
        
        scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    
    subplot(3,2,4)
    hold on
    axis square
    
    
    xlim([-1 1])
    ylim([yMin, yMax])
    for ch = 1:96
        y = max(REdata.StimCircDprime(2,:,ch));
        x = REdata.stimCorrs(2,ch);
        
        scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    
    subplot(3,2,6)
    hold on
    axis square
    xlabel('Correlation')
   
    
    xlim([-1 1])
    ylim([yMin, yMax])
    for ch = 1:96
        y = max(REdata.StimCircDprime(3,:,ch));
        x = REdata.stimCorrs(3,ch);
        
        scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end