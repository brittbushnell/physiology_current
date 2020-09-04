% radFreq2_autoGoodCh
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
%% PSTHs
if doPSTH == 1
    radFreq_basicPSTH(LEcleanData)
    radFreq_LocationResponses(LEcleanData, endBin, saveData, location)
end
%% Define good chs
[LEgoodCh] = getGoodCh_radFreq(LEdata.bins,LEdata.rf,numBoot,startMean,endMean);
[LEgoodChClean] = getGoodCh_radFreq(LEcleanData.bins,LEcleanData.rf,numBoot,startMean,endMean);
[REgoodCh] = getGoodCh_radFreq(REdata.bins,REdata.rf,numBoot,startMean,endMean);
[REgoodChClean] = getGoodCh_radFreq(REcleanData.bins,REcleanData.rf,numBoot,startMean,endMean);


LEdata.goodCh = LEgoodCh;
REdata.goodCh = REgoodCh;
REcleanData.goodCh = REgoodChClean;
LEcleanData.goodCh = LEgoodChClean;
%%
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