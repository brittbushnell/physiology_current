function [] = MergePNGFiles(files, newName, location)

% MergePNGFiles
%
% NOTE: THIS SHOULD WORK FOR ALL .PNG FILES

%%
% clear all
% close all
% %clc
% location = 0; %0 = laptop 1 = laca
%% WU
% RF
% files = ['WU_LE_RadFreqLoc2_nsp2_20170707_002';
%          'WU_LE_RadFreqLoc2_nsp2_20170706_004';
%          'WU_LE_RadFreqLoc2_nsp2_20170705_004';
%          'WU_LE_RadFreqLoc2_nsp2_20170705_005';
%          'WU_LE_RadFreqLoc1_nsp2_20170628_004';
%          'WU_LE_RadFreqLoc1_nsp2_20170626_002'];

% files = ['WU_RE_RadFreqLoc2_nsp2_20170707_005';
%          'WU_RE_RadFreqLoc2_nsp2_20170706_002';
%          'WU_RE_RadFreqLoc2_nsp2_20170705_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170628_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170627_002';
%          'WU_RE_RadFreqLoc1_nsp2_20170626_006'];
% newName = 'WU_RE_RadFreq_nsp1_June2017';

% files = ['WU_LE_RadFreqLoc2_nsp1_20170707_002';
%     'WU_LE_RadFreqLoc2_nsp1_20170706_004';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_004';
%     'WU_LE_RadFreqLoc2_nsp1_20170705_005';
%     'WU_LE_RadFreqLoc1_nsp1_20170628_004';
%     'WU_LE_RadFreqLoc1_nsp1_20170626_002'];
% newName = 'WU_LE_RadFreq_nsp1_June2017';

% files = ['WU_RE_RadFreqLoc2_nsp1_20170707_005';
%          'WU_RE_RadFreqLoc2_nsp1_20170706_002';
%          'WU_RE_RadFreqLoc2_nsp1_20170705_002';
%          'WU_RE_RadFreqLoc1_nsp1_20170628_002';
%          'WU_RE_RadFreqLoc1_nsp1_20170627_002';
%          'WU_RE_RadFreqLoc1_nsp1_20170626_006';];

% Textures
% files = ['WU_LE_TexturesBehav_nsp2_20170711_002';
%          'WU_LE_TexturesBehav_nsp2_20170710_004'];

% Contour Integration
% files = ['WU_LE_ContourIntegration_nsp2_20170712_004';
%          'WU_LE_ContourIntegration_nsp2_20170719_002';
%          'WU_LE_ContourIntegration_nsp2_20170721_002'];
%
% files = [ 'WU_RE_ContourIntegration_nsp2_20170719_004';
%           'WU_RE_ContourIntegration_nsp2_20170720_002';
%           'WU_RE_ContourIntegration_nsp2_20170720_003';
%           'WU_RE_ContourIntegration_nsp2_20170720_004'];

% Glass patterns
% files = ['WU_LE_Glass_nsp2_20170817_001';
%          'WU_LE_Glass_nsp2_20170821_002';
%          'WU_LE_Glass_nsp2_20170822_001'];

% files = ['WU_LE_Glass_nsp1_20170817_001';
%          'WU_LE_Glass_nsp1_20170821_002';
%          'WU_LE_Glass_nsp1_20170822_001'];
% newName = 'WU_LE_Glass_nsp1_Aug2017';
   

% files = ['WU_RE_Glass_nsp2_20170817_002';
%          'WU_RE_Glass_nsp2_20170818_001';
%          'WU_RE_Glass_nsp2_20170818_002';
%          'WU_RE_Glass_nsp2_20170821_001'];


% Pasupathy Stimuli
% files = ['WU_LE_Pasupathy1_nsp2_20170526_002';
%          'WU_LE_Pasupathy1_nsp2_20170530_002';
%          'WU_LE_Pasupathy2_nsp2_20170531_005';
%          'WU_LE_Pasupathy2_nsp2_20170605_002'];

% files = ['WU_RE_Pasupathy1_nsp2_20170526_004';
%          'WU_RE_Pasupathy1_nsp2_20170530_004';
%          'WU_RE_Pasupathy2_nsp2_20170531_002';
%          'WU_RE_Pasupathy2_nsp2_20170531_003';
%          'WU_RE_Pasupathy2_nsp2_20170605_004'];

% files = ['WU_RE_Pasupathy1loc_nsp1_20170606_002';
%          'WU_RE_Pasupathy1loc_nsp1_20170606_003'];
%
% files = ['WU_LE_Pasupathy1loc_nsp1_20170606_005'];


%newName = 'WU_LE_Pasupathy1loc_nsp1';
%% cd to save directory
if location == 1
    if contains(files(1,:),'nsp1')
        cd '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/V1/ConcatenatedMats'
    else
        cd '/Local/Users/bushnell/Dropbox/ArrayData/matFiles/V4/ConcatenatedMats'
    end
elseif location == 0
    if contains(files(1,:),'nsp1')
        cd  /Users/bbushnell/Dropbox/ArrayData/matFiles/V1/ConcatenatedMats
    else
        cd  /Users/bbushnell/Dropbox/ArrayData/matFiles/V4/ConcatenatedMats
    end
end
%% load data and extract info
for fi = 1:size(files,1)
    data = load(files(fi,:));
    
    if strfind(files(1,:),'Pasupathy')
        [data.filename, data.stimName] = PasupathyFileNameFix(data.filename);
    end
    
    dataComp{fi} = data;
end
%% Concatenation
bins = [];
pos_x = [];
pos_y = [];
stimOn = [];
stimOff = [];
filename = [];
fix_x = [];
fix_y = [];
ori = [];
stimName = [];
size_x = [];

if contains(files(1,:),'Pasupathy') ||contains(files(1,:),'TR')
    rotation = [];
end

for i = 1:length(dataComp)
    %i
    bT     = dataComp{i}.bins;
    xoff   = dataComp{i}.pos_x;
    yoff   = dataComp{i}.pos_y;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    file   = dataComp{i}.filename;
    if contains(files(1,:),'mapNoise_') && contains(files(1,:),'XT')
        Xfix  = 0;
        Yfix  = 0;
    else
        Xfix  = dataComp{i}.fix_x;
        Yfix  = dataComp{i}.fix_y;
    end

    if contains(files(1,:),'Pasupathy') ||contains(files(1,:),'TR')
    or = dataComp{i}.rotation;
    %stm = dataComp{i}.stimName;
    sz = dataComp{i}.size_x;
    end
    
    for y = 1:size(file,1)
         a(y,:) = strsplit(file(y,:),'/');
    end
    useName = a(:,end);

    bins     = cat(1,bins, bT);
    pos_x    = [pos_x, xoff];
    pos_y    = [pos_y, yoff];
    fix_x    = [fix_x, Xfix];
    fix_y    = [fix_y, Yfix];
    stimOn   = [stimOn, stmOn];
    stimOff  = [stimOff, stmOff];
    filename = cat(1,filename, useName);
    if contains(files(1,:),'Pasupathy') ||contains(files(1,:),'TR')
        ori      = [ori,or];
%        stimName = cat(1,stimName,stm);
        size_x = [size_x, sz];
    end
%     i
%     size(filename)
%     size(pos_x)
    clear a
end
%% Concatenate info into a new structure
% bins
% bin1 = data2{1}.bins;
% bin2 = data2{2}.bins;
% bin3 = data2{3}.bins;
% bin4 = data2{4}.bins;
% bin5 = data2{5}.bins;
% bin6 = data2{6}.bins;
% bin7 = data2{7}.bins;
% bin8 = data2{8}.bins;
% bins = cat(1,bin1,bin2,bin3,bin4,bin5,bin6,bin7,bin8);%
% 
% % x positions
% x1 = data2{1}.pos_x;
% x2 = data2{2}.pos_x;
% x3 = data2{3}.pos_x;
% x4 = data2{4}.pos_x;
% x5 = data2{5}.pos_x;
% x6 = data2{6}.pos_x;
% x7 = data2{7}.pos_x;
% x8 = data2{8}.pos_x;
% pos_x = cat(2,x1,x2,x3,x4,x5,x6,x7,x8);
% 
% % y positions
% y1 = data2{1}.pos_y;
% y2 = data2{2}.pos_y;
% y3 = data2{3}.pos_y;
% y4 = data2{4}.pos_y;
% y5 = data2{5}.pos_y;
% y6 = data2{6}.pos_y;
% y7 = data2{5}.pos_y;
% y8 = data2{6}.pos_y;
% 
% pos_y = cat(2,y1,y2,y3,y4,y5,y6,y7,y8);
% 
% % filenames
% f1 = data2{1}.filename;
% f2 = data2{2}.filename;
% f3 = data2{3}.filename;
% f4 = data2{4}.filename;
% f5 = data2{5}.filename;
% f6 = data2{6}.filename;
% filename = cat(1,f1,f2,f3,f4);%,f5);
% 
% 
% % stimOn
% on1 = data2{1}.stimOn;
% on2 = data2{2}.stimOn;
% on3 = data2{3}.stimOn;
% on4 = data2{4}.stimOn;
% % on5 = data2{5}.stimOn;
% % on6 = data2{6}.stimOn;
% stimOn = cat(2,on1,on2,on3,on4);%,on5,on6);
% 
% % stimOff
% off1 = data2{1}.stimOff;
% off2 = data2{2}.stimOff;
% off3 = data2{3}.stimOff;
% off4 = data2{4}.stimOff;
% % off5 = data2{5}.stimOff;
% % off6 = data2{6}.stimOff;
% stimOff = cat(2,off1,off2,off3,off4);%,off5,off6);
% 
% % size of image
% if isempty(strfind(files(1,:),'RF'))
%     sz1 = data2{1}.size_x;
%     sz2 = data2{2}.size_x;
%     sz3 = data2{3}.size_x;
%    sz4 = data2{4}.size_x;
%     %     sz5 = data2{5}.size_x;
%     %     sz6 = data2{6}.size_x;
%     size_x = cat(2,sz1,sz2,sz3,sz4);%,sz5,sz6);
% end
% 
% if strfind(files(1,:),'Pasupathy')
%     ori1 = data2{1}.rotation;
%     %    ori2 = data2{2}.rotation;
%     %     ori3 = data2{3}.rotation;
%     %     ori4 = data2{4}.rotation;
%     % ori5 = data2{5}.rotation;
%     rotation = cat(2, ori1);%, ori2);%, ori3, ori4);%, ori5);
%     
%     stm1 = data2{1}.stimName;
%     %    stm2 = data2{2}.stimName;
%     %     stm3 = data2{3}.stimName;
%     %     stm4 = data2{4}.stimName;
%     % stm5 = data2{5}.stimName;
%     stimName = cat(1, stm1);%, stm2);%, stm3, stm4);%, stm5);
% end
%% Save new .mat file

if contains(files(1,:),'Pasupathy')
    save(newName,'files','bins','pos_x','pos_y','fix_x','fix_y','filename','stimName','stimOn','stimOff','size_x','rotation')
elseif contains(files(1,:),'TR')
        save(newName,'files','bins','pos_x','pos_y','fix_x','fix_y','filename','stimOn','stimOff','rotation')
else
    %save(newName,'files','bins','pos_x','pos_y','filename','stimOn','stimOff')
    save(newName,'files','bins','pos_x','pos_y','fix_x','fix_y','filename','stimOn','stimOff')
end
fprintf('%s saved \n',newName)



