% radFreq1_cleanData
%
% Step 2 of the radial frequency analysis pipeline, this program takes the
% responses of either a single day or a combination of days and creates and
% adds the stimResp and blankResp matrices to the data structure. It also
% combines LE and RE data into one .mat file
%
% June 1, 2018 Brittany Bushnell
%%
%
clear all
close all
clc
tic
%% WU
% files = ['WU_RE_RadialFrequency_V4_3day_goodCh'; 'WU_LE_RadialFrequency_V4_3day_goodCh'];
% newName = 'WU_RadialFrequency_V4_3day_byStim';

% files = ['WU_LE_RadFreqLoc2_nsp2_20170706_004';'WU_RE_RadFreqLoc2_nsp2_20170706_002'];
% newName = 'WU_RadFreqLoc2_V4_20170706_sortedBins';

% files = ['WU_LE_RadFreqLoc2_nsp2_20170707_002';'WU_RE_RadFreqLoc2_nsp2_20170707_005'];
% newName = 'WU_RadFreqLoc2_V4_20170707_cleaned_0731';
%% XT
% Low SF
% files = ['XT_RE_radFreqLowSF_loc1_nsp1_Oct2018';'XT_LE_radFreqLowSF_loc1_nsp1_Oct2018'];
% newName = 'XT_radFreqLowSF_loc1_V1_Oct2018_cleaned';
%
files = ['XT_RE_radFreqLowSF_loc1_nsp2_Oct2018';'XT_LE_radFreqLowSF_loc1_nsp2_Oct2018'];
newName = 'XT_radFreqLowSF_loc1_V4_Oct2018_cleaned';

% high SF
% files = ['XT_RE_radFreqHighSF_loc1_nsp1_Oct2018'; 'XT_LE_radFreqHighSF_loc1_nsp1_Oct2018'];
% newName = 'XT_radFreqHighSF_loc1_V1_Nov2018_cleaned';

% files = ['XT_RE_radFreqHighSF_loc1_nsp2_Oct2018'; 'XT_LE_radFreqHighSF_loc1_nsp2_Oct2018'];
% newName = 'XT_radFreqHighSF_loc1_V4_Nov2018_cleaned';

% all SF
% files = ['XT_LE_radFreqAll_loc1_nsp2_Oct2018';'XT_RE_radFreqAll_loc1_nsp2_Oct2018'];
% newName = 'XT_radFreqAll_loc1_V4_Oct2018_cleaned';

location = 1; %0 = laptop 1 = desktop 2 = zemina
startBin = 5;
endBin = 35;
dbg = 1; % if testing and debugging, will do last chunk and make more figures
date = 'Oct2018';
%% Get array map
aMap = getBlackrockArrayMap(files(1,:));
data.amap = aMap;
%% load data and extract info
for fi = 1%:size(files,1)
    data = load(files(fi,:));
    size(data.bins)
    textName = figTitleName(files(fi,:));
    fprintf('\n analyzing file: %s\n',textName)
    
    % Find unique x and y locations used
    xloc  = unique(data.pos_x);
    yloc  = unique(data.pos_y);
    
    for y = 1:length(yloc)
        for x = 1:length(xloc)
            posX(x,y) = xloc(x);
            posY(x,y) = yloc(y);
        end
    end
    
    % all of the other unique parameters are stored in the file name and need
    % to be parsed out.
    for i = 1:length(data.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
        
        data.rf(i,1)  = rf 
        data.amplitude(i,1) = mod;
        data.orientation(i,1) = ori;
        data.spatialFrequency(i,1) = sf;
        data.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
        name  = char(name);
        data.name(i,:) = name;
    end
    numCh = size(data.bins,3);
    
    % Make all of the vectors the same dimensions
    data.pos_x = data.pos_x';
    data.pos_y = data.pos_y';
    % data.t_stim = data.t_stim';
    
    %% Create a clean version of data structures  and determine outliers.
%     cleanXpos = double(data.pos_x);
%     cleanYpos = double(data.pos_y);
%     % cleanTstim = double(data.t_stim);
%     cleanRF = double(data.rf);
%     cleanAmp = double(data.amplitude);
%     cleanOri = double(data.orientation);
%     cleanSF = double(data.spatialFrequency);
%     cleanRad = double(data.radius);
%     cleanFile = data.filename;
%     cleanBins = double(data.bins); % note, if you don't make it a double, cannot set things to nan.
    %% determine outliers
      cleanData = getCleanData_RF(data,startBin,endBin);
      % double check
%     cleanData = getCleanData_RF(cleanData,startBin,endBin);
%%
%     meanBins1 = mean(data.bins(:,startBin:endBin,:),2)./0.01;
%     useBins = squeeze(meanBins1);
%     maxBad = round(size(useBins,1)/25);
%     badBins = isoutlier(useBins,'gesd','ThresholdFactor',1,'MaxNumOutliers',maxBad);
%     badTrials = sum(badBins,2);
%     %% Create cleaned verison of data structures
%     %ndx = 1;
%     
%     for trl = 1:size(badBins,1) %(cleanData.badTrials,1)
%         if badTrials(trl,1) > 1 %(cleanData.badTrials(trl)) ~= 0
%             cleanBins(trl,:,:) = nan; % If that trial is no good, make that trial nan for all channels
%            % cleanBins(trl,1) = nan;
%             cleanXpos(trl,1) = nan;
%             cleanYpos(trl,1) = nan;
%             %cleanTstim(trl,1) = nan;
%             cleanRF(trl,1) = nan;
%             cleanAmp(trl,1) = nan;
%             cleanOri(trl,1) = nan;
%             cleanSF(trl,1) = nan;
%             cleanRad(trl,1) = nan;
%             cleanFile(trl,1) = nan;
%         end
%     end
%     %% Remove nan rows and trials
%     
%     %     cleanAmp(isnan(cleanAmp)) = [];
%     %     cleanXpos(isnan(cleanXpos)) = [];
%     %     cleanYpos(isnan(cleanYpos)) = [];
%     %     % cleanTstim(isnan(cleanTstim)) = [];
%     %     cleanRF(isnan(cleanRF)) = [];
%     %     cleanOri(isnan(cleanOri)) = [];
%     %     cleanSF(isnan(cleanSF)) = [];
%     %     cleanRad(isnan(cleanRad)) = [];
%     %
%     %     cleanBins(any(any(isnan(cleanBins),3),2),:,:) = [];
%     %% Create cleanData
%     cleanData.bins = cleanBins;
%     cleanData.pos_x = cleanXpos;
%     cleanData.pos_y = cleanYpos;
%     %  cleanData.t_Stim = cleanTstim;
%     cleanData.rf = cleanRF;
%     cleanData.amplitude = cleanAmp;
%     cleanData.orientation = cleanOri;
%     cleanData.spatialFrequency = cleanSF;
%     cleanData.radius = cleanRad;
    %% make stimulus response matrices
    
    [cleanRFStimResp,cleanBlankResps] = parseRadFreqStimResp(cleanData,startBin,endBin);
    [RFStimResp,blankResps] = parseRadFreqStimResp(data,startBin,endBin);
    
    [cleanRFbins, cleanBlankBins] = sortRadFreqBins(cleanData,(startBin+endBin));
    [RFbins, blankBins] = sortRadFreqBins(cleanData,(startBin+endBin));
    
    data.stimResps = RFStimResp;
    data.blankResps = blankResps;
    data.RFbins = RFbins;
    data.blankBins = blankBins;
    
    cleanData.stimResps = cleanRFStimResp;
    cleanData.blankResps = cleanBlankResps;
    cleanData.RFbins = RFbins;
    cleanData.blankBins = blankBins;
    %% Name data structures for saving.
    
    if strfind(files(fi,:),'RE')
        REdata = data;
        REcleanData = cleanData;
    elseif strfind(files(fi,:),'LE')
        LEdata = data;
        LEcleanData = cleanData;
    else
        error('File name does not have an eye')
    end
    %% plot responses Fig1
    meanBins2 = nanmean(cleanData.bins(:,startBin:endBin,:),2)./0.01;
    meanBins = nanmean(data.bins(:,startBin:endBin,:),2)./0.01;
    useBins = squeeze(meanBins);
    useBins2 = squeeze(meanBins2);
    
    figure(1)
    clf
    hold on
    plot(nanmean(useBins,2),'ko')
    %pause
    if contains(files(fi,:),'RE')
        plot(nanmean(useBins2,2),'r*')
        title('mean responses RE in cleaned data')
        figName = 'RE_cleanedData_V4';
    else
        plot(nanmean(useBins2,2),'b*')
        title('mean responses LE in cleaned data')
        figName = 'LE_cleanedData_V4';
    end
    legend('original','cleaned')
    set(gca,'color','none','tickdir','out','box','off')
    
    if location == 1
        if strfind(files(fi,:),'nsp1')
            cd '/Local/Users/bushnell/Dropbox/Figures/XT/RadialFrequency/V1/clean'
        else
            cd '/Local/Users/bushnell/Dropbox/Figures/XT/RadialFrequency/V1/clean'
        end
    elseif location == 0
        if strfind(files(fi,:),'nsp1')
            cd '/Users/bbushnell/Dropbox/Figures/XT/RadialFrequency/V1/clean'
        else
            cd '/Users/bbushnell/Dropbox/Figures/XT/RadialFrequency/V4/clean'
        end
    end
    saveas(gcf,figName,'pdf')
    %% plot responses to blank screen fig 2
    useRuns = find(data.rf == 10000);
    meanBins = nanmean(data.bins(useRuns,startBin:endBin,:),2)./0.01;
    useBins = squeeze(meanBins);
    
    useRuns2 = find(cleanData.rf == 10000);
    meanBins2 = nanmean(cleanData.bins(useRuns2,startBin:endBin,:),2)./0.01;
    useBins2 = squeeze(meanBins2);
    
    figure(2)
    clf
    hold on
    plot(nanmean(useBins,2),'ko')
    %pause
    if contains(files(fi,:),'RE')
        plot(nanmean(useBins2,2),'r*')
        title('mean responses to blank screen RE in cleaned data')
        figName = 'RE_cleanedBlanks_V4';
    else
        plot(nanmean(useBins2,2),'b*')
        title('mean responses to blank screen LE in cleaned data')
        figName = 'LE_cleanedBlanks_V4';
    end
    legend('original','cleaned')
    set(gca,'color','none','tickdir','out','box','off')
    %ylim([0 350])
    
    saveas(gcf,figName,'pdf')
    %% plot responses to circles fig3
    useRuns = find(data.rf == 32);
    useRuns2 = find(cleanData.rf == 32);
    
    meanBins = nanmean(data.bins(useRuns,startBin:endBin,:),2)./0.01;
    useBins = squeeze(meanBins);
    
    meanBins2 = nanmean(cleanData.bins(useRuns2,startBin:endBin,:),2)./0.01;
    useBins2 = squeeze(meanBins2);
    
    figure (3)
    clf
    hold on
    plot(nanmean(useBins,2),'ko')
    if contains(files(fi,:),'RE')
        plot(nanmean(useBins2,2),'r*')
        title('mean responses to circles RE in cleaned data')
        figName = 'RE_cleanedCircles_V4';
    else
        eye = 'LE';
        plot(useBins2,'b*')
        title('mean responses to circles LE in cleaned data')
        figName = 'LE_cleanedCircles_V4';
    end
    legend('original','cleaned')
    set(gca,'color','none','tickdir','out','box','off')
    
    saveas(gcf,figName,'pdf')
    %% plot responses to circles for each channel fig 4
    for ch = 1:96
        meanBins(1,ch) = nanmean(nanmean(data.bins(useRuns,startBin:endBin,ch),2)./0.01);
    end
    meanBins = squeeze(meanBins);
    
    for ch = 1:96
        meanBins2(1,ch) = nanmean(nanmean(cleanData.bins(useRuns2,startBin:endBin,ch),2)./0.01);
    end
    meanBins2 = squeeze(meanBins2);
    
    figure (4)
    clf
    hold on
    plot(meanBins,'ko')
    if contains(files(fi,:),'RE')
        plot(meanBins2,'r*')
        title('mean responses to circles RE in cleaned data')
        figName = 'RE_cleanedCircles_V4';
    else
        eye = 'LE';
        plot(meanBins2,'b*')
        title('mean responses to circles LE in cleaned data')
        figName = 'LE_cleanedCircles_V4';
    end
    legend('original','cleaned')
    set(gca,'color','none','tickdir','out','box','off')
    
    saveas(gcf,figName,'pdf')
end
%%
if strfind(files(1,:),'nsp1') | strfind(files(1,:),'V1')
    if location == 2
        cd /home/bushnell/matFiles/XT/V1/radFreqLowSF/cleanData
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/cleanData
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/cleanData
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/XT/V4/radFreqLowSF/cleanData
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/cleanData
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/cleanData
    end
end
if size(files,1) > 1
    save(newName,'REdata','LEdata', 'REcleanData','LEcleanData')
else
    if strfind(files,'RE')
        save(newName,'REdata','REcleanData')
    elseif strfind(files,'LE')
        save(newName,'LEdata','LEcleanData')
    end
end

toc





