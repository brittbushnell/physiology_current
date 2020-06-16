%%
clear all
close all
clc
%% Other files (edge, contrast, map)

% files = ['WU_LE_Gratings_nsp1_20170626_mean1';
%     'WU_LE_Gratings_nsp1_20170628_mean1';
%     'WU_LE_Gratings_nsp1_20170703_mean1';
%     'WU_LE_Gratings_nsp1_20170705_mean1';
%     'WU_LE_Gratings_nsp1_20170706_mean1';
%     'WU_LE_Gratings_nsp1_20170707_mean1'];
% newName = 'WU_LE_Gratings_nsp1_withRF_means';

%% Extract stimulus information
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

bins   = [];
spatial_frequency = [];
rotation = [];
width = [];
xoffset = [];
yoffset = [];
contrast = [];
stimOn  = [];
stimOff = [];
t_stim  = [];


for i = 1:length(dataComp)
    bT     = dataComp{i}.bins;
    fnm    = dataComp{i}.filename;
    rot    = dataComp{i}.rotation;
    szx    = dataComp{i}.width;
    stmOn  = dataComp{i}.stimOn;
    stmOff = dataComp{i}.stimOff;
    tStim  = dataComp{i}.t_stim;
    xPos = dataComp{i}.xoffset;
    yPos = dataComp{i}.yoffset;
    con = dataComp{i}.contrast;
    
    
    bins = cat(1, bins, bT);
    rotation = [rotation,rot];
    width = [width,szx];
    stimOn = [stimOn, stmOn];
    stimOff = [stimOff, stmOff];
    t_stim = [t_stim, tStim];
    filename = cat(1, filename, fnm);
    xoffset = [xoffset, xPos];
    yoffset = [yoffset, yPos];
    contrast = [contrast,con];
    
end
%% save new matrix
cd '~/matFiles/V1/Gratings/ConcatenatedMats/'

save(newName,'bins','spatial_frequency','rotation','width','xoffset',...
    'yoffset','stimOn','stimOff','files','contrast','stimResps');

fprintf('file %s done \n', newName)



















