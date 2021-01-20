clear
close all
clc
%%
load('WV_BE_V1_Glass_Aug2017_clean_merged');
WVv1 = data;
clear data

load('WV_BE_V4_Glass_Aug2017_clean_merged');
WVv4 = data;
clear data

load('WU_BE_V1_Glass_Aug2017_clean_merged');
WUv1 = data;
clear data

load('WU_BE_V4_Glass_Aug2017_clean_merged');
WUv4 = data;
clear data

load('XT_BE_V1_Glass_Aug2017_clean_merged');
XTv1 = data;
clear data

load('XT_BE_V4_Glass_Aug2017_clean_merged');
XTv4 = data;
clear data
%% call RF parameters
WVv1RE = callReceptiveFieldParameters(WVv1.RE);
WVv1LE = callReceptiveFieldParameters(WVv1.LE);

WVv4RE = callReceptiveFieldParameters(WVv4.RE);
WVv4LE = callReceptiveFieldParameters(WVv4.LE);

WUv1RE = callReceptiveFieldParameters(WUv1.RE);
WUv1LE = callReceptiveFieldParameters(WUv1.LE);

WUv4RE = callReceptiveFieldParameters(WUv4.RE);
WUv4LE = callReceptiveFieldParameters(WUv4.LE);

XTv1RE = callReceptiveFieldParameters(XTv1.RE);
XTv1LE = callReceptiveFieldParameters(XTv1.LE);

XTv4RE = callReceptiveFieldParameters(XTv4.RE);
XTv4LE = callReceptiveFieldParameters(XTv4.LE);
%% move to directory for saving the figures
location = determineComputer;

if location == 1
    figDir =  '~/bushnell-local/Dropbox/Figures/CrossAnimals/RF';
elseif location == 0
    figDir =  '~/Dropbox/Figures/CrossAnimals/RF/';
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
