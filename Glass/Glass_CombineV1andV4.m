clear
close all
clc
%%
% load('WV_BE_V1_bothGlass_cleanMerged';);
% V1data = data;
% clear data;
% 
% load('WV_BE_V4_bothGlass_cleanMerged';);
% V4data = data;
% clear data;
% newName = 'WV_2eyes_2arrays_GlassPatterns';
%%
load('WU_BE_V1_bothGlass_cleanMerged');
V1data = data;
clear data;

load('WU_BE_V4_bothGlass_cleanMerged');
V4data = data;
clear data;
newName = 'WU_2eyes_2arrays_GlassPatterns';
%%
 getRFsinGlass_V1andV4(V1data.conRadLE,V4data.conRadLE);
 
 [V1data.rfQuadrantLE, V1data.rfParamsLE, V1data.inStimLE, V4data.rfQuadrantLE, V4data.rfParamsLE, V4data.inStimLE] = getRFsinGlass_V1andV4(V1data.conRadLE,V4data.conRadLE);
 [V1data.rfQuadrantRE, V1data.rfParamsRE, V1data.inStimRE, V4data.rfQuadrantRE, V4data.rfParamsRE, V4data.inStimRE] = getRFsinGlass_V1andV4(V1data.conRadRE,V4data.conRadRE);
%%
 getRFsinGlass_V1V4_BE(V1data.conRadLE,V4data.conRadLE,V1data.conRadRE,V4data.conRadRE)
 %%
 location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/Glass/allTypes/%s/',V1data.trRE.animal);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/Glass/allTypes/%s/',V1data.trRE.animal);
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

data.V1 = V1data;
data.V4 = V4data;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)