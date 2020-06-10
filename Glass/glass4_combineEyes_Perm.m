clear 
close all
clc
%%
 % WU   
% REfile = 'WU_RE_Glass_nsp2_20170818_all_raw_2kFixPerm_Stats';...
% LEfile = 'WU_LE_Glass_nsp2_20170817_001_raw_2kFixPerm_Stats';...
% newName = 'WU_BE_Glass_V4_raw_May2020';

% REfile = 'WV_RE_glassCoh_nsp2_20190404_all_raw_2kFixPerm_Stats';...
% LEfile = 'WV_LE_glassCoh_nsp2_20190402_all_raw_2kFixPerm_Stats';...
% newName = 'WV_BE_Glass_V4_raw_combSameDay';
% 
%  REfile = 'XT_RE_GlassCoh_nsp2_20190321_all_raw_2kFixPerm_Stats';...
%  LEfile = 'XT_LE_GlassCoh_nsp2_20190325_all_raw_2kFixPerm_Stats';...
%  newName = 'XT_BE_Glass_V4_raw_combSameDay';

% V1

% REfile = 'WU_RE_Glass_nsp1_20170818_001_raw_2kFixPerm_Stats';...
% LEfile = 'WU_LE_Glass_nsp1_20170817_001_raw_2kFixPerm_Stats';...
% newName = 'WU_BE_Glass_V1_raw_May2020';

% REfile = 'WV_RE_glassCoh_nsp1_20190404_all_raw_2kFixPerm_Stats';...
% LEfile = 'WV_LE_glassCoh_nsp1_20190403_all_raw_2kFixPerm_Stats';...
% newName = 'WV_BE_Glass_V1_raw_combSameDay';

 REfile = 'XT_RE_GlassCoh_nsp1_20190321_all_raw_2kFixPerm_Stats';...
 LEfile = 'XT_LE_GlassCoh_nsp1_20190325_all_raw_2kFixPerm_Stats';...
 newName = 'XT_BE_Glass_V1_raw_combSameDay';
%%
location = determineComputer;
if location == 1
    outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
elseif location == 0
    outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
end
%% combine data from the two eyes into one pair of structures
data = CombineEyes_OD(LEfile, REfile);

location = determineComputer;
if location == 1
    outputDir = '~/bushnell-local/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
elseif location == 0
    outputDir =  '~/Dropbox/ArrayData/matFiles/V4/Glass/Parsed/';
end
 %%
data = getGlassODI(data);
%% histograms
% plotGlassChiSquareDistribution(data);
% %% scatter
% plotGlass_dPrimeScatter(data)
% %%
%  plotGlassPSTHs_visualResponses(data)
%  plotGlass_CoherenceTuning(data)
% %% distribution of latencies
%  data = plotGlass_latencyDist(data);
%  plotGlass_latencyDprimeCrossEyes_marginals(data.LE,data.RE)
%% binocular triplots
 if contains(REfile,'WU') 
     triplotter_stereo_Glass_BE(data,3)
 elseif contains(REfile,'WV') 
      triplotter_stereo_Glass_BE(data,2.5)
 else
      triplotter_stereo_Glass_BE(data,1.25)
 end
%%
saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)