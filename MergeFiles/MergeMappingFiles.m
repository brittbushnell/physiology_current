clear all
close all
clc

%% WV

% V4
% files = { 
%     'WV_LE_MapNoise_nsp2_20190130_001_thresh35';
%     'WV_LE_MapNoise_nsp2_20190130_002_thresh35';
%     };
% newName = 'WV_LE_MapNoise_nsp2_20190130_all_thresh35';

% files = {
%      'WV_RE_MapNoise_nsp2_20190130_003_thresh35.mat';           
%      'WV_RE_MapNoise_nsp2_20190130_004_thresh35.mat';
%      };
% newName = 'WV_RE_MapNoise_nsp2_20190130_all_thresh35';

% V1
% files = {     
%     'WV_LE_MapNoise_nsp1_20190130_001_thresh35';
%     'WV_LE_MapNoise_nsp1_20190130_002_thresh35';
%     };
% newName = 'WV_LE_MapNoise_nsp1_20190130_all_thresh35';

% files = {
%      'WV_RE_MapNoise_nsp1_20190130_003_thresh35.mat';           
%      'WV_RE_MapNoise_nsp1_20190130_004_thresh35.mat';
%      };
% newName = 'WV_RE_MapNoise_nsp1_20190130_all_thresh35';
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

files = {
   'WU_LE_Gratmap_nsp1_20170428_003_thresh35';
   'WU_LE_Gratmap_nsp1_20170428_004_thresh35';
};
newName = 'WU_LE_Gratmap_nsp1_20170428_all_thresh35';
%%
location = determineComputer;
for fi = 1:size(files,1)
    filename = files{fi,:};
    data = load(filename);
    
    if contains(filename,'XX')
        data.fix_x = -1;
        data.fix_y = 2;
        if contains(filename,'nsp2')
            data.bins = data.binsV4;
        else
            data.bins = data.binsV1;
        end
    end
    % adjust locations so fixation is at (0,0). This will also allow us to
    % combine across runs with different locations to get full maps.
    
    if contains(filename,'WU')
        data.pos_x = data.xoffset;
        data.pos_y = data.yoffset;
    end

    data.fix_xOrig = data.fix_x;
    data.fix_x = data.fix_x - data.fix_x;
    data.pos_xOrig = data.pos_x;
    data.pos_x = data.pos_x - double(unique(data.fix_xOrig));
    
    data.fix_yOrig = data.fix_y;
    data.fix_y = data.fix_y - data.fix_y;
    data.pos_yOrig = data.pos_y;
    data.pos_y = data.pos_y - double(unique(data.fix_yOrig));
    dataComp{fi} = data;
    
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

for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    fx     = dataComp{i}.fix_x;
    fy     = dataComp{i}.fix_y;
    rot    = dataComp{i}.rotation;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    
    if ~contains(files{fi,:},'WU') %there are a few things that are named differently because WU was run with gratings instead of pngs
        fnm    = dataComp{i}.filename;
        filename = cat(1, filename, fnm);
%         if fi == 6
%             szx = [];
%         else
        szx    = dataComp{i}.size_x;
%         end
        xPos = dataComp{i}.pos_x;
        yPos = dataComp{i}.pos_y;
    else
        szx = dataComp{i}.width;
        xPos = dataComp{i}.xoffset;
        yPos = dataComp{i}.yoffset;
        sf = dataComp{i}.spatial_frequency;
        spatial_frequency = [spatial_frequency, sf];
        ph = dataComp{i}.current_phase;
        phase = [phase, ph];
        con = dataComp{i}.contrast;
        contrast = [contrast,con];
    end
    
    bins = cat(1, bins, bT);
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    rotation = [rotation,rot];
    size_x = [size_x,szx];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos]; 
end
%% save new matrix
if contains(files(1,:),'V1') || contains(files(1,:),'nsp1')
    if location == 3
        cd /home/bushnell/matFiles/V1/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/mapNoise/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/mapNoise
    end
else
    if location == 3
        cd  /home/bushnell/matFiles/V4/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/mapNoise/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/mapNoise/
    end
end

if~contains(files{fi,:},'WU')
    save(newName,'bins','rotation','size_x','stimOn','stimOff','t_stim','filename',...
        'pos_x','pos_y','fix_x','fix_y')
else
    save(newName,'bins','rotation','size_x','stimOn','stimOff','t_stim',...
        'pos_x','pos_y','fix_x','fix_y','spatial_frequency','phase','contrast')
end

fprintf('file %s done \n', newName)
%%
%% WV

% files = {
%      'WV_LE_MapNoise_nsp2_20190122_003_thresh35';
%      'WV_LE_MapNoise_nsp2_20190130_001_thresh35';
%      'WV_LE_MapNoise_nsp2_20190130_002_thresh35';
%     };
% newName = 'WV_LE_MapNoise_nsp2_Jan2019_all_thresh35';

% files = {
%     'WV_RE_MapNoise_nsp2_20190130_003_thresh35';
%      'WV_RE_MapNoise_nsp2_20190130_004_thresh35';
%     };
% newName = 'WV_RE_MapNoise_nsp2_Jan2019_all_thresh35';

% files = {
%      'WV_LE_MapNoise_nsp2_20190122_003';
%      'WV_LE_MapNoise_nsp2_20190130_001';
%      'WV_LE_MapNoise_nsp2_20190130_002';
%     };
% newName = 'WV_LE_MapNoise_nsp2_Jan2019_all';

% files = {
%     'WV_RE_MapNoise_nsp2_20190130_003';
%      'WV_RE_MapNoise_nsp2_20190130_004';
%     };
% newName = 'WV_RE_MapNoise_nsp2_Jan2019_all';
%% XT
%  files = {
%     'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35.mat';
%     'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35.mat';
%  };
%  newName = 'XT_LE_mapNoiseVarCheck_nsp2_nov20182_all_thresh35';

%  files = {
% 'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35.mat';
% 'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35.mat';
% 'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35.mat';
% };
% newName = 'XT_RE_mapNoiseVarCheck_nsp2_nov2018_all_thresh35';

% raw
%  files = {
%     'XT_LE_mapNoiseRight_nsp2_20181105_003';
%     'XT_LE_mapNoiseRight_nsp2_20181105_004';
%     'XT_LE_mapNoiseRight_nsp2_20181120_001';
%     'XT_LE_mapNoiseRight_nsp2_20181120_002';
%     'XT_LE_mapNoiseRight_nsp2_20181120_003';
%     'XT_LE_mapNoiseRight_nsp2_20181127_001';
%  };
%  newName = 'XT_LE_mapNoiseVarCheck_nsp2_nov20182_all';

%  files = {
% 'XT_RE_mapNoiseRight_nsp2_20181026_001';
% 'XT_RE_mapNoiseRight_nsp2_20181026_003';
% 'XT_RE_mapNoiseRight_nsp2_20181119_001';
% };
% newName = 'XT_RE_mapNoiseVarCheck_nsp2_nov2018_all';

%% WU
% files = {'WU_RE_GratingsMapRF_nsp2_20170814_001_thresh35';
%     'WU_RE_GratingsMapRF_nsp2_20170814_002_thresh35';
%     'WU_RE_GratingsMapRF_nsp2_20170815_001_thresh35';
%     };
% newName = 'WU_RE_GratingsMapRF_nsp2_20170814_all_thresh35';
% 
% files = {'WU_RE_GratingsMapRF_nsp1_20170814_001_thresh35';
%     'WU_RE_GratingsMapRF_nsp1_20170814_002_thresh35';
%     'WU_RE_GratingsMapRF_nsp1_20170815_001_thresh35';
%     };
% newName = 'WU_RE_GratingsMapRF_nsp1_20170814_all_thresh35';