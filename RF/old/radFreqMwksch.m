%function [data] = radFreqMwksch(filename, location, errType, numBoots,beAmpVerbose, beRFVerbose)
%
% Analysis code for MWorks RadFreq program using .mat files that have been
% merged using .py code from Darren.
%
% Created Feb 22, 2017
% Brittany Bushnell

%% NOTES
%     textName = figTitleName(filename); to make better figure titles and
%     get rid of all of the if statements.  Call right after load(filename)


%% Comment out when running as a function
clear all
close all
clc
tic
%% Variables passed in when function
location = 1; %1 = amfortas
files = ['WU_LE_RadFreq_nsp2_June2017'; 'WU_RE_RadFreq_nsp2_June2017'];
dispPSTH = 1;
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
%% load data and extract info
for fi = 1:size(files,1)
    filename = files(1,:);
    data = load(filename);
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    
    % Find unique x and y locations used
    xloc = unique(data.pos_x);
    yloc = unique(data.pos_y);
    
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    
    % Save array layout
    data.amap = aMap;
    % all of the other unique parameters are stored in the file name and needs
    % to be parsed out.
    for i = 1:length(data.filename)
        [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
        rfParams(1,i) = rf;
        rfParams(2,i) = mod;
        rfParams(3,i) = ori;
        rfParams(4,i) = sf;
        rfParams(5,i) = rad;
        
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
    % find unique stimuli run
    rfs  = unique(data.rf(:,1));
    amps = unique(data.amplitude(:,1));
    oris = unique(data.orientation(:,1));
    sfs  = unique(data.spatialFrequency(:,1));
    rads = unique(data.radius(:,1));
    
    numChannels = size(data.bins,3);

    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    disp(sprintf('Stim on: %d   Stim off: %d',stimOn, stimOff))
    %% PSTH
    % create a psth figure that compares the response to a blank stimulus
    % with the rersponse to any stimulus
    if dispPSTH == 1
        for ch = 1:numChannels
            blankNdx(ch,:) = find(data.rf > 999);
            stimNdx(ch,:)  = find(data.rf < 50);
        end
        textName = [textName, 'stim vs blank'];
        psthFigMwksArray(data, textName, blankNdx, stimNdx)
        clear blankNdx
        clear stimNdx
    end
    % create a psth figure that compares the response to a circle
    % with the rersponse to any RF stimulus
    if dispPSTH == 1
        for ch = 1:numChannels
            circleNdx(ch,:) = find(data.rf == 32);
            rfNdx(ch,:)  = find(data.rf < 32);
        end
        textName = [textName, 'RF vs Circle'];
        psthFigMwksArray(data, textName, circleNdx, rfNdx)
        clear circleNdx
        clear rfNdx
    end
    %% Define good channels
    goodChannels = MwksGetGoodCh(data,filename,0); % setting the 3rd input to 1 makes it ignore all suppressive channels
    disp(sprintf('There are %d good channels in file %s', length(goodChannels), filename))
    data.goodChannels = goodChannels;
    %% Get responses across parameters
    % NOTE: data.bins is organized into a 3 dimensional matrix organized by:
    % successful presentations, 50 10ms bins after stim presentations, channels
    % That means that spikes(1,:,1) would give the # of threshold crossings
    % on channel #1 in response to first stimulus in 10ms time bins 
    
    rfAmpT = nan(9,6);
    
    for ch = 1:numChannels
        if rem(ch,6) == 0 || ch == 1
            fprintf('%d ',ch)
        end
        
        % Get Latency
%         latency = getLatencyMwks(data.bins,20,10,ch);
%         endBin  = latency+numBins;
%         data.latency(1,ch) = latency;
%         data.latency(2,ch) = endBin;
        startBin = ones(1,96).* 5;
        endBin   = ones(1,96).* 15;
        data.latency = [startBin; endBin];
        
        % separate by location
        for x = 1:size(xloc,1)
            for y = 1:size(yloc,1)
                % collapse across locations
                
                % collapse across all RFs
                for i = 1:size(rfs,1)
                    rfs(i,2) = sum(data.rf == rfs(i,1));
                    tmpNdx   = find(data.rf == rfs(i,1));
                    useRuns  = data.bins(tmpNdx,latency:endBin,ch);
                    useRuns  = double(useRuns);
                    rfs(i,3) = mean(mean(useRuns))./0.010;
                    
                    if errType == 1
                        stErr    = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                        %rfs(i,4) = rfs(i,3) - stErr;
                        %rfs(i,5) = rfs(i,3) + stErr;
                        rfs(i,4) = stErr;
                    else
                        % bootstrap confidence intervals
                        errBounds = bootci(numBoots,@mean,useRuns(:));
                        rfs(i,4) = errBounds(1,1);
                        rfs(i,5) = errBounds(2,1);
                    end
                    
                    % collapse across all amplitudes
                    for m = 1:size(amps,1)
                        rfAmpT(m,1) = rfs(i,1);
                        rfAmpT(m,2) = amps(m,1);
                        rfAmpT(m,3) = sum((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                        tmpNdx      = find((data.amplitude == amps(m,1)) .* (data.rf == rfs(i,1)));
                        useRuns     = data.bins(tmpNdx,latency:endBin,ch);
                        useRuns     = double(useRuns);
                        rfAmpT(m,4) = mean(mean(useRuns))./0.010;
                        
                        if isnan(rfAmpT(m,4)) == 0
                            if errType == 1
                                stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                                %rfAmpT(m,5) = rfAmpT(m,4) - stErr;
                                %rfAmpT(m,6) = rfAmpT(m,4) + stErr;
                                rfAmpT(m,5) = stErr;
                            else
                                % 95% confidence intervals
                                
                                errBounds  = bootci(numBoots,@mean,useRuns(:));
                                rfAmpT(m,5) = errBounds(1,1);
                                rfAmpT(m,6) = errBounds(2,1);
                            end
                        end
                    end
                    % Each RF has a cell array of responses at different
                    % amplitudes. Keep in mind, not every RF uses all
                    % amplitudes, and any that weren't used for the given RF
                    % will be NAN
                    rfAmp{i} = rfAmpT;
                    clear rfAmpT
                end
                % collapse across all amplitudes
                for am = 1:size(amps,1)
                    amps(am,2) = sum(data.amplitude == amps(am,1));
                    tmpNdx     = find(data.amplitude == amps(am,1));
                    useRuns    = data.bins(tmpNdx,latency:endBin,ch);
                    useRuns    = double(useRuns);
                    amps(am,3) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(amps(am,3))
                        if errType == 1
                            stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                            %amps(am,4) = amps(am,3) - stErr;
                            %amps(am,5) = amps(am,3) + stErr;
                            amps(am,4) = stErr;
                        else
                            % error bars using 95% confidence intervals
                            errBounds = bootci(numBoots,@mean,useRuns(:));
                            amps(am,4) = errBounds(1,1);
                            amps(am,5) = errBounds(2,1);
                        end
                    end
                end
                % collapse across all sizes
                for s = 1:size(rads,1)
                    rads(s,2) = sum(data.radius == rads(s,1));
                    tmpNdx    = find(data.radius == rads(s,1));
                    useRuns   = data.bins(tmpNdx,latency:endBin,ch);
                    useRuns   = double(useRuns);
                    rads(s,3) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(rads(s,3))
                        if errType == 1
                            stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                            %rads(s,4) = rads(s,3) - stErr;
                            %rads(s,5) = rads(s,3) + stErr;
                            rads(s,4) = stErr;
                        else
                            % 95% confidence intervals
                            errBounds = bootci(numBoots,@mean,useRuns);
                            rads(s,4) = errBounds(1,1);
                            rads(s,5) = errBounds(2,1);
                        end
                    end
                end
                
                % collapse across all sfs
                for sp = 1:size(sfs,1)
                    sfs(sp,2) = sum(data.spatialFrequency == sfs(sp,1));
                    tmpNdx    = find(data.spatialFrequency == sfs(sp,1));
                    useRuns   = data.bins(tmpNdx,latency:endBin,ch);
                    useRuns   = double(useRuns);
                    sfs(sp,3) = mean(mean(useRuns))./0.010;
                    
                    if ~isnan(sfs(sp,3))
                        if errType == 1
                            stErr     = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                            %sfs(sp,4) = sfs(sp,3) - stErr;
                            %sfs(sp,5) = sfs(sp,3) + stErr;
                            sfs(sp,4) = stErr;
                        else
                            % 95% confidence intervals
                            errBounds = bootci(numBoots,@mean,useRuns(:));
                            sfs(sp,4) = errBounds(1,1);
                            sfs(sp,5) = errBounds(2,1);
                        end
                    end
                end
            end
        end
        data.radFreqResponse{ch} = rfs;
        data.radiusResponse{ch} = rads;
        data.ampResponse{ch} = amps;
        data.sfResponse{ch} = sfs;
        data.rfAmpResponse{ch} = rfAmp;
    end
end
%%
%load handel
%sound(y,Fs)
toc