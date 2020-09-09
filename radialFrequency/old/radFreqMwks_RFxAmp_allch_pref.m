clear all
close all
clc
tic;
%%
% file = 'WU_V1_RadFreq_0707_goodCh';
% array = 'V1';
file = 'WU_V4_RadFreq_0707_goodCh';
array = 'V4';

location = 2;
%%
load(file);
%%
RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
SFs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);

numCh = size(LEdata.bins,3);
%% CD to correct folder for saving
if strfind(file,'V1')
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V1/RFxAmp
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/RF/V1/RFxAmp
    elseif location == 2
        cd ~/Figures/V1/RadFreq/RFxAmp
    end
else
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V4/RFxAmp
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/RF/V4/RFxAmp
    elseif location == 2
        cd ~/Figures/V4/RadFreq/RFxAmp
    end
end
%%
[SfPrefRE,SfPrefLE, sizePrefRE, sizePrefLE, phasePrefRE, phasePrefLE]  = radFreqMwks_getPrefs(file,0);
%%
for r = 1:length(RFs)
    ndx = 1;
    for a = 1:length(amps)
        
        REstimResps = cell2mat(REdata.stimResps);
        LEstimResps = cell2mat(LEdata.stimResps);
        
        REndx = find((REstimResps(4,:) == RFs(r)) & ...
            (REstimResps(5,:) == amps(a)) & ...
            (REstimResps(9,:) == -3) & ...
            (REstimResps(8,:) == sizePrefRE(1)) & ...
            (REstimResps(7,:) == SfPrefRE(1)));
        
        
        
        LEndx = find((LEstimResps(4,:) == RFs(r)) & ...
            (LEstimResps(5,:) == amps(a)) & ...
            (LEstimResps(9,:) == -3) & ...
            (LEstimResps(8,:) == sizePrefLE(1)) & ...
            (LEstimResps(7,:) == SfPrefLE(1)));
        
        
        if ~isempty(REndx)  % different RFs use different amplitudes, so this should skip any amplitudes that weren't run for that RF
            %disp(sprintf('RF %d, amp %d',RFs(r),amps(a)))
            for i = 1:length(LEndx)
                REndxBS(i) = (REstimResps(3,REndx(i)));
                LEndxBS(i) = (LEstimResps(3,LEndx(i)));
                
                REndx2(i) = (REstimResps(1,REndx(i)));
                LEndx2(i) = (LEstimResps(1,LEndx(i)));
                
                REste1(i) = REstimResps(2,REndx(i));
                LEste1(i) = LEstimResps(2,LEndx(i));
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
    
    LEmu = LEmuT;
    REmu = REmuT;
    
    REste = REsteT;
    LEste = LEsteT;
    
    LEmuBS = LEmuTS;
    REmuBS = REmuTS;
end
%% Baseline subtracted responses as a function of amplitude

xdata = [4,8,16,32,64,128];

figure

reMax = max(REmuBS(:));
leMax = max(LEmuBS(:));
yMax = max(reMax,leMax);
yMax = yMax + (yMax/15);

reMin = min(REmuBS(1:3,:));
reMin = min(reMin);
leMin = min(LEmuBS(1:3,:));
leMin = min(leMin);

reSTEmin = min(REste(1:3,:));
reSTEmin = min(reSTEmin);
leSTEmin = min(LEste(1:3,:));
leSTEmin = min(leSTEmin);
steMin = min(reSTEmin, leSTEmin);

yMin = min(reMin,leMin);
yMin = yMin - steMin;
yMin = round(yMin);
yMin = yMin + (yMin/40);

for  r = 1:4
    subplot(2,2,r)
    if r == 1
        title(sprintf('%s radial frequency tuning baseline subtracted all ch', array));
        axis off
        set(gca,'Color','none')
    else
        hold on  
        errorbar(xdata,REmuBS(r-1,:),REste(r-1,:),'r-o','LineWidth',2)
        errorbar(2,REmuBS(end,1),REste(end,1),'r-o','LineWidth',2)
        plot([0 32], [32 0], ':k')
        
        
        errorbar(xdata,LEmuBS(r-1,:),LEste(r-1,:),'b-o','LineWidth',2)
        errorbar(2,LEmuBS(end,1),LEste(end,1),'b-o','LineWidth',2)
        plot([0 0], [32 32], ':k')
        
        set(gca,'tickdir','out','box','off','Color','none','XScale','log','XTick',[2 4 8 16 32 64]...
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

figName = ['WU_',array,'_allch','_RFxAmpBaseSub'];
saveas(gca,figName,'pdf')


%%

figure

reMax = max(REmu(:));
leMax = max(LEmu(:));
yMax = max(reMax,leMax);
yMax = yMax + (yMax/15);

for  r = 1:4
    subplot(2,2,r)
    hold on
    if r == 1
        title(sprintf('%s Radial frequency tuning all ch',array))
        axis off
        set(gca,'Color','none')
    else
        errorbar(xdata,REmu(r-1,:),REste(r-1,:),'r-o','LineWidth',2)
        errorbar(2,REmu(end,1),REste(end,1),'r-o','LineWidth',2)
        plot([0 0], [32 32], ':k')
        
        errorbar(xdata,LEmu(r-1,:),LEste(r-1,:),'b-o','LineWidth',2)
        errorbar(2,LEmu(end,1),LEste(end,1),'b-o','LineWidth',2)
        plot([0 0], [32 32], ':k')
        
        set(gca,'tickdir','out','box','off','XScale','log','Color','none','XTick',[2 4 8 16 32 64]...
            ,'XTickLabel',{'circle','low','','','','','high'},'XTickLabelRotation', 45)
        ylim([0 yMax])
        
        if r == 3
            ylabel('mean response')
            xlabel('Amplitude modulation')
        end
        
        title(sprintf('RF %d',RFs(r-1)))
    end
end


figName = ['WU_',array,'_allCh','_RFxAmp'];
saveas(gca,figName,'pdf')
%%

toc/60




