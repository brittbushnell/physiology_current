% function [] = plotMwksOriData360(filename)
% plotMwksOriData
% This function takes in the fitted .mat files from gratMwksCh and plots
% the orientation data.
%
% Written Nov 5, 2017 Brittany Bushnell
clc
close all
clear all
location = 0;
%%
%filename = 'fitData_WU_Gratings_V4_withRF';
%filename = 'fitData_WU_Gratings_V1_withRF';

%filename = 'fitData_WU_GratingsCon_V4_Aug2017';
%filename = 'fitData_WU_GratingsCon_V1_Aug2017';
filename = 'fitData_WU_Gratings_V4_recuts';
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
 %% Plot orientation curves 0:360
% figure
% for ch = 1:numChannels
%     REmaxResp = max(REdata.oriResps360{ch}(2,:))+5;
%     LEmaxResp = max(LEdata.oriResps360{ch}(2,:))+5;
%     maxResp = max(REmaxResp, LEmaxResp);
%
%     subplot(aMap,10,10,ch)
%     hold on
%     plot(REdata.oriResps360{ch}(1,:), REdata.oriResps360{ch}(2,:),'r.-','MarkerSize',8)
%     plot(REdata.prefOri360(1,ch), (REmaxResp),'rv')
%     plot(REdata.maxOri360(1,ch), (REmaxResp),'rs')
%     plot([0 360], [REdata.spatialFrequencyResp{ch}(3,1) REdata.spatialFrequencyResp{ch}(3,1)],'r--')
%
%
%     plot(LEdata.oriResps360{ch}(1,:), LEdata.oriResps360{ch}(2,:),'b.-','MarkerSize',8)
%     plot(LEdata.prefOri360(1,ch), (maxResp),'bv')
%     plot(LEdata.maxOri360(1,ch), (maxResp),'bs')
%     plot([0 360], [LEdata.spatialFrequencyResp{ch}(3,1) LEdata.spatialFrequencyResp{ch}(3,1)],'b--')
%
%
%     %     LENdx = ['LE OI: ', num2str(LEdata.oriNdx(2,ch))];
%     %     text(0,max(REmaxResp, LEmaxResp)+5,LENdx)
%
%     %     RENdx = ['RE OI: ', num2str(REdata.oriNdx(2,ch))];
%     %     text(180,max(REmaxResp, LEmaxResp),RENdx)
%
%     set(gca,'box', 'off','color', 'none', 'tickdir','out')
%     title(ch)
%     xlim([0 360])
%
%     if ch == 1
%         topTitle = 'Orientation tuning, V4 array';
%         annotation('textbox',...
%             [0.4 0.94 0.35 0.05],...
%             'LineStyle','none',...
%             'String',topTitle,...
%             'Interpreter','none',...
%             'FontSize',16,...
%             'FontAngle','italic',...
%             'FontName','Helvetica Neue');
%         subplot(10,10,1)
%         xlabel('ori')
%         ylabel('sp/s')
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
%         text(2,13,'square = peak FR','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%         text(2,5,'triangle = pref Ori','FontSize',12,'FontWeight','bold','FontAngle','italic','FontName','Helvetica Neue')
%     end
% end
% %% Plot orientation curves 0:360 baseline subtracted
% figure
% for ch = 1:numChannels
%     REmaxResp = max(REdata.oriTuneResp{ch}(3,:))+5;
%     LEmaxResp = max(LEdata.oriTuneResp{ch}(3,:))+5;
%     maxResp = max(REmaxResp, LEmaxResp);
%
%     subplot(aMap,10,10,ch)
%     hold on
%     plot(REdata.oriResps360{ch}(1,:), REdata.oriResps360{ch}(3,:),'r.-','MarkerSize',8)
%     plot(REdata.prefOri(1,ch), (REmaxResp),'rv')
%     plot(REdata.maxOri(1,ch), (REmaxResp),'rs')
%
%     plot(LEdata.oriResps360{ch}(1,:), LEdata.oriResps360{ch}(3,:),'b.-','MarkerSize',8)
%     plot(LEdata.prefOri(1,ch), (maxResp),'bv')
%     plot(LEdata.maxOri(1,ch), (maxResp),'bs')
%
%     set(gca,'box', 'off','color', 'none', 'tickdir','out')
%     title(ch)
%     xlim([0 360])
%
%     if ch == 1
%         if strfind(filename,'V4')
%             topTitle = 'Orientation tuning 0:360, V4 array';
%             subplot(10,10,1)
%         elseif strfind(filename,'V1')
%             topTitle = 'SF tuning, V1 array';
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
%% Plot vonmises fits from Tom's fitting program and 360 deg data
% figure
% for ch = 1:numChannels
%
%     x = REdata.oriResps360{ch}(1,:).*2;
%     yR = REdata.oriResps360{ch}(2,:);
%     REb360 = vonmisesfit(x,yR,'silent',true);
%     rFoo360(1,ch) = REb360(3);
%
%     xxR = 0:30:360;
%     yyR =  REb360(1) + REb360(2) .* exp(REb360(4)*cosd(xxR-REb360(3))) / (2*pi*besseli(0,REb360(4)));
%
%    % xL = LEdata.oriResps360{ch}(1,:);
%     yL = LEdata.oriResps360{ch}(2,:);
%     LEb360 = vonmisesfit(x,yL,'silent',true);
%     lFoo360(1,ch) = LEb360(3);
%
%     xxL = 0:30:360;
%     yyL =  LEb360(1) + LEb360(2) .* exp(LEb360(4)*cosd(xxL-LEb360(3))) / (2*pi*besseli(0,LEb360(4)));
%     maxResp = max((REb360(2)+REb360(1)), (LEb360(2)+LEb360(1)));
%     maxResp = maxResp+10;
%
%
%     subplot(aMap,10,10,ch)
%     hold on
%     plot(x,yR,'ro');
%     plot(xxR,yyR,'r-','LineWidth',2);
%     %plot([REb360(3) REb360(3)], [0 maxResp+20],'r:','LineWidth',1.5)
%
%     plot(x,yL,'bo');
%     plot(xxL,yyL,'b-','LineWidth',2);
%     %plot([LEb360(3) LEb360(3)], [0 (maxResp+20)],'b:','LineWidth',1.5)
%
%     set(gca,'box', 'off','color', 'none', 'tickdir','out')
%     %xlim([0 180])
%     title(ch)
%
%     if ch == 1
%         if strfind(filename,'V4')
%             topTitle = 'Orientation tuning for best SF V4 array';
%             subplot(10,10,1)
%         elseif strfind(filename,'V1')
%             topTitle = 'Orientation tuning for best SF V1 array';
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