% RFMwksGoodCh

%%
clear all
close all
clc
tic
%%
files = ['WU_LE_RadFreq_nsp2_June2017';'WU_RE_RadFreq_nsp2_June2017'];

beRFVerbose = 1;
beAmpVerbose = 0;
numBins = 20;
location = 0;
%% Check file, get array map
if location == 1
    %Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
else
    %laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
end

if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    cd ../matFiles/V4/RadialFrequency/ConcatenatedMats/
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    cd ../matFiles/V1/RadialFrequency
    
else
    error('Error: array ID missing or wrong')
end

for fi = 1:size(files,1)
    filename = files(fi,:);
    
    data = load(filename);
    % Find unique x and y locations used
    xloc = unique(data.pos_x);
    yloc = unique(data.pos_y);
    
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    
    % all of the other unique parameters are stored in the file name and needs
    % to be parsed out.
    for i = 1:length(data.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
        rfParams(1,i) = rf;
        rfParams(2,i) = mod;
        rfParams(3,i) = ori;
        rfParams(4,i) = sf;
        rfParams(5,i) = rad;
        
        % save all of the data in a cell in the same way it's done for other
        % experiments (eg: gratings).  Each cell represents what stimulus is
        % shown on a given presentation.
        
        data.rf(i,1)  = rf;
        data.amplitude(i,1) = mod;
        data.orientation(i,1) = ori;
        data.spatialFrequency(i,1) = sf;
        data.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
        name  = char(name);
        data.name(i,:) = name;
        
        % Blanks values are set to:
        % rf  = 10000;
        % mod = 10000;
        % ori = 10000;
        % sf  = 100;
        % rad = 100;
    end
    
    name = unique(data.filename,'rows');
    rfs  = unique(data.rf(:,1));
    amps = unique(data.amplitude(:,1));
    oris = unique(data.orientation(:,1));
    sfs  = unique(data.spatialFrequency(:,1));
    rads = unique(data.radius(:,1));
    
    numChannels = size(data.bins,3);
    %% Get good channels
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    trialLength = stimOn+stimOff;
    trialLengthBins = trialLength/10;
    goodChannels = [];
    gc = 1;
    
    goodChannels = MwksGetGoodCh(data,data.rf);
    
    %% Make version of data.bins with only responisve channels
    for ch = 1:numChannels
        
        blankNdx  = find(data.rf > 999);
        circleNdx = find(data.rf == 32);
        rfNdx     = find(data.rf < 32);
        stmNdx    = find(data.rf <50);
        
        % using bins from stim on until start of next stimulus
        %    allStimResps = data.bins(stmNdx,1:20,ch);
        
        allStimResps = data.bins(stmNdx,1:trialLengthBins,ch);
        allStimRespsMean = mean(allStimResps,1)./0.010;
        
        % blankResps = data.bins(blankNdx,1:20,ch);
        
        blankResps = data.bins(blankNdx,1:trialLengthBins,ch);
        blankRespsMean = mean(blankResps,1)./0.010;
        
        %circleResps = data.bins(circleNdx,1:20,ch);
        
        circleResps = data.bins(circleNdx,1:trialLengthBins,ch);
        circleRespsMean = mean(circleResps,1)./0.010;
        
        rfResps = data.bins(rfNdx,1:trialLengthBins,ch);
        rfRespsMean = mean(rfResps,1)./0.010;
        
        % Define good channels
        earlyResp = mean(data.bins(stmNdx,1,ch));
        lateResp  = mean(data.bins(stmNdx,12,ch));
        testResps = [earlyResp, lateResp];
        foo = ttest(testResps);
        if foo == 1
            goodChannels(gc,1) = ch;
            gc = gc+1;
        end
    end
    goodBins = nan((size(data.bins,1)),(size(data.bins,2)),length(goodChannels));
    for gch = 1:length(goodChannels)
        ch = goodChannels(gch);
        goodBins(:,:,gch) = data.bins(:,:,ch);
    end
    data.goodBins = goodBins;
    %% PSTH
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    trialLength = stimOn+stimOff;
    trialLengthBins = trialLength/10;
    goodChannels = [];
    gc = 1;
    
    figure
    for ch = 1:numChannels
        
        blankNdx  = find(data.rf > 999);
        circleNdx = find(data.rf == 32);
        rfNdx     = find(data.rf < 32);
        stmNdx    = find(data.rf <50);
        
        % using bins from stim on until start of next stimulus
        %    allStimResps = data.bins(stmNdx,1:20,ch);
        
        allStimResps = data.bins(stmNdx,1:trialLengthBins,ch);
        allStimRespsMean = mean(allStimResps,1)./0.010;
        
        % blankResps = data.bins(blankNdx,1:20,ch);
        
        blankResps = data.bins(blankNdx,1:trialLengthBins,ch);
        blankRespsMean = mean(blankResps,1)./0.010;
        
        %circleResps = data.bins(circleNdx,1:20,ch);
        
        circleResps = data.bins(circleNdx,1:trialLengthBins,ch);
        circleRespsMean = mean(circleResps,1)./0.010;
        
        rfResps = data.bins(rfNdx,1:trialLengthBins,ch);
        rfRespsMean = mean(rfResps,1)./0.010;
        
        % Define good channels
        earlyResp = mean(data.bins(stmNdx,1,ch));
        lateResp  = mean(data.bins(stmNdx,12,ch));
        testResps = [earlyResp, lateResp];
        foo = ttest(testResps);
        if foo == 1
            goodChannels(gc,1) = ch;
            gc = gc+1;
        end
        
        xaxis = 1:10:trialLength;
        
        if strfind(filename,'nsp1')
            if strfind(filename,'LE')
                topTitle = sprintf('V1/V2 Fellow eye PSTH RF (blue) vs Blank (red) vs Circle (black)');
            else
                topTitle = sprintf('V1/V2 Amblyopic eye PSTH RF (blue) vs Blank (red) vs Circle (black)');
            end
        else
            if strfind(filename,'LE')
                topTitle = sprintf('V4 Fellow eye PSTH RF (blue) vs Blank (red) vs Circle (black)');
            else
                topTitle = sprintf('V4 Amblyopic eye PSTH RF (blue) vs Blank (red) vs Circle (black)');
            end
        end
        
        if strfind(filename,'LE')
            figure(1)
        else
            figure(2)
        end
        
        subplot(aMap,10,10,ch)
        hold on
        plot(xaxis, blankRespsMean,'r')
        plot(xaxis, rfRespsMean,'b')
        plot(xaxis, circleRespsMean,'k')
        title(sprintf('%d',ch))
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out', 'XTickLabelRotation', 45)
        
        if ch == 1
            annotation('textbox',...
                [0.4 0.94 0.5 0.05],...
                'LineStyle','none',...
                'String',topTitle,...
                'Interpreter','none',...
                'FontSize',16,...
                'FontAngle','italic');
        end
        
        subplot(10,10,1)
        xlabel('time(ms)')
        ylabel('sp/s')
        axis square xy
        title('ch')
        ylim([0 (max(circleRespsMean)+1)])
        if ~isempty(strfind(filename,'nsp2'))
            set(gca,'color','none','XTick',zeros(1,0),'YTick',zeros(1,0))
        end
    end
    %% Extract information from good channels
    for gch = 1:length(goodChannels)
        latency(gch,1) = getLatencyMwks(data.goodBins, binStimOn*2, 10, gch);
    end
    data.latency = latency;
    
    meanLatency = round(double(mean(data.latency)));
    meanEndBin = round(double(meanLatency + binStimOn));
    for x = 1:size(xloc,1)
        for y = 1:size(yloc,1)
            % collapse across locations
            
            % collapse across all RFs
            for i = 1:size(rfs,1)
                rfs(i,2) = sum(data.rf == rfs(i,1));
                tmpNdx   = find(data.rf == rfs(i,1));
                useRuns  = data.goodBins(tmpNdx,meanLatency:meanEndBin,:);
                useRuns  = double(useRuns);
                rfs(i,3) = mean(mean(mean(useRuns)))./0.010;
                
                stErr    = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                rfs(i,4) = stErr;
                
                % collapse across all amplitudes
                for m = 1:size(amps,1)
                    rfAmpT(m,1) = rfs(i,1);
                    rfAmpT(m,2) = amps(m,1);
                    rfAmpT(m,3) = sum((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                    tmpNdx      = find((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                    useRuns     = data.goodBins(tmpNdx,meanLatency:meanEndBin,:);
                    useRuns     = double(useRuns);
                    rfAmpT(m,4) = mean(mean(mean(useRuns)))./0.010;
                    
                    if isnan(rfAmpT(m,4)) == 0
                        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                        rfAmpT(m,5) = stErr;
                    end
                end
                rfAmp{i} = rfAmpT;
                clear rfAmpT
            end
            % collapse across all amplitudes
            for am = 1:size(amps,1)
                amps(am,2) = sum(data.amplitude == amps(am,1));
                tmpNdx     = find(data.amplitude == amps(am,1));
                useRuns    = data.goodBins(tmpNdx,meanLatency:meanEndBin,:);
                useRuns    = double(useRuns);
                amps(am,3) = mean(mean(mean(useRuns)))./0.010;
                
                if ~isnan(amps(am,3))
                    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                    amps(am,4) = stErr;
                end
            end
            % collapse across all sizes
            for s = 1:size(rads,1)
                rads(s,2) = sum(data.radius == rads(s,1));
                tmpNdx    = find(data.radius == rads(s,1));
                useRuns   = data.goodBins(tmpNdx,meanLatency:meanEndBin,:);
                useRuns   = double(useRuns);
                rads(s,3) = mean(mean(mean(useRuns)))./0.010;
                
                if ~isnan(rads(s,3))
                    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                    rads(s,4) = stErr;
                end
            end
            
            % collapse across all sfs
            for sp = 1:size(sfs,1)
                sfs(sp,2) = sum(data.spatialFrequency == sfs(sp,1));
                tmpNdx    = find(data.spatialFrequency == sfs(sp,1));
                useRuns   = data.goodBins(tmpNdx,meanLatency:meanEndBin,:);
                useRuns   = double(useRuns);
                sfs(sp,3) = mean(mean(mean(useRuns)))./0.010;
                
                if ~isnan(sfs(sp,3))
                    stErr     = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                    sfs(sp,4) = stErr;
                end
            end
        end
    end
    data.radFreqResponse = rfs;
    data.radiusResponse  = rads;
    data.ampResponse   = amps;
    data.sfResponse    = sfs;
    data.rfAmpResponse = rfAmp;
    
    if strfind(filename,'RE')
        AEdata = data;
    else
        FEdata = data;
    end
end
%% Plot RF data
xdata = data.radFreqResponse((1:end-2),1);

AEydata = AEdata.radFreqResponse((1:end-2),3);
AEErr   = AEdata.radFreqResponse((1:end-2),4);
AExCirc     = AEdata.radFreqResponse((end-1),1);
AEyCirc     = AEdata.radFreqResponse((end-1),3);
AEcircErr   = AEdata.radFreqResponse((end-1),4);

FEydata = FEdata.radFreqResponse((1:end-2),3);
FEErr   = FEdata.radFreqResponse((1:end-2),4);
FExCirc     = FEdata.radFreqResponse((end-1),1);
FEyCirc     = FEdata.radFreqResponse((end-1),3);
FEcircErr   = FEdata.radFreqResponse((end-1),4);

figure
hold on
errorbar(xdata,AEydata,AEErr,'ro','LineWidth',2,'MarkerSize',6)
errorbar(2,AEyCirc,AEcircErr,'ro','LineWidth',2,'MarkerSize',6)
AEblankResp = AEdata.radFreqResponse(end,3);
plot([1 35], [AEblankResp AEblankResp],'r','MarkerSize',5)

errorbar(xdata,FEydata,FEErr,'bo','LineWidth',2,'MarkerSize',6)
errorbar(2,FEyCirc,FEcircErr,'bo','LineWidth',2,'MarkerSize',6)

FEblankResp = FEdata.radFreqResponse(end,3);
plot([1 35], [FEblankResp FEblankResp],'b','MarkerSize',5)

eBar = [1 2 4 8 16 32 64 128];

for stuff = 1:length(eBar)
    errorbar(eBar(stuff),FEblankResp,data.radFreqResponse((end),4),'b.')
    errorbar(eBar(stuff),AEblankResp,data.radFreqResponse((end),4),'r.')
end

title('Responses as a function of radial frequency')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32]...
    ,'XTickLabel',{'circle','4','8','16',''},'XTickLabelRotation', 45)
xlim([1 32])
% maxResp = max(data.radFreqResponse{ch}(:,3)+10); % use top of the upper error bar as the limit
% ylim([0 maxResp])
xlabel('Radial Frequency')
ylabel('Spikes/sec')
legend('AE RF','AE Circle','AE Blank','FE RF','FE Circle','FE Blank','Location','NorthWestOutside')
%% Plot amplitude data
figure
for rs = 1:size(rfs,1)
    AExdata = AEdata.rfAmpResponse{rs}(:,2);
    AEydata = AEdata.rfAmpResponse{rs}(:,4);
    AEstErr = AEdata.rfAmpResponse{rs}(:,5);
    hold on
    subplot(1,2,1)
    if rs < 4
        errorbar(AExdata,AEydata,AEstErr,'o:','LineWidth',2,'MarkerSize',6)
    elseif rs == 4
        errorbar(1.5,AEyCirc,AEcircErr,'o','LineWidth',2,'MarkerSize',6)
    elseif rs == 5
        AEblankResp = (AEdata.rfAmpResponse{rs}(9,4));
        plot([1 300], [AEblankResp AEblankResp],'k','LineWidth',2,'MarkerSize',11)
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),AEdata.rfAmpResponse{rs}(9,4),AEdata.rfAmpResponse{rs}(9,5),'k.','MarkerSize',11)
        end
    end
end
title('AE responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTickLabelRotation', 45)
xlabel('Modulation amplitude')
ylabel('Spikes/sec')
xlim([1 310])
ylim([85 120])
%legend('RF 4','RF 8','RF 16','Circle','Blank','Location','NorthWestOutside')


for sr = 1:size(rfs,1)
    FExdata = FEdata.rfAmpResponse{sr}(:,2);
    FEydata = FEdata.rfAmpResponse{sr}(:,4);
    FEstErr = FEdata.rfAmpResponse{sr}(:,5);
    hold on
    subplot(1,2,2)
    if sr < 4
        errorbar(FExdata,FEydata,FEstErr,'o-','LineWidth',2,'MarkerSize',6)
    elseif sr == 4
        errorbar(1.5,FEyCirc,FEcircErr,'o','LineWidth',2,'MarkerSize',6)
    elseif sr == 5
        FEblankResp = (FEdata.rfAmpResponse{sr}(9,4));
        plot([1 300], [FEblankResp FEblankResp],'k','LineWidth',2,'MarkerSize',11)
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),FEdata.rfAmpResponse{rs}(9,4),FEdata.rfAmpResponse{rs}(9,5),'k.','MarkerSize',11)
        end
    end
end
title('FE responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTickLabelRotation', 45)
xlabel('Modulation amplitude')
ylabel('Spikes/sec')
xlim([1 310])
ylim([85 120])
legend('RF 4','RF 8','RF 16','Circle','Blank','Location','SouthWestOutside')
%%
figure
for jigs = 1:3
    xdata = [4,8,16,32,64,128];
    
    FEydata = FEdata.rfAmpResponse{jigs}(:,4);
    FEstErr = FEdata.rfAmpResponse{jigs}(:,5);
    FEblankResp = FEdata.rfAmpResponse{jigs}(9,4);
    
    AEydata = AEdata.rfAmpResponse{jigs}(:,4);
    AEstErr = AEdata.rfAmpResponse{jigs}(:,5);
    AEblankResp = AEdata.rfAmpResponse{jigs}(9,4);
    
    nd = 1;
    for ja = 1:length(FEydata)
        if ~isnan(FEydata(ja,1))
            FEy(nd,1) = FEydata(ja,1);
            FEerr(nd,1) = FEstErr(ja,1);
            
            AEy(nd,1) = AEydata(ja,1);
            AEerr(nd,1) = AEstErr(ja,1);
            nd = nd+1;
        end
    end
    
    if jigs == 1
        subplot(1,3,1)
        hold on
        errorbar(xdata,AEy,AEerr,'ro-')
        errorbar(xdata,FEy,FEerr,'bo-')
        
        errorbar(2,FEyCirc,FEcircErr,'bo')
        errorbar(2,AEyCirc,AEcircErr,'ro')
        
        
        plot([2 256], [FEdata.rfAmpResponse{sr}(9,4) FEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [AEdata.rfAmpResponse{sr}(9,4) AEdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),FEdata.rfAmpResponse{rs}(9,4),FEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),AEdata.rfAmpResponse{rs}(9,4),AEdata.rfAmpResponse{rs}(9,5),'r.')
        end
        
        title('RF4')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        ylabel('response sp/sec')
        
    elseif jigs == 2
        subplot(1,3,2)
        hold on
        errorbar(xdata,AEy,AEerr,'o-r')
        errorbar(xdata,FEy,FEerr,'o-b')
        
        errorbar(2,FEyCirc,FEcircErr,'bo')
        errorbar(2,AEyCirc,AEcircErr,'ro')
        
        plot([2 256], [FEdata.rfAmpResponse{sr}(9,4) FEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [AEdata.rfAmpResponse{sr}(9,4) AEdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),FEdata.rfAmpResponse{rs}(9,4),FEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),AEdata.rfAmpResponse{rs}(9,4),AEdata.rfAmpResponse{rs}(9,5),'r.')
        end
        
        title('RF8')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        xlabel('Modulation amplitude')
        
    elseif jigs == 3
        subplot(1,3,3)
        hold on
        errorbar(xdata,AEy,AEerr,'o-r')
        errorbar(xdata,FEy,FEerr,'o-b')
        
        errorbar(1.5,FEyCirc,FEcircErr,'bo')
        errorbar(1.5,AEyCirc,AEcircErr,'ro')
        
        plot([2 256], [FEdata.rfAmpResponse{sr}(9,4) FEdata.rfAmpResponse{sr}(9,4)],'b')
        plot([2 256], [AEdata.rfAmpResponse{sr}(9,4) AEdata.rfAmpResponse{sr}(9,4)],'r')
        
        eBar = [2 4 8 16 32 64 128 256];
        for stuff = 1:length(eBar)
            errorbar(eBar(stuff),FEdata.rfAmpResponse{rs}(9,4),FEdata.rfAmpResponse{rs}(9,5),'b.')
            errorbar(eBar(stuff),AEdata.rfAmpResponse{rs}(9,4),AEdata.rfAmpResponse{rs}(9,5),'r.')
        end
        title('RF16')
        axis square xy
        set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
            ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
        xlim([1 260])
        ylim([85 120])
        legend ('AE','FE')
    end
end
%%
figure
hold on

xdata = [4,8,16,32,64,128];

for jigs = 1:3
    FEydata = FEdata.rfAmpResponse{jigs}(:,4);
    FEstErr = FEdata.rfAmpResponse{jigs}(:,5);
    FEblankResp = FEdata.rfAmpResponse{jigs}(9,4);
    
    AEydata = AEdata.rfAmpResponse{jigs}(:,4);
    AEstErr = AEdata.rfAmpResponse{jigs}(:,5);
    AEblankResp = AEdata.rfAmpResponse{jigs}(9,4);
    
    nd = 1;
    for ja = 1:length(FEydata)
        if ~isnan(FEydata(ja,1))
            FEy(nd,1) = FEydata(ja,1);
            FEerr(nd,1) = FEstErr(ja,1);
            
            AEy(nd,1) = AEydata(ja,1);
            AEerr(nd,1) = AEstErr(ja,1);
            nd = nd+1;
        end
    end
    errorbar(xdata,AEy,AEerr,'o:')
    errorbar(xdata,FEy,FEerr,'o-')
end

errorbar(2,AEyCirc,AEcircErr,'ro')
errorbar(2,FEyCirc,FEcircErr,'bo')

plot([2 256], [AEdata.rfAmpResponse{sr}(9,4) AEdata.rfAmpResponse{sr}(9,4)],'r')
plot([2 256], [FEdata.rfAmpResponse{sr}(9,4) FEdata.rfAmpResponse{sr}(9,4)],'k')

eBar = [2 4 8 16 32 64 128 256];
for stuff = 1:length(eBar)
    errorbar(eBar(stuff),AEdata.rfAmpResponse{rs}(9,4),AEdata.rfAmpResponse{rs}(9,5),'r.')
    errorbar(eBar(stuff),FEdata.rfAmpResponse{rs}(9,4),FEdata.rfAmpResponse{rs}(9,5),'k.')
end

title('Responses to RF stimuli as a function of amplitude')
axis square xy
set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log','XTick',[2 4 8 16 32 64 128 256]...
    ,'XTickLabel',{'circle','low','','','','','high','blank'},'XTickLabelRotation', 45)
xlim([1 260])
ylim([85 135])
legend ('AE RF4','FE RF4',...
    'AE RF8','FE RF8',...
    'AE RF16','FE RF 16',...
    'AE circe','FE circle',...
    'AE blank','FE blank')
ylabel('response spikes/sec')
xlabel('Modulation amplitude')





