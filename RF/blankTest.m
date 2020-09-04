%%

clc
clear all
close all

% files = ['WU_LE_RadFreqLoc2_nsp1_20170707_means1'; 'WU_RE_RadFreqLoc2_nsp1_20170707_means1'];
% newName = 'WU_V1_RadFreq_0707_goodCh';

 files = ['WU_LE_RadFreqLoc2_nsp2_20170707_means1'; 'WU_RE_RadFreqLoc2_nsp2_20170707_means1'];
 newName = 'WU_V4_RadFreq_0707_goodCh';
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
%%
if strfind(filename,'nsp1')
    REGoodCh = [0 0 0 1 1 1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 1 0 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 0 0 1 1 1 0 1 1 1 1 0 1 1 0 0 1 0 0 0 0 1 1 0 0 1 1 0];
    LEGoodCh = [0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 1 1 0 1 1 1 0 0 0 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 1 1 0 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 0 0 0 1 1 0 0 0 1 0];
    array = 'V1';
    
    cd /home/bushnell/matFiles/V1/RadialFrequency/FittedMats
else
    LEGoodCh = [1 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 0 1];
    REGoodCh = [1 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0];
    array = 'V4';
    
    cd /home/bushnell/matFiles/V4/RadialFrequency/FittedMats
end

REdata.goodCh = REGoodCh;
LEdata.goodCh = LEGoodCh;

save(newName,'LEdata','REdata');


location = 2;
%%
if strfind(filename,'V1')
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V1/Prefs
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/V1/RF/Prefs
    elseif location == 2
        cd ~/Figures/V1/RadFreq/Prefs
    end
else
    if location == 0
        cd ~/Dropbox/Figures/WU_Arrays/RF/V4/Prefs
    elseif location == 1
        cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/V4/RF/Prefs
    elseif location == 2
        cd ~/Figures/V4/RadFreq/Prefs
    end
end
%%
figure;
for index = 1:96
    subplot(10,10,index);
    hold on;
    if REGoodCh(index) == 1
        plot(mean(squeeze(REdata.bins(find(REdata.radius==100),1:35,index)),1),'k');
        plot(mean(squeeze(REdata.bins(find(REdata.radius~=100),1:35,index)),1),'r');
    else
        plot(mean(squeeze(REdata.bins(find(REdata.radius==100),1:35,index)),1),'-','Color',[0.6 0.6 0.6]);
        plot(mean(squeeze(REdata.bins(find(REdata.radius~=100),1:35,index)),1),'m-');
    end
    
    title(index)
    axis off;
end
figName = ['WU_RE_',array,'_psth_RF_0707_goodCh'];
saveas(gcf,figName,'pdf')

figure
for ch = 1:96
    subplot(10,10,ch)
    hold on
    if LEGoodCh(ch) == 1
        plot(mean(squeeze(LEdata.bins(find(LEdata.radius==100),1:35,ch)),1),'k');
        plot(mean(squeeze(LEdata.bins(find(LEdata.radius~=100),1:35,ch)),1),'b');
    else
        plot(mean(squeeze(LEdata.bins(find(LEdata.radius==100),1:35,ch)),1),'-','Color',[0.6 0.6 0.6]);
        plot(mean(squeeze(LEdata.bins(find(LEdata.radius~=100),1:35,ch)),1),'-c');
    end
    title(ch)
    axis off;
end
figName = ['WU_LE_',array,'_psth_RF_0707_goodCh'];
saveas(gcf,figName,'pdf')
%%
figure
for ch = 1:96
    hold on
    if (LEGoodCh(ch) + REGoodCh(ch)) == 2
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'.','Color',[0.5 0 0.5],'MarkerSize',10)
    elseif (LEGoodCh(ch) + REGoodCh(ch)) == 0
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'xk','LineWidth',2)
    elseif LEGoodCh(ch) == 1
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'.b','MarkerSize',10)
    else
        plot(LEdata.stimResps{ch}(1,1),REdata.stimResps{ch}(1,1),'.r','MarkerSize',10)
    end
    plot([0 450], [0 450])
    set(gca,'TickDir','out','box','off')
    xlabel('FE baseline response')
    ylabel('AE baseline response')
    title(sprintf('%s baseline comparisons',array))
    
end

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
set(gca,'TickDir','out','box','off')
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
set(gca,'TickDir','out','box','off')
xlabel('FE evoked response')
ylabel('AE evoked response')
title(sprintf('%s evoked response comparisons',array))

figName = ['WU_',array,'_evokedResps_goodCh'];
saveas(gcf,figName,'pdf')




