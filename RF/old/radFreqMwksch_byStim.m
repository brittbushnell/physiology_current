clear all
close all
clc
tic
%%
% files = ['WU_LE_RadFreq_V1_meanDaily_sub';'WU_RE_RadFreq_V1_meanDaily_sub'];
% newName = 'WU_V1_RadFreq_combined_sub';

% files = ['WU_LE_RadFreq_V4_meanDaily_sub';'WU_RE_RadFreq_V4_meanDaily_sub'];
% newName = 'WU_V4_RadFreq_combined_sub';
%
% files = ['WU_LE_RadFreqLoc2_nsp1_20170707_means1'; 'WU_RE_RadFreqLoc2_nsp1_20170707_means1'];
% newName = 'WU_V1_RadFreq_0707_better';

% files = ['WU_LE_RadFreqLoc2_nsp2_20170707_find'; 'WU_RE_RadFreqLoc2_nsp2_20170707_find'];
% newName = 'WU_V4_RadFreq_0707_find';

files = ['WU_LE_RadFreqLoc2_nsp2_20170707_find3'; 'WU_RE_RadFreqLoc2_nsp2_20170707_find3'];
newName = 'WU_V4_RadFreq_0707_find3';

% files = ['WU_LE_RadFreqLoc2_nsp1_20170707_find2'; 'WU_RE_RadFreqLoc2_nsp1_20170707_find2'];
% newName = 'WU_V1_RadFreq_0707_find2';

location = 1;
binStart = 5;
binEnd = 35;
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
if ~isempty(strfind(files(1,:),'V4')) || ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'V1')) || ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
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
    
    
    
    
    if strfind(filename,'nsp1')
        REGoodCh = [0 0 0 1 1 1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 0 1 0 1 0 0 0 1 1 0 1 0 0 0 1 1 1 1 0 1 0 1 1 1 0 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 0 0 1 1 1 0 1 1 1 1 0 1 1 0 0 1 0 0 0 0 1 1 0 0 1 1 0];
        LEGoodCh = [0 1 0 0 0 0 0 1 1 1 1 0 0 0 0 1 1 0 1 1 1 0 0 0 1 1 0 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 1 1 0 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 0 0 0 1 1 0 0 0 1 0];
        array = 'V1';
    else
        LEGoodCh = [1 0 0 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 0 0 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 1 0 0 0];
        REGoodCh = [1 0 0 1 1 0 1 0 0 0 0 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 1 1 0 1 0 1 1 1 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 1 1 0 0 0 0 0 0 0 0];
        array = 'V4';
    end
    


    
    
    %% Create eye specific data structures before beginning next file
    if strfind(filename,'RE')
        data.goodCh = REGoodCh;
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        data.goodCh = LEGoodCh;
        LEdata = data;
    end
end
%% save data
if strfind(filename,'nsp1')
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/daily
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/FittedMats/daily
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/FittedMats/daily
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/FittedMats/daily
    end
end

if strfind(filename,'BE')
    save(newName,'BEdata');
else
    save(newName,'LEdata','REdata');
end

%%
toc