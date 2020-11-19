% This is just to be used for debugging and fucking around with things.
% Creating a saved script for it after losing info due to crashes.
%%
clear
close all
clc
location = determineComputer;

files = {
    'WU_LE_GratingsMapRF_nsp1_20170426_003_thresh35';
    'WU_LE_GratingsMapRF_nsp1_20170814_003_thresh35';
    'WU_LE_Gratmap2_nsp1_20170428_005_thresh35'    ;
    'WU_LE_Gratmap_nsp1_20170216_008_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170216_009_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170216_010_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170221_001_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170424_001_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170428_003_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170428_004_thresh35'     ;
    'WU_LE_GratingsMapRF_nsp1_20170426_003_thresh35';
    'WU_LE_GratingsMapRF_nsp1_20170814_003_thresh35';
    'WU_LE_GratingsMapRF_nsp2_20170426_003_thresh35';
    'WU_LE_GratingsMapRF_nsp2_20170620_001_thresh35';
    'WU_LE_Gratmap2_nsp1_20170428_005_thresh35'    ;
    'WU_LE_Gratmap2_nsp2_20170428_005_thresh35'    ;
    'WU_LE_Gratmap_nsp1_20170216_008_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170216_009_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170216_010_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170221_001_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170424_001_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170428_003_thresh35'     ;
    'WU_LE_Gratmap_nsp1_20170428_004_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170215_002_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170215_003_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170215_004_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170424_001_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170428_003_thresh35'     ;
    'WU_LE_Gratmap_nsp2_20170428_004_thresh35'     ;
%     'WU_LE_Gratmap_nsp2_20170504_007_thresh35'     ;
    'WU_RE_GratingsMapRF_nsp1_20170426_001_thresh35';
    'WU_RE_GratingsMapRF_nsp1_20170427_001_thresh35';
    'WU_RE_GratingsMapRF_nsp1_20170427_002_thresh35';
    'WU_RE_GratingsMapRF_nsp1_20170814_001_thresh35';
    'WU_RE_GratingsMapRF_nsp1_20170814_002_thresh35';
    'WU_RE_GratingsMapRF_nsp1_20170815_001_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170426_001_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170427_001_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170427_002_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170814_001_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170814_002_thresh35';
    'WU_RE_GratingsMapRF_nsp2_20170815_001_thresh35';
    'WU_RE_Gratmap2_nsp1_20170428_007_thresh35'    ;
    'WU_RE_Gratmap2_nsp2_20170428_007_thresh35'    ;
    'WU_RE_Gratmap_nsp1_20170216_005_thresh35'     ;
    'WU_RE_Gratmap_nsp1_20170216_006_thresh35'     ;
    'WU_RE_Gratmap_nsp1_20170216_007_thresh35'     ;
    'WU_RE_Gratmap_nsp1_20170428_006_thresh35'     ;
    'WU_RE_Gratmap_nsp2_20170424_002_thresh35'     ;
    'WU_RE_Gratmap_nsp2_20170428_006_thresh35'     ;
    'WU_RE_Gratmap_nsp2_20170504_002_thresh35'     ;
    'WU_RE_Gratmap_nsp2_20170504_004_thresh35'     ;
   };
%%
for fi = 1:length(files)
    fname = files{fi};
    load(fname)
    info = strsplit(fname,'_');
    
    fprintf('## %s ##\n',fname)
    if contains(fname,'LE')
        deets(fi,1) = 1;
    else
        deets(fi,1) = 2;
    end
    a = info{5};
    b = info{6};
    deets(fi,2) = str2num(a);
    deets(fi,3) = str2num(b);
    deets(fi,4:6) = unique(yoffset);
    deets(fi,8:10) = unique(xoffset);

%     xfix = unique(dataT.fix_x)
%     yfix = unique(dataT.fix_y)
end