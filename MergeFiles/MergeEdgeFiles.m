function [] = MergeEdgeFiles(files, newName, location)

%%
% clear all
% close all
% clc
if contains(files(1,:),'nsp1')
    array = 'V1';
else
    array = 'V4';
end
%%
if location == 0
 useDir = sprintf('~/Dropbox/ArrayData/matFiles/%s/EdgeCos/combinedMats/', array);
elseif location == 1
 useDir = sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/EdgeCos/combinedMats/', array);
end
cd(useDir)
%% Extract stimulus information
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename); 
    dataComp{fi} = data;   
end
%%
bins = [];
spatial_frequency = [];
rotation = [];
width = [];
xoffset = [];
yoffset = [];
stimOn = [];
stimOff = [];
contrast = [];
starting_phase = [];
current_phase = [];
height = [];
temporal_frequency = [];
direction = [];


for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    sf     = dataComp{i}.spatial_frequency;
    rot    = dataComp{i}.rotation;
    wid    = dataComp{i}.width;
    xoff   = dataComp{i}.xoffset;
    yoff   = dataComp{i}.yoffset;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    con    = dataComp{i}.contrast;
    sph    = dataComp{i}.starting_phase;
    cph    = dataComp{i}.current_phase;
    tf     = dataComp{i}.temporal_frequency;
    dir    = dataComp{i}.direction;
    ht     = dataComp{i}.height;
    
    bins     = cat(1,bins, bT);
    rotation = [rotation, rot];
    width    = [width, wid];
    xoffset  = [xoffset, xoff];
    yoffset  = [yoffset, yoff];
    stimOn   = [stimOn, stmOn];
    stimOff  = [stimOff, stmOff];
    contrast = [contrast, con];
    starting_phase     = [starting_phase, sph];
    current_phase      = [current_phase,cph];
    height             = [height,ht];
    temporal_frequency = [temporal_frequency,tf];
    spatial_frequency  = [spatial_frequency, sf];
    direction          = [direction, dir];
end
 %%
% % combine bin fields
% bin1 = dataComp{1}.bins;
% bin2 = dataComp{2}.bins;
% bins = cat(1,bin1,bin2);
% 
% % combine Oris
% oris1 = dataComp{1}.rotation;
% oris2 = dataComp{2}.rotation;
% rotation = cat(2,oris1,oris2);
% 
% % combine spatial frequency fields
% sfs1 = dataComp{1}.spatial_frequency;
% sfs2 = dataComp{2}.spatial_frequency;
% spatial_frequency = cat(2,sfs1,sfs2);
% 
% % combine width fields
% wide1 = dataComp{1}.width;
% wide2 = dataComp{2}.width;
% width = cat(2,wide1,wide2);
% 
% % combine x_offset fields
% x1 = dataComp{1}.xoffset;
% x2 = dataComp{2}.xoffset;
% xoffset = cat(2,x1,x2);
% 
% % combine x_offset fields
% y1 = dataComp{1}.yoffset;
% y2 = dataComp{2}.yoffset;
% yoffset = cat(2,y1,y2);
% 
% % combine stimOn fields
% on1 = dataComp{1}.stimOn;
% on2 = dataComp{2}.stimOn;
% stimOn = cat(2,on1,on2);
% 
% % combine stimOff fields
% off1 = dataComp{1}.stimOff;
% off2 = dataComp{2}.stimOff;
% stimOff = cat(2,off1,off2);
% 
% % combine contrasts
% con1 = dataComp{1}.contrast;
% con2 = dataComp{2}.contrast;
% contrast = cat(2,con1,con2);
% 
% % combine starting phases
% ph1 = dataComp{1}.starting_phase;
% ph2 = dataComp{2}.starting_phase;
% starting_phase = cat(2,ph1,ph2);
% 
% % combine current phases
% cph1 = dataComp{1}.current_phase;
% cph2 = dataComp{2}.current_phase;
% current_phase = cat(2,cph1,cph2);
% 
% % combine height
% height1 = dataComp{1}.height;
% height2 = dataComp{2}.height;
% height = cat(2,height1,height2); 
% 
% % combine temporal frequencies
% tf1 = dataComp{1}.temporal_frequency;
% tf2 = dataComp{2}.temporal_frequency;
% temporal_frequency = cat(2,tf1,tf2);
% 
% % combine direction
% dir1 = dataComp{1}.direction;
% dir2 = dataComp{2}.direction;
% direction = cat(2,dir1,dir2); 

%% save new matrix
save(newName,'bins','spatial_frequency','rotation','width','xoffset','yoffset'...
    ,'stimOn','stimOff','contrast','starting_phase','current_phase',...
    'height','temporal_frequency','direction','files')



