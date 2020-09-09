% radFreq1_PSTH_0715
%
%
clc
clear all
close all
% 
% file = 'WU_RadFreqLoc2_V4_20170707_cleaned_0731';
% newName = 'WU_RadFreqLoc2_V4_20170707_cleaned_goodCh_0731';
file = 'WU_RadFreqLoc2_V4_20170706_sortedBins';
newName = 'WU_RadFreqLoc2_V4_20170706_sortedBins_goodCh';

% files = 'WU_RE_RadialFrequency_V4_3day';
% newName = 'WU_RE_RadialFrequency_V4_3day_goodCh';

location = 0; %0 = laptop 1 = desktop 2 = zemina
saveData = 1;
clean = 1;
dbg = 0;
%%
load(file);
textName = figTitleName(file);
fprintf('\n analyzing file: %s\n',textName)
numCh = size(REdata.bins,3);

%% Determine date for figures
chunks = strsplit(textName, ' ');
date = string(chunks(end-1));
%% PSTHs for cleaned data
figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(LEcleanData.bins((LEcleanData.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(LEcleanData.bins((LEcleanData.radius~=100),1:35,ch)),1)./.010),'b','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',sprintf('LE PSTH clean data %s',date),...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end
end

figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(REcleanData.bins((REcleanData.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(REcleanData.bins((REcleanData.radius~=100),1:35,ch)),1)./.010),'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',sprintf('RE PSTH clean data %s',date),...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end
end
%% PSTH for raw data
figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(LEdata.bins((LEdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(LEdata.bins((LEdata.radius~=100),1:35,ch)),1)./.010),'b','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',sprintf('LE PSTH raw data %s',date),...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end

end

figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,ch)),1)./.010),'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',sprintf('RE PSTH raw data %s',date),...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end

end
%% define good channels
LEgoodCh = ones(96,1);
REgoodCh = ones(96,1);

%bad channels determined manualy for 07/07 clean data
% REbadCh = [2 3 6 8 10 11 14 19 20 23 24 25 26 27 28 30 32 35 36 38 39 40 41 44 45 47 55 60 69 72 73 74 75 76 77 78 79 81 83 86 88 89 90 92 93 94 95 96];
% LEbadCh = [2 14 19 26 27 39 55 76 83 92 94 95 96];

%07/06 data
REbadCh = [2 3 5 7 8 9 10 11 12 13 14 18 19 20 23 24 25 26 27 28 29 30 32 33 36 38 39 40 41 44 45 47 55 60 67 68 64 69 70 71 72 73 74 76 77 78 79 81 83 85 88 89 90 91 92 93 94 95 96];
LEbadCh = [2 5 14 18 19 26 39 44 55 57 59 61 83 88 92 94 95 96];

for badC = 1:length(REbadCh)
    REgoodCh(REbadCh(badC)) = 0;
end

for badC = 1:length(LEbadCh)
    LEgoodCh(LEbadCh(badC)) = 0;
end
       

REdata.goodCh = REgoodCh;
LEdata.goodCh = LEgoodCh;
REcleanData.goodCh = REgoodCh;
LEcleanData.goodCh = LEgoodCh;
%% Save data
if saveData == 1
    if contains(file,'nsp1')
        if location == 2
            cd /home/bushnell/matFiles/V1/RadialFrequency/goodCh
        elseif location == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/goodCh
        end
    else
        if location == 2
            cd  /home/bushnell/matFiles/V4/RadialFrequency/goodCh
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/goodCh
        end
    end
    
    
    save(newName,'LEdata','REdata','LEcleanData','REcleanData');
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