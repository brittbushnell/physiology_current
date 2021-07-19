if contains(dataT.animal,'XT')
    if contains(dataT.eye,'LE')
        eye = 'LE';
    else
        eye = 'RE';
    end
else
    if contains(dataT.eye,'LE')
        eye = 'FE';
    else
        eye = 'AE';
    end
end
   

ndx = 1;
    if plotFlag == 1
        figure (2)
        clf
        hold on
        pos = get(gcf,'Position');
        set(gcf, 'Position',[pos(1) pos(2) 850 900])
        
        s = suptitle(sprintf('%s %s %s mean zscores as a funciton of amplitude ch %d',dataT.animal, dataT.array, eye,ch));
        s.Position(2) = s.Position(2) + 0.02;
        
        fillCirc = sprintf('\x25CF');
        openCirc = sprintf('\x25CB');
    end

                %% plot curves
                if plotFlag == 1
                subplot(3,4,ndx)
                
                rf4a = squeeze(rfMuZ(1,1,:,sf,rad,loc,ch));
                rf4b = squeeze(rfMuZ(1,2,:,sf,rad,loc,ch));
                
                rf8a = squeeze(rfMuZ(2,1,:,sf,rad,loc,ch));
                rf8b = squeeze(rfMuZ(2,2,:,sf,rad,loc,ch));
                
                rf16a = squeeze(rfMuZ(3,1,:,sf,rad,loc,ch));
                rf16b = squeeze(rfMuZ(3,2,:,sf,rad,loc,ch));
                
                circ = squeeze(circMuZ(sf,rad,loc,ch));
                
                hold on
                plot(1,circ,'ok','MarkerFaceColor','k','MarkerSize',4)
                plot(2:7,rf4a,'o-','Color',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor',[0 0.6 0.2],'MarkerSize',4)
                plot(2:7,rf4b,'o--','Color',[0 0.6 0.2],'MarkerFaceColor','w','MarkerEdgeColor',[0 0.6 0.2],'MarkerSize',4)
                
                plot(2:7,rf8a,'o-','Color',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor',[1 0.5 0.1],'MarkerSize',4)
                plot(2:7,rf8b,'o--','Color',[1 0.5 0.1],'MarkerFaceColor','w','MarkerEdgeColor',[1 0.5 0.1],'MarkerSize',4)
                
                plot(2:7,rf16a,'o-','Color',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor',[0.7 0 0.7],'MarkerSize',4)
                plot(2:7,rf16b,'o--','Color',[0.7 0 0.7],'MarkerFaceColor','w','MarkerEdgeColor',[0.7 0 0.7],'MarkerSize',4)
                
                xlim([0.75 10])
                
                mygca(ndx) = gca;
                
                b = get(gca,'YLim');
                yMaxs(ndx) = max(b);
                yMins(ndx) = min(b);
                
                title(sprintf('sf %d rad %d loc %d',sf,rad,loc))
                set(gca,'Box','off','XScale','log','tickdir','out','TickLength',[0.03 0.025],'XTickLabel',[])
                axis square
                
                if ndx == 1 || ndx == 5 || ndx == 9
                    ylabel('zscore')
                end
                
                if ndx >= 9
                    xlabel('amplitude')
                end
                %%
                ndx = ndx+1;
                end
                    if plotFlag == 1
    minY = min(yMins);
    maxY = max(yMaxs);
    yLimits = ([minY maxY]);
    set(mygca,'YLim',yLimits);
    %%
    subplot(3,4,9)
    hold on
    text(20, minY - 1, 'RF4','Color',[0 0.6 0.2],'FontWeight','bold','FontSize',12)
    text(80, minY - 1, 'RF8','Color',[1 0.5 0.1],'FontWeight','bold','FontSize',12)
    text(200, minY - 1, 'RF16','Color',[0.7 0 0.7],'FontWeight','bold','FontSize',12)
    text(500, minY - 1, 'Circle','FontWeight','bold','FontSize',12)
    
    text(30, minY - 1.35, fillCirc,'FontWeight','bold','FontSize',20);    
    text(40, minY - 1.4,'0 deg','FontWeight','bold','FontSize',12)
    text(150, minY - 1.35, openCirc,'FontWeight','bold','FontSize',20);
    text(200, minY - 1.4, 'alternate phase','FontWeight','bold','FontSize',12)

    
    %%
    figName = [dataT.animal,'_',dataT.eye,'_',dataT.array,'_radFreqTuningCurves_ch',num2str(ch),'.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')
                    end