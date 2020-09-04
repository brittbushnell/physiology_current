%plotRFMwks2

clear all
close all
clc
tic
%%
%file = 'WU_RadFreq_V4_June2017';
file = 'WU_RadFreq_V1_June2017';
location = 0;
array = 'V1';
program = 'RadFreq';
%% Extract information
load(file);

numChannels = size(LEdata.bins,3);
amap = LEdata.amap;

RFs   = unique(LEdata.rf);
amps  = unique(LEdata.amplitude);
phase = unique(LEdata.orientation);
SFs   = unique(LEdata.spatialFrequency);
xLocs = unique(LEdata.pos_x);
yLocs = unique(LEdata.pos_y);
rads  = unique(LEdata.radius);
%% get baseline responses
for ch = 1:numChannels
    LEblank(ch,1) = LEdata.radFreqResponse{ch}(end,3);
    REblank(ch,1) = REdata.radFreqResponse{ch}(end,3);
end
%% cd to folder for saving
if strfind(file,'V1')
    if location == 0
        cd ~/Dropbox/Figures/wu_Arrays/V1/RF/Location
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/V1/RF/Location
    elseif location == 2
        cd ~/Figures/V1/RadFreq/Location
    end
else
    if location == 0
        cd ~/Dropbox/Figures/wu_Arrays/V4/RF/Location
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/wu_Arrays/V4/RF/Location
    elseif location == 2
        cd ~/Figures/V4/RadFreq/Location
    end
end
%% Responses for full array FE
figure
for ch = 1:numChannels
    subplot(amap,10,10,ch)
    imagesc(LEdata.locRespBS{ch})
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off','XTick',[],'YTick',[])
    axis square xy
    title(ch)
    
    if ch == 1
        if strfind(file,'V4')
            topTitle = 'V4 FE Rad Freq responses by location';
        else
            topTitle = 'V1 FE Rad Freq responses by location';
        end
        
        annotation('textbox',...
            [0.1 0.94 0.85 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
figName = ['WU','_',array,'_',program,'_','FE','_','allCh'];
%saveas(gcf,figName,'pdf')
%% Responses for full array FE
figure
for ch = 1:numChannels
    subplot(amap,10,10,ch)
    imagesc(REdata.locRespBS{ch})
    colormap(1-gray(255))
    set(gca, 'tickdir','out','color','none','box','off','XTick',[],'YTick',[])
    axis square xy
    title(ch)
    
    if ch == 1
        if strfind(file,'V4')
            topTitle = 'V4 AE Rad Freq responses by location';
        else
            topTitle = 'V1 AE Rad Freq responses by location';
        end
        
        annotation('textbox',...
            [0.1 0.94 0.85 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
figName = ['WU','_',array,'_',program,'_AE_allCh'];
%saveas(gcf,figName,'pdf')
%%
% for ch = 1:numChannels
%     %if ~isempty(intersect(ch,REdata.goodChannels))
%     figure
%     imagesc(REdata.locRespBS{ch})
%     colormap(1-gray(255))
%     set(gca, 'tickdir','out','color','none','box','off',...
%         'XTick',1:3, 'XTickLabel',{'-4.5', '-3', '-1.5'},...   % Note: change the tick labels to populate according to matrix values so not hardcoded.
%         'YTick',1:3, 'YTickLabel',{'-1.5', '0', '1.5'})
%     axis square xy
%     colorbar
%     title(sprintf('%s ch %d AE baseline subtracted responses to preferred grating for locations', array, ch))
%     xlabel('x coordinate (deg)')
%     ylabel('y coordinate (deg)')
%     
%     h = colorbar;
%     ylabel(h,'sp/s','FontSize',12)
%     text(0.6, 0.6, sprintf('%.2f',REdata.spatialFrequencyResp{ch}(3,1)),'Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%     
%     if strfind(filename,'nsp1')
%         if location == 0
%             cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
%         elseif location == 1
%             cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1/MapRF
%         elseif location == 2
%             cd ~/Figures/V1/Gratings/MapRF
%         end
%     else
%         if location == 0
%             cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
%         elseif location == 1
%             cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4/MapRF
%         elseif location == 2
%             cd ~/Figures/V4/Gratings/MapRF
%         end
%     end
%     figName = ['WU','_',array,'_AE_gratMap_',num2str(ch)];
%     saveas(gcf,figName,'pdf')
% end
% close all










