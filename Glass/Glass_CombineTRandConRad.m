clear
close all
clc
%%
% load('WV_BE_GlassTRCoh_V1_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WV_BE_V1_Glass_Aug2017_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WV_BE_V1_bothGlass_cleanMerged';
%%
% load('WU_BE_GlassTR_V1_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WU_BE_V1_Glass_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WU_BE_V1_bothGlass_cleanMerged';
%% 
load('XT_BE_GlassTR_V1_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('XT_BE_V1_Glass_clean_merged');
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data

newName = 'XT_BE_V1_bothGlass_cleanMerged';
%%  get receptive field information
% It doesn't matter if you use the conRad or translational inputs, they'll
% both return the same thing.

trLE = callReceptiveFieldParameters(trLE);
trRE = callReceptiveFieldParameters(trRE);

%%
[trLE.rfQuadrant, trLE.inStim, trLE.inStimCenter] = getRFsRelGlass_ecc(trLE);
trLE = GlassTR_bestSumDOris(trLE);
trLE.quadOris = getOrisInRFs_conRadPrefs(trLE,conRadLE);

[trRE.rfQuadrant, trRE.inStim, trRE.inStimCenter] = getRFsRelGlass_ecc(trRE);
trRE = GlassTR_bestSumDOris(trRE);
trRE.quadOris = getOrisInRFs_conRadPrefs(trRE,conRadRE);

conRadLE.rfQuadrant   = trLE.rfQuadrant;
conRadLE.inStim       = trLE.inStim;
conRadLE.inStimCenter = trLE.inStimCenter;

conRadRE.rfQuadrant   = trRE.rfQuadrant;
conRadRE.inStim       = trRE.inStim;
conRadRE.inStimCenter = trRE.inStimCenter;
%% Is there any reason to do this for both?  Why not just save the information from above to both?
% [conRadLE.rfQuadrant] = getRFsRelGlass_ecc(conRadLE);
% [conRadRE.rfQuadrant] = getRFsRelGlass_ecc(conRadRE);
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