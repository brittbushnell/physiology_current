%function [data] = radFreqMwksch_April(filename, location)
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
%%
% files = ['WU_RE_RadFreqLoc2_nsp2_20170707_005';
%          'WU_RE_RadFreqLoc2_nsp2_20170706_002';
%          'WU_RE_RadFreqLoc2_nsp2_20170705_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170628_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170627_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170626_006';];

% files = ['WU_LE_RadFreqSparse_nsp2_20170609_002';
%          'WU_LE_RadFreqSparse_nsp2_20170607_002'];
    
% files = ['WU_RE_RadFreqSparse_nsp2_20170607_004';
%           'WU_RE_RadFreqSparse_nsp2_20170607_005];
%%
% files = ['WU_LE_RadFreqSparse_nsp2_20170609_002'; 'WU_RE_RadFreqSparse_nsp2_20170607_004'];
% newName = 'WU_RadFreqSparse_V4_July';
files = ['WU_LE_RadFreq_nsp1_June2017'; 'WU_RE_RadFreq_nsp1_June2017'];
newName = 'WU_RadFreq_V1_June2017';
% 
% files = ['WU_LE_RadFreq_nsp2_June2017'; 'WU_RE_RadFreq_nsp2_June2017'];
% newName = 'WU_RadFreq_V4_June2017';

location = 1; %0 = laptop 1 = desktop 2 = zemina
dispPSTH = 0;
%% Check file, get array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    % Zemina
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
%% load data and extract info
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    
    % Find unique x and y locations used
    xloc  = unique(data.pos_x);
    yloc  = unique(data.pos_y);
    
    for y = 1:length(yloc)
        for x = 1:length(xloc)
            posX(x,y) = xloc(x); 
            posY(x,y) = yloc(y);
        end
    end
    
    % Timing
    stimOn  = unique(data.stimOn);
    stimOff = unique(data.stimOff);
    
    % Save array layout
    data.amap = aMap;
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
    % disp(sprintf('Stim on: %d   Stim off: %d',stimOn, stimOff))
    %% Get responses across parameters
    % NOTE: data.bins is organized into a 3 dimensional matrix organized by:
    % successful presentations, 50 10ms bins after stim presentations, channels
    % That means that spikes(1,:,1) would give the # of threshold crossings
    % on channel #1 in response to first stimulus in 10ms time bins
    
    rfAmpT = nan(9,6);
    blankResp = nan(1,numChannels);
    
    for ch = 1%:numChannels
        if rem(ch,6) == 0 || ch == 1
            fprintf('%d ',ch)
        end
        
        latency = 5;
        endBin = 15;
       
        blankNdx = find(data.spatialFrequency == 100);        if strfind(filename,'BE')
            save(newName,'BEdata');
        else
            save(newName,'LEdata','REdata','structKey');
        end
        blankResp(1,ch) = mean(mean(data.bins(blankNdx,latency:endBin,ch)))./0.01;
        data.blankResp = blankResp;
        
        glory = 0;
        % separate by location
        for y = 1:size(yloc,2)
            for x = 1:size(xloc,2)
                % collapse across locations
                %disp(sprintf('(%.1f,%.1f)',xloc(x),yloc(y)))

                tmpNdx   = find((data.pos_x == xloc(1,x)) .* (data.pos_y == yloc(1,y)));
                useRuns  = data.bins(tmpNdx,latency:endBin,ch);
                useRuns  = double(useRuns);
                locs(x,y) = mean(mean(useRuns))./0.01;
                %disp(sprintf('(%d, %d) = %.2f',xloc(x),yloc(y),locs(x,y)))
                stErr    = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
                locStErr(x,y) = stErr;
                locsBS(x,y) = locs(x,y) - blankResp(1,ch);
                
                if locsBS(x,y) > glory
                    glory = locsBS;
                    gloryXY = [xloc(1,x) yloc(1,y)];
                end

            end
        end
        glory = 0;
%         loo = max(locsBS);
%         [~,I] = ind2sub([length(yloc),length(xloc)],loo);
%        prefLoc(1,ch) = locBS(I);
                
        data.locResponse{ch} = locs;
        data.locRespBS{ch} = locsBS;
        data.locStErr{ch} = locStErr;
        data.prefLoc(ch,:) = gloryXY;
        
        % collapse across all sizes
        for s = 1:size(rads,1)
            rads(s,2) = sum(data.radius == rads(s,1) & (data.pos_x == -3) & (data.pos_y == 0)); % limit to the best location
            tmpNdx    = find(data.radius == rads(s,1));
            useRuns   = data.bins(tmpNdx,latency:endBin,ch);
            useRuns   = double(useRuns);
            rads(s,3) = mean(mean(useRuns))./0.010;
            
            if ~isnan(rads(s,3))
                stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                rads(s,4) = stErr;
            end
            
            if rads(s,3) > glory
                glory = rads(s,3);
                gloryRad = rads(s,1);
            end
        end
        glory = 0;
        data.radiusResponse{ch} = rads;
         
        % collapse across all sfs
        for sp = 1:size(sfs,1)
            sfs(sp,2) = sum(data.spatialFrequency == sfs(sp,1) & (data.pos_x == -3) & (data.pos_y == 0));
            tmpNdx    = find(data.spatialFrequency == sfs(sp,1));
            useRuns   = data.bins(tmpNdx,latency:endBin,ch);
            useRuns   = double(useRuns);
            sfs(sp,3) = mean(mean(useRuns))./0.010;
            
            if ~isnan(sfs(sp,3))
                stErr     = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                sfs(sp,4) = stErr;
            end
            
            if sf(sp,3) > glory
                glory = sfs(sp,3);
                gloryRad = sfs(s,1);
            end
        end
        % collapse across all RFs
        for i = 1:size(rfs,1)
            rfs(i,2) = sum(data.rf == rfs(i,1));
            tmpNdx   = find(data.rf == rfs(i,1));
            useRuns  = data.bins(tmpNdx,latency:endBin,ch);
            useRuns  = double(useRuns);
            rfs(i,3) = mean(mean(useRuns))./0.01;
            
            stErr    = std(useRuns(:))/sqrt(length(useRuns(:)))./0.01;
            rfs(i,4) = stErr;
            
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
                    stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                    rfAmpT(m,5) = stErr;
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
                stErr = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
                amps(am,4) = stErr;
            end
        end
    
        data.radFreqResponse{ch} = rfs;
        data.ampResponse{ch} = amps;
        data.sfResponse{ch} = sfs;
        data.rfAmpResponse{ch} = rfAmp;
    end
    
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        LEdata = data;
    end
end
%% save data
if strfind(filename,'nsp1')
    if location == 2
        cd  /home/bushnell/matFiles/V1/RadialFrequency/FittedMats/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/FittedMats/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/FittedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/FittedMats/
        
    end
end
if strfind(filename,'BE')
    save(newName,'BEdata');
else
    save(newName,'LEdata','REdata');
end

%%
%load handel
%sound(y,Fs)

toc/60