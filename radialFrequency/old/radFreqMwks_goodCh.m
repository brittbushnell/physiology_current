%%
% NOTE: FIX GOOD CH FOR V1

clc
clear all
close all

files = ['WU_LE_RadFreqLoc2_nsp2_20170707_find3'; 'WU_RE_RadFreqLoc2_nsp2_20170707_find3'];
%newName = 'WU_V4_RadFreq_0707_find2';

% files = ['WU_LE_RadFreqLoc2_nsp1_20170707_find2'; 'WU_RE_RadFreqLoc2_nsp1_20170707_find2'];
% newName = 'WU_V1_RadFreq_0707_find2';

location = 1;
%%
% % 'WU_LE_RadFreqLoc2_nsp1_20170706_means1';
% % 'WU_LE_RadFreqLoc2_nsp1_20170705_means2';

% % 'WU_RE_RadFreqLoc2_nsp1_20170706_means1_sub';
% % 'WU_RE_RadFreqLoc2_nsp1_20170705_means1_sub';

%file = ('WU_LE_RadFreqLoc2_nsp2_20170707_means1');

%  'WU_LE_RadFreqLoc2_nsp2_20170706_means1_sub';
% 'WU_LE_RadFreqLoc2_nsp2_20170705_means2_sub';

%file = ('WU_RE_RadFreqLoc2_nsp2_20170707_means1');

%  'WU_RE_RadFreqLoc2_nsp2_20170706_means1_sub';
%  'WU_RE_RadFreqLoc2_nsp2_20170705_means1_sub';
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
    if strfind(filename,'LE')
        LEdata = data;
    else
        REdata = data;
    end
end
%% Check file, get array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    % Zemina
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(files(1,:),'V4')) || ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'V1')) || ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
%%
if strfind(filename,'nsp1')
    REGoodCh = [0 0 0 1 1 1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 1 0 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 0 0 1 1 1 0 1 1 1 1 0 1 1 0 0 1 0 0 0 0 1 1 0 0 1 1 0];
    LEGoodCh = [0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 1 1 0 1 1 1 0 0 0 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 1 1 0 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 0 0 0 1 1 0 0 0 1 0];
    array = 'V1';
else
    LEGoodCh = [1 0 0 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 0 0];
    REGoodCh = [1 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0];
    array = 'V4';
end

REdata.goodCh = REGoodCh;
LEdata.goodCh = LEGoodCh;

%save(newName,'LEdata','REdata');


location = 1;
%%
if strfind(filename,'V1')
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V1/Prefs
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/RF/V1/Prefs
    elseif location == 2
        cd ~/Figures/V1/RadFreq/Prefs
    end
else
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V4/Prefs
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/RF/V4/Prefs
    elseif location == 2
        cd ~/Figures/V4/RadFreq/Prefs
    end
end
%% PSTHs
figure;
for index = 1:96
    subplot(aMap,10,10,index);
    hold on;
    if REGoodCh(index) == 1
        plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,index)),1)./.010),'k','LineWidth',2);
        plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,index)),1)./.010),'r','LineWidth',2);
        %         plot((mean(squeeze(REdata.bins((REdata.radius == 2 & REdata.rf==32 & REdata.spatialFrequency==2),1:35,index)),1)./.010),'k-');
        %         plot((mean(squeeze(REdata.bins((REdata.radius==2 & REdata.rf==8 & REdata.spatialFrequency==2 & (REdata.amplitude==6.25 | REdata.amplitude == 12.5)),1:35,index)),1)./.010),'r','linewidth',2);
    else
        plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,index)),1)./.010),'-','Color',[0.6 0.6 0.6]);
        plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,index)),1)./.010),'m','LineWidth',2);
        %         plot((mean(squeeze(REdata.bins((REdata.radius == 2 & REdata.rf==32 & REdata.spatialFrequency==2),1:35,index)),1)./.010),'-','Color',[0.6 0.6 0.6]);
        %         plot((mean(squeeze(REdata.bins((REdata.radius==2 & REdata.rf==8 & REdata.spatialFrequency==2 & (REdata.amplitude==6.25 | REdata.amplitude == 12.5)),1:35,index)),1)./.010),'m-','linewidth',2);
    end
    
    title(index)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    
    if index == 1
        topTitle = sprintf('%s AE PSTH',array);
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
% figName = ['WU_RE_',array,'_psth_RF_0707_goodCh'];
% saveas(gcf,figName,'pdf')


figure
for ch = 1:96
    subplot(aMap,10,10,ch)
    hold on
    if LEGoodCh(ch) == 1
        plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
        plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'b','LineWidth',2);
        %         plot((mean(squeeze(LEdata.bins((LEdata.pos_y' == -1.5 & LEdata.radius == 2 & LEdata.rf==32 & LEdata.spatialFrequency==2),1:35,ch)),1)./.010),'k-');
        %         plot((mean(squeeze(LEdata.bins((LEdata.pos_y' == -1.5 &LEdata.radius==2 & LEdata.rf==8 & LEdata.spatialFrequency==2 & (LEdata.amplitude==6.25 | LEdata.amplitude == 12.5)),1:35,ch)),1)./.010),'b','linewidth',[2]);
    else
        plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'-','Color',[0.6 0.6 0.6],'LineWidth',2);
        plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'c','LineWidth',2);
        %         plot((mean(squeeze(LEdata.bins((LEdata.pos_y' == -1.5 &LEdata.radius==2 & LEdata.rf==32 & LEdata.spatialFrequency==2),1:35,ch)),1)./.010),'-','Color',[0.6 0.6 0.6]);
        %         plot((mean(squeeze(LEdata.bins((LEdata.pos_y' == -1.5 &LEdata.radius==2 & LEdata.rf==8 & LEdata.spatialFrequency==2 & (LEdata.amplitude==6.25 | LEdata.amplitude == 12.5)),1:35,ch)),1)./.010),'-c','linewidth',2);
    end
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    
    if ch == 1
        topTitle = sprintf('%s FE PSTH',array);
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end

figure
for ch = 1:96
    subplot(aMap,10,10,ch)
    hold on
    if LEGoodCh(ch) == 1
        plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'k--','LineWidth',2);
        plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'--','Color',[0.5 0 1],'LineWidth',2);
    else
        plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'--','Color',[0.6 0.6 0.6],'LineWidth',2);
        plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'--','Color',[0.3 0 0.6],'LineWidth',2);
    end
    
    if REGoodCh(ch) == 1
        plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
        plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,ch)),1)./.010),'-','Color',[0.5 0 1],'LineWidth',2);
    else
        plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,ch)),1)./.010),'-','Color',[0.6 0.6 0.6],'LineWidth',2);
        plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,ch)),1)./.010),'-','Color',[0.3 0 0.6],'LineWidth',2);
    end
    
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    
    if ch == 1
        topTitle = sprintf('%s FE PSTH',array);
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',14,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end


%%
figName = ['WU_LE_',array,'_psth_RF_0707_goodCh'];
saveas(gcf,figName,'pdf')
%%
figure
for ch = 1:96
    hold on
    if (LEGoodCh(ch) + REGoodCh(ch)) == 2
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'o','Color',[0.5 0 0.5],'LineWidth',1.5)
    elseif (LEGoodCh(ch) + REGoodCh(ch)) == 0
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'xk','LineWidth',1.5)
    elseif LEGoodCh(ch) == 1
        plot(LEdata.stimResps{ch}(1,1),0,'ob','LineWidth',1.5)
    else
        plot(0,REdata.stimResps{ch}(1,1),'or','LineWidth',1.5)
    end
    plot([0 300], [0 300],':k')
    ylim([0 300])
    xlim([0 300])
    set(gca,'TickDir','out','box','off','Color','none')
    xlabel('FE baseline response')
    ylabel('AE baseline response')
    title(sprintf('%s baseline comparisons',array))
    
end
%%
figName = ['WU_',array,'_baseComps_goodCh'];
saveas(gcf,figName,'pdf')
%%
REevokedRespGoodBS = zeros(1,96);
LEevokedRespGoodBS = zeros(1,96);

for ch = 1:96
    if REGoodCh(ch) == 1
        REevokedRespGoodBS(1,ch) = mean(REdata.stimResps{ch}(3,2:end));
    end
    if LEGoodCh(ch) == 1
        LEevokedRespGoodBS(1,ch) = mean(LEdata.stimResps{ch}(3,2:end));
    end
end

figure
hold on
for ch = 1:96
    if (LEGoodCh(ch) + REGoodCh(ch)) == 2
        plot(LEevokedRespGoodBS(ch),REevokedRespGoodBS(ch),'o','Color',[0.5 0 0.5])
    elseif LEGoodCh(ch) == 1
        plot(LEevokedRespGoodBS(ch),REevokedRespGoodBS(ch),'ob')
    elseif REGoodCh(ch) == 1
        plot(LEevokedRespGoodBS(ch),REevokedRespGoodBS(ch),'or')
    end
end
plot([-10 15], [-10 15],'k')
set(gca,'TickDir','out','box','off','Color','none')
xlabel('FE evoked response')
ylabel('AE evoked response')
title(sprintf('%s evoked response comparisons baseline subtracted',array))

figName = ['WU_',array,'_evokedRespsBS_goodCh'];
saveas(gcf,figName,'pdf')
%%
REevokedRespGood = zeros(1,96);
LEevokedRespGood = zeros(1,96);

for ch = 1:96
    if REGoodCh(ch) == 1
        REevokedRespGood(1,ch) = mean(REdata.stimResps{ch}(1,2:end));
    end
    if LEGoodCh(ch) == 1
        LEevokedRespGood(1,ch) = mean(LEdata.stimResps{ch}(1,2:end));
    end
end

figure
hold on
for ch = 1:96
    if (LEGoodCh(ch) + REGoodCh(ch)) == 2
        plot(LEevokedRespGood(ch),REevokedRespGood(ch),'o','Color',[0.5 0 0.5])
    elseif LEGoodCh(ch) == 1
        plot(LEevokedRespGood(ch),REevokedRespGood(ch),'ob')
    elseif REGoodCh(ch) == 1
        plot(LEevokedRespGood(ch),REevokedRespGood(ch),'or')
    end
end
plot([0 300], [0 300],'k')
set(gca,'TickDir','out','box','off','Color','none')
xlabel('FE evoked response')
ylabel('AE evoked response')
title(sprintf('%s evoked response comparisons',array))

figName = ['WU_',array,'_evokedResps_goodCh'];
saveas(gcf,figName,'pdf')




