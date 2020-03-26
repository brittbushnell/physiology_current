% MergeGratFiles
%
%
%
%%
clear all
close all
clc
tic

location  = 1; %0 = laptop 1 = Amfortas 2 = zemina
%% Other files (edge, contrast, map)

% files = ['WU_LE_Gratings_nsp1_20170626_mean1';
%     'WU_LE_Gratings_nsp1_20170628_mean1';
%     'WU_LE_Gratings_nsp1_20170703_mean1';
%     'WU_LE_Gratings_nsp1_20170705_mean1';
%     'WU_LE_Gratings_nsp1_20170706_mean1';
%     'WU_LE_Gratings_nsp1_20170707_mean1'];
% newName = 'WU_LE_Gratings_nsp1_withRF_means';

% files = ['WU_RE_Gratings_nsp2_20170626_mean1';
%     'WU_RE_Gratings_nsp2_20170626_mean2';
%     'WU_RE_Gratings_nsp2_20170627_mean1';
%     'WU_RE_Gratings_nsp2_20170628_mean1';
%     'WU_RE_Gratings_nsp2_20170705_mean1';
%     'WU_RE_Gratings_nsp2_20170706_mean1';
%      'WU_RE_Gratings_nsp2_20170707_mean1'];
% newName = 'WU_RE_Gratings_nsp2_withRF_means';

%% Extract stimulus information

for fi = 1:size(files,1)
    filename = files(fi,:);
    load(filename);
    % data.amap = aMap;
    dataComp{fi} = data;
end

for i = 1:length(dataComp)
    bins = cell2mat(dataComp{i}.bins);
    spatial_frequency = cell2mat(dataComp.spatial_frequency);
    rotation = cell2mat(dataComp.rotation);
    width = cell2mat(dataComp.width);
    xoffset = cell2mat(dataComp.xoffset);
    yoffset = cell2mat(dataComp.yoffset);
    stimOn = cell2mat(dataComp.stimOn);
    stimOff = cell2mat(dataComp.stimOff);
    files = cell2mat(dataComp.files);
    contrast = cell2mat(dataComp.contrast);
    
    
end

% Combine structures
% Use same names as the files in the original data structures - this way
% the analysis code can be run using this combined mat file instead.

%% combine bin fields
bin1 = dataComp{1}.bins;
bin2 = dataComp{2}.bins;
 bin3 = dataComp{3}.bins;
 bin4 = dataComp{4}.bins;
 bin5 = dataComp{5}.bins;
 bin6 = dataComp{6}.bins;
%bin7 = dataComp{7}.bins;
%bin8 = dataComp{8}.bins;
bins = cat(1,bin1,bin2,bin3,bin4,bin5,bin6);%,bin7);%,bin8);

% combine spatial frequency fields
sfs1 = dataComp{1}.spatial_frequency;
sfs2 = dataComp{2}.spatial_frequency;
 sfs3 = dataComp{3}.spatial_frequency;
 sfs4 = dataComp{4}.spatial_frequency;
 sfs5 = dataComp{5}.spatial_frequency;
 sfs6 = dataComp{6}.spatial_frequency;
%sfs7 = dataComp{7}.spatial_frequency;
%sfs8 = dataComp{8}.spatial_frequency;
spatial_frequency = cat(2,sfs1,sfs2,sfs3,sfs4,sfs5,sfs6);%,sfs7);%,sfs8);

% combine orientation fields
oris1 = dataComp{1}.rotation;
oris2 = dataComp{2}.rotation;
 oris3 = dataComp{3}.rotation;
 oris4 = dataComp{4}.rotation;
 oris5 = dataComp{5}.rotation;
 oris6 = dataComp{6}.rotation;
%oris7 = dataComp{7}.rotation;
%oris8 = dataComp{8}.rotation;
rotation = cat(2,oris1,oris2,oris3,oris4,oris5,oris6);%,oris7);%,oris8);

% combine width fields
wide1 = dataComp{1}.width;
wide2 = dataComp{2}.width;
 wide3 = dataComp{3}.width;
 wide4 = dataComp{4}.width;
 wide5 = dataComp{5}.width;
 wide6 = dataComp{6}.width;
%wide7 = dataComp{7}.width;
%wide8 = dataComp{8}.width;
width = cat(2,wide1,wide2,wide3,wide4,wide5,wide6);%,wide7);%,wide8);

% combine x_offset fields
x1 = dataComp{1}.xoffset;
x2 = dataComp{2}.xoffset;
 x3 = dataComp{3}.xoffset;
 x4 = dataComp{4}.xoffset;
 x5 = dataComp{5}.xoffset;
 x6 = dataComp{6}.xoffset;
%x7 = dataComp{7}.xoffset;
%x8 = dataComp{8}.xoffset;
xoffset = cat(2,x1,x2,x3,x4,x5,x6);%,x7);%,x8);

% combine y_offset fields
y1 = dataComp{1}.yoffset;
y2 = dataComp{2}.yoffset;
 y3 = dataComp{3}.yoffset;
 y4 = dataComp{4}.yoffset;
 y5 = dataComp{5}.yoffset;
 y6 = dataComp{6}.yoffset;
%y7 = dataComp{7}.yoffset;
%y8 = dataComp{8}.yoffset;
yoffset = cat(2,y1,y2,y3,y4,y5,y6);%,y7);%,y8);

% combine stimOn fields
on1 = dataComp{1}.stimOn;
on2 = dataComp{2}.stimOn;
 on3 = dataComp{3}.stimOn;
 on4 = dataComp{4}.stimOn;
 on5 = dataComp{5}.stimOn;
 on6 = dataComp{6}.stimOn;
% on7 = dataComp{7}.stimOn;
% on8 = dataComp{8}.stimOn;
stimOn = cat(2,on1,on2,on3,on4,on5,on6);%,on7);%,on8);

% combine stimOff fields
off1 = dataComp{1}.stimOff;
off2 = dataComp{2}.stimOff;
 off3 = dataComp{3}.stimOff;
 off4 = dataComp{4}.stimOff;
 off5 = dataComp{5}.stimOff;
 off6 = dataComp{6}.stimOff;
%off7 = dataComp{7}.stimOff;
%off8 = dataComp{8}.stimOff;
stimOff = cat(2,off1,off2,off3,off4,off5,off6);%,off7);%,off8);


% comibine contrast fields
con1 = dataComp{1}.contrast;
con2 = dataComp{2}.contrast;
 con3 = dataComp{3}.contrast;
 con4 = dataComp{4}.contrast;
 con5 = dataComp{5}.contrast;
 con6 = dataComp{6}.contrast;
%con7 = dataComp{7}.contrast;
%con8 = dataComp{8}.contrast;
contrast = cat(2,con1,con2,con3,con4,con5,con6);%,con7);%,con8);

for ch = 1:96
    resps1 = dataComp{1}.stimResps{ch};
    resps2 = dataComp{2}.stimResps{ch};
    resps3 = dataComp{3}.stimResps{ch};
    resps4 = dataComp{4}.stimResps{ch};
    resps5 = dataComp{5}.stimResps{ch};
    resps6 = dataComp{6}.stimResps{ch};
   % resps7 = dataComp{7}.stimResps{ch};
    %resps8 = dataComp{8}.stimResps;
    stimResps{ch} = cat(2,resps1,resps2,resps3,resps4,resps5,resps6);%,resps7);%,resps8);
end
%% save new matrix
cd '~/matFiles/V1/Gratings/ConcatenatedMats/'

save(newName,'bins','spatial_frequency','rotation','width','xoffset',...
    'yoffset','stimOn','stimOff','files','contrast','stimResps');%,'goodChannels','badChannels')









