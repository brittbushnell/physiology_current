% plotMwksGratSurface
%
%
close all
clear all
clc
tic
%% NOTES
% testing to show Emily
%%
%file = 'fitData_WU_Gratings_V4_recuts_surface.mat';
%file = 'fitData_WU_Gratings_V1_recuts_surface.mat';
%file = 'fit_WU_Gratings_V1_0626_recut_surface.mat';
%file = 'fit_WU_Gratings_V4_0626_recut_surface.mat';
%file = 'fit_WU_Gratings_V4_withRF_recut_surface_raw';
%file = 'fit_WU_Gratings_V1_withRF_recut_surface_raw';
file = 'fit_WU_Gratings_V4_withRF_recut_surface_T4';

norm = 1; % set to 1 if fits were done on normalized data.
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
    LEp = LEdata. surfParams{ch};
    muxLE = LEp(2);
    muyLE = LEp(3);
    
    REp = REdata. surfParams{ch};
    muxRE = REp(2);
    muyRE = REp(3);
    
    LEdata.pkSF(1,ch)  = muxLE;
    LEdata.pkOri(1,ch) = muyLE;
    REdata.pkSF(1,ch)  = muxRE;
    REdata.pkOri(1,ch) = muyRE;
end
x = [0 6];
y = [0 5];
%% Rank channels by quality of fits (residuals)
resRE = nan(numChannels,2);
resLE = nan(numChannels,2);

for ch = 1:numChannels
    resRE(ch,2) = nanmean(REdata.residuals{ch}(:));
    
    resLE(ch,2) = nanmean(LEdata.residuals{ch}(:));
end
[resRankRE,resRankREch] = sort(resRE);
[resRankLE,resRankLEch] = sort(resLE);
%% Plot heatmaps of the normalized data
% 
% for ch = 1:numChannels
%     figure
%     REMin = min(REdata.residuals{ch}(:));
%     LEMin = min(LEdata.residuals{ch}(:));
%     scaleMin = min(REMin,LEMin);
%     
%     REMax = max(REdata.residuals{ch}(:));
%     LEMax = max(LEdata.residuals{ch}(:));
%     scaleMax = max(REMax,LEMax);
%     scaleLims = [scaleMin scaleMax];
%     
%     subplot(1,2,1)
%     hold on
%     imagesc(x,y,LEdata.surfFitVals{ch}, scaleLims)
%     colormap(1-gray(255))
%     colorbar
%     set(gca, 'tickdir','out','color','none','box','off',...
%         'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
%         'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
%     axis square
%     xlim([-0.5 6.5]);
%     ylim([-0.5 5.5]);
%     xlabel('Spatial Frequency (cpd)')
%     ylabel('Orientation (deg)')
%     title (sprintf('FE ch %d', ch))
%     
%     subplot(1,2,2)
%     hold on
%     imagesc(x,y,REdata.surfFitVals{ch}, scaleLims)
%     colormap(1-gray(255))
%     colorbar
%     set(gca, 'tickdir','out','color','none','box','off',...
%         'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
%         'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
%     axis square
%     xlim([-0.5 6.5]);
%     ylim([-0.5 5.5]);
%     xlabel('Spatial Frequency (cpd)')
%     ylabel('Orientation (deg)')
%     title (sprintf('AE ch %d', ch))
%     
%     if strfind(file,'V1')
%         topTitle = 'Normalized responses of V1/V2 array fit with a vonMises';
%     else
%         topTitle = 'Normalized responses of V4 array fit with a vonMises';
%     end
%     annotation('textbox',...
%         [0.1 0.75 0.9 0.05],...
%         'LineStyle','none',...
%         'String',topTitle,...
%         'Interpreter','none',...
%         'FontSize',18,...
%         'FontAngle','italic',...
%         'FontName','Helvetica Neue');
%     
%     if strfind(file,'V1')
%         cd /users/bushnell/Desktop/Figs/Surfaces/V1
%     else
%         cd /users/bushnell/Desktop/Figs/Surfaces/V4
%     end
%     figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','surface','_','norm'];
%     saveas(gcf,figName,'pdf')
% end
% close all
%% plot heatmaps of threshold crossings and fits
for ch = 1:numChannels
    RErank = resRankREch(ch,2);
    LErank = resRankLEch(ch,2);
    
%     REMin = min(REdata.normOriXsf{ch}(:));
%     LEMin = min(LEdata.normOriXsf{ch}(:));
%     scaleMin = min(REMin,LEMin);
%     
%     REMax = max(REdata.normOriXsf{ch}(:));
%     LEMax = max(LEdata.normOriXsf{ch}(:));
%     scaleMax = max(REMax,LEMax);
%     scaleLims = [scaleMin scaleMax];
    
    REMin = min(REdata.normOriXsf{ch}(:));
    LEMin = min(LEdata.normOriXsf{ch}(:));
    scaleMin = min(REMin,LEMin);
    
    REMax = max(REdata.normOriXsf{ch}(:));
    LEMax = max(LEdata.normOriXsf{ch}(:));
    scaleMax = max(REMax,LEMax);
    scaleLims = [scaleMin scaleMax];
    figure
    
    subplot(2,2,1)
    hold on
    %imagesc(x,y,LEdata.normOriXsf{ch},scaleLims)
    imagesc(x,y,LEdata.normOriXsf{ch},scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
   % xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('FE ch %d normalized responses', ch))
    
    subplot(2,2,2)
    hold on
    %imagesc(x,y,REdata.normOriXsf{ch},scaleLims)
    imagesc(x,y,REdata.normOriXsf{ch},scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
    xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('AE ch %d normalized responses', ch))
    
%     REMin = min(REdata.surfFitVals{ch}(:));
%     LEMin = min(LEdata.surfFitVals{ch}(:));
%     scaleMin = min(REMin,LEMin);
%     
%     REMax = max(REdata.surfFitVals{ch}(:));
%     LEMax = max(LEdata.surfFitVals{ch}(:));
%     scaleMax = max(REMax,LEMax);
%     scaleLims = [scaleMin scaleMax];
    
    subplot(2,2,3)
    hold on
    imagesc(x,y,LEdata.normSurfFitVals{ch}, scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
    xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('FE ch %d fits', ch))
    
    subplot(2,2,4)
    hold on
    imagesc(x,y,REdata.normSurfFitVals{ch}, scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
    xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('AE ch %d fits', ch))
    
    
    %     if strfind(file,'V1')
    %         topTitle = 'V1/V2 array threshold crossings';
    %     else
    %         topTitle = 'V4 array threshold crossings';
    %     end
    %     annotation('textbox',...
    %         [0.1 0.75 0.9 0.05],...
    %         'LineStyle','none',...
    %         'String',topTitle,...
    %         'Interpreter','none',...
    %         'FontSize',18,...
    %         'FontAngle','italic',...
    %         'FontName','Helvetica Neue');
    %
        if strfind(file,'V1')
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/Surfacess
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
            elseif location == 2
                cd ~/Figures/V1/Gratings/Surfaces/
            end
        else
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/Surfaces
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
            elseif location == 2
                cd ~/Figures/V4/Gratings/Surfaces/
            end
        end
        figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','Surf_heat'];
        saveas(gcf,figName,'pdf')
end
%% Plot stacked fit curves
% 
% close all
% sfSmooth = logspace(0,10,100);
% sfs = log10([0 0.3125 0.625 1.25 2.5 5 10]);
% 
% oriSmooth = linspace(0,150,100);
% oris = [0 30 60 90 120 150];
% 
% for ch = 1:numChannels
%     RErank = resRankREch(ch,2);
%     LErank = resRankLEch(ch,2);
%     figure
%     
%     subplot(2,2,1)
%     hold on
%     plot(sfs,LEdata.surfFitVals{ch}','-')
%     plot(sfs,LEdata.normOriXsf{ch}','o')
%     set(gca, 'tickdir','out','color','none','box','off');
%     ylabel('z-score response')
%     xlabel('sf')
%     title (sprintf('FE SF fits ch %d', ch))
%     
%     subplot(2,2,2)
%     hold on
%     plot(oris,LEdata.surfFitVals{ch},'-')
%     plot(oris,LEdata.normOriXsf{ch},'o')
%     set(gca, 'tickdir','out','color','none','box','off');
%     xlabel('orientation')
%     title (sprintf('FE orientation fits ch %d', ch))
%     
%     subplot(2,2,3)
%     hold on
%     plot(sfs,REdata.surfFitVals{ch}','-')
%     plot(sfs,REdata.normOriXsf{ch}','o')
%     set(gca, 'tickdir','out','color','none','box','off');
%     ylabel('z-score response')
%     xlabel('sf')
%     title (sprintf('AE SF fits ch %d', ch))
%     
%     subplot(2,2,4)
%     hold on
%     plot(oris,REdata.surfFitVals{ch},'-')
%     plot(oris,REdata.normOriXsf{ch},'o')
%     set(gca, 'tickdir','out','color','none','box','off');
%     xlabel('orientation')
%     title (sprintf('AE orientation fits ch %d', ch))
%     
%     if strfind(file,'V1')
%         cd ~/Desktop/Figs/Stacked/V1
%     else
%         cd ~/Desktop/Figs/Stacked/V4
%     end
%     figName = ['WU','_',array,'_',program,'_',num2str(RErank),'_','date','_','fits'];
%     saveas(gcf,figName,'pdf')
% end

%%
close all
% sfs = unique(LEdata.spatial_frequency);
% sfs = [(sfs(1,1)), (sfs(1,4:end))];
%
% oris = unique(LEdata.rotation);
% oris = oris(1,1:end-1);
%
% for ch = 1:numChannels
%     figure
%
%     LEp = LEdata. surfParams{ch};
%     amp = LEp(1);
%     muxLE = LEp(2);
%     muyLE = LEp(3);
%     kappaX = LEp(4);
%     kappaY = LEp(5);
%
%     %     yyR =  REb(1) + amp .* exp(shape*cosd(xxR-mu)) /
%     %     (pi*besseli(0,shape));
%
%     or = 0:5:150;
%     sf = 0:0.25:10;
%
%     orCurveLE = amp .* exp(kappaX*cosd(or-muxLE)) / (pi*besseli(0,kappaX)); % do I want to multiply by pi?
%     sfCurveLE = amp .* exp(kappaY*cosd(sf-muyLE)) / (pi*besseli(0,kappaY));
%
%     sfMuLE  = mean(LEdata.normOriXsf{ch},1);
%     oriMuLE = mean(LEdata.normOriXsf{ch},2)';
%
%     subplot (2,2,1)
%     hold on
%     plot(sf,sfCurveLE,'k')
%     plot(LEdata.pkSF(ch),(max(sfCurveLE)),'b*')
%     %     for s = 1:length(sfs)
%     %         plot(sfs,(LEdata.normOriXsf{ch}(:,s)),'o')
%     %     end
%     % plot(sfs,sfMuLE,'o')
%     ylabel('z-score response')
%     title (sprintf('FE SF fits ch %d', ch))
%     set(gca, 'tickdir','out','color','none','box','off',...
%         'XTick',1:7,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
%
%     subplot (2,2,2)
%     hold on
%     plot(or,orCurveLE,'k')
%     plot(LEdata.pkOri(ch),(max(orCurveLE)),'b*')
%     %plot(oris,oriMuLE,'o')
%     %     for o = 1:length(oris)
%     %         plot(oris,(LEdata.normOriXsf{ch}(o,:)),'o')
%     %     end
%     title (sprintf('FE orientation fits ch %d', ch))
%     set(gca, 'tickdir','out','color','none','box','off')%,...
%        % 'XTick',1:7,'XTickLabel',{'180','150','120','90','60','30','0'})
%
%     REp = REdata. surfParams{ch};
%     amp = REp(1);
%     muxRE = REp(2);
%     muyRE = REp(3);
%     kappaX = REp(4);
%     kappaY = REp(5);
%
%     orCurveRE = amp .* exp(kappaX*cosd(or-muxRE)) / (pi*besseli(0,kappaX));
%     sfCurveRE = amp .* exp(kappaY*cosd(sf-muyRE)) / (pi*besseli(0,kappaY));
%
%     sfMuRE  = mean(REdata.normOriXsf{ch},1);
%     oriMuRE = mean(REdata.normOriXsf{ch},2)';
%
%
%     subplot (2,2,3)
%     hold on
%     plot(sf,sfCurveRE,'k')
%     plot(REdata.pkSF(ch),(max(sfCurveRE)),'r*')
%     %     for s = 1:length(sfs)
%     %         plot(sfs,(LEdata.normOriXsf{ch}(:,s)),'o')
%     %     end
%     % plot(sfs,sfMuLE,'o')
%     xlabel('spatial frequency')
%     ylabel('z-score response')
%     title (sprintf('AE SF fits ch %d', ch))
%     set(gca, 'tickdir','out','color','none','box','off',...
%        'XTick',1:7,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
%
%     subplot (2,2,4)
%     hold on
%     plot(or,orCurveRE,'k')
%     plot(REdata.pkOri(ch),(max(orCurveRE)),'r*')
%     %plot(oris,oriMuLE,'o')
%     %     for o = 1:length(oris)
%     %         plot(oris,(LEdata.normOriXsf{ch}(o,:)),'o')
%     %     end
%     xlabel('orientation')
%     title (sprintf('FE orientation fits ch %d', ch))
%     set(gca, 'tickdir','out','color','none','box','off')%,...
%         %'XTick',1:7,'XTickLabel',{'180','150','120','90','60','30','0'})
%
% %     if strfind(file,'V1')
% %         topTitle = 'Fits for V1/V2 array';
% %     else
% %         topTitle = 'Fits for V4 array fit with a vonMises';
% %     end
% %     annotation('textbox',...
% %         [0.1 0.99 0.9 0.05],...
% %         'LineStyle','none',...
% %         'String',topTitle,...
% %         'Interpreter','none',...
% %         'FontSize',18,...
% %         'FontAngle','italic',...
% %         'FontName','Helvetica Neue');
%
%     if strfind(file,'V1')
%         cd /users/bushnell/Desktop/Figs/SurfaceFits/V1
%     else
%         cd /users/bushnell/Desktop/Figs/SurfaceFits/V4
%     end
%     figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','residuals'];
%     saveas(gcf,figName,'pdf')
% end
% close all
%% residual heatmaps
for ch = 1:numChannels
    RErank = resRankREch(ch,2);
    LErank = resRankLEch(ch,2);
    
    figure
    
    REMin = min(REdata.residuals{ch}(:));
    LEMin = min(LEdata.residuals{ch}(:));
    scaleMin = min(REMin,LEMin);
    
    REMax = max(REdata.residuals{ch}(:));
    LEMax = max(LEdata.residuals{ch}(:));
    scaleMax = max(REMax,LEMax);
    scaleLims = [scaleMin scaleMax];
    
    
    subplot(1,2,1)
    imagesc(x,y,LEdata.residuals{ch},scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
    xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('FE ch %d', ch))
    
    subplot(1,2,2)
    imagesc(x,y,REdata.residuals{ch},scaleLims)
    colormap(1-gray(255))
    colorbar
    set(gca, 'tickdir','out','color','none','box','off',...
        'YTick',0:5.5,'YTickLabel',{'150','120','90','60','30','0'},...
        'XTick',0:6.5,'XTickLabel',{'0','0.3', '0.6', '1.25', '2.5', '5', '10'}, 'XTickLabelRotation', 45)
    axis square
    xlim([-0.5 6.5]);
    ylim([-0.5 5.5]);
    xlabel('Spatial Frequency (cpd)')
    ylabel('Orientation (deg)')
    title (sprintf('AE ch %d', ch))
    
    if strfind(file,'V1')
        topTitle = 'Residuals of V1/V2 array';
    else
        topTitle = 'Residuals of V4 array';
    end
    annotation('textbox',...
        [0.1 0.75 0.9 0.05],...
        'LineStyle','none',...
        'String',topTitle,...
        'Interpreter','none',...
        'FontSize',18,...
        'FontAngle','italic',...
        'FontName','Helvetica Neue');
    
        if strfind(file,'V1')
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/Surfacess
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
            elseif location == 2
                cd ~/Figures/V1/Gratings/Surfaces/
            end
        else
            if location == 0
                cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/Surfaces
            elseif location == 1
                cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
            elseif location == 2
                cd ~/Figures/V4/Gratings/Surfaces/
            end
        end
        figName = ['WU','_',array,'_',program,'_',num2str(ch),'_','Surf_resid'];
        saveas(gcf,figName,'pdf')
end

toc/60




