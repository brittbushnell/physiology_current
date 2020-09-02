% function [] = plotMwksOriData(filename)
% plotMwksOriData
% This function takes in the fitted .mat files from gratMwksCh and plots
% the orientation data.
%
% Written Nov 5, 2017 Brittany Bushnell
clc
close all
clear all
location = 1;
%%
%filename = 'fitData_WU_Gratings_V4_withRF';
%filename = 'fitData_WU_Gratings_V1_withRF';

%filename = 'fitData_WU_GratingsCon_V4_Aug2017';
%filename = 'fitData_WU_GratingsCon_V1_Aug2017';
%filename = 'fitData_WU_Gratings_V4_recuts';
filename = 'fitData_WU_Gratings_V1_recuts';
%%
if location == 1
else
    if strfind(filename,'V4')
        cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/
    else
        cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
    end
end
%%
load(filename)
numChannels = size(LEdata.bins,3);
aMap = LEdata.amap;
%% plot orientation tuning
% figure
% for ch = 1:numChannels
%     %figure
%     REmaxResp = max(REdata.oriTuneResp{ch}(3,:))+5;
%     LEmaxResp = max(LEdata.oriTuneResp{ch}(3,:))+5;
%     
%     REminResp = min(REdata.oriTuneResp{ch}(3,:))+5;
%     LEminResp = min(LEdata.oriTuneResp{ch}(3,:))+5;
%     maxResp = max(REmaxResp, LEmaxResp);
%     
%     subplot(aMap,10,10,ch)
%     hold on
%     if ~isempty(intersect(REdata.goodChannels,ch))
%         plot(REdata.oriTuneResp{ch}(1,:), REdata.oriTuneResp{ch}(3,:),'r.:','MarkerSize',11)
%         % plot(REdata.prefOri(1,ch), REmaxResp,'r*')
%         %    plot(REdata.prefOriVM(1,ch), REmaxResp,'rv')
%         plot([0 180], [REdata.spatialFrequencyResp{ch}(3,1) REdata.spatialFrequencyResp{ch}(3,1)],'r-')
%     end
%     
%     if ~isempty(intersect(LEdata.goodChannels,ch))
%         plot(REdata.oriTuneResp{ch}(1,:), LEdata.oriTuneResp{ch}(3,:),'b.:','MarkerSize',11)
%         % plot(LEdata.prefOri(1,ch), LEmaxResp,'b*')
%         %    plot(LEdata.prefOriVM(1,ch), LEmaxResp,'bv')
%         plot([0 180], [LEdata.spatialFrequencyResp{ch}(3,1) LEdata.spatialFrequencyResp{ch}(3,1)],'b-')
%     end
%     %     LEpref = ['LE OI: ', num2str(LEdata.oriIndex(1,ch))];
%     %     text(0,max(REmaxResp, LEmaxResp)+5,LEpref)
%     %
%     %     REpref = ['RE OI: ', num2str(REdata.oriIndex(1,ch))];
%     %     text(0,max(REmaxResp, LEmaxResp),REpref)
%     
%     set(gca,'box', 'off','color', 'none', 'tickdir','out')
%     xlim([-1 181])
%     title(ch)
%     
%     subplot(10,10,1)
%     xlabel('ori')
%     ylabel('sp/s')
%     set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
%     
%     if ch == 1
%         if strfind(filename,'V1')
%             topTitle = 'Mean orientation response V1';
%         else
%             topTitle = 'Mean orientation response V4';
%         end
%         annotation('textbox',...
%             [0.4 0.94 0.35 0.05],...
%             'LineStyle','none',...
%             'String',topTitle,...
%             'Interpreter','none',...
%             'FontSize',16,...
%             'FontAngle','italic',...
%             'FontName','Helvetica Neue');
%         xlim([0 30])
%         ylim([0 35])
%         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
%         if strfind(filename,'XT')
%             text(2,20,'RE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'LE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         else
%             text(2,20,'AE','Color','red','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%             text(18,20,'FE','Color','blue','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         end
%         %         text(2,13,'square = peak FR','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         %         text(2,5,'triangle = pref Ori','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%     end
% end
%% Plot vonmises fits from Tom's fitting program and 180 deg data
%figure
for ch = 1:numChannels
    
    figure
    x = REdata.oriTuneResp{ch}(1,:);
    yR = REdata.oriTuneResp{ch}(3,:);
    REb = vonmisesfit(x,yR,'silent',true);
    REprefOri(1,ch) = REb(3);
    REoriBan(1,ch) = vonmisesbandwidth(REb);
    
    
    xxR = 0:5:180;
    yyR =  REb(1) + REb(2) .* exp(REb(4)*cosd(xxR-REb(3))) / (pi*besseli(0,REb(4)));
    
    yL = LEdata.oriTuneResp{ch}(3,:);
    LEb = vonmisesfit(x,yL,'silent',true);
    LEprefOri(1,ch) = LEb(3);
    LEoriBan(1,ch) = vonmisesbandwidth(LEb);
    
    xxL = 0:5:180;
    yyL =  LEb(1) + LEb(2) .* exp(LEb(4)*cosd(xxL-LEb(3))) / (2*pi*besseli(0,LEb(4)));
    
    if ~isempty(intersect(REdata.goodChannels,ch)) &&  ~isempty(intersect(LEdata.goodChannels,ch))
            maxResp = max((REb(2)+REb(1)), (LEb(2)+LEb(1)));
%             maxRespt = maxResp*.10;
%             maxResp = maxResp + maxRespt;
        elseif ~isempty(intersect(REdata.goodChannels,ch))
            maxResp = REb(2);
        elseif ~isempty(intersect(LEdata.goodChannels,ch))
            maxResp = LEb(2);
        end
      
        %subplot(aMap,10,10,ch)
        hold on
        if ~isempty(intersect(REdata.goodChannels,ch))
            plot(x,yR,'ro');
            plot(xxR,yyR,'r-','LineWidth',2);
            plot([REb(3) REb(3)], [0 maxResp],'r:','LineWidth',1.5)
            plot(0, REdata.spatialFrequencyResp{ch}(3,1),'r*')
        end
        if ~isempty(intersect(LEdata.goodChannels,ch))
            plot(x,yL,'bo');
            plot(xxL,yyL,'b-','LineWidth',2);
            plot([LEb(3) LEb(3)], [0 (maxResp)],'b:','LineWidth',1.5)
            plot(0, LEdata.spatialFrequencyResp{ch}(3,1),'b*')
        end
        set(gca,'box', 'off','color', 'none', 'tickdir','out')%,'XScale','log')
        xlim([-5 180])
        xlabel('Orienation (deg)')
        ylabel('Spikes/sec')
        
        AEstr = 'AE';
        FEstr = 'FE';
        preStr = ': preferred SF';
        annotation('textbox',[0.2 0.87 0.7 0.05],...
            'LineStyle','none',...
            'String',AEstr,...
            'Interpreter','none',...
            'FontSize',10,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue',...
            'FontWeight','bold',...
            'Color','Red');
        annotation('textbox',[0.3 0.87 0.7 0.05],...
            'LineStyle','none',...
            'String',FEstr,...
            'Interpreter','none',...
            'FontSize',10,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue',...
            'FontWeight','bold',...
            'Color','Blue');
        annotation('textbox',[0.4 0.87 0.7 0.05],...
            'LineStyle','none',...
            'String',preStr,...
            'Interpreter','none',...
            'FontSize',10,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue',...
            'FontWeight','bold');
        
        if strfind(filename,'V4')
            title(sprintf('Orientation tuning V4 array ch %d, vonMises fits',ch))
        else
            title(sprintf('Orientation tuning V1 array ch %d, vonMises fits',ch))
        end
        if strfind(filename,'V1')
            figName = ['WU','_','V1','_',num2str(ch,'ch%d')];
            cd /users/bushnell/Desktop/Ori/V1
        else
            figName = ['WU','_','V4','_',num2str(ch,'ch%d')];
            cd /users/bushnell/Desktop/Ori/V4
        end
        
        saveas(gcf,figName,'pdf')
    end
    %%     if ch == 1
    %         if strfind(filename,'V4')
    %             topTitle = 'Orientation tuning for best SF V4 array';
    %             subplot(10,10,1)
    %         elseif strfind(filename,'V1')
    %             topTitle = 'Orientation tuning for best SF V1 array';
    %             subplot(10,10,21)
    %         end
    %         xlabel('ori(deg)')
    %         ylabel('sp/s')
    %         xlim([0 30])
    %         ylim([0 35])
    %         set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    %         % text(2,5,'lines = pref SF','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
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
    %% Plot histogram of tuning indices w/ min ori
    LEpref = nan(1,numChannels);
    REpref = nan(1,numChannels);
    
    for ch = 1:numChannels
        if ~isempty(intersect(LEdata.goodChannels,ch))
            LEpref(1,ch) = LEdata.oriIndex(ch);
        end
    end
    
    for ch = 1:numChannels
        if ~isempty(intersect(REdata.goodChannels,ch))
            REpref(1,ch) = REdata.oriIndex(ch);
        end
    end
    
    mnLE = nanmean(LEpref);
    mnRE = nanmean(REpref);
    
    [~,pDiff]= ttest2(REpref,LEpref);
    
    figure
    hold on
    histogram(LEpref,10,'BinWidth',0.1,'FaceColor',[0,0.5,0],'FaceAlpha',0.3)
    histogram(REpref,10,'BinWidth',0.1,'FaceColor',[0.5,0.2,0.5],'FaceAlpha',0.3)
    
    plot(mnLE,18,'v','MarkerFaceColor',[0,0.5,0],...
        'MarkerEdgeColor',[0,0.5,0],'MarkerSize',8)
    text(mnLE,18.5,num2str(mnLE,'%.3f'),...
        'FontSize',10,'HorizontalAlignment','center')
    
    plot(mnRE,18,'v','MarkerFaceColor',[0.5,0.2,0.5],...
        'MarkerEdgeColor',[0.5,0.2,0.5],'MarkerSize',8)
    text(mnRE,18.5,num2str(mnRE,'%.3f'),...
        'FontSize',10,'HorizontalAlignment','center')
    %text(0.75,17,num2str(pDiff,'AE vs FE p = %.4f'))
    
    ylim([0 20])
    
    legend('FE','AE')
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XTick',[0 0.25 0.5 0.75 1]);%,'XTickLabel',{'Not tuned','','0.5','','Highly Tuned'},...
    %  'XTickLabelRotation', 45)
    xlabel('Orientation Tuning Index','FontWeight','bold')
    ylabel('# channels','FontWeight','bold')
    if strfind(filename,'V4')
        title('V4 Orientation tuning indices for good channels AE vs FE min')
    else
        title('V1 Orientation tuning indices for good channels AE vs FE min')
    end
    %% Plot histogram of tuning indices w/ null ori
    % for gch = 1:length(LEdata.goodChannels)
    %     ch = LEdata.goodChannels(gch);
    %     if ~isempty(intersect(LEdata.goodChannels,ch))
    %         LEpref(1,gch) = LEdata.oriIndexNull(ch);
    %     end
    % end
    %
    % for gch = 1:length(REdata.goodChannels)
    %     ch = REdata.goodChannels(gch);
    %     if ~isempty(intersect(REdata.goodChannels,ch))
    %         REpref(1,gch) = REdata.oriIndexNull(ch);
    %     end
    % end
    %
    % mnLE = mean(LEpref);
    % mnRE = mean(REpref);
    %
    % figure
    % hold on
    % histogram(LEdata.oriIndexNull,'FaceColor',[0,0,0.5],'FaceAlpha',0.3)
    % histogram(REdata.oriIndexNull,'FaceColor',[0.5,0,0],'FaceAlpha',0.3)
    %
    % plot(mnDiff,13,'v','MarkerFaceColor',[0,0,0.5],...
    %     'MarkerEdgeColor',[0,0,0.5],'MarkerSize',8)
    % text(mnDiff,13.5,num2str(mnDiff,'%.3f'),...
    %     'FontSize',10,'HorizontalAlignment','center')
    %
    % plot(medRE,13,'v','MarkerFaceColor',[0.5,0,0],...
    %     'MarkerEdgeColor',[0.5,0,0],'MarkerSize',8)
    % text(medRE,13.5,num2str(medRE,'%.3f'),...
    %     'FontSize',10,'HorizontalAlignment','center')
    %
    % legend('FE','AE')
    % set(gca,'box', 'off','color', 'none', 'tickdir','out')
    % title('V4 Orientation tuning indices AE vs FE null')
    %% Plot histogram of peak tuning
    
%     for ch = 1:numChannels
%         if ~isempty(intersect(LEdata.goodChannels,ch))
%             LEpref(1,ch) = LEdata.prefOriTVM(ch);
%         end
%     end
%     
%     for ch = 1:numChannels
%         if ~isempty(intersect(REdata.goodChannels,ch))
%             REpref(1,ch) = REdata.prefOriTVM(ch);
%         end
%     end
%     
%     mnLE = nanmean(LEpref);
%     mnRE = nanmean(REpref);
%     
%     figure
%     hold on
%     histogram(LEdata.prefOriTVM,10,'BinWidth',10,'FaceColor',[0,0.5,0],'FaceAlpha',0.3)
%     histogram(REdata.prefOriTVM,10,'BinWidth',10,'FaceColor',[0.5,0.2,0.5],'FaceAlpha',0.3)
%     
%     plot(mnLE,84,'v','MarkerFaceColor',[0,0.5,0],...
%         'MarkerEdgeColor',[0,0.5,0],'MarkerSize',8)
%     text(mnLE,86,num2str(mnLE,'%.3f'),...
%         'FontSize',10,'HorizontalAlignment','center')
%     
%     plot(mnRE,84,'v','MarkerFaceColor',[0.5,0.2,0.5],...
%         'MarkerEdgeColor',[0.5,0.2,0.5],'MarkerSize',8)
%     text(mnRE,86,num2str(mnRE,'%.3f'),...
%         'FontSize',10,'HorizontalAlignment','center')
%     
%     legend('FE','AE')
%     set(gca,'box', 'off','color', 'none', 'tickdir','out','XTick',[0 30 60 90 120 150 180])
%     xlabel('Orientation (deg)','FontWeight','bold')
%     ylabel('# channels','FontWeight','bold')
%     
%     if strfind(filename,'V4')
%         title('V4 Preferred orienations for good channels AE vs FE')
%     else
%         title('V1 Preferred orienations for good channels AE vs FE')
%     end
    %% Plot bandwidths
%     for ch = 1:numChannels
%         if ~isempty(intersect(LEdata.goodChannels,ch))
%             LEpref(1,ch) = LEprefOri(1,ch);
%         end
%     end
%     
%     for ch = 1:numChannels
%         if ~isempty(intersect(REdata.goodChannels,ch))
%             REpref(1,ch) = LEprefOri(1,ch);
%         end
%     end
%     
%     mnLE = nanmean(LEdata.oriBanTVM);
%     mnRE = nanmean(REdata.oriBanTVM);
%     
%     figure
%     hold on
%     histogram(LEdata.oriBanTVM,10,'BinWidth',30,'FaceColor',[0,0.5,0],'FaceAlpha',0.3)
%     histogram(REdata.oriBanTVM,10,'BinWidth',30,'FaceColor',[0.5,0.2,0.5],'FaceAlpha',0.3)
%     
%     plot(mnLE,84,'v','MarkerFaceColor',[0,0.5,0],...
%         'MarkerEdgeColor',[0,0.5,0],'MarkerSize',8)
%     text(mnLE,87,num2str(mnLE,'%.3f'),...
%         'FontSize',10,'HorizontalAlignment','center')
%     
%     plot(mnRE,84,'v','MarkerFaceColor',[0.5,0.2,0.5],...
%         'MarkerEdgeColor',[0.5,0.2,0.5],'MarkerSize',8)
%     text(mnRE,87,num2str(mnRE,'%.3f'),...
%         'FontSize',10,'HorizontalAlignment','center')
%     
%     legend('FE','AE')
%     set(gca,'box', 'off','color', 'none', 'tickdir','out','XTick',0:30:390)
%     xlabel('Orientation (deg)','FontWeight','bold')
%     ylabel('# channels','FontWeight','bold')
%     %xlim([0 380])
%     if strfind(filename,'V4')
%         title('V4 orientation bandwidths for good channels AE vs FE')
%     else
%         title('V1 orientation bandwidths for good channels AE vs FE')
%     end
    %% scatter plot of preferred orientations
    maxOri
    % prefOriTVM - very few. Something's fishy
    % prefOri
    
    % figure
    % for ch = 1:numChannels
    %     hold on
    %     if ~isempty(intersect(REdata.goodChannels,ch)) && ~isempty(intersect(LEdata.goodChannels,ch))
    %         plot(LEdata.maxOri(1,ch),REdata.maxOri(ch),'ok')
    %     elseif isempty(intersect(LEdata.goodChannels,ch))
    %         plot(LEdata.maxOri(1,ch),0,'ok')
    %     elseif isempty(intersect(REdata.goodChannels,ch))
    %         plot(0,REdata.maxOri(1,ch),'ok')
    %     end
    %
    %     plot ([0 180], [0 180], ':k')
    %     set(gca,'box', 'off','color', 'none', 'tickdir','out')
    %     xlabel('FE preferred orientation (deg)')
    %     ylabel('AE preferred orientation (deg)')
    %     if strfind(filename,'V4')
    %         title ('V4 preferred orientations AE vs FE')
    %     else
    %         title ('V1 preferred orientations AE vs FE')
    %     end
    % end
    %%
    figure
    set(gca,'box', 'off','color', 'none', 'tickdir','out')
    xlim([0 380])
    ylim([0 380])
    for ch = 1:numChannels
        hold on
        if ~isempty(intersect(REdata.goodChannels,ch))
            plot(REprefOri(1,ch),REoriBan(1,ch),'or')
        end
        if~isempty(intersect(LEdata.goodChannels,ch))
            plot(LEprefOri(1,ch),LEoriBan(1,ch),'ob')
        end
    end
    
    set(gca,'box', 'off','color', 'none', 'tickdir','out')%,'XScale','log',...
    % 'XTick',0:30:180,'YScale','log')
    
    xlabel('Preferred orientation (deg)')
    ylabel('Orientation bandwidth')
    legend('AE','FE')
    
    if strfind(filename,'V4')
        title('Bandwidth as a function of preferred orientation V4 array')
    else
        title('Bandwidth as a function of preferred orientation V1 array')
    end
    
    if strfind(filename,'V1')
        figName = ['WU','_','V1','_','OriCorr'];
        cd /users/bushnell/Desktop/Ori/V1
    else
        figName = ['WU','_','V4','_','OriCorr'];
        cd /users/bushnell/Desktop/Ori/V4
    end
    
    
    
    
