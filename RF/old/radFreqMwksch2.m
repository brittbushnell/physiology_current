% gratMwksCh
% Analyze grating responses by channel
%

clear all
close all
clc
tic
%% Variables passed in when function
location = 1;
files = ['WU_LE_RadFreq_nsp2_June2017';'WU_RE_RadFreq_nsp2_June2017'];
%files = ['WU_LE_RadFreq_nsp1_June2017';'WU_RE_RadFreq_nsp1_June2017'];
dispPSTH = 0;
beRFVerbose = 0;
beAmpVerbose = 0;
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
%%
structKey = makeGratMwksStructKey;
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    [animal,eye, program, array, date] = parseFileName(filename);
    
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    xloc = unique(data.pos_x);
    yloc = unique(data.pos_y);
    
    numChannels = size(data.bins,3);
    data.amap = aMap;
    data.stimTime = [binStimOn,binStimOff];
    
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
        
        data.rf(1,i)  = rf;
        data.amplitude(1,i) = mod;
        data.orientation(1,i) = ori;
        data.spatialFrequency(1,i) = sf;
        data.radius(1,i) = rad; %remember, size of RF stimuli is in mean radius
        name  = char(name);
        data.name(:,i) = name;
        
        % Blanks values are set to:
        % rf  = 10000;
        % mod = 10000;
        % ori = 10000;
        % sf  = 100;
        % rad = 100;
    end
    
    name = unique(data.filename,'rows');
    rfs  = unique(data.rf(1,:));
    amps = unique(data.amplitude(1,:));
    oris = unique(data.orientation(1,:));
    sfs  = unique(data.spatialFrequency(1,:));
    rads = unique(data.radius(1,:));
    %% PSTH
    if dispPSTH == 1
        for ch = 1:numChannels
            blankNdx(ch,:) = find(data.rf > 999);
            stimNdx(ch,:)  = find(data.rf < 50);
        end
        textName = [textName, stim vs blank];
        psthFigMwksArray(data, textName, blankNdx, stimNdx)
        clear blankNdx
        clear stimNdx
    end
    if dispPSTH == 1
        for ch = 1:numChannels
            circleNdx(ch,:) = find(data.rf == 32);
            rfNdx(ch,:)  = find(data.rf < 32);
        end
        textName = [textName, RF vs Circle];
        psthFigMwksArray(data, textName, circleNdx, rfNdx)
        clear circleNdx
        clear rfNdx
    end
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
    for ch = 1:numChannels
        if rem(ch,6) == 0 || ch == 1
            fprintf('%d ',ch)
        end
        latency(1,ch) = getLatencyMwks(data.bins, binStimOn*2, 10, ch);
        latency(2,ch) = latency(1,ch) +binStimOn;
    end
    data.latency = latency;
    %% Get responses across parameters
    % NOTE: data.bins is organized into a 3 dimensional matrix organized by:
    % successful presentations, 50 10ms bins after stim presentations, channels
    % That means that spikes(1,:,1) would give the # of threshold crossings
    % on channel #1 in response to first stimulus in 10ms time bins for 500ms
    
    rfAmpT = nan(6,9);
    
    for ch = 1:numChannels
        % separate by location
        for x = 1:size(xloc,1)
            for y = 1:size(yloc,1)
                % collapse across locations
                % collapse across all RFs
                for i = 1:size(rfs,1)
                    rfs(2,i) = sum(data.rf == rfs(1,i));
                    tmpNdx   = find(data.rf == rfs(1,i));
                    useRuns  = data.bins(tmpNdx,latency(1,ch):latency(2,ch),ch);
                    useRuns  = double(useRuns);
                    rfs(3,i) = mean(mean(useRuns))./0.010;
                    
                    stErr    = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                    rfs(4,i) = rfs(i,3) - stErr;
                    rfs(5,i) = rfs(i,3) + stErr;
                    rfs(6,i) = stErr;
                    
                    % collapse across all amplitudes
                    for m = 1:size(amps,1)
                        rfAmpT(1,m) = rfs(1,i);
                        rfAmpT(2,m) = amps(1,m);
                        rfAmpT(3,m) = sum((data.amplitude == amps(1,m)) .* (data.rf == rfs(1,i)));
                        tmpNdx      = find((data.amplitude == amps(1,m)) .* (data.rf == rfs(1,i)));
                        useRuns     = data.bins(tmpNdx,latency(1,ch):latency(2,ch),ch);
                        useRuns     = double(useRuns);
                        rfAmpT(4,m) = mean(mean(useRuns))./0.010;
                        
                        if isnan(rfAmpT(4,m)) == 0
                            stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                            rfAmpT(5,m) = rfAmpT(4,m) - stErr;
                            rfAmpT(6,m) = rfAmpT(4,m) + stErr;
                            rfAmpT(7,m) = stErr;
                        end
                    end
                    % Each RF has a cell array of responses at different
                    % amplitudes. Keep in mind, not every RF uses all
                    % amplitudes, and any that weren't used for the given RF
                    % will be NAN
                    rfAmp{i} = rfAmpT;
                    clear rfAmpT
                end
                clear i
                % collapse across all amplitudes
                for am = 1:size(amps,1)
                    amps(2,am) = sum(data.amplitude == amps(1,am));
                    tmpNdx     = find(data.amplitude == amps(1,am));
                    useRuns    = data.bins(tmpNdx,latency(1,ch):latency(2,ch),ch);
                    useRuns    = double(useRuns);
                    amps(3,am) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(amps(3,am))
                        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                        amps(4,am) = amps(3,am) - stErr;
                        amps(5,am) = amps(3,am) + stErr;
                        amps(6,am) = stErr;
                    end
                end
                clear am
                % collapse across all sizes
                for s = 1:size(rads,1)
                    rads(2,s) = sum(data.radius == rads(1,s));
                    tmpNdx    = find(data.radius == rads(1,s));
                    useRuns   = data.bins(tmpNdx,latency(1,ch):latency(2,ch),ch);
                    useRuns   = double(useRuns);
                    rads(3,s) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(rads(3,s))
                        stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                        rads(4,s) = rads(3,s) - stErr;
                        rads(5,s) = rads(3,s) + stErr;
                        rads(6,s) = stErr;
                    end
                end
                clear s
                % collapse across all sfs
                for sp = 1:size(sfs,1)
                    sfs(2,sp) = sum(data.spatialFrequency == sfs(1,sp));
                    tmpNdx    = find(data.spatialFrequency == sfs(1,sp));
                    useRuns   = data.bins(tmpNdx,latency(1,ch):latency(2,ch),ch);
                    useRuns   = double(useRuns);
                    sfs(3,sp) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(sfs(3,sp))
                        stErr     = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                        sfs(4,sp) = sfs(3,sp) - stErr;
                        sfs(5,sp) = sfs(3,sp) + stErr;
                        sfs(6,sp) = stErr;
                    end
                end
                clear sp
            end
        end
        data.radFreqResponse{ch} = rfs;
        data.radiusResponse{ch} = rads;
        data.ampResponse{ch} = amps;
        data.sfResponse{ch} = sfs;
        data.rfAmpResponse{ch} = rfAmp;
    end
    %% Create eye specific data structures
    if strfind(filename,'LE')
        LEdata = data;
    else
        REdata = data;
    end
end
%%













