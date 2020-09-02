% gratMwksGoodCh
% Analyze grating responses collapsed across all visually responsive
% channels for both eyes.
%

clc
%% NOTES

%% comment out if running as a function
clear all
close all
tic;
location = 0; % 1 = Amfortas
%% Files to run
%files = ['WU_RE_Gratings_nsp1_20170707_004_recut045'];
files = 'WU_RE_Gratings_nsp1_20170707_004';
%files = ['WU_RE_Gratings_nsp2_withRF'; 'WU_LE_Gratings_nsp2_withRF'];

% Single day v4 files
% files = ['WU_RE_Gratings_nsp2_20170705_001';'WU_LE_Gratings_nsp2_20170705_003'];
% files = ['WU_RE_Gratings_nsp2_20170706_001';'WU_LE_Gratings_nsp2_20170706_003'];
% files = ['WU_RE_Gratings_nsp2_20170707_004';'WU_LE_Gratings_nsp2_20170707_001'];
% files = ['WU_RE_Gratings_nsp2_20170710_001';'WU_LE_Gratings_nsp2_20170710_003'];
% files = ['WU_RE_Gratings_nsp2_20170719_003';'WU_LE_Gratings_nsp2_20170719_001'];
% files = ['WU_LE_Gratings_nsp2_20170721_001'; 'WU_RE_Gratings_nsp2_20170720_001'];

% v1/v2 files
% files = ['WU_RE_Gratings_nsp1_20170705_001';'WU_LE_Gratings_nsp1_20170705_003'];
% files = ['WU_RE_Gratings_nsp1_20170706_001';'WU_LE_Gratings_nsp1_20170706_003'];
% files = ['WU_RE_Gratings_nsp1_20170707_004';'WU_LE_Gratings_nsp1_20170707_001'];
% files = ['WU_RE_Gratings_nsp1_20170710_001';'WU_LE_Gratings_nsp1_20170710_003'];
% files = ['WU_RE_Gratings_nsp1_20170719_003';'WU_LE_Gratings_nsp1_20170719_001'];
%% Verify file and find array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
else
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
end
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    cd ../matFiles/V4
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    cd ../matFiles/V1
    
else
    error('Error: array ID missing or wrong')
end

if ~isempty(strfind(files(1,:),'Gratings'))
    cd Gratings/ConcatenatedMats/
elseif ~isempty(strfind(files(1,:),'Gratmap'))
    cd Gratmap/
elseif ~isempty(strfind(files(1,:),'GratingsMapRF'))
    cd GratMapRF/
else
    error('Error: cannot identify the program run, check file name')
end
%% Extract stim information
for fi = 1:size(files,1)
    filename = files(fi,:);
    
    data = load(filename);
    textName = figTitleName(filename);
    
    sfs   = unique(data.spatial_frequency);
    oris  = unique(data.rotation);
    width = unique(data.width); %do not call this size! size is already a function!!!
    xloc  = unique(data.xoffset);
    yloc  = unique(data.yoffset);
    
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    
    numChannels = size(data.bins,3);
    data.amap = aMap;
    %% PSTH
    for ch = 1:numChannels
        blankNdx(ch,:) = find(data.spatial_frequency == 0);
        stimNdx(ch,:)  = find(data.spatial_frequency > 0);
    end
    psthFigMwksArray(data, textName, blankNdx, stimNdx)
    
    clear blankNdx
    clear stimNdx
    %% Define Good channels
    goodChannels = MwksGetGoodCh(data,filename);
    data.goodChannels = goodChannels;
    %% Make version of data.bins with only responisve channels
    goodBins = nan((size(data.bins,1)),(size(data.bins,2)),length(goodChannels));
    for gch = 1:length(goodChannels)
        goodBins(:,:,gch) = data.bins(:,:,goodChannels(gch));
    end
    data.goodBins = goodBins;
    %% Extract information from the good channels
    % Get latency information
    for gch = 1:length(goodChannels)
        latency(gch,1) = getLatencyMwks(data.goodBins, binStimOn*2, 10, gch);
    end
    data.latency = latency;
    
    meanLatency = double(mean(data.latency));
    meanEndBin = double(meanLatency + binStimOn);
    
    medLatency  = double(median(data.latency));
    medEndBin  = double(medLatency  + binStimOn);
    
    for i = 1:length(sfs)
        
        sfs(2,i) = sum(data.spatial_frequency == (sfs(1,i)));
        tmpNdx   = find(data.spatial_frequency == (sfs(1,i)));
        
        useRuns  = double(data.goodBins(tmpNdx,latency:meanEndBin,:));
        sfs(3,i) = mean(mean(mean(useRuns)))./0.010;
        blank    = sfs(3,1);
        % subtract baseline response rate
        sfs(4,i) = sfs(3,i) - blank;
        
        %error bars
        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
        sfs(5,i) = sfs(3,i) - stErr;
        sfs(6,i) = sfs(3,i) + stErr;
        sfs(7,i) = stErr;
    end
    
    % SF with maximum response
    % using absolute value of baseline subtracted responses, so it
    % returns the stimulus with the largest effect on the baseline
    % responses, regardless of sign.
    [maxSFval, maxSFndx] = max(abs(sfs(4,4:end))); % excluding stimuli with no orientation content - blanks and lum flashes
    maxSF = sfs(1,maxSFndx+3);
    data.spatialFrequencyResp = sfs;
    data.maxSF =  [maxSF, maxSFndx, maxSFval];
    %% Spatial frequency tuning
    xVals = data.spatialFrequencyResp(1,4:end);
    resps = data.spatialFrequencyResp(4,4:end); %row 3 is regular mean, row 4 is baseline subtracted mean
    [fitParams, fitResps] = FitDifOfGaus(xVals,resps,0,10);
    
    [sfPref,sfHigh,sfBandwidth] = DifOfGausStats(xVals(1,1),xVals(1,end),fitParams);
    data.sfPrefs = sfPref;
    data.sfHigh  = sfHigh;
    data.sfBandwidth = sfBandwidth;
    data.sfFitParams = fitParams;
    %% orientation responses
    for l = 1:length(oris)
        % collapsed across all SFs
        oris(2,l) = sum(data.rotation == (oris(1,l)));
        tmpNdx    = find(data.rotation == (oris(1,l)));
        
        useRuns   = double(data.goodBins(tmpNdx,latency:meanEndBin,:));
        oris(3,l) = mean(mean(mean(useRuns)))./0.010; %dividing the mean by binStimOn/100 puts the results into spikes/sec
        oris(4,l) = oris(3,l) - blank;
        
        %error bars
        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
        oris(5,l) = oris(3,l) - stErr;
        oris(6,l) = oris(3,l) + stErr;
        oris(7,l) = stErr;
        
        % Orientation tuning prep
        % limit to trials where the spatial frequency with the highest response was used
        oriTune(1,:) = oris(1,:);
        oriTune(2,l) = sum((data.rotation == (oris(1,l))) .* (data.spatial_frequency == maxSF));
        tmpNdx = find((data.rotation == (oris(1,l))) .* (data.spatial_frequency == maxSF));
        
        useRuns   = double(data.goodBins(tmpNdx,latency:meanEndBin,:));
        oriTune(3,l) = mean(mean(mean(useRuns)))./0.010; %dividing the mean by binStimOn/100 puts the results into spikes/sec
        oriTune(4,l) = oriTune(3,l) - blank;
        
        %error bars
        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
        oriTune(5,l) = oriTune(3,l) - stErr;
        oriTune(6,l) = oriTune(3,l) + stErr;
        oriTune(7,l) = stErr;
    end
    
    data.orientationResp = oris;
    data.oriTuneResp = oriTune;
    
    %% orientation tuning
    vectAngle = nan(3,(size(oris,2)+1));
    vectAngle(1,1:end-1) = oris(1,:);
    for or = 1:size(oris,2)
        vectAngle(2,or) = oriTune(3,or) * (cos(oriTune(1,or)));    % x = FRa(COSa)
        vectAngle(3,or) = oriTune(3,or) * (sin(oriTune(1,or)));    % y = FRa(SINa)
    end
    vectAngle(2,end) = sum(vectAngle(2,1:end-1));
    vectAngle(3,end) = sum(vectAngle(3,1:end-1));
    
    pkOri = atan((vectAngle(3,end))/(vectAngle(2,end)))
    oriNdx = sqrt(((vectAngle(3,end))/size(oris,2))^2 + ((vectAngle(3,end))/size(oris,2))^2)
    vectAngleRad = deg2rad(vectAngle(1,1:end-1));
    %% Create eye specific data structures
    if strfind(filename,'RE')
        AEdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        FEdata = data;
    end
end
%% Plot SF responses
if exist('BEdata','var') == 1
    figure
    % data were recorded binocularly
    errorbar(BEdata.spatialFrequencyResp(1,4:end),BEdata.spatialFrequencyResp(3,4:end),BEdata.spatialFrequencyResp(7,4:end),'.-',...
        'Color',[0.5 0 0.5],'MarkerFaceColor',[0.5 0 0.5],'LineWidth',2,'MarkerSize',15)
    hold on
    errorbar(0.15, BEdata.spatialFrequencyResp(3,2),BEdata.spatialFrequencyResp(7,2),'^',...
        'Color',[0.5 0 0.5],'MarkerSize',5) % white flash
    errorbar(0.15, BEdata.spatialFrequencyResp(3,3),BEdata.spatialFrequencyResp(7,2),'v',...
        'Color',[0.5 0 0.5],'MarkerSize',5) % black flash
    blankResp = BEdata.spatialFrequencyResp(3,1);
    plot([0.01 45], [blankResp blankResp],'Color',[0.5 0 0.5]) % blank
    errorbar(0.3,blankResp,BEdata.spatialFrequencyResp(7,1),'.','Color',[0.5 0 0.5],'LineWidth',2,'MarkerSize',15)
    
    
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.15 0.3 0.6 1.25 2.5 5 10 20],...
        'XTickLabel',{'0', '0.3', '', '1.25', '', '5', '10', ''},...
        'XTickLabelRotation', 45)
    xlim([0.1 40])
    %ylim([60 100])
    
    if strfind(filename,'nsp1')
        title('Mean responses by SFs of V1/V2 array across responsive channels')
    else
        title('Mean responses by SFs of V4 array across responsive channels')
    end
    
    xlabel('Spatial Frequency (cpd)')
    ylabel('Response (sp/s)')
    legend('Binoc','white flash', 'black flash', 'blank','Location','NorthEastOutside')
    
else
    figure
    
    errorbar(FEdata.spatialFrequencyResp(1,4:end),FEdata.spatialFrequencyResp(3,4:end),FEdata.spatialFrequencyResp(7,4:end),'b.-','LineWidth',2,'MarkerSize',12)
    hold on
    errorbar(0.15, FEdata.spatialFrequencyResp(3,2),FEdata.spatialFrequencyResp(7,2),'^b', 'MarkerSize',5) % white flash
    errorbar(0.15, FEdata.spatialFrequencyResp(3,3),FEdata.spatialFrequencyResp(7,2),'vb', 'MarkerSize',5) % black flash
    blankResp = FEdata.spatialFrequencyResp(3,1);
    plot([0.01 45], [blankResp blankResp],'b') % blank
    errorbar(0.3,blankResp,FEdata.spatialFrequencyResp(7,1),'b')
    
    errorbar(AEdata.spatialFrequencyResp(1,4:end),AEdata.spatialFrequencyResp(3,4:end),AEdata.spatialFrequencyResp(7,4:end),'r.-','LineWidth',2,'MarkerSize',12)
    errorbar(0.15, AEdata.spatialFrequencyResp(3,2),AEdata.spatialFrequencyResp(7,2),'^r', 'MarkerSize',5) % white flash
    errorbar(0.15, AEdata.spatialFrequencyResp(3,3),AEdata.spatialFrequencyResp(7,3),'vr', 'MarkerSize',5) % black flash
    blankResp = AEdata.spatialFrequencyResp(3,1);
    plot([0.01 45], [blankResp blankResp],'r') % blank
    errorbar(0.3,blankResp,AEdata.spatialFrequencyResp(7,1),'r')
    
    axis square xy
    set(gca,'box', 'off','color', 'none', 'tickdir','out','XScale','log',...
        'XTick',[0.15 0.3 0.6 1.25 2.5 5 10 20],...
        'XTickLabel',{'0', '0.3', '', '1.25', '', '5', '10', ''},...
        'XTickLabelRotation', 45)
    xlim([0.1 40])
    
    title(sprintf('%s',textName));
    
    xlabel('Spatial Frequency (cpd)')
    ylabel('Response (sp/s)')
    legend('FE','FE white flash', 'FE black flash', 'FE blank',...
        'AE','AE white flash', 'AE black flash', 'AE blank','Location','NorthEastOutside')
end
%% plot orientation tuning
figure
polar(vectAngleRad, oriTune(4,:))
toc

