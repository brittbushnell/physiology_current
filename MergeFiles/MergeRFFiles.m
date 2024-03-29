% MergeGratFiles
% This version of the merge code will combine good channels from each day
% input files need to be from one eye only. Run this first if combining
% days


%%
clear
close all
clc
tic

location = 0; %0 = laptop 1 = Desktop 2 = zemina
%%
% WU LE radFreqLoc1 is one file.
% Hopefully radFreqLoc1 is best in terms of locations - that was the set
% where V1/V2 and V4 were collected simultaneously. 

files = {'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat'};
newName = 'WU_RE_radFreqLoc1_nsp2_June2017_info';

% files = {    'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35_info.mat'};
% newName = 'WU_RE_radFreqLoc1_nsp1_June2017_info';
% 
% files = {    'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35_info.mat';              
%     'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35_info.mat'};
% newName ='WU_LE_RadFreqLoc2_nsp2_July2017_info';
% 
% files = {'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35_info.mat';
%     'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35_info.mat'};
% newName = 'WU_LE_RadFreqLoc2_nsp1_July2017_info';
% 
% files = { 'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35_info.mat';
%     'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp2_July2017_info';
% 
% files = {'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35_info.mat';              
%     'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35_info.mat'};
% newName = 'WU_RE_RadFreqLoc2_nsp1_July2017_info';
%% Extract stimulus information

for fi = 1:size(files,1)
    filename = files{fi};
    load(filename);
   
    if contains(filename,'RE') == 1
        dataT = data.RE;
    elseif contains(filename,'LE') == 1
        dataT = data.LE;
    end
     
    dataComp{fi} = dataT;
end
%% Concatenate sections

bins =     [];
stimOn =   [];
stimOff =  [];
t_stim =   [];
filename = [];

pos_x =    [];
pos_y =    [];
rf =        [];
amplitude = [];
orientation = [];
spatialFrequency = [];
radius = [];
name = [];

RFStimResps = [];
blankResps = [];
stimResps = [];
RFspikeCount = [];
blankSpikeCount = [];
RFzScore = [];
blankZscore = []; 


for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    fName  = dataComp{i}.filename;
    
    xPos = dataComp{i}.pos_x;
    yPos = dataComp{i}.pos_y;
    radF = dataComp{i}.rf;
    amp = dataComp{i}.amplitude;
    ori = dataComp{i}.orientation;
    sf = dataComp{i}.spatialFrequency;
    rad = dataComp{i}.radius;
    nom = dataComp{i}.name;
    
    rfResp = dataComp{i}.RFStimResps;
    bResp = dataComp{i}.blankResps;
    sResp = dataComp{i}.stimResps;
    
    Rsc = dataComp{i}.RFspikeCount;
    bsc = dataComp{i}.blankSpikeCount;
    rz = dataComp{i}.RFzScore;
    bz = dataComp{i}.blankZscore;
    
    bins = cat(1, bins, bT);
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    filename = cat(1, filename, fName);
    
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    rf = [rf; radF];
    amplitude = [amplitude; amp];
    orientation = [orientation; ori];
    spatialFrequency = [spatialFrequency; sf];
    radius = [radius; rad];
    name = cat(1, name, nom);
    
    for ch = 1:96
        RFStimResps = [RFStimResps, ];
        blankResps = [];
        stimResps = [];
        RFspikeCount = [];
        blankSpikeCount = [];
        RFzScore = [];
        blankZscore = [];
    end
    
end

if exist('data.amap') == 0  
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
        amap = arraymap('SN 1024-001795.cmp');
        
    elseif ~isempty(strfind(files(1,:),'V1')) || ~isempty(strfind(files(1,:),'nsp1'))
        disp 'data recorded from nsp1, V1/V2 array'
        amap = arraymap('SN 1024-001790.cmp');
        
    else
        error('Error: array ID missing or wrong')
    end
    
else
    amap = dataT.amap;
end

%% save new matrix
if strfind(files(1,:),'V1') | strfind(files(1,:),'nsp1')    
    if location == 2
        cd /home/bushnell/matFiles/V1/RadialFrequency/mergedMats/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/RadialFrequency/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/RadialFrequency/mergedMats/
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/RadialFrequency/mergedMats/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V4/RadialFrequency/mergedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/RadialFrequency/mergedMats/
    end
end
save(newName,'bins','amap','stimOn','stimOff','t_stim','filename',...
             'pos_x','pos_y','rf','amplitude','orientation','spatialFrequency',...
             'radius','name')









