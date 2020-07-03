clear all
close all
clc
%% WV
% files = {
%     'WV_LE_MapNoise_nsp2_20190204_003';
%     'WV_LE_MapNoise_nsp2_20190204_002';
%     'WV_LE_MapNoise_nsp2_20190204_001';
%     };
% newName = 'WV_LE_MapNoise_nsp2_20190204_all';

% files = {
%     'WV_LE_MapNoise_nsp1_20190204_003';
%     'WV_LE_MapNoise_nsp1_20190204_002';
%     'WV_LE_MapNoise_nsp1_20190204_001';
%     };
% newName = 'WV_LE_MapNoise_nsp1_20190204_all';
%
% files = {
%     'WV_LE_MapNoiseRightWide_nsp2_20190121_002';
%     'WV_LE_MapNoiseRightWide_nsp2_20190121_001';
%     };
% newName = 'WV_LE_MapNoiseRight_nsp2_20190121_all';

% files = {
% 'WV_LE_MapNoiseRightWide_nsp1_20190121_002';
% 'WV_LE_MapNoiseRight_nsp1_20190121_001';
% };
% newName = 'WV_LE_MapNoiseRight_nsp1_20190121_all';
%% XT
% V4
% files = {'XT_LE_mapNoise_nsp2_20181023_001'; 'XT_LE_mapNoise_nsp2_20181025_001'};
% newName = 'XT_LE_mapNoise_nsp2_Oct2018';

% files = {'XT_LE_mapNoiseRight_nsp2_20181120_001'; 'XT_LE_mapNoiseRight_nsp2_20181120_002'};
% newName = 'XT_LE_mapNoiseRight_nsp2_Nov2018';

files = {'XT_RE_mapNoise_nsp2_20181024_001';...
         'XT_RE_mapNoise_nsp2_20181024_002';...
         'XT_RE_mapNoise_nsp2_20181024_004'};
newName = 'XT_RE_mapNoise_nsp2_EarlyOct2018';

% files = {'XT_RE_mapNoiseRight_nsp2_20181026_001';...
%          'XT_RE_mapNoiseRight_nsp2_20181026_003'};
% newName = 'XT_RE_mapNoiseRight_nsp2_LateOct2018';
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
save(newName,'bins','rotation','size_x','stimOn','stimOff','t_stim','filename',...
    'pos_x','pos_y','fix_x','fix_y')
fprintf('file %s done \n', newName)