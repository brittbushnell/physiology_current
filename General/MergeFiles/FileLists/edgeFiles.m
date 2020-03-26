% edgeFiles
location = 1;
%% WU
% files = ['WU_LE_EdgeCos_nsp2_20170515_006'; 'WU_LE_EdgeCos_nsp2_20170516_002'];
% files = ['WU_RE_EdgeCos_nsp2_20170515_007';'WU_RE_EdgeCos_nsp2_20170516_001'];

% files = ['WU_RE_EdgeCos_nsp2_20170807_003'; 'WU_RE_EdgeCos_nsp2_20170803_005'];
% files = ['WU_RE_EdgeCos_nsp1_20170807_003';'WU_RE_EdgeCos_nsp1_20170803_005'];

files = ['WU_RE_EdgeCos_nsp2_20170803_005'; 'WU_RE_EdgeCos_nsp2_20170807_003'];   
newName = 'WU_RE_EdgeCos_nsp2_Aug2017';
%% XT
% Before biopsy, only ran on LE

% files = ['XT_LE_edgeCos_nsp1_20181106_001';'XT_LE_edgeCos_nsp1_20181106_002'];
% newName = 'XT_LE_edgeCos_nsp1_Nov2018';

% files = ['XT_LE_edgeCos_nsp2_20181106_001';'XT_LE_edgeCos_nsp2_20181106_002'];
% newName = 'XT_LE_edgeCos_nsp2_Nov2018';

% post biopsy 1
% NSP1
% files = ['XT_LE_edgeCos_nsp1_20181127_003'; 'XT_LE_edgeCos_nsp1_20181127_004'; 'XT_LE_edgeCos_nsp1_20181127_005'];
% newName = 'XT_LE_edgeCos_nsp1_peripheral_Nov2018';

% files = ['XT_RE_edgeCos_nsp1_20181128_001';'XT_RE_edgeCos_nsp1_20181128_002'];
% newName = 'XT_RE_edgeCos_nsp1_peripheral_Nov2018';

% NSP2
%  files = ['XT_LE_edgeCos_nsp2_20181127_003'; 'XT_LE_edgeCos_nsp2_20181127_004'; 'XT_LE_edgeCos_nsp2_20181127_005'];
%  newName = 'XT_LE_edgeCos_nsp2_peripheral_Nov2018';
 
% files = ['XT_RE_edgeCos_nsp2_20181128_001';'XT_RE_edgeCos_nsp2_20181128_002'];
% newName = 'XT_RE_edgeCos_nsp2_peripheral_Nov2018';
%% WV
% V1
% files = ['WV_RE_EdgeCos_nsp1_20190214_001';...
%          'WV_RE_EdgeCos_nsp1_20190214_002';...
%          'WV_RE_EdgeCos_nsp1_20190214_003';...
%          'WV_RE_EdgeCos_nsp1_20190215_001'];
% newName = 'WV_RE_edgeCos_nsp1_Feb2019';

% files = ['WV_LE_EdgeCos_nsp1_20190212_001';...
%          'WV_LE_EdgeCos_nsp1_20190212_002';...
%          'WV_LE_EdgeCos_nsp1_20190212_003';...
%          'WV_LE_EdgeCos_nsp1_20190213_001';...
%          'WV_LE_EdgeCos_nsp1_20190213_002';...
%          'WV_LE_EdgeCos_nsp1_20190213_003'];
% newName = 'WV_LE_edgeCos_nsp1_Feb2019';

% V4
% files = ['WV_RE_EdgeCos_nsp2_20190214_001';...
%          'WV_RE_EdgeCos_nsp2_20190214_002';...
%          'WV_RE_EdgeCos_nsp2_20190214_003';...
%          'WV_RE_EdgeCos_nsp2_20190215_001'];
% newName = 'WV_RE_edgeCos_nsp2_Feb2019';

% files = ['WV_LE_EdgeCos_nsp2_20190212_001';...
%          'WV_LE_EdgeCos_nsp2_20190212_002';...
%          'WV_LE_EdgeCos_nsp2_20190212_003';...
%          'WV_LE_EdgeCos_nsp2_20190213_001';...
%          'WV_LE_EdgeCos_nsp2_20190213_002';...
%          'WV_LE_EdgeCos_nsp2_20190213_003'];
% newName = 'WV_LE_edgeCos_nsp2_Feb2019';
%%
MergeEdgeFiles(files, newName, location)