% radFreq1_PSTH_0715
%
%
clc
clear all
close all
%% WU
% file = 'WU_RadFreqLoc2_V4_20170707_cleaned';
% newName = 'WU_RadFreqLoc2_V4_20170707_cleaned_goodCh';

% files = 'WU_RE_RadialFrequency_V4_3day';
% newName = 'WU_RE_RadialFrequency_V4_3day_goodCh';
%% XT run1
% V1
% file = 'XT_radFreqLowSF_loc1_V1_Oct2018_cleaned';
% newName = 'XT_radFreqLowSF_loc1_V1_Oct2018_goodCh';

% file = 'XT_radFreqHighSF_loc1_V1_Nov2018_cleaned';
% newName = 'XT_radFreqHighSF_loc1_V1_Nov2018_goodCh';

% V4
%  file = 'XT_radFreqLowSF_loc1_V4_Oct2018_cleaned';
%  newName = 'XT_radFreqLowSF_loc1_V4_Oct2018_goodCh';
 
%  file = 'XT_radFreqHighSF_loc1_V4_Nov2018_cleaned';
%  newName = 'XT_radFreqHighSF_loc1_V4_Nov2018_goodCh';
%% XT manual locations
% V1
% file = 'XT_radFreqHighSF_V1_ManualLocs_cleaned';
% newName = 'XT_radFreqHighSF_V1_ManualLocs_goodCh';
% 
% file = 'XT_radFreqLowSF_V1_ManualLocs_cleaned';
% newName = 'XT_radFreqLowSF_V1_ManualLocs_goodCh';

%V4
% file = 'XT_radFreqHighSF_V4_ManualLocs_cleaned';
% newName = 'XT_radFreqHighSF_V4_ManualLocs_goodCh';

% file = 'XT_radFreqLowSF_V4_ManualLocs_cleaned';
% newName = 'XT_radFreqLowSF_V4_ManualLocs_goodCh';
%% WV
file = 'WV_RadFreqHighSF_V4_cleaned';
newName = 'WV_RadFreqHighSF_V4_March2019_goodCh';
%%
location = 0; %0 = laptop 1 = desktop 2 = zemina
saveData = 1;
clean = 1;
endBin = 35;
dbg = 0;
%%
load(file);
textName = figTitleName(file);
fprintf('\n analyzing file: %s\n',textName)
numCh = 96;

%% Determine date for figures
chunks = strsplit(textName, ' ');
date = string(chunks(end-1));

radFreq_basicPSTH(LEcleanData)
radFreq_LocationResponses(LEcleanData, endBin, saveData, location)

% radFreq_basicPSTH(REcleanData)
% radFreq_LocationResponses(REcleanData, endBin, saveData, location) 
%% PSTHs for cleaned data
% figure;
% for ch = 1:96
%     subplot(10,10,ch);
%     hold on;
%     plot((mean(squeeze(LEcleanData.bins((LEcleanData.radius==100) ,1:35,ch)),1)./.010),'k','LineWidth',2);
%     if strfind(file,'nsp1')
%         plot((mean(squeeze(LEcleanData.bins(((LEcleanData.radius~=100) & (LEcleanData.pos_x == min(unique(LEdata.pos_x)))),1:35,ch)),1)./.010),'c','LineWidth',2);
%     else
%         plot((mean(squeeze(LEcleanData.bins((LEcleanData.radius~=100),1:35,ch)),1)./.010),'c','LineWidth',2);
%     end
%     
%     title(ch)
%     set(gca,'Color','none','XColor','none')
%     ylim([0 inf])
%     if ch == 1
%     annotation('textbox',...
%         [0.37 0.94 0.4 0.038],...
%         'String',sprintf('LE PSTH clean data %s',date),...
%         'FontWeight','bold',...
%         'FontSize',16,...
%         'FontAngle','italic',...
%         'EdgeColor','none');
%     end
% end
% 
% figure;
% for ch = 1:96
%     subplot(10,10,ch);
%     hold on;
%     plot((mean(squeeze(REcleanData.bins((REcleanData.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
%     if strfind(file,'nsp1')
%         plot((mean(squeeze(REcleanData.bins(((REcleanData.radius~=100) & (REcleanData.pos_x == min(unique(LEdata.pos_x)))),1:35,ch)),1)./.010),'r','LineWidth',2);
%     else
%         plot((mean(squeeze(REcleanData.bins((REcleanData.radius~=100),1:35,ch)),1)./.010),'r','LineWidth',2);
%     end    
%     title(ch)
%     set(gca,'Color','none','XColor','none')
%     ylim([0 inf])
%     if ch == 1
%     annotation('textbox',...
%         [0.37 0.94 0.4 0.038],...
%         'String',sprintf('RE PSTH clean data %s',date),...
%         'FontWeight','bold',...
%         'FontSize',16,...
%         'FontAngle','italic',...
%         'EdgeColor','none');
%     end
% end
% %% PSTH for raw data
% figure;
% for ch = 1:96
%     subplot(10,10,ch);
%     hold on;
%     plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
%     plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'c','LineWidth',2);
%     
%     title(ch)
%     set(gca,'Color','none','XColor','none')
%     ylim([0 inf])
%     if ch == 1
%     annotation('textbox',...
%         [0.37 0.94 0.4 0.038],...
%         'String',sprintf('LE PSTH raw data %s',date),...
%         'FontWeight','bold',...
%         'FontSize',16,...
%         'FontAngle','italic',...
%         'EdgeColor','none');
%     end
% 
% end
% 
% figure;
% for ch = 1:96
%     subplot(10,10,ch);
%     hold on;
%     plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
%     plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,ch)),1)./.010),'r','LineWidth',2);
%     
%     title(ch)
%     set(gca,'Color','none','XColor','none')
%     ylim([0 inf])
%     if ch == 1
%     annotation('textbox',...
%         [0.37 0.94 0.4 0.038],...
%         'String',sprintf('RE PSTH raw data %s',date),...
%         'FontWeight','bold',...
%         'FontSize',16,...
%         'FontAngle','italic',...
%         'EdgeColor','none');
%     end
% 
% end
%% define good channels
LEgoodCh = ones(96,1);
% REgoodCh = ones(96,1);
% REbadCh = [];
LEbadCh = [];
%% WU
%bad channels determined manualy for 07/07 clean data V4
 %REbadCh = [2 3 6 8 10 11 14 19 20 23 24 25 26 27 28 30 32 35 36 38 39 40 41 44 45 47 55 60 69 72 73 74 75 76 77 78 79 81 83 86 88 89 90 92 93 94 95 96];
 %LEbadCh = [2 14 19 26 27 39 55 76 83 92 94 95 96];

%07/06 data V4
% REbadCh = [2 3 5 7 8 9 10 11 12 13 14 18 19 20 23 24 25 26 27 28 29 30 32 33 36 38 39 40 41 44 45 47 55 60 67 68 64 69 70 71 72 73 74 76 77 78 79 81 83 85 88 89 90 91 92 93 94 95 96];
% LEbadCh = [2 5 14 18 19 26 39 44 55 57 59 61 83 88 92 94 95 96];
%% XT
% V4 lowSF
% REbadCh = [10, 14, 18, 22];
% LEbadCh = [];

% V4 highSF
% REbadCh = [10 14 18 33 77];
% LEbadCh = [10 14 18 22];

% V1 lowSF
%REbadCh = [];
%LEbadCh = [];

% V1 highSF
%REbadCh = [1 2 3 4 6 8 10 11 14 33 34 35 39 61 65 68 69 70 71 72 73 74 75 76 80 94];
%LEbadCh = [];
%%
% for badC = 1:length(REbadCh)
%     REgoodCh(REbadCh(badC)) = 0;
% end

for badC = 1:length(LEbadCh)
    LEgoodCh(LEbadCh(badC)) = 0;
end
       

%REdata.goodCh = REgoodCh;
LEdata.goodCh = LEgoodCh;
%REcleanData.goodCh = REgoodCh;
LEcleanData.goodCh = LEgoodCh;
%% Save data
if saveData == 1
    if contains(file,'V1')
        if location == 2
            cd /home/bushnell/matFiles/XT/V1/radFreqLowSF/goodCh
        elseif location == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        end
    else
        if location == 2
            cd  /home/bushnell/matFiles/XT/V4/radFreqLowSF/goodCh
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        end
    end
    
    
%     save(newName,'LEdata','REdata','LEcleanData','REcleanData');
%    save(newName,'REdata','REcleanData');
    save(newName,'LEdata','LEcleanData');
    fprintf('File saved as: %s\n',newName)
else
    fprintf('FILE NOT SAVED!!\n')
end
%% 
if dbg == 1
    for ch = 1:numCh
        if REcleanData.goodCh(ch) == 1
            maxX = max(REcleanData.stimResps{ch}(end-3,:));
            maxY = max(REcleanData.stimResps{ch}(end-2,:));
            
            figure
            hold on
            plot(REcleanData.stimResps{ch}(end-3,:),REcleanData.stimResps{ch}(end-2,:),'ko')
            plot([0 maxX], [0 maxY],'--')
            set(gca,'color','none','tickdir','out','box','off')
            xlabel('median response')
            ylabel('mean response')
            title(sprintf('ch %d',ch))
            xlim([0 maxX])
            ylim([0 maxY])
        end
    end
end