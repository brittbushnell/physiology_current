clear
close all
% clc
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

[V1data.CoMRE,V1data.CoMLE,V4data.CoMRE,V4data.CoMLE,...
 V1data.CoMDist,V4data.CoMDist,V1data.CoMpVal,V4data.CoMpVal,...
 V1data.conRadLE.MeanConRadNdx,V1data.conRadLE.CRI,V1data.conRadRE.MeanConRadNdx,V1data.conRadRE.CRI,...
 V4data.conRadLE.MeanConRadNdx,V4data.conRadLE.CRI,V4data.conRadRE.MeanConRadNdx,V4data.conRadRE.CRI] = makeFig_triplotGlass_trNoise(V1data, V4data);
%% coherence
% if ~contains(V1data.conRadRE.animal,'XT')
%   [V1data.NumSigCohCorrLE,V1data.NumSigCohCorrRE,V4data.NumSigCohCorrLE,V4data.NumSigCohCorrRE] = GlassCohCorrStats(V1data, V4data);
% end

%% d' scatter plots
location = determineComputer;
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/dPrime',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/dPrime/',V1data.conRadRE.animal);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

stimBlankR2 = {};
stimNoiseR2 = {};

stimBlankR2 = makeGlassFigs_dPrimeScatter_binocOnly(V1data, V4data, stimBlankR2);
stimNoiseR2 = makeGlassFigs_dPrimeScatter_stimVnoise_binocOnly(V1data,V4data, stimNoiseR2);

%% Chi squared homogeneity
% plotGlassChiSquareDistribution(V4data.conRadRE,V4data.conRadLE)
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

data.stimNoiseR2 = stimNoiseR2;
data.stimBlankR2 = stimBlankR2;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)