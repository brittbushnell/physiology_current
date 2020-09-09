file = 'XT_radFreqLowSF_V4_ManualLocs_RFxAmp';
load(file)
%% plot (center stimuli only)
xdata = [4,8,16,32,64,128];

for spf = 1:numSfs
    for rd = 1:numRad
        % get the mean responses to the desired SF and size combinations,
        % and subtract baseline.
        useStim = find((LERadFreqCenterLoc(4,:,1) == sfs(spf) & (LERadFreqCenterLoc(5,:,1) == rad(rd))));
        if contains(file,'V1')
            tmpL = LERadFreqLoc1(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            tmpR = RERadFreqLoc1(:,useStim,:);
        else
            tmpL = LERadFreqLoc2(:,useStim,:); %now, there's a 3d matrix of responses to one location, sf, and size combo.  Still need to combine phases
            tmpR = RERadFreqLoc2(:,useStim,:);
        end
        
        muRespsL = tmpL(end-3,:,:) - LEbaseMu;
        muRespsR = tmpR(end-3,:,:) - REbaseMu;
        
        medRespsL = tmpL(end-2,:,:) - LEbaseMd;
        medRespsR = tmpR(end-2,:,:) - REbaseMd;
        
        useStim = find((LECircleCenterLoc(4,:,1) == sfs(spf) & (LECircleCenterLoc(5,:,1) == rad(rd))));
        tmpLC = LECircleCenterLoc(:,useStim,:);
        tmpRC = RECircleCenterLoc(:,useStim,:);
        
        muRespsLC = tmpLC(end-3) -LEbaseMu;
        muRespsRC = tmpRC(end-3) -REbaseMu;
        
        medRespsLC = tmpLC(end-2) -LEbaseMd;
        medRespsRC = tmpRC(end-2) -REbaseMd;
        
        
        rm1 = max(RERadFreqCenterLoc(end-3,:));
        rm2 = max(RERadFreqCenterLoc(end-2,:));
        lm1 = max(LERadFreqCenterLoc(end-3,:));
        lm2 = max(LERadFreqCenterLoc(end-2,:));
        
        %             rm1 = max(muRespsR(:));
        %             rm2 = max(medRespsR(:));
        %
        %             lm1 = max(muRespsL(:));
        %             lm2 = max(medRespsR(:));
        
        r = round(max(rm1,rm2));
        l = round(max(lm1,lm2));
        y = max(r,l) + (max(r,l)./0.85);
        
        %% plot
        
        figure(1)
        clf
        if LEcleanData.goodCh(ch) == 1
            subplot(2,3,1)
            hold on
            plot(xdata, muRespsL(1,:,1),'b-o')
            plot(xdata, medRespsL(1,:,1),'k-o')
            plot(2,medRespsLC,'ko')
            plot(2,muRespsLC,'bo')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            subplot(2,3,2)
            hold on
            plot(xdata, muRespsL(1,:,2),'b-o')
            plot(xdata, medRespsL(1,:,2),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,3)
            hold on
            plot(xdata, muRespsL(1,:,3),'b-o')
            plot(xdata, medRespsL(1,:,3),'k-o')
            plot(2,medRespsLC,'bo')
            plot(2,muRespsLC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
        end
        
        if REcleanData.goodCh(ch) == 1
            subplot(2,3,4)
            hold on
            plot(xdata, muRespsR(1,:,1),'r-o')
            plot(xdata, medRespsR(1,:,1),'k-o')
            plot(2,medRespsRC,'ko')
            plot(2,muRespsRC,'ro')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf4')
            ylim([0 y]);
            axis square
            
            
            subplot(2,3,5)
            hold on
            plot(xdata, muRespsR(1,:,2),'r-o')
            plot(xdata, medRespsR(1,:,2),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf8')
            ylim([0 y]);
            axis square
            
            subplot(2,3,6)
            hold on
            plot(xdata, muRespsR(1,:,3),'r-o')
            plot(xdata, medRespsR(1,:,3),'k-o')
            plot(2,muRespsRC,'ro')
            plot(2,medRespsRC,'ko')
            set(gca,'color','none','tickdir','out','box','off','XScale','log')
            title('rf16')
            ylim([0 y]);
            axis square
        end
        
        annotation('textbox',...
            [0.2 0.96 0.65 0.05],...
            'LineStyle','none',...
            'String',sprintf('%s ch%d sf%d size%d',animal,ch,spf,rd),...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
        
        pause(0.2)
        
        if location == 0
            figDir = sprintf('/Users/bbushnell/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s',animal,array,programRun);
        elseif location == 1
            figDir = sprintf('~/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/RFxAmp/%s',animal,array,programRun);
        else
            error('Need to define figure path for Zemina')
        end
        
        cd(figDir);
        
        figName = [animal,'_',array,'_',programRun,'_sf',num2str(spf),'_size',num2str(rd),'_',num2str(ch)];
        saveas(gcf,figName,'pdf');
        
    end
end