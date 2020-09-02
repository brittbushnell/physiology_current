% gratMwks_fitStats_daily
%
%

clear all
close all
clc
tic
%%
file = 'WU_Gratings_V4_withRF_goodCh_fit';
newName = 'WU_Gratings_V4_withRF_prefStim';

% file = 'WU_Gratings_V1_withRF_goodCh_fit';
% newName = 'WU_Gratings_V1_withRF_prefStim';

location = 2;
%%
%for fi = 1:size(file,1)
    filename = file;%(fi,:);
    load(filename)
    
%     if strfind(filename,'LE')
%         data = LEdata;
%     else
%         data = REdata;
%     end
    numChannels = size(REdata.bins,3);
    %%
    for ch = 1:numChannels
        LEparams(ch,:) = LEdata.surfParams{ch};
        REparams(ch,:) = REdata.surfParams{ch};
    end
    
    LEPrefOris(ch) = LEparams(2);
    REPrefOris(ch) = REparams(2);
    
    LEPrefSFs(ch)  = LEparams(3);
    REPrefSFs(ch)  = REparams(3);
    
%     for ch = 1:numChannels
%         if LEPrefOris(ch) > 180
%             LEPrefOris(ch) = LEPrefOris(ch,1) - 180;
%         end
%     end
    %% Bandwidth - fix
    for ch = 1:numChannels
        LEOriBan(ch) = vonmisesbandwidth_B(LEparams(ch,:));
        REOriBan(ch) = vonmisesbandwidth_B(REparams(ch,:));
    end
%end
%%
sfs = unique(REdata.spatial_frequency);
sfs = (sfs(1,4:end));
logSFs = log10(sfs);

oris = unique(REdata.rotation);
oris = oris(1,1:end-1);

if strfind(filename,'V1')
    array = 'V1';
else
    array = 'V4';
end
%% plot preferred orientations and SFs for each day

% for ch = 1:numChannels 
%     figure
%     subplot(1,2,1)
%     hold on
%     if eye == 'LE'
%     plot(oriDiff(ch,:),'.b','MarkerSize',20)
%     else
%      plot(oriDiff(ch,:),'.r','MarkerSize',20)
%     end
%     xlabel('day')
%     ylabel('Ratio (AE/FE)')
%     title(sprintf('Daily SF pref %s ch %s',array, ch))
%     
%     subplot(1,2,2)
%     hold on
%     if eye == 'LE'
%     semilogy(sfDiff,'.b','MarkerSize',20)
%     else
%             semilogy(sfDiff,'.r','MarkerSize',20)
%     end
%     xlabel('day')
%     ylabel('Log ration (AE/FE)')
%     title('Daily SF pref')
%     
%     if strfind(file,'V1')
%         if location == 0
%             cd ~/Dropbox/Figures/WU_Arrays/Gratings/V1
%         elseif location == 1
%             cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V1
%         elseif location == 2
%             cd ~/Figures/V1/Gratings/DailySurfFits/
%         end
%     else
%         if location == 0
%             cd ~/Dropbox/Figures/WU_Arrays/Gratings/V4
%         elseif location == 1
%             cd /users/bushnell/bushnell-local/Dropbox/Figures/WU_Arrays/Gratings/V4
%         elseif location == 2
%             cd ~/Figures/V4/Gratings/DailySurfFits/
%         end
%     end
%     figName = ['WU','_',array,'_',eye,'_',program,'_',num2str(LErank),'_','dailyPrefComp'];
%     saveas(gcf,figName,'pdf')
%     
% end
%%
figure
subplot(1,2,1)
plot(LEPrefOris,REPrefOris,'o')
title('Preferred Ori')
xlabel('AE Pref Ori')
ylabel('FE Pref Ori')

subplot(1,2,2)
plot(LEPrefSFs,REPrefSFs,'o')
set(gca,'XScale','log','YScale','log')
title('Preferred SF')
xlabel('AE Pref SF')
ylabel('FE Pref SF')

