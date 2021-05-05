files = {'WU_LE_RadFreqLoc1_nsp2_20170626_002_thresh35_info.mat';
    
    'WU_LE_RadFreqLoc1_nsp1_20170626_002_thresh35_info.mat';
    
    'WU_RE_RadFreqLoc1_nsp2_20170627_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc1_nsp2_20170628_002_thresh35_info.mat';

    'WU_RE_RadFreqLoc1_nsp1_20170627_002_thresh35_info.mat';              
    'WU_RE_RadFreqLoc1_nsp1_20170628_002_thresh35_info.mat';    
    

    'WU_LE_RadFreqLoc2_nsp2_20170703_003_thresh35_info.mat';              
    'WU_LE_RadFreqLoc2_nsp2_20170704_005_thresh35_info.mat';              
    'WU_LE_RadFreqLoc2_nsp2_20170705_005_thresh35_info.mat';              
    'WU_LE_RadFreqLoc2_nsp2_20170706_004_thresh35_info.mat';              
    'WU_LE_RadFreqLoc2_nsp2_20170707_002_thresh35_info.mat';
    
    'WU_LE_RadFreqLoc2_nsp1_20170703_003_thresh35_info.mat';
    'WU_LE_RadFreqLoc2_nsp1_20170705_005_thresh35_info.mat';
    'WU_LE_RadFreqLoc2_nsp1_20170706_004_thresh35_info.mat';
    'WU_LE_RadFreqLoc2_nsp1_20170707_002_thresh35_info.mat';
    
    'WU_RE_RadFreqLoc2_nsp2_20170704_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc2_nsp2_20170704_003_thresh35_info.mat';
    'WU_RE_RadFreqLoc2_nsp2_20170705_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc2_nsp2_20170706_002_thresh35_info.mat';
    'WU_RE_RadFreqLoc2_nsp2_20170707_005_thresh35_info.mat';    
    
    'WU_RE_RadFreqLoc2_nsp1_20170705_002_thresh35_info.mat';              
    'WU_RE_RadFreqLoc2_nsp1_20170706_002_thresh35_info.mat';              
    'WU_RE_RadFreqLoc2_nsp1_20170707_005_thresh35_info.mat'};
%%
failNdx = 1;

fileInfo = cell(length(files)+1,12);
fileInfo{1,1} = 'animal';   fileInfo{1,2} = 'eye';
fileInfo{1,3} = 'program';  fileInfo{1,4} = 'array';
fileInfo{1,5} = 'date';     fileInfo{1,6} = 'runNum';

fileInfo{1,7} = 'x1';       fileInfo{1,10} = 'y1';
fileInfo{1,8} = 'x2';       fileInfo{1,11} = 'y2';
fileInfo{1,9} = 'x3';       fileInfo{1,12} = 'y3';
    
for fi = 1:length(files)
    try
   filename = files{fi};
   load(filename);
   if contains(filename,'LE')
       dataT = data.LE;
   else
       dataT = data.RE;
   end
    
   fileInfo{fi+1,1} = string(dataT.animal);     fileInfo{fi+1,2} = string(dataT.eye);
   fileInfo{fi+1,3} = string(dataT.programID);  fileInfo{fi+1,4} = string(dataT.array);
   fileInfo{fi+1,5} = str2double(dataT.date2);  fileInfo{fi+1,6} = str2double(dataT.runNum);
   
   xpos = unique(dataT.pos_x); xpos = round(xpos,1);
   ypos = unique(dataT.pos_y); ypos = round(ypos,1);
   
   fileInfo{fi+1,7} = xpos(1);    fileInfo{fi+1,10} = ypos(1);
   fileInfo{fi+1,8} = xpos(2);    fileInfo{fi+1,11} = ypos(2);
   fileInfo{fi+1,9} = xpos(3);    fileInfo{fi+1,12} = ypos(3);
    catch ME
        failedfile{failNdx,1} = filename;
        failedfile{failNdx,2} = ME.message;
        failNdx = failNdx+1;
    end
end