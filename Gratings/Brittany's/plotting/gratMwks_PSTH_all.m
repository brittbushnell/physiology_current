%gratMwks_PSTH_all


clc
%% NOTES
%%
clear all
close all
tic;

location = 2; % 0 = laptop 1 = Amfortas 2 = zemina
%% Good channels
% file = 'fit_WU_Gratings_V1_withRF_surface_0502';
% array = 'V1';
file ='fit_WU_Gratings_V4_withRF_surface_0502';
array = 'V4';

startBin = 1;
endBin = 31;
%% Get out the information
load(file);

numChannels = size(LEdata.bins,3);

sfs = unique(LEdata.spatial_frequency);
sfs = sfs(4:end);

oris = unique(LEdata.rotation);
oris = oris(1:end-1);
%%
xaxis = startBin:endBin;

for ch = 1:numChannels
    ndx = 1;
    blankNdx   = find(LEdata.spatial_frequency == 0);
    blankResps{ch} = mean((LEdata.bins(blankNdx,startBin:endBin,ch)),1)./.01;
    
    for sf = 1:length(sfs)
        for or = 1:length(oris)
            stimNdx  = find((LEdata.spatial_frequency == sfs(sf)) .* (LEdata.rotation == oris(or)));
            stimResp{ch}(ndx,:) = mean((LEdata.bins(stimNdx,startBin:endBin,ch)),1)./.01;
            ndx = ndx+1;
        end
    end
end


for ch = 1:numChannels
    figure
    yMax = max(stimResp{ch}(:));
    yMax = yMax + (yMax./15);
    topTitle = (sprintf('%s FE PSTH ch %d', array, ch));
    
    ndx = 1;
    for sf = 1:length(sfs)
        for or = 1:length(oris)
            subplot(6,6,ndx)
            hold on
            plot(xaxis, blankResps{ch},'k')
            plot(xaxis, stimResp{ch}(ndx,:),'b')
            ylim([0 yMax])
            axis tight
            set(gca,'box', 'off','color', 'none', 'tickdir','out',...
                'XTick',[],'FontSize',8)
            title (sprintf('%d SF%.2f',oris(or), sfs(sf)))
            
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
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/PSTH
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/PSTH
        elseif location == 2
            cd ~/Figures/V1/Gratings/PSTH
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 2
            cd ~/Figures/V4/Gratings/PSTH
        end
    end
    figName = ['WU','_',array,'_',num2str(ch),'_FE_gratingPSTH600'];
    saveas(gcf,figName,'pdf')
end
close all
%%
for ch = 1:numChannels
    ndx = 1;
    blankNdx   = find(REdata.spatial_frequency == 0);
    blankResps{ch} = mean((REdata.bins(blankNdx,startBin:endBin,ch)),1)./.01;
    
    for sf = 1:length(sfs)
        for or = 1:length(oris)
            stimNdx  = find((REdata.spatial_frequency == sfs(sf)) .* (REdata.rotation == oris(or)));
            stimResp{ch}(ndx,:) = mean((REdata.bins(stimNdx,startBin:endBin,ch)),1)./.01;
            ndx = ndx+1;
        end
    end
end


for ch = 1:numChannels
    figure
    yMax = max(stimResp{ch}(:));
    yMax = yMax + (yMax./15);
    topTitle = (sprintf('%s AE PSTH ch %d', array, ch));
    
    ndx = 1;
    for sf = 1:length(sfs)
        for or = 1:length(oris)
            subplot(6,6,ndx)
            hold on
            plot(xaxis, blankResps{ch},'k')
            plot(xaxis, stimResp{ch}(ndx,:),'R')
            ylim([0 yMax])
            axis tight
            set(gca,'box', 'off','color', 'none', 'tickdir','out',...
                'XTick',[],'FontSize',8)
            title (sprintf('%d SF%.2f',oris(or), sfs(sf)))
            
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
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/PSTH
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/PSTH
        elseif location == 2
            cd ~/Figures/V1/Gratings/PSTH
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/PSTH
        elseif location == 2
            cd ~/Figures/V4/Gratings/PSTH
        end
    end
    figName = ['WU','_',array,'_',num2str(ch),'_AE_gratingPSTH600'];
    saveas(gcf,figName,'pdf')
end
close all

