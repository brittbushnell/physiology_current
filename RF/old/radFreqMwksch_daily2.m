%
%% Comment out when running as a function
clear all
close all
clc
tic
%% Run by day
% V1;
files = ['WU_LE_RadFreqLoc2_nsp1_20170707_002';
    'WU_LE_RadFreqLoc2_nsp1_20170706_004';
    'WU_LE_RadFreqLoc2_nsp1_20170705_004';
    'WU_LE_RadFreqLoc2_nsp1_20170705_005';
    'WU_LE_RadFreqLoc1_nsp1_20170628_004';
    
    'WU_RE_RadFreqLoc2_nsp1_20170707_005';
    'WU_RE_RadFreqLoc2_nsp1_20170706_002';
    'WU_RE_RadFreqLoc2_nsp1_20170705_002';
    'WU_RE_RadFreqLoc1_nsp1_20170628_002';
    'WU_RE_RadFreqLoc1_nsp1_20170627_002';
    
    'WU_LE_RadFreqLoc2_nsp2_20170707_002';
    'WU_LE_RadFreqLoc2_nsp2_20170706_004';
    'WU_LE_RadFreqLoc2_nsp2_20170705_004';
    'WU_LE_RadFreqLoc2_nsp2_20170705_005';
    'WU_LE_RadFreqLoc1_nsp2_20170628_004';
    
    'WU_RE_RadFreqLoc2_nsp2_20170707_005';
    'WU_RE_RadFreqLoc2_nsp2_20170706_002';
    'WU_RE_RadFreqLoc2_nsp2_20170705_002';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002';
    'WU_RE_RadFreqLoc1_nsp2_20170627_002'];
%%
location = 2; %0 = laptop 1 = desktop 2 = zemina
startBin = 5;
endBin = 35;

if location == 2
    addpath(genpath('/home/bushnell/ArrayAnalysis/'))
    addpath(genpath('/home/bushnell/Figures/'))
    addpath(genpath('/home/bushnell/binned_data/'))
    addpath(genpath('/home/bushnell/matFiles/'))
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
    
    %% Find responses to each stimulus
    
    RFStimResp = parseRadFreqStimResp(data,startBin,endBin);
    
    data.stimResps = RFStimResp;
    
    for ch = 1:numChannels
        if ~isempty(RFStimResp{ch})
            for t = 1:5
                if strfind(filename,'nsp1')
                    if strfind(filename,'RE')
                        REblanksV1(t,ch) = RFStimResp{ch}(1,1);
                    else
                        LEblanksV1(t,ch) = RFStimResp{ch}(1,1);
                    end
                else
                    if strfind(filename,'RE')
                        REblanksV4(t,ch) = RFStimResp{ch}(1,1);
                    else
                        LEblanksV4(t,ch) = RFStimResp{ch}(1,1);
                    end
                end
            end
        end
    end
end
if strfind(filename,'nsp1')
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadFreq/FittedMats/daily
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/FittedMats/daily
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadFreq/FittedMats/daily
    end
end
%% save new data matrix
%  save(newName,'data')

toc