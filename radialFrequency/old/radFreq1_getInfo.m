% radFreq1_cleanData
%
% Step 1 of the radial frequency analysis pipeline, this program takes the
% responses of either a single day or a combination of days and creates and
% adds the stimResp and blankResp matrices to the data structure. It also
% combines LE and RE data into one .mat file
%
% June 1, 2018 Brittany Bushnell
% Updated Sep 8, 2020 to be consistent with Glass1_getInfo which has newer
% things in it and is more streamlined.
%%
%
clear all
close all
clc
tic

%%
nameEnd = 'info';
numPerm = 2000;
numBoot = 200;
holdout = 0.9;

plotFlag = 0;
%% Get array map
aMap = getBlackrockArrayMap(files(1,:));
data.amap = aMap;
%% load data and extract info
for fi = 1:size(files,1)
    data = load(files(fi,:));
    size(data.bins)
    textName = figTitleName(files(fi,:));
    fprintf('\n analyzing file: %s\n',textName)
    
    %extract information from filename
    chunks = strsplit(textName);
    animal = chunks{1};
    eye = chunks{2};
    program = chunks{3};
    array = chunks{4};
    date = chunks{5};
    
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
        
        data.rf(i,1)  = rf;
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
    
    % add other information 
    data.animal = animal;
    data.array = array;
    data.eye = eye;
    data.program = program;
    data.date = date;
    %% determine outliers
    cleanData = getCleanData_RF(data,startBin,endBin);
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
    cleanData.animalID = animal;
    cleanData.arrayID = array;
    cleanData.eye = eye;
    cleanData.program = program;
    cleanData.date = date;
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





