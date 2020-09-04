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
%% XT first run
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
%% XT second run
% file = 'XT_radFreqLowSF_manLocs_V1_Dec2018_cleaned';
% newName = 'XT_radFreqLowSF_manLocs_V1_Dec2018_goodCh';

file = 'XT_radFreqLowSF_manLocs_V1_Dec2018_cleaned';
newName = 'XT_radFreqLowSF_manLocs_V1_Dec2018_goodCh';
%%
location = 0; %0 = laptop 1 = desktop 2 = zemina
saveData = 1;
clean = 1;
dbg = 0;
endBin = 35;
%%
load(file);
textName = figTitleName(file);
fprintf('\n analyzing file: %s\n',textName)
numCh = size(REdata.bins,3);

%% Determine date for figures
chunks = strsplit(textName, ' ');
date = string(chunks(end-1));

radFreq_basicPSTH(LEcleanData, REcleanData)

radFreq_LocationResponses(LEcleanData, endBin, saveData, location, 1) % 1 = LE, 2 = RE
radFreq_LocationResponses(REcleanData, endBin, saveData, location, 2) 
%% define good channels
LEgoodCh = ones(96,1);
REgoodCh = ones(96,1);
REbadCh = [];
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
% REbadCh = [2,10,11,12,14,16,18,20,23,24,27,61];
% LEbadCh = [2,10,11,12,14,16,18,20,23,24,27,61];

% V1 lowSF
% REbadCh = [];
% LEbadCh = [];
%%
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
    
    
    save(newName,'LEdata','REdata','LEcleanData','REcleanData');
    %    save(newName,'REdata','REcleanData');
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