location = 1;
%%
files = ['XT_LE_Pasupathy_nsp1_20190308_001';...
         'XT_LE_Pasupathy_nsp1_20190311_001';...
         'XT_LE_Pasupathy_nsp1_20190311_002';...
         'XT_LE_Pasupathy_nsp1_20190313_001'];
newName = 'XT_LE_Pasupathy_nsp1_March2019';

files = ['XT_RE_Pasupathy_nsp1_20190315_002'];
newName = 'XT_RE_Pasupathy_nsp1_March2019';

% V4
% files = ['XT_LE_Pasupathy_nsp2_20190308_001';...
%          'XT_LE_Pasupathy_nsp2_20190311_001';...
%          'XT_LE_Pasupathy_nsp2_20190311_002';...
%          'XT_LE_Pasupathy_nsp2_20190313_001'];
% newName = 'XT_LE_Pasupathy_nsp2_March2019';

files = ['XT_RE_Pasupathy_nsp2_20190315_002'];
newName = 'XT_RE_Pasupathy_nsp2_March2019';
%% 
MergePNGFiles(files,newName,location);
