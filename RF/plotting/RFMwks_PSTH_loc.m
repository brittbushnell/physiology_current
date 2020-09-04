%gratMwks_PSTH_all


clc
%% NOTES
%%
clear all
close all
tic;

location = 2; % 0 = laptop 1 = Amfortas 2 = zemina
%% Good channels
% file = 'WU_V1_RadFreq_combined';
% array = 'V1';
% file ='WU_V4_RadFreq_combined';
% array = 'V4';
%% XT
file = 'XT_radFreqLowSF_V4_Oct2018_RFxAmp';
array = 'V4'
%% Get out the information
load(file);

numChannels = size(LEdata.bins,3);

xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
%%
startBin = 1;
endBin = 40;
xaxis = startBin:endBin;

for ch = 1:numChannels
    ndx = 1;
    blankNdx   = find((LEdata.stimResps{ch}(7,:) == 100));
    useRuns = double(LEdata.bins(blankNdx,startBin:endBin,ch));
    blankResps{ch} = mean(useRuns,1)./.01;
    blankSTE{ch} = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
        
    for ys = 1:length(yLocs)
        for xs = 1:length(xLocs)
            stimNdx  = find((LEdata.stimResps{ch}(9,:) == xLocs(xs)) .* (LEdata.stimResps{ch}(10,:) == yLocs(ys)));
            useRuns = double(LEdata.bins(stimNdx,startBin:endBin,ch));
            stimResp{ch}(ndx,:) = mean(useRuns,1)./.01;
            stimSTE{ch}(ndx,:) = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
            if isnan(stimSTE{ch}(ndx,:))
                stimSTE{ch}(ndx,:) = 0;
            end
            ndx = ndx+1;
        end
    end
    
    figure
    sMax = max(stimResp{ch}(:));
    bMax = max(blankResps{ch}(:));
    yMax = max(sMax,bMax);
    yMax = yMax + (yMax./15);
    topTitle = (sprintf('%s FE PSTH ch %d', array, ch));
    
    ndx = 1;
    for ys = 1:length(yLocs)
        for xs = 1:length(xLocs)
            subplot(3,3,ndx)
            hold on
%            if ~isnan(LEdata.locRespBS{ch}(xs,ys))
                plot(xaxis, blankResps{ch},'k')
                plot(xaxis, stimResp{ch}(ndx,:),'b')
%                 errorbar(xaxis, blankResps{ch},blankSTE{ch},'k')
%                 errorbar(xaxis, stimResp{ch}(ndx,:),stimSTE{ch}(ndx,:),'b')
                title (sprintf('(%.1f, %.1f)',xLocs(xs), yLocs(ys)))
                axis tight
                ylim([0 yMax])
                set(gca,'box', 'off','color', 'none', 'tickdir','out',...
                    'XTick',[],'FontSize',8, 'XTick',0:15:30,'XTickLabel',{'0','150','300'})
%             else
%                 set(gca,'box', 'off','color', 'none','YTick',[])
%             end
%             
            if ndx == 1
                annotation('textbox',...
                    [0.4 0.94 0.35 0.05],...
                    'LineStyle','none',...
                    'String',topTitle,...
                    'Interpreter','none',...
                    'FontSize',14,...
                    'FontAngle','italic',...
                    'FontName','Helvetica Neue');
            end
            
            if ndx == 31
                ylabel('Sp/s')
                xlabel('time(ms)')
            end
            
            if ndx>= 31
                set(gca,'XTick',0:20:60, 'XTickLabel', {'0','200','400','600'})
            end
            
            
            ndx = ndx+1;
            
        end
    end
    
    %squeezesubplots(gca,0.4)
    
    if strfind(file,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/RF/V1/PSTH/Location
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/RF/V1/PSTH/Location
        elseif location == 2
            cd ~/Figures/V1/Gratings/PSTH
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/RF/V4/PSTH/Location
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 2
            cd ~/Figures/V4/Gratings/PSTH
        end
    end
    figName = ['WU','_',array,'_',num2str(ch),'_FE_RF_PSTH_loc'];
    saveas(gcf,figName,'pdf')
end
close all
%%
for ch = 1:numChannels
    ndx = 1;
    blankNdx   = find((REdata.stimResps{ch}(7,:) == 100));
    useRuns = double(REdata.bins(blankNdx,startBin:endBin,ch));
    blankResps{ch} = mean(useRuns,1)./.01;
    blankSTE{ch} = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
        
    for ys = 1:length(yLocs)
        for xs = 1:length(xLocs)
            stimNdx  = find((REdata.stimResps{ch}(9,:) == xLocs(xs)) .* (REdata.stimResps{ch}(10,:) == yLocs(ys)));
            useRuns = double(REdata.bins(stimNdx,startBin:endBin,ch));
            stimResp{ch}(ndx,:) = mean(useRuns,1)./.01;
            stimSTE{ch}(ndx,:) = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
            ndx = ndx+1;
        end
    end
end


for ch = 1:numChannels
    figure
    sMax = max(stimResp{ch}(:));
    bMax = max(blankResps{ch}(:));
    yMax = max(sMax,bMax);
    yMax = yMax + (yMax./15);
    topTitle = (sprintf('%s FE PSTH ch %d', array, ch));
    
    ndx = 1;
    for ys = 1:length(yLocs)
        for xs = 1:length(xLocs)
            subplot(3,3,ndx)
            hold on
            if ~isnan(REdata.locRespBS{ch}(xs,ys))
                plot(xaxis, blankResps{ch},'k')
                plot(xaxis, stimResp{ch}(ndx,:),'r')
%                 errorbar(xaxis, blankResps{ch},blankSTE{ch},'k')
%                 errorbar(xaxis, stimResp{ch}(ndx,:),stimSTE{ch}(ndx,:),'b')
                title (sprintf('(%.1f, %.1f)',xLocs(xs), yLocs(ys)))
                axis tight
                ylim([0 yMax])
                set(gca,'box', 'off','color', 'none', 'tickdir','out',...
                    'XTick',[],'FontSize',8, 'XTick',0:15:30,'XTickLabel',{'0','150','300'})
            else
                set(gca,'box', 'off','color', 'none','YTick',[])
            end
            
            if ndx == 1
                annotation('textbox',...
                    [0.4 0.94 0.35 0.05],...
                    'LineStyle','none',...
                    'String',topTitle,...
                    'Interpreter','none',...
                    'FontSize',14,...
                    'FontAngle','italic',...
                    'FontName','Helvetica Neue');
            end
            
            if ndx == 31
                ylabel('Sp/s')
                xlabel('time(ms)')
            end
            
            if ndx>= 31
                set(gca,'XTick',0:20:60, 'XTickLabel', {'0','200','400','600'})
            end
            
            
            ndx = ndx+1;
            
        end
    end
    
    %squeezesubplots(gca,0.4)
    
    if strfind(file,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/RF/V1/PSTH/Location
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/RF/V1/PSTH/Location
        elseif location == 2
            cd ~/Figures/V1/Gratings/PSTH
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/RF/V4/PSTH/Location
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 2
            cd ~/Figures/V4/Gratings/PSTH
        end
    end
    figName = ['WU','_',array,'_',num2str(ch),'_AE_RF_PSTH_loc'];
    saveas(gcf,figName,'pdf')
end
%close all