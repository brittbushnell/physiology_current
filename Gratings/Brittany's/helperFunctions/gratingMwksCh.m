function [data] = gratingMwksCh(filename,location,beOriVerbose,beSFVerbose,baselineFigs)
%
% Analysis code for MWorks grat_map program using .mat files that have been
% merged using .py code from Darren.
%
% Created Feb 8, 2017
% Brittany Bushnell
%

tic;
clc
%% NOTES TO SELF
%     textName = figTitleName(filename); to make better figure titles and
%     get rid of all of the if statements.  Call right after load(filename)
%
% Update good channels to use new good channels function
%% Comment out if running as a function
% clear all
% close all
% tic
%
% filename = 'WU_BE_LE_Gratings_nsp2_20170907_002.mat';
% numBins = 10; % how many bins to search across
% numBoots = 100; % number of bootstraps to do
%
% beOriVerbose = 0;
% beSFVerbose  = 0;
% baselineFigs = 0;
% location = 1;
% %% Verify file and find array map
% if location == 1
%     % Amfortas
%     cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
% else
%     % laptop
%     cd ~/Dropbox/ArrayData/WU_ArrayMaps
% end
% if ~isempty(strfind(filename,'nsp2'))
%     disp 'data recorded from nsp2, V4 array'
%     aMap = arraymap('SN 1024-001795.cmp');
%     cd ../matFiles/V4
%     
% elseif ~isempty(strfind(filename,'nsp1'))
%     disp 'data recorded from nsp1, V1/V2 array'
%     aMap = arraymap('SN 1024-001790.cmp');
%     cd ../matFiles/V1
%     
% else
%     error('Error: array ID missing or wrong')
% end
% 
% if ~isempty(strfind(filename,'Gratings'))
%     cd Gratings/
% elseif ~isempty(strfind(filename,'Gratmap'))
%     cd Gratmap/
% elseif ~isempty(strfind(filename,'GratingsMapRF'))
%     cd GratMapRF/
% else
%     error('Error: cannot identify the program run, check file name')
% end
%% Extract stimulus information
% NOTES:
% sf 0.003 is the white luminance flash
% sf 0.006 is the black luminance flash
% sf 0 is a blank screen
%
% data.bins is organized into a 3 dimensional matrix organized by:
% successful presentations, 50 10ms bins after stim presentations, channels
% That means that spikes(1,:,1) would give the # of threshold crossings
% on channel #1 in response to first stimulus in 10ms time bins for 500ms

data = load(filename);
textName = figTitleName(filename);

sfs   = unique(data.spatial_frequency);
oris  = unique(data.rotation);
width = unique(data.width); %do not call this size! size is already a function!!!
xloc  = unique(data.xoffset);
yloc  = unique(data.yoffset);
stimOn  = unique(data.stimOn);
stimOff = unique(data.stimOff);

numChannels = size(data.bins,3);
data.amap = getBlackrockArrayMap(filename);
aMap = data.amap
%% PSTHs and define good channels
goodChannels = [];
gc = 1;
figure(1)
figure(2)

binStimOn  = stimOn/10;
binStimOff = stimOff/10;

for ch = 1:numChannels
    
    blankNdx = find(data.spatial_frequency == 0);
    stimNdx  = find(data.spatial_frequency > 0);
    
    blankResps = data.bins(blankNdx,1:(binStimOn+binStimOff),ch);
    blankRespsMean = mean(blankResps,1)./0.010;
    
    stimResps = data.bins(stimNdx,1:(binStimOn+binStimOff),ch);
    stimRespsMean = mean(stimResps,1)./0.010;
    
    xaxis = 1:10:stimOn+stimOff;
    
    % Define good channels
    blankResp = mean(data.bins(blankNdx,(binStimOn/2),ch));
    lateResp  = mean(data.bins(stimNdx,(binStimOn/2),ch));
    testResps = [blankResp, lateResp];
    foo = ttest(testResps);
    if foo == 1
        goodChannels(gc,1) = ch;
        gc = gc+1;
    end
    
    if strfind(filename,'LE')
        figure(1)
    else
        figure(2)
    end
    
    % plot PSTHs
    subplot(aMap,10,10,ch)
    hold on
    
    plot(xaxis, blankRespsMean,'k','LineWidth',2)
    plot(xaxis, stimRespsMean,'r','LineWidth',2)
    
    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
    
    if ch == 1
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',textName,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
        set(gca,'box','off','color','none')
        xlabel('time')
        ylabel('sp/sec')
    end
end

data.goodChannels = goodChannels;
%% Make version of data.bins with only responisve channels
goodBins = nan((size(data.bins,1)),(size(data.bins,2)),gc-1);
for gch = 1:length(goodChannels)
    goodBins(:,:,gch) = data.bins(:,:,goodChannels(gch));
end
data.goodBins = goodBins;
%% Responses collapsed across a parameter
binSize = 10;
maxSF  = nan(2,numChannels);
maxOri = nan(2,numChannels);

for ch = 1:numChannels
    %disp(sprintf('Analyzing channel %d',ch))
    
    % get latency
    latency = getLatencyMwks(data.bins,binStimOn*2, binSize,ch);
    endBin  = latency+binStimOn;
    
    % responses for spatial frequencies across all orienations
    for i = 1:length(sfs)
        sfs(2,i) = sum(data.spatial_frequency == (sfs(1,i)));
        tmpNdx   = find(data.spatial_frequency == (sfs(1,i)));
        useRuns  = data.bins(tmpNdx,latency:endBin,ch);
        useRuns  = double(useRuns);
        sfs(3,i) = mean(mean(useRuns))./0.010;
        blank    = sfs(3,1);
        % subtract baseline response rate
        sfs(4,i) = sfs(3,i) - blank;
        
        %error bars
        stErr = std(useRuns(:))/sqrt(length(useRuns(:)));
        sfs(5,i) = sfs(3,i) - stErr;
        sfs(6,i) = sfs(3,i) + stErr;
        
        %SF with maximum response
        tmp = sfs(3,:);
        [tmpM, tmpI] = max(tmp); % get the maximum response, and the index
        maxSF(1,ch) = sfs(1,tmpI); % what is the sf?
        maxSF(2,ch) = sfs(3,tmpI);
    end
    
    % responses for orienation collapsed across spatial frequency
    for l = 1:length(oris)
        oris(2,l) = sum(data.rotation == (oris(1,l))); %Because == returns a binary result, sum gives a count of repeats
        tmpNdx    = find(data.rotation == (oris(1,l)));
        useRuns   = data.bins(tmpNdx,latency:endBin,ch);
        useRuns  = double(useRuns);
        oris(3,l) = mean(mean(useRuns))./0.010; %dividing the mean by binStimOn/100 puts the results into spikes/sec
        oris(4,l) = oris(3,l) - blank; %sfs(3,1) = blank
        
        %error bars
        stErr = std(useRuns(:))/sqrt(length(useRuns(:)));
        oris(5,l) = oris(3,l) - stErr;
        oris(6,l) = oris(3,l) + stErr;
        
        % Orientation with maximum response
        %         tmp = sfs(3,:);
        %         [tmpM, tmpI] = max(tmp); % get the maximum response, and the index
        %         maxOri(1,ch) = oris(1,tmpI); % what is the sf?
        %         maxOri(2,ch) = oris(3,tmpI);
        
    end
    
    % if more than one location was used, collapse across everything else
    if length(xloc) > 1
        for t = 1:length(xloc)
            xloc(2,t) = sum(data.xoffset == (xloc(1,t)));
            tmpNdx = find(data.xoffset == (xloc(1,t)));
            useRuns   = data.bins(tmpNdx,latency:endBin,ch);
            useRuns  = double(useRuns);
            xloc(3,t) = mean(mean(useRuns))./0.010;
            xloc(4,t) = xloc(3,t) - blank;
            
            %error bars
            stErr = std(useRuns(:))/sqrt(length(useRuns(:)));
            xloc(5,t) = xloc(3,t) - stErr;
            xloc(6,t) = xloc(3,t) + stErr;
        end
        data.locationResp{ch} = xloc;
    end
    
    data.orientationResp{ch} = oris;
    data.spatialFrequencyResp{ch} = sfs;
    data.maxSF = maxSF;
    data.maxOri = maxOri;
end
%% Orientation tuning for entire array
figure(1)
clf
for ch = 1:numChannels
    subplot(aMap,10,10,ch)
    plot(data.orientationResp{ch}(1,:),data.orientationResp{ch}(3,:),'b.-')
    hold on
    blankResp = data.spatialFrequencyResp{ch}(3,1);
    plot([0 190], [blankResp blankResp],'r') % blank
    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out')
    xlim([0 190])
    
    subplot(10,10,1)
    xlabel('ori')
    ylabel('sp/s')
    axis square xy
    if ~isempty(strfind(filename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end
    
    topTitle = sprintf('Orientation tuning: %s',filename);
    if ch == 1
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',textName,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
%% SF tuning for entire array
figure(2)
clf
for ch = 1:numChannels
    subplot(aMap,10,10,ch)
    plot(data.spatialFrequencyResp{ch}(1,4:end),data.spatialFrequencyResp{ch}(3,4:end),'b.-', 'MarkerSize',9)
    hold on
    plot(20, data.spatialFrequencyResp{ch}(3,2),'m.', 'MarkerSize',9) % white flash
    plot(40, data.spatialFrequencyResp{ch}(3,3),'k.', 'MarkerSize',9) % black flash
    
    if maxSF(1,ch) == 0.0003
        plot(20, (maxSF(2,ch)+10),'bv','MarkerSize',4)
        
    elseif maxSF(1,ch) == 0.0006
        plot(40, (maxSF(2,ch)+10),'bv','MarkerSize',4)
    else
        plot(maxSF(1,ch), (maxSF(2,ch)+10),'bv','MarkerSize',4)
    end
    
    blankResp = data.spatialFrequencyResp{ch}(3,1);
    plot([0.3 45], [blankResp blankResp],'r') % blank
    title(sprintf('%d',ch))
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.3 0.6 1.25 2.5 5 10 20 40],...
        'XTickLabel',{'0.3', '', '1.25', '', '5', '10', 'W','B'},...
        'XTickLabelRotation', 45)
    xlim([0.1 40])
    
    subplot(10,10,1)
    xlabel('sf')
    ylabel('sp/s')
    axis square xy
    if ~isempty(strfind(filename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end
    
    topTitle = sprintf('SF tuning: %s',filename);
    if ch == 1
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',textName,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end
%% Spatial frequency tuning: figures for each channel
if beSFVerbose == 1
    for ch = 1:numChannels
        figure(3)
        clf
        xData = data.spatialFrequencyResp{ch}(1,4:end);
        yData = data.spatialFrequencyResp{ch}(3,4:end);
        dnErr = data.spatialFrequencyResp{ch}(5,4:end);
        upErr = data.spatialFrequencyResp{ch}(6,4:end);
        
        wData  = data.spatialFrequencyResp{ch}(3,2);
        wdnErr = data.spatialFrequencyResp{ch}(5,2);
        wupErr = data.spatialFrequencyResp{ch}(6,2);
        
        kData  = data.spatialFrequencyResp{ch}(3,3);
        kdnErr = data.spatialFrequencyResp{ch}(5,3);
        kupErr = data.spatialFrequencyResp{ch}(6,3);
        
        errorbar(xData,yData,dnErr,upErr,'b.-', 'MarkerSize',12)
        hold on
        errorbar(20, wData, wdnErr, wupErr,'m.', 'MarkerSize',12) % white flash
        errorbar(40, kData, kdnErr, kupErr,'k.', 'MarkerSize',12) % black flash
        
        if maxSF(1,ch) == 0.0003
            plot(20, (maxSF(2,ch)+10),'bv', 'MarkerSize',8)
            
        elseif maxSF(1,ch) == 0.0006
            plot(40, (maxSF(2,ch)+10),'bv','MarkerSize',8)
        else
            plot(maxSF(1,ch), (maxSF(2,ch)+10),'bv','MarkerSize',8)
        end
        
        blankResp = data.spatialFrequencyResp{ch}(3,1);
        plot([0.1 45], [blankResp blankResp],'r') % blank
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
            'XTick',[0.3 0.6 1.25 2.5 5 10 20 40],...
            'XTickLabel',{'0.3', '', '1.25', '', '5', '10', 'W','B'},...
            'XTickLabelRotation', 45)
        xlim([0.3 40])
        xlabel('spatial frequency (c/deg)')
        ylabel('spikes/sec')
        title(sprintf('SF tuning: %s',textName))
    end
end
%% Orientation tuning: figures for each channel
if beOriVerbose == 1
    for ch = 1:numChannels
        figure(4)
        clf
        xData = data.orientationResp{ch}(1,:);
        yData = data.orientationResp{ch}(3,:);
        dnErr = data.orientationResp{ch}(5,:);
        upErr = data.orientationResp{ch}(6,:);
        
        errorbar(xData,yData,dnErr,upErr,'b.-', 'MarkerSize',12)
        hold on
        blankResp = data.spatialFrequencyResp{ch}(3,1);
        plot([0 190], [blankResp blankResp],'r') % blank
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out')
        xlim([-2 190])
        ylabel('Spikes/sec')
        xlabel('Orientation (deg)')
        title(sprintf('Orientation tuning: %s',textName));
        legend('ori','blank','Location','NorthEastOutside')
    end
end
%% Baseline subtracted figures
if baselineFigs == 1
    figure(5)
    clf
    for ch = 1:numChannels
        hold on
        subplot(aMap,10,10,ch)
        plot(data.orientationResp{ch}(1,:),data.orientationResp{ch}(4,:))
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out')
        %ylim([0 10])
        
        subplot(10,10,1)
        xlabel('ori')
        ylabel('sp/s - blank')
        axis square xy
        if ~isempty(strfind(filename,'nsp2'))
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
        end
        
        topTitle = sprintf('Orientation tuning baseline subtracted:   %s',textName);
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.35 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
    
    figure(6)
    clf
    for ch = 1:numChannels
        hold on
        subplot(aMap,10,10,ch)
        plot(data.spatialFrequencyResp{ch}(1,:),data.spatialFrequencyResp{ch}(4,:))
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out')
        
        subplot(10,10,1)
        xlabel('sf')
        ylabel('sp/s - blank')
        axis square xy
        if ~isempty(strfind(filename,'nsp2'))
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
        end
        
        topTitle = sprintf('SF tuning baseline subtracted:   %s',textName);
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.35 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic',...
                'FontName','Helvetica Neue');
        end
    end
end
%% Fit subtracted spatial frequency data
figure(7)
clf
for gch = 1:length(goodChannels) %1:numChannels
    ch = goodChannels(gch);
    disp(sprintf('Fitting channel %d',ch))
    xVals = data.spatialFrequencyResp{ch}(1,4:end);
    resps = data.spatialFrequencyResp{ch}(4,4:end); %row 3 is regular mean, row 4 is baseline subtracted mean
    [fitParams, fitResps] = FitDifOfGaus(xVals,resps,0,10);
    
    [xPref,xHigh,bandwidth] = DifOfGausStats(xVals(1,1),xVals(1,end),fitParams);
    data.sfPrefs{ch} = xPref;
    data.sfHigh{ch} = xHigh;
    data.sfBandwidth = bandwidth;
    data.sfFitParams{ch} = fitParams;
    
    subplot(aMap,10,10,ch)
    plot(xVals,fitResps','b')
    hold on
    plot(xVals,(data.spatialFrequencyResp{ch}(4,4:end)),'k.')
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.3 0.6 1.25 2.5 5 10 20 40],...
        'XTickLabel',{'0.3', '', '1.25', '', '5', '10', 'W','B'},...
        'XTickLabelRotation', 45)
    title(sprintf('ch %d',ch))
    subplot(10,10,1)
    xlabel('sf')
    ylabel('sp/s - blank')
    axis square xy
    if ~isempty(strfind(filename,'nsp2'))
        set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
    end
    topTitle = sprintf('model fitting SF tuning for responsive channels   %s',textName);
    if gch == 1
        annotation('textbox',...
            [0.4 0.94 0.35 0.05],...
            'LineStyle','none',...
            'String',topTitle,...
            'Interpreter','none',...
            'FontSize',16,...
            'FontAngle','italic',...
            'FontName','Helvetica Neue');
    end
end

%%
% load handel
% sound(y,Fs)
toc