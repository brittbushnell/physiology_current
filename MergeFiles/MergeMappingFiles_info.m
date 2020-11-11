clear all
close all
clc

%% WV

% V4
% files = {
%     'WV_LE_MapNoise_nsp2_20190130_001_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp2_20190130_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp2_20190201_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp2_20190204_001_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp2_20190204_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp2_20190204_003_thresh35_info3'                   ;
%     };
% newName = 'WV_LE_MapNoise_nsp2_20190130_all_thresh35';

% files = {
%     'WV_RE_MapNoise_nsp2_20190130_003_thresh35_info3'                   ;
%     'WV_RE_MapNoise_nsp2_20190130_004_thresh35_info3'                   ;
%     'WV_RE_MapNoise_nsp2_20190201_001_thresh35_info3'                   ;
%     'WV_RE_MapNoise_nsp2_20190205_001_thresh35_info3'                   ;
%      };
% newName = 'WV_RE_MapNoise_nsp2_20190130_all_thresh35';

% V1
% files = {
%     'WV_LE_MapNoise_nsp1_20190130_001_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp1_20190130_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp1_20190201_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp1_20190204_001_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp1_20190204_002_thresh35_info3'                   ;
%     'WV_LE_MapNoise_nsp1_20190204_003_thresh35_info3'                   ;
%     };
% newName = 'WV_LE_MapNoise_nsp1_20190130_all_thresh35';
%
files = {
    'WV_RE_MapNoise_nsp1_20190130_003_thresh35_ogcorrupt_info3'         ;
    'WV_RE_MapNoise_nsp1_20190130_004_thresh35_ogcorrupt_info3'         ;
    'WV_RE_MapNoise_nsp1_20190201_001_thresh35_ogcorrupt_info3'         ;
    'WV_RE_MapNoise_nsp1_20190205_001_thresh35_ogcorrupt_info3'         ;
    };
newName = 'WV_RE_MapNoise_nsp1_Jan2019_all_thresh35_info';
%% XT

% V4
% files = {
%    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35';
%    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35';
%    'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35';
% };
% newName = 'XT_LE_mapNoiseRight_nsp2_20181120_all_thresh35';

% files = {
%    'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35';
%    'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35';
% };
% newName = 'XT_RE_mapNoiseRight_nsp2_20181026_all_thresh35';

% V1
% files = {
%    'XT_LE_mapNoiseRight_nsp1_20181120_001_thresh35';
%    'XT_LE_mapNoiseRight_nsp1_20181120_002_thresh35';
%    'XT_LE_mapNoiseRight_nsp1_20181120_003_thresh35';
% };
% newName = 'XT_LE_mapNoiseRight_nsp1_20181120_all_thresh35';

% files = {
%    'XT_RE_mapNoiseRight_nsp1_20181026_001_thresh35';
%    'XT_RE_mapNoiseRight_nsp1_20181026_003_thresh35';
% };
% newName = 'XT_RE_mapNoiseRight_nsp1_20181026_all_thresh35';
%% WU
% files = {
%    'WU_LE_Gratmap_nsp2_20170428_003_thresh35';
%    'WU_LE_Gratmap_nsp2_20170428_004_thresh35';
% };
% newName = 'WU_LE_Gratmap_nsp2_20170428_all_thresh35';

% files = {
%    'WU_LE_Gratmap_nsp1_20170428_003_thresh35';
%    'WU_LE_Gratmap_nsp1_20170428_004_thresh35';
% };
% newName = 'WU_LE_Gratmap_nsp1_20170428_all_thresh35';
%%
location = determineComputer;
for fi = 1:size(files,1)
    filename = files{fi,:};
    load(filename);
    if contains(filename,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    
    if contains(filename,'XX')
        dataT.fix_x = -1;
        dataT.fix_y = 2;
        if contains(filename,'nsp2')
            dataT.bins = dataT.binsV4;
        else
            dataT.bins = dataT.binsV1;
        end
    end
    % adjust locations so fixation is at (0,0). This will also allow us to
    % combine across runs with different locations to get full maps.
    
    if contains(filename,'WU')
        dataT.pos_x = dataT.xoffset;
        dataT.pos_y = dataT.yoffset;
    end
    
    dataT.fix_xOrig = dataT.fix_x;
    dataT.fix_x = dataT.fix_x - dataT.fix_x;
    dataT.pos_xOrig = dataT.pos_x;
    dataT.pos_x = dataT.pos_x - double(unique(dataT.fix_xOrig));
    
    dataT.fix_yOrig = dataT.fix_y;
    dataT.fix_y = dataT.fix_y - dataT.fix_y;
    dataT.pos_yOrig = dataT.pos_y;
    dataT.pos_y = dataT.pos_y - double(unique(dataT.fix_yOrig));
    dataTComp{fi} = dataT;
    
end
%% Concatenate sections
action = [];
bins   = [];
filename = [];
fix_x = [];
fix_y = [];
pos_x = [];
pos_y = [];
rotation = [];
size_x  = [];
stimOn  = [];
stimOff = [];
t_stim  = [];
spatial_frequency = [];
phase = [];
contrast = [];

% added 11/11
stimulus = [];
blankSpikeCount = [];
stimSpikeCount = [];
stimSpikeCountAllLoc = [];
blankZscore = [];
stimZscore = [];
stimZscoreAllLoc = [];
fix_xOrig = [];
fix_yOrig = [];
pos_xOrig = [];
pos_yOrig = [];

for i = 1:length(dataTComp)
    bT     = dataTComp{i}.bins;
    fx     = dataTComp{i}.fix_x;
    fy     = dataTComp{i}.fix_y;
    rot    = dataTComp{i}.rotation;
    stmOn  = dataTComp{i}.stimOn;
    stmOff = dataTComp{i}.stimOff;
    tStim  = dataTComp{i}.t_stim;
    bSC = dataTComp{i}.blankSpikeCount;
    sSC = dataTComp{i}.stimSpikeCount;
    lSC = dataTComp{i}.stimSpikeCountAllLoc;
    bZ  = dataTComp{i}.blankZscore;
    sZ  = dataTComp{i}.stimZscore;
    lZ  = dataTComp{i}.stimZscoreAllLoc;
    fXog= dataTComp{i}.fix_xOrig;
    fYog= dataTComp{i}.fix_yOrig;
    pXog= dataTComp{i}.pos_xOrig;
    pYog= dataTComp{i}.pos_yOrig;
    
    if ~contains(files{fi,:},'WU') %there are a few things that are named differently because WU was run with gratings instead of pngs
        fnm    = dataTComp{i}.filename;
        filename = cat(1, filename, fnm);
        szx    = dataTComp{i}.size_x;
        xPos = dataTComp{i}.pos_x;
        yPos = dataTComp{i}.pos_y;
        stim = dataTComp{i}.stimulus;
        stimulus = [stimulus, stim];
        
    else
        %%
        szx = dataTComp{i}.width;
        xPos = dataTComp{i}.xoffset;
        yPos = dataTComp{i}.yoffset;
        sf = dataTComp{i}.spatial_frequency;
        spatial_frequency = [spatial_frequency, sf];
        ph = dataTComp{i}.current_phase;
        phase = [phase, ph];
        con = dataTComp{i}.contrast;
        contrast = [contrast,con];
    end
    %%
    bins = cat(1, bins, bT);
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    rotation = [rotation, rot];
    size_x = [size_x, szx];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    
    blankSpikeCount = cat(2,blankSpikeCount, bSC);
    blankZscore = cat(2,blankZscore, bZ);
    stimSpikeCountAllLoc = cat(2,stimSpikeCountAllLoc, lSC);
    stimZscoreAllLoc = cat(2,stimZscoreAllLoc, lZ);
    
    stimSpikeCount = cat(4,stimSpikeCount, sSC);
    stimZscore = cat(4,stimZscore, sZ);
    
    
    fix_xOrig = [fix_xOrig, fXog];
    fix_yOrig = [fix_yOrig, fYog];
    pos_xOrig = [pos_xOrig, pXog];
    pos_yOrig = [pos_yOrig, pYog];
end
%% add things that are consistent across all sessions/repeats
amap = dataT.amap;
animal = dataT.animal;
eye = dataT.eye;
array = dataT.array;
programID = dataT.programID;
runNum = 'all';
reThreshold = dataT.reThreshold;
%% save new matrix
if contains(files(1,:),'V1') || contains(files(1,:),'nsp1')
    if location == 3
        cd /home/bushnell/matFiles/V1/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/mapNoise/info/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/mapNoise/info/
    end
else
    if location == 3
        cd  /home/bushnell/matFiles/V4/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/mapNoise/info/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/mapNoise/info/
    end
end

if~contains(files{fi,:},'WU')
    save(newName,'bins','rotation','size_x','stimOn','stimOff','t_stim','filename',...
        'pos_x','pos_y','fix_x','fix_y','stimulus',...
        'blankSpikeCount','stimSpikeCount','stimSpikeCountAllLoc',...
        'blankZscore','stimZscore','stimZscoreAllLoc',...
        'fix_xOrig','fix_yOrig','pos_xOrig','pos_yOrig',...
        'amap','animal','eye','array','programID','runNum','reThreshold')
else
    save(newName,'bins','rotation','size_x','stimOn','stimOff','t_stim',...
        'pos_x','pos_y','fix_x','fix_y','spatial_frequency','phase','contrast',...
        'blankSpikeCount','stimSpikeCount','stimSpikeCountAllLoc',...
        'blankZscore','stimZscore','stimZscoreAllLoc',...
        'fix_xOrig','fix_yOrig','pos_xOrig','pos_yOrig',...
        'amap','animal','eye','array','programID','runNum','reThreshold')
end

fprintf('file %s done \n', newName)
