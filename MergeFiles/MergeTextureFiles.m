% mergeTextureFiles
clear all
close all
clc
tic
%%
location  = 1;
files = [];
newName = 'WU_RE_TexturesBehav_July2017';
%%
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    
    data2{fi} = data;
end
%% Concatenate information


    