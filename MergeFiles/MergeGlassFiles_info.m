clear all
close all
clc
%% WU

%{'WU_LE_GlassTR_nsp1_20170822_002_thresh35.mat'} % leaving this file out because there's something really messed up with the V4 version.
% files = {'WU_LE_GlassTR_nsp1_20170824_001_thresh35_info';
%          'WU_LE_GlassTR_nsp1_20170825_002_thresh35_info'};
% newName = 'WU_LE_GlassTR_nsp1_Aug2017_all_thresh35_info';

files = {'WU_LE_GlassTR_nsp2_20170824_001_thresh35_info';
    'WU_LE_GlassTR_nsp2_20170825_002_thresh35_info'};
newName = 'WU_LE_GlassTR_nsp2_Aug2017_all_thresh35_info';

% files = {'WU_LE_Glass_nsp1_20170817_001_thresh35_info';
%          'WU_LE_Glass_nsp1_20170821_002_thresh35_info';
%          'WU_LE_Glass_nsp1_20170822_001_thresh35_info'};
% newName = 'WU_LE_Glass_nsp1_Aug2017_all_thresh35_info';
%
% files = {'WU_LE_Glass_nsp2_20170817_001_thresh35_info';
%          'WU_LE_Glass_nsp2_20170821_002_thresh35_info';
%          'WU_LE_Glass_nsp2_20170822_001_thresh35_info'};
% newName = 'WU_LE_Glass_nsp2_Aug2017_all_thresh35_info';

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
    
    %     if contains(filename,'XX')
    %         dataT.fix_x = -1;
    %         dataT.fix_y = 2;
    %         if contains(filename,'nsp2')
    %             dataT.bins = dataT.binsV4;
    %         else
    %             dataT.bins = dataT.binsV1;
    %         end
    %     end
    
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
% size_x  = [];
stimOn  = [];
stimOff = [];

type = [];
numDots = [];
dx = [];
coh = [];
sample = [];
dxDeg = [];
chReceptiveFieldParams = [];
arrayReceptiveFieldParams = [];
rfQuadrant  = [];
inStim = [];

for i = 1:length(dataTComp)
    bT     = dataTComp{i}.bins;
    fnm    = dataTComp{i}.filename;
    fx     = dataTComp{i}.fix_x;
    fy     = dataTComp{i}.fix_y;
    rot    = dataTComp{i}.rotation;
    stmOn  = dataTComp{i}.stimOn;
    stmOff = dataTComp{i}.stimOff;
    xPos = dataTComp{i}.pos_x;
    yPos = dataTComp{i}.pos_y;
    
    tps  = dataTComp{i}.type;
    ndt  = dataTComp{i}.numDots;
    nx   = dataTComp{i}.dx;
    ch   = dataTComp{i}.coh;
    smp  = dataTComp{i}.sample;
    ddeg = dataTComp{i}.dxDeg;
    chRF = dataTComp{i}.chReceptiveFieldParams;
    arRF = dataTComp{i}.arrayReceptiveFieldParams;
    rfQ  = dataTComp{i}.rfQuadrant;
    inRF = dataTComp{i}.inStim;
    
    bins = cat(1, bins, bT);
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    rotation = [rotation,rot];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    filename = cat(1, filename, fnm);
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    
    type = [type, tps];
    numDots = [numDots, ndt];
    dx = [dx, nx];
    coh = [coh, ch];
    sample = [sample, smp];
    dxDeg = [dxDeg, ddeg];
    chReceptiveFieldParams = [chReceptiveFieldParams, chRF];
    arrayReceptiveFieldParams = [arrayReceptiveFieldParams, arRF];
    rfQuadrant  = [rfQuadrant, rfQ];
    inStim = [inStim, inRF];
end

animal = dataTComp{1}.animal;
eye = dataTComp{1}.eye;
programID = dataTComp{1}.programID;
array = dataTComp{1}.array;
amap = dataTComp{1}.amap;
%% save new matrix
if contains(files(1,:),'V1') || contains(files(1,:),'nsp1')
    if location == 3
        saveDir = '/home/bushnell/matFiles/V1/';
    elseif location == 1
        saveDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/';
    elseif location  == 0
        saveDir = '~/Dropbox/ArrayData/matFiles/V1/Glass/mergedMats/';
    end
else
    if location == 3
        saveDir =  '/home/bushnell/matFiles/V4/';
    elseif location  == 1
        saveDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/';
    elseif location  == 0
        saveDir = '~/Dropbox/ArrayData/matFiles/V4/Glass/mergedMats/';
    end
end

if ~exist(saveDir,'dir')
    mkdir(saveDir)
end
cd(saveDir)
%%

save(newName,'bins','fix_x','fix_y','rotation','stimOn','stimOff','filename',...
    'animal','eye','programID','array','amap',...
    'pos_x','pos_y','type','numDots','dx','coh','sample','dxDeg',...
    'chReceptiveFieldParams','arrayReceptiveFieldParams','rfQuadrant','inStim')
fprintf('file %s done \n', newName)







