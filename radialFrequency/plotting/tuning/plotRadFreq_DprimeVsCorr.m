function plotRadFreq_DprimeVsCorr(LEdata,REdata)
    %%
    % x: corr
    % y: d'
    
    LEmax = max(abs(LEdata.StimCircDprime),[],'all');
    REmax = max(abs(REdata.StimCircDprime),[],'all');
        
    yMax = max([LEmax,REmax]) + 0.5;
    
    figure(3)
    clf
    
    s = suptitle(sprintf('%s %s max |d''| versus best stimulus correlation', REdata.animal, REdata.array));
    s.Position(2) = s.Position(2) + 0.022;
    
    subplot(3,2,1)
    hold on
    axis square
    ylabel('max |d''|')
    
    if contains(LEdata.animal,'XT')
        title('LE')
    else
        title('FE')
    end
    
    xlim([-1 1])
    ylim([0, yMax])
    text( -2.3, (0+yMax)/2, 'RF4','FontSize',12,'FontWeight','bold')
    for ch = 1:96
        y = max(abs(LEdata.StimCircDprime(1,:,ch)));
        x = LEdata.stimCorrs(1,ch);
        
        scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    
    subplot(3,2,3)
    hold on
    axis square
    ylabel('max |d''|')
    
    xlim([-1 1])
    ylim([0, yMax])
    text( -2.3, (0+yMax)/2, 'RF8','FontSize',12,'FontWeight','bold')
    for ch = 1:96
        y = max(abs(LEdata.StimCircDprime(2,:,ch)));
        x = LEdata.stimCorrs(2,ch);
        
        scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    
    subplot(3,2,5)
    hold on
    axis square
    xlabel('Correlation')
    ylabel('max |d''|')
    
    xlim([-1 1])
    ylim([0, yMax])
    text( -2.3, (0+yMax)/2, 'RF16','FontSize',12,'FontWeight','bold')
    for ch = 1:96
        y = max(abs(LEdata.StimCircDprime(3,:,ch)));
        x = LEdata.stimCorrs(3,ch);
        
        scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    
    subplot(3,2,2)
    hold on
    axis square
    
    if contains(REdata.animal,'XT')
        title('RE')
    else
        title('AE')
    end
    
    xlim([-1 1])
    ylim([0, yMax])
    for ch = 1:96
        y = max(abs(REdata.StimCircDprime(1,:,ch)));
        x = REdata.stimCorrs(1,ch);
        
        scatter(x,y,'MarkerFaceColor',[0.7 0 0.7], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    
    subplot(3,2,4)
    hold on
    axis square
    
    
    xlim([-1 1])
    ylim([0, yMax])
    for ch = 1:96
        y = max(abs(REdata.StimCircDprime(2,:,ch)));
        x = REdata.stimCorrs(2,ch);
        
        scatter(x,y,'MarkerFaceColor',[1 0.5 0.1], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    
    subplot(3,2,6)
    hold on
    axis square
    xlabel('Correlation')
    
    
    xlim([-1 1])
    ylim([0, yMax])
    for ch = 1:96
        y = max(abs(REdata.StimCircDprime(3,:,ch)));
        x = REdata.stimCorrs(3,ch);
        
        scatter(x,y,'MarkerFaceColor',[0 0.6 0.2], 'MarkerEdgeColor','w','MarkerFaceAlpha',0.7, 'MarkerEdgeAlpha',0.7)
    end
    set(gca,'tickdir','out','FontAngle','italic','FontSize',10)
    %%
    
    location = determineComputer;
    
    if location == 1
        if contains(LEdata.animal,'WU')
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
        elseif contains(LEdata.animal,'XT')
            if contains(LEdata.programID,'low','IgnoreCase',true)
                if contains(LEdata.programID,'V4')
                    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
                else
                    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
                end
            else
                if contains(LEdata.programID,'V4')
                    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
                else
                    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
                end
            end
        else
            if contains(LEdata.programID,'low','IgnoreCase',true)
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    elseif location == 0
        if contains(LEdata.animal,'WU')
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
        elseif contains(LEdata.animal,'XT')
            if contains(LEdata.programID,'low','IgnoreCase',true)
                if contains(LEdata.programID,'V1')
                    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
                else
                    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
                end
            else
                if contains(LEdata.programID,'V1')
                    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
                else
                    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
                end
            end
        else
            if contains(LEdata.programID,'low','IgnoreCase',true)
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    end
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    
    
    set(gcf,'InvertHardcopy','off','Color','w')
    figName = [LEdata.animal,'_BE_',LEdata.array,'_',LEdata.programID,'_dPrimeVsCorr','.pdf'];
    print(gcf, figName,'-dpdf','-bestfit')