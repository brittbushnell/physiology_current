%for ch = 1:numCh
for r = 1:3
    for ch = 1:numCh
        if r == 1
            ph2 = 45;
        elseif r == 2
            ph2 = 22.5;
        elseif r == 3
            ph2 = 11.25;
        end
        
        LEndx1 = find((LEdata.stimResps{ch}(4,:) == RFs(r)) & (LEdata.stimResps{ch}(6,:) == 0) & (LEdata.stimResps{ch}(9,:) == -3));
        LEndx2 = find((LEdata.stimResps{ch}(4,:) == RFs(r)) & (LEdata.stimResps{ch}(6,:) == ph2) & (LEdata.stimResps{ch}(9,:) == -3));
        
        REndx1 = find((REdata.stimResps{ch}(4,:) == RFs(r)) & (REdata.stimResps{ch}(6,:) == 0) & (REdata.stimResps{ch}(9,:) == -3));
        REndx2 = find((REdata.stimResps{ch}(4,:) == RFs(r)) & (REdata.stimResps{ch}(6,:) == ph2) & (REdata.stimResps{ch}(9,:) == -3));
        
        LEResps(1,:) = LEdata.stimResps{ch}(3,LEndx1);
        LEResps(2,:) = LEdata.stimResps{ch}(3,LEndx2);
        
        REResps(1,:) = REdata.stimResps{ch}(3,REndx1);
        REResps(2,:) = REdata.stimResps{ch}(3,REndx2);
        
        orL(1,:) = mean(LEResps,2);
        orR(1,:) = mean(REResps,2);
        
        LEMeans(:,ch) = orL';
        REMeans(:,ch) = orR';
        
        [mx,Idx] = max(orL);
        if Idx == 1
            phasePrefLE{r}(1,ch) = 0;
        else
            phasePrefLE{r}(1,ch) = ph2;
        end
        phasePrefLE{r}(2,ch) = mx;
        
        [mx,Idx] = max(orR);
        if Idx == 1
            phasePrefRE{r}(1,ch) = 0;
        else
            phasePrefRE{r}(1,ch) = ph2;
        end
        phasePrefRE{r}(2,ch) = mx;
        
    end
    
    figure
    subplot(2,1,1)
    hold on
    plot(LEMeans(1,:),'b','LineWidth',1)
    plot(LEMeans(2,:),'Color',[0 0.6 0.4],'LineWidth',1)
    plot(LEMeans(1,:),'.b','MarkerSize',8)
    plot(LEMeans(2,:),'.','MarkerSize',8,'Color',[0 0.6 0.4])
    legend('0','other','Location','best')
    ylabel('mean response -baseline')
    title(sprintf('LE Response to RF %d at different phases',RFs(r)))

    
    subplot(2,1,2)
    plot((LEMeans(1,:) - LEMeans(2,:)),'k')
    xlabel('channel')
    ylabel('0 resp - other resp')
    title('Difference in responses at different phases')
    set(gca,'box','off','color','none','tickdir','out')
    
    figName = ['WU_LE_RF_PhaseDiffs',r];
    saveas(gcf,figName,'pdf')
    
    figure
    subplot(2,1,1)
    hold on
    plot(REMeans(1,:),'b','LineWidth',1)
    plot(REMeans(2,:),'Color',[0 0.6 0.4],'LineWidth',1)
    plot(REMeans(1,:),'.b','MarkerSize',8)
    plot(REMeans(2,:),'.','MarkerSize',8,'Color',[0 0.6 0.4])
    legend('0','other','Location','best')
    xlabel('channel')
    ylabel('mean response -baseline')
    title(sprintf('RE Response to RF %d at different phases',RFs(r)))

    
    subplot(2,1,2)
    plot((REMeans(1,:) - REMeans(2,:)),'k')
    xlabel('channel')
    ylabel('0 resp - other resp')
    title('Difference in responses at different phases')
     set(gca,'box','off','color','none','tickdir','out')
     
     figName = ['WU_RE_RF_PhaseDiffs',r];
     
     
     figure;scatter(LEMeans(1,:),LEMeans(2,:),'b');
     hold on; scatter(REMeans(1,:),LEMeans(2,:),'k');
     xlim auto; ylim auto
     plot([-10 10],[-10 10],'k')
     legend({'fellow eye';'amblyopic eye'});
    title(sprintf('RE Response to RF %d at different phases',RFs(r)))
     
   % saveas(gcf,figName,'pdf')
end

