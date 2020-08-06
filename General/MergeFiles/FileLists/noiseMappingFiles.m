% noise mapping files

location = 0;
%% XT noise mapping

% V1
% files = ['XT_LE_mapNoise_nsp1_20181023_001'; 'XT_LE_mapNoise_nsp1_20181025_001'];
% newName = 'XT_LE_mapNoise_nsp1_Oct2018';

% files = ['XT_RE_mapNoise_nsp1_20181024_001'; 'XT_RE_mapNoise_nsp1_20181024_002'; 'XT_RE_mapNoise_nsp1_20181024_004'];
% newName = 'XT_RE_mapNoise_nsp1_Oct2018';

%  files = ['XT_LE_mapNoiseRight_nsp1_20181120_001'; 'XT_LE_mapNoiseRight_nsp1_20181120_002'];
%  newName = 'XT_LE_mapNoiseRight_nsp1_Nov2018';

% V4
% files = ['XT_LE_mapNoise_nsp2_20181023_001'; 'XT_LE_mapNoise_nsp2_20181025_001'];
% newName = 'XT_LE_mapNoise_nsp2_Oct2018';

% files = ['XT_LE_mapNoiseRight_nsp2_20181120_001'; 'XT_LE_mapNoiseRight_nsp2_20181120_002'];
% newName = 'XT_LE_mapNoiseRight_nsp2_Nov2018';

% files = ['XT_RE_mapNoise_nsp2_20181024_001';...
%          'XT_RE_mapNoise_nsp2_20181024_002';...
%          'XT_RE_mapNoise_nsp2_20181024_004'];
% newName = 'XT_RE_mapNoise_nsp2_EarlyOct2018';

% files = ['XT_RE_mapNoiseRight_nsp2_20181026_001';...
%          'XT_RE_mapNoiseRight_nsp2_20181026_003'];
% newName = 'XT_RE_mapNoiseRight_nsp2_LateOct2018';
%% WV
% files = ['WV_LE_MapNoise_nsp1_20190201_002';...
%          'WV_LE_MapNoise_nsp1_20190204_002';...
%          'WV_LE_MapNoise_nsp1_20190204_003'];
% newName = 'WV_LE_MapNoise_nsp1_Feb2019';

% files = ['WV_RE_MapNoise_nsp1_20190201_001';...
%          'WV_RE_MapNoise_nsp1_20190205_001'];
% newName = 'WV_RE_MapNoise_nsp1_Feb2019'; 

% V4
% files = ['WV_LE_MapNoise_nsp2_20190201_002';...
%          'WV_LE_MapNoise_nsp2_20190204_002';...
%          'WV_LE_MapNoise_nsp2_20190204_003'];
% newName = 'WV_LE_MapNoise_nsp2_Feb2019';

% files = ['WV_RE_MapNoise_nsp2_20190201_001';...
%          'WV_RE_MapNoise_nsp2_20190205_001'];
% newName = 'WV_RE_MapNoise_nsp2_Feb2019';
% %% WU
% files = {'WU_RE_GratingsMapRF_nsp2_20170814_001_thresh35';
%     'WU_RE_GratingsMapRF_nsp2_20170814_002_thresh35';
%     'WU_RE_GratingsMapRF_nsp2_20170815_001_thresh35';
% };
% newName = 'WU_RE_GratingsMapRF_nsp2_20170814_all_thresh35';
%%
MergePNGFiles(files, newName, location);