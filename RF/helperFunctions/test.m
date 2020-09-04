
RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
SFs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);

numCh = size(LEdata.bins,3);
%%
%[SfPrefRE,SfPrefLE, sizePrefRE, sizePrefLE, phasePrefRE, phasePrefLE]  = radFreqMwks_getPrefs(file,1);
%%
for ch = 5%1:numCh
    %     LEmuT = nan(4,6);
    %     REmuT = nan(4,6);
    %
    %     LEsteT = nan(4,6);
    %     REsteT = nan(4,6);
    for r = 1:length(RFs)
        ndx = 1;
        for a = 1:length(amps)
            
            REndx = find((REdata.stimResps{ch}(4,:) == RFs(r)) & ...
                (REdata.stimResps{ch}(5,:) == amps(a)) & ...
                (REdata.stimResps{ch}(9,:) == -3));% & ...
            %                     (REdata.stimResps{ch}(8,:) == sizePrefRE(1,ch)) & ...
            %                     (REdata.stimResps{ch}(7,:) == SfPrefRE(1,ch)));
            
            
            
            LEndx = find((LEdata.stimResps{ch}(4,:) == RFs(r)) & ...
                (LEdata.stimResps{ch}(5,:) == amps(a)) & ...
                (LEdata.stimResps{ch}(9,:) == -3));% & ...
            %                     (LEdata.stimResps{ch}(8,:) == sizePrefLE(1,ch)) & ...
            %                     (LEdata.stimResps{ch}(7,:) == SfPrefLE(1,ch)));
            
            
            if ~isempty(REndx)  % different RFs use different amplitudes, so this should skip any amplitudes that weren't run for that RF
                %disp(sprintf('RF %d, amp %d',RFs(r),amps(a)))
                for i = 1:length(LEndx)
                    REndxBS(i) = (REdata.stimResps{ch}(3,REndx(i)));
                    LEndxBS(i) = (LEdata.stimResps{ch}(3,LEndx(i)));
                    
                    REndx2(i) = (REdata.stimResps{ch}(1,REndx(i)));
                    LEndx2(i) = (LEdata.stimResps{ch}(1,LEndx(i)));
                    
                    REste1(i) = REdata.stimResps{ch}(2,REndx(i));
                    LEste1(i) = LEdata.stimResps{ch}(2,LEndx(i));
                end
                LEmuTS(r,ndx) = mean(LEndxBS);
                REmuTS(r,ndx) = mean(REndxBS);
                
                LEmuT(r,ndx) = mean(LEndx2);
                REmuT(r,ndx) = mean(REndx2);
                
                REsteT(r,ndx) = mean(REste1);
                LEsteT(r,ndx) = mean(LEste1);
                
                ndx = ndx+1;
            end
        end
    end
    LEmu{ch} = LEmuT;
    REmu{ch} = REmuT;
    
    REste{ch} = REsteT;
    LEste{ch} = LEsteT;
    
    LEmuBS{ch} = LEmuTS;
    REmuBS{ch} = REmuTS;
end
%% Baseline subtracted responses as a function of amplitude
cd BaseSub
xdata = [4,8,16,32,64,128];
for ch = 5%1:numCh
    if (REdata.goodCh(ch) + LEdata.goodCh(ch)) ~=0
        
        figure
        
        reMax = max(REmuBS{ch}(:));
        leMax = max(LEmuBS{ch}(:));
        yMax = max(reMax,leMax);
        yMax = yMax + (yMax/15);
        
        reMin = min(REmuBS{ch}(1:3,:));
        reMin = min(reMin);
        leMin = min(LEmuBS{ch}(1:3,:));
        leMin = min(leMin);
        
        reSTEmin = min(REste{ch}(1:3,:));
        reSTEmin = min(reSTEmin);
        leSTEmin = min(LEste{ch}(1:3,:));
        leSTEmin = min(leSTEmin);
        steMin = min(reSTEmin, leSTEmin);
        
        yMin = min(reMin,leMin);
        yMin = yMin - steMin;
        yMin = round(yMin);
        yMin = yMin + (yMin/40);
        
        for  r = 1:4
            subplot(2,2,r)
            if r == 1
                title(sprintf('%s radial frequency tuning baseline subtracted ch %d', array, ch));
                axis off
                set(gca,'Color','none')
            else
                hold on
                if REdata.goodCh(ch) == 1
                    plot(xdata,REmuBS{ch}(r-1,:),'r-o','LineWidth',2)
                    plot(2,REmuBS{ch}(end,1),'r-o','LineWidth',2)
                    plot([2 128], [0 0], ':k')
                end
                if LEdata.goodCh(ch) == 1
                    plot(xdata,LEmuBS{ch}(r-1,:),'b-o','LineWidth',2)
                    plot(2,LEmuBS{ch}(end,1),'b-o','LineWidth',2)
                    plot([2 128], [0 0], ':k')
                end
                set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64 128]...
                    ,'XTickLabel',{'circle','low','','','','','high'},'XTickLabelRotation', 45)
                ylim([yMin yMax])
                %[ampConv] = convertWF(sizePrefRE(1,ch),
                
                if r == 3
                    ylabel('baseline subtracted response')
                    xlabel('Amplitude modulation')
                end
                
                title(sprintf('RF %d', RFs(r-1)))
            end
        end
    end
%     if REdata.goodCh(ch) == 1 || LEdata.goodCh(ch) == 1
%         figName = ['WU_',array,'_',num2str(ch),'_RFxAmpBaseSub'];
%         saveas(gca,figName,'pdf')
%     end
end

%%
cd ../Normal
for ch = 5%1:numCh
    if (REdata.goodCh(ch) + LEdata.goodCh(ch)) ~=0
        figure
        
        reMax = max(REmu{ch}(:));
        leMax = max(LEmu{ch}(:));
        yMax = max(reMax,leMax);
        yMax = yMax + (yMax/15);
        
        for  r = 1:4
            subplot(2,2,r)
            hold on
            if r == 1
                title(sprintf('%s Radial frequency tuning ch %d',array,ch))
                axis off
                set(gca,'Color','none')
            else
                if REdata.goodCh(ch) == 1
                    plot(xdata,REmu{ch}(r-1,:),'r-o','LineWidth',2)
                    plot(2,REmu{ch}(end,1),'r-o','LineWidth',2)
                    plot([2 128], [REmu{ch}(1,1) REmu{ch}(1,1)], '--r')
                end
                if LEdata.goodCh(ch) == 1
                    plot(xdata,LEmu{ch}(r-1,:),'b-o','LineWidth',2)
                    plot(2,LEmu{ch}(end,1),'b-o','LineWidth',2)
                    plot([1 127], [LEmu{ch}(1,1) LEmu{ch}(1,1)], '--b')
                end
                set(gca,'tickdir','out','box','off','XScale','log','Color','none','XTick',[2 4 8 16 32 64 128]...
                    ,'XTickLabel',{'circle','low','','','','','high'},'XTickLabelRotation', 45)
                ylim([0 yMax])
                if r == 3
                    ylabel('mean response')
                    xlabel('Amplitude modulation')
                end
                
                title(sprintf('RF %d',RFs(r-1)))
            end
        end
    end
%     if REdata.goodCh(ch) == 1 || LEdata.goodCh(ch) == 1
%         figName = ['WU_',array,'_',num2str(ch),'_RFxAmp'];
%         saveas(gca,figName,'pdf')
%     end
end