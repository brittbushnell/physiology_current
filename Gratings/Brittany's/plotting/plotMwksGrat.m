% plotMwksGratSurface
%
%
close all
clear all
clc
tic
%% NOTES

%%
%file = 'fitData_WU_Gratings_V4_recuts_surface.mat';
%file = 'fitData_WU_Gratings_V1_recuts_surface.mat';
%file = 'fit_WU_Gratings_V1_0626_recut_surface.mat';
%file = 'fit_WU_Gratings_V4_0626_recut_surface.mat';
%file = 'fit_WU_Gratings_V4_withRF_recut_surface_raw';
%file = 'fit_WU_Gratings_V1_withRF_recut_surface_asym';
file = 'fit_WU_Gratings_V4_withRF_recut_surface_asym';

location = 1;
%%
load(file)
numChannels = size(LEdata.bins,3);
%aMap = LEdata.amap;

program = 'Gratings';
date = 'WithRF';
animal = 'WU';
if strfind(file,'V1')
    array = 'V1';
else
    array = 'V4';
end
%% Get prefs for ori and SF
for ch = 1:numChannels
    prefOris(1,ch) = LEdata.normPrefOri(1,ch);
    prefOris(2,ch) = REdata.normPrefOri(1,ch);
    
    prefSFs(1,ch) = LEdata.normPrefSF(1,ch);
    prefSFs(2,ch) = REdata.normPrefSF(1,ch);
end

x = [0 6];
y = [0 5];
%% Rank channels by quality of fits (residuals)
% resRE = nan(numChannels,2);
% resLE = nan(numChannels,2);

% for ch = 1:numChannels
%     resRE(ch,2) = nanmean(REdata.residuals{ch}(:));
%
%     resLE(ch,2) = nanmean(LEdata.residuals{ch}(:));
% end
% [resRankRE,resRankREch] = sort(resRE);
% [resRankLE,resRankLEch] = sort(resLE);


sfs = [0.3125 0.625 1.25 2.5 5 10];
oris = [0 30 60 90 120 150];

cmap = [1 0 0;
    1 0.5 0;
    0 0.7 0;
    0 0 1;
    0 1 1;
    0.5 0 1];
%% Plot individual fit curves
for ch = 1:numChannels
    LEdataMax = max(LEdata.oriXsf_sparse{ch}(:));
    LEfitMax  = max(LEdata.surfFitVals{ch}(:));
    LEMax = max(LEdataMax, LEfitMax);
    
    REdataMax = max(REdata.oriXsf_sparse{ch}(:));
    REfitMax  = max(REdata.surfFitVals{ch}(:));
    REMax = max(REdataMax, REfitMax);
    
    yMax = max(REMax, LEMax);
    
    LEblank  = mean(LEdata.oriXsf{ch}(:,1));
    LEblanks = repmat(LEblank,1,length(sfs));
    REblank  = mean(REdata.oriXsf{ch}(:,1));
    REblanks = repmat(REblank,1,length(sfs));
    
    figure
    for i = 1:6
        subplot(2,3,i)
        hold on
        plot(sfs,LEdata.surfFitVals{ch}(i,:),'-','color',cmap(i,:))
        plot(sfs,LEdata.oriXsf_sparse{ch}(i,:),'.','color',cmap(i,:),'MarkerSize',15)
        plot(sfs,LEblanks,'k--')
        ylabel('firing rate')
        xlabel('sf')
        ylim([0 yMax])
        set(gca, 'tickdir','out','color','none','box','off','XScale','log');
        if i == 1
            title (sprintf('%s FE SF fits ch %d %d deg',array, ch, oris(i)))
        else
            title(sprintf('%d deg',oris(i)))
        end
    end
    if strfind(file,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/Split
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/Split
        elseif location == 2
            cd ~/Figures/V1/Gratings/Split
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/Split
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/Split
        elseif location == 2
            cd ~/Figures/V4/Gratings/Split
        end
    end
    figName = ['WU','_',array,'_FE','_',program,'_',num2str(ch),'_','Split'];
    saveas(gcf,figName,'pdf')
    
    figure
    for i = 1:6
        subplot(2,3,i)
        hold on
        plot(sfs,REdata.surfFitVals{ch}(i,:),'-','color',cmap(i,:))
        plot(sfs,REdata.oriXsf_sparse{ch}(i,:),'.','color',cmap(i,:),'MarkerSize',15)
        plot(sfs,REblanks,'k--')
        ylabel('firing rate')
        xlabel('sf')
        ylim([0 yMax])
        set(gca, 'tickdir','out','color','none','box','off','XScale','log');
        if i == 1
            title (sprintf('%s AE SF fits ch %d %d deg', array, ch, oris(i)))
        else
            title(sprintf('%d deg',oris(i)))
            
        end
    end
    if strfind(file,'V1')
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/Split
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/Split
        elseif location == 2
            cd ~/Figures/V1/Gratings/Split
        end
    else
        if location == 0
            cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/Split
        elseif location == 1
            cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/Split
        elseif location == 2
            cd ~/Figures/V4/Gratings/Split
        end
    end
    figName = ['WU','_',array,'_AE','_',program,'_',num2str(ch),'_','Split'];
    saveas(gcf,figName,'pdf')
end

%%



toc/60




