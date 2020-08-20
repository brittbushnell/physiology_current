%function [] = plotMwksSFdata(filename)
% PLOTMWKSSFDATA
% This function takes in the fitted .mat files from gratMwksCh and plots
% the spatial frequency data.
%
% Written Nov 5, 2017 Brittany Bushnell
clc
close all
clear all

%filename = 'fitData_WU_Gratings_V1_recuts';

%filename = 'fitData_WU_Gratings_V4_withRF';
filename = 'fitData_WU_Gratings_V4_recuts';
%%
load(filename)
numChannels = size(LEdata.bins,3);
aMap = LEdata.amap;
%% Plot un-fit data
% xs = LEdata.spatialFrequencyResp{1}(1,4:end);
% figure
% for ch = 1:numChannels
%     subplot(aMap,10,10,ch)
%     Rys = REdata.spatialFrequencyResp{ch}(3,4:end);
%     RyFit = REdata.sfFitResps{ch};
%     RmaxResp = max(REdata.spatialFrequencyResp{ch}(3,4:end))+5;
%
%     Lys = LEdata.spatialFrequencyResp{ch}(3,4:end);
%     LyFit = LEdata.sfFitResps{ch};
%     LmaxResp = max(LEdata.spatialFrequencyResp{ch}(3,4:end))+5;
%     maxResp = max(LmaxResp, RmaxResp);
%
%     hold on
%     if ~isempty(intersect(LEdata.goodChannels,ch))
%         plot(xs,Lys,'bo')
%         plot(xs,LyFit,'b-','LineWidth',1.5)
%          plot([LEdata.sfPrefs(1,ch) LEdata.sfPrefs(1,ch)],[0 maxResp+20],'b:','LineWidth',2)
%     end
%
%     if ~isempty(intersect(REdata.goodChannels,ch))
%         plot(xs,Rys,'ro')
%         plot(xs,RyFit,'r-','LineWidth',1.5)
%          plot([REdata.sfPrefs(1,ch) REdata.sfPrefs(1,ch)], [0 maxResp+20],'r:','LineWidth',2)
%     end
%
%     title(ch)
%     set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
%         'XTick',[0.3 0.6 1.25 2.5 5 10],...
%         'XTickLabel',{'0.3', '0.6', '1.25', '2.5', '5', '10'},...
%         'FontSize',10,...
%         'XTickLabelRotation', 45)
%     xlim([0.2 11])
%
%     if ch == 1
%         if strfind(filename,'V4')
%             topTitle = 'SF tuning, good channels V4 array';
%             subplot(10,10,1)
%         elseif strfind(filename,'V1')
%             topTitle = 'SF tuning, good channels V1 array';
%             subplot(10,10,21)
%         end
%         xlabel('sf(cpd)')
%         ylabel('sp/s')
%         xlim([0 30])
%         ylim([0 35])
%         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
%         text(2,5,'lines = pref SF','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%
%         if strfind(filename,'XT')
%             text(2,20,'RE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'LE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         else
%             text(2,20,'AE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'FE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         end
%         annotation('textbox',...
%             [0.4 0.94 0.35 0.05],...
%             'LineStyle','none',...
%             'String',topTitle,...
%             'Interpreter','none',...
%             'FontSize',16,...
%             'FontAngle','italic',...
%             'FontName','Helvetica Neue');
%     end
% end
%% plot fit data
xs = LEdata.spatialFrequencyResp{1}(1,4:end);
% figure
for ch = 1:numChannels
    figure
    % subplot(aMap,10,10,ch)
    Rys = REdata.sfTune{ch}(3,4:end);
    RyFit = REdata.sfTuneFitResps{ch};
    RmaxResp = max(REdata.sfTune{ch}(3,4:end))+5;
    
    Lys = LEdata.sfTune{ch}(3,4:end);
    LyFit = LEdata.sfTuneFitResps{ch};
    LmaxResp = max(LEdata.spatialFrequencyResp{ch}(3,4:end));
    maxResp = max(LmaxResp, RmaxResp);
    
    hold on
    if ~isempty(intersect(LEdata.goodChannels,ch))
        plot(xs,Lys,'bo')
        plot(xs,LyFit,'b-','LineWidth',2)
        plot(0.15,LEdata.spatialFrequencyResp{ch}(3,1),'b*')
        plot([LEdata.sfTunePrefs(1,ch) LEdata.sfTunePrefs(1,ch)],[0 maxResp+10],'b:','LineWidth',1.5)
    end
    
    if ~isempty(intersect(REdata.goodChannels,ch))
        plot(xs,Rys,'ro')
        plot(xs,RyFit,'r-','LineWidth',2)
        plot(0.15, REdata.spatialFrequencyResp{ch}(3,1),'r*')
        plot([REdata.sfTunePrefs(1,ch) REdata.sfTunePrefs(1,ch)], [0 maxResp+10],'r:','LineWidth',1.5)
    end
    %    title(ch)
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.15 0.3 0.6 1.25 2.5 5 10],...
        'XTickLabel',{'baseline','0.3', '0.6', '1.25', '2.5', '5', '10'},...
        'FontSize',10,...
        'XTickLabelRotation', 45)
    xlim([0.1 11])
    xlabel('spatial frequency (cpd)')
    ylabel('spikes/sec')
    
    AEstr = 'AE';
    FEstr = 'FE';
    preStr = ': preferred SF';
    annotation('textbox',[0.2 0.87 0.7 0.05],...
        'LineStyle','none',...
        'String',AEstr,...
        'Interpreter','none',...
        'FontSize',12,...
        'FontAngle','italic',...
        'FontName','Helvetica Neue',...
        'FontWeight','bold',...
        'Color','Red');
    annotation('textbox',[0.25 0.87 0.7 0.05],...
        'LineStyle','none',...
        'String',FEstr,...
        'Interpreter','none',...
        'FontSize',12,...
        'FontAngle','italic',...
        'FontName','Helvetica Neue',...
        'FontWeight','bold',...
        'Color','Blue');
    annotation('textbox',[0.3 0.87 0.7 0.05],...
        'LineStyle','none',...
        'String',preStr,...
        'Interpreter','none',...
        'FontSize',12,...
        'FontAngle','italic',...
        'FontName','Helvetica Neue',...
        'FontWeight','bold');
    
    %     text(0.2,5,'AE','Color','red','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    %     text(0.2,2,'FE','Color','blue','FontSize',20,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
    
    if strfind(filename,'V4')
        title(sprintf('SF tuning V4 array ch %d, DOG fits',ch))
    else
        title(sprintf('SF tuning V1 array ch %d, DOG fits',ch))
    end
    if strfind(filename,'V1')
        figName = ['WU','_','V1','_',num2str(ch,'ch%d')];
        cd /users/bushnell/Desktop/SF/V1
    else
        figName = ['WU','_','V4','_',num2str(ch,'ch%d')];
        cd /users/bushnell/Desktop/SF/V4
    end
    
    saveas(gcf,figName,'pdf')
end

%     if ch == 1
%         if strfind(filename,'V4')
%             topTitle = 'SF tuning for best orientation, V4 array';
%             subplot(10,10,1)
%         elseif strfind(filename,'V1')
%             topTitle = 'SF tuning for best orientation, V1 array';
%             subplot(10,10,21)
%         end
%         xlabel('sf(cpd)')
%         ylabel('sp/s')
%         xlim([0 30])
%         ylim([0 35])
%         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
%         %text(2,5,'lines = pref SF','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%
%         if strfind(filename,'XT')
%             text(2,20,'RE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'LE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         else
%             text(2,20,'AE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'FE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         end
%         annotation('textbox',...
%             [0.4 0.94 0.35 0.05],...
%             'LineStyle','none',...
%             'String',topTitle,...
%             'Interpreter','none',...
%             'FontSize',16,...
%             'FontAngle','italic',...
%             'FontName','Helvetica Neue');
%     end
% end
%% preferredSF AE vs FE
% figure
% hold on
% set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
%     'XTick',[0.3125, 0.625, 1.25, 2.5, 5, 10],...
%     'XTickLabel',{'0.3', '0.6', '1.25', '2.5', '5', '10'},...
%     'YScale','log', 'YTick',[0.3125, 0.625, 1.25, 2.5, 5, 10],...
%     'XTickLabel',{'0.3', '0.6', '1.25', '2.5', '5', '10'})
%
% ylim([0 10])
% xlim([0 10])
%
% for ch = 1:numChannels
%     if ~isempty(intersect(REdata.goodChannels,ch)) && ~isempty(intersect(LEdata.goodChannels,ch))
%         plot(LEdata.sfTunePrefs(1,ch), REdata.sfTunePrefs(1,ch),'om')
%     elseif ~isempty(intersect(REdata.goodChannels,ch)) && isempty(intersect(LEdata.goodChannels,ch))
%         plot(0.15, REdata.sfTunePrefs(1,ch),'om')
%     elseif ~isempty(intersect(LEdata.goodChannels,ch)) && isempty(intersect(REdata.goodChannels,ch))
%         plot(LEdata.sfTunePrefs(1,ch), 0.15,'om')
%     end
% end
%
% plot([0.15 10], [0.15 10], ':k')
%
% xlabel('FE preferred SF')
% ylabel('AE preferred SF')
% if strfind(filename,'V1')
%     title('Preferred SFs for each eye from the V1 array')
% else
%     title('Preferred SFs for each eye from the V4 array')
% end
%% bandwidth vs preferred SF
% figure
% for ch = 1:numChannels
%    if ~isempty(intersect(REdata.goodChannels,ch))
%     plot(REdata.sfTune
% end





