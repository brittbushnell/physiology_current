clear
close all
clc
% %%
% load('WV_BE_GlassTRCoh_V4_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WV_BE_V4_Glass_Aug2017_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WV_BE_V4_bothGlass_cleanMerged';
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
load('XT_BE_GlassTR_V4_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('XT_BE_V4_Glass_clean_merged');
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data

newName = 'XT_BE_V4_bothGlass_cleanMerged';
%%  get receptive field information
% It doesn't matter if you use the conRad or translational inputs, they'll
% both return the same thing.

trLE = callReceptiveFieldParameters(trLE);
trRE = callReceptiveFieldParameters(trRE);

%%
trLE = GlassTR_bestSumDOris(trLE);
[trLE.rfQuadrant, trLE.inStim, trLE.inStimCenter, trLE.within2Deg] = getRFsRelGlass_ecc_Sprinkles(trLE, conRadLE);
trLE.quadOris = getOrisInRFs_conRadColored(trLE,conRadLE);
diffPrefOriPrefStimOri(trLE,conRadLE)

trRE = GlassTR_bestSumDOris(trRE);
[trRE.rfQuadrant, trRE.inStim, trRE.inStimCenter,trRE.within2Deg] = getRFsRelGlass_ecc_Sprinkles(trRE, conRadRE);
trRE.quadOris = getOrisInRFs_conRadColored(trRE,conRadRE);
diffPrefOriPrefStimOri(trRE,conRadRE)


conRadLE.rfQuadrant   = trLE.rfQuadrant;
conRadLE.inStim       = trLE.inStim;
conRadLE.inStimCenter = trLE.inStimCenter;
conRadLE.within2Deg   = trLE.within2Deg;

conRadRE.rfQuadrant   = trRE.rfQuadrant;
conRadRE.inStim       = trRE.inStim;
conRadRE.inStimCenter = trRE.inStimCenter;
conRadRE.within2Deg   = trRE.within2Deg;
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