clear
close all
clc
%%
load('WV_BE_GlassTRCoh_V4_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('WV_BE_V4_Glass_Aug2017_clean_merged');
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data

newName = 'WV_BE_V4_bothGlass_cleanMerged';
%%
% load('WU_BE_GlassTR_V1_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WU_BE_V1_Glass_Aug2017_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WU_BE_V1_bothGlass_cleanMerged';
%%  get correct receptive field information
[trLE.rfQuadrant] = getRFsinGlass(trLE);
trLE = GlassTR_bestSumDOris(trLE);
trLE.quadOris = getOrisInRFs_conRadPrefs(trLE,conRadLE);

[trRE.rfQuadrant] = getRFsinGlass(trRE);
trRE = GlassTR_bestSumDOris(trRE);
trRE.quadOris = getOrisInRFs_conRadPrefs(trRE,conRadRE);

[conRadLE.rfQuadrant] = getRFsinGlass(conRadLE);
[conRadRE.rfQuadrant] = getRFsinGlass(conRadRE);
%% get the preferred density dx for concentric and radial
% tr.prefParamsIndex refers to dt,dx indices so 1 = (1,1) 2 = (1,2) 3 = (2,1) 4 = (2,2)
%% save combined data

location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/allTypes/%s/',trRE.array,trRE.animal);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/allTypes/%s/',trRE.array,trRE.animal);
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

data.trLE = trLE;
data.trRE = trRE;
data.conRadLE = conRadLE;
data.conRadRE = conRadRE;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)