clear
%close all
clc
 %%
% load('WV_BE_V1_bothGlass_cleanMerged');
% V1data = data;
% clear data;
% 
% load('WV_BE_V4_bothGlass_cleanMerged');
% V4data = data;
% clear data;
% newName = 'WV_2eyes_2arrays_GlassPatterns';
%%
% load('WU_BE_V1_bothGlass_cleanMerged');
% V1data = data;
% clear data;
% 
% load('WU_BE_V4_bothGlass_cleanMerged');
% V4data = data;
% clear data;
% newName = 'WU_2eyes_2arrays_GlassPatterns';
%%
load('XT_BE_V1_bothGlass_cleanMerged');
V1data = data;
clear data;

load('XT_BE_V4_bothGlass_cleanMerged');
V4data = data;
clear data;
newName = 'XT_2eyes_2arrays_GlassPatterns';
%% triplot
% using best dt, dx for each pattern
% triplotter_Glass_BExArrays_optimalForPattern(V1data,V4data)
%% d' scatter plots
makeGlassFigs_dPrimeScatter_bothProgs(V1data, V4data)
%% Chi squared homogeneity
% plotGlassChiSquareDistribution(data)
 %% coherence
% plotGlass_CoherenceResps(REdata)
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
%%
data.V1 = V1data;
data.V4 = V4data;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)