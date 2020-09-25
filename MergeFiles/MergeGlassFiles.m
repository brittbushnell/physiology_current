clear all
close all
clc
%%
saveDir = '/Users/brittany/Dropbox/ArrayData/matFiles/reThreshold/listMatrices/Glass'

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


for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    fnm    = dataComp{i}.filename;
    fx     = dataComp{i}.fix_x;
    fy     = dataComp{i}.fix_y;
    rot    = dataComp{i}.rotation;
    szx    = dataComp{i}.size_x;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    xPos = dataComp{i}.pos_x;
    yPos = dataComp{i}.pos_y;
    
    
    bins = cat(1, bins, bT);
    fix_x = [fix_x, fx];
    fix_y = [fix_y, fy];
    rotation = [rotation,rot];
    size_x = [size_x,szx];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    filename = cat(1, filename, fnm);
    pos_x = [pos_x, xPos];
    pos_y = [pos_y, yPos];
    
end
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

save(newName,'bins','fix_x','fix_y','rotation','size_x','stimOn','stimOff','t_stim','filename',...
    'pos_x','pos_y')
fprintf('file %s done \n', newName)







