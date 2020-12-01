% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
clear

%%
files = {
    'XT_LE_mapNoiseRight_nsp2_20181105_003_thresh35_info3';
    'XT_LE_mapNoiseRight_nsp2_20181105_004_thresh35_info3';
    'XT_LE_mapNoiseRight_nsp2_20181120_001_thresh35_info3';
    'XT_LE_mapNoiseRight_nsp2_20181120_002_thresh35_info3';
    'XT_LE_mapNoiseRight_nsp2_20181120_003_thresh35_info3';
    'XT_LE_mapNoiseRight_nsp2_20181127_001_thresh35_info3';
    'XT_LE_mapNoise_nsp2_20181023_002_thresh35_info3';     
    'XT_LE_mapNoise_nsp2_20181025_001_thresh35_info3';     
    'XT_RE_mapNoiseLeft_nsp2_20181026_001_thresh35_info3'; 
    'XT_RE_mapNoiseRight_nsp2_20181026_001_thresh35_info3';
    'XT_RE_mapNoiseRight_nsp2_20181026_003_thresh35_info3';
    'XT_RE_mapNoiseRight_nsp2_20181119_001_thresh35_info3';
    'XT_RE_mapNoise_nsp2_20181024_001_thresh35_info3';     
    'XT_RE_mapNoise_nsp2_20181024_002_thresh35_info3';     
    'XT_RE_mapNoise_nsp2_20181024_003_thresh35_info3'};
%%
info = {};
for fi = 1:length(files)
    fname = files{fi};
    load(fname)
    if contains(fname,'RE')
        dataT = data.RE;
    else
        dataT = data.LE;
    end
    info{fi,1} = dataT.eye;
    info{fi,2} = dataT.date2;
    info{fi,3} = dataT.runNum;
    info{fi,4} = unique(dataT.pos_x);
    info{fi,5} = unique(dataT.pos_y);    
end