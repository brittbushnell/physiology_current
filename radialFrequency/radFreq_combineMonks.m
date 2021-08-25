% radFreq_combineMonks

clear
close all
tic
%%

WU = 'WU_BE_radFreq_allSF_bothArrays_stats';
WV = 'WV_BE_radFreq_allSF_bothArrays_stats';
XT = 'XT_BE_radFreq_allSF_bothArrays_stats';
%%
load(WU)
WUdata = data;
WUV4RE = data.V4.RE;
WUV4LE = data.V4.LE;
WUV1RE = data.V1.RE;
WUV1LE = data.V1.LE;
clear data

load(WV) % use highSF
WVdata = data;
WVV4RE = data.V4.REhighSF;
WVV4LE = data.V4.LEhighSF;
WVV1RE = data.V1.REhighSF;
WVV1LE = data.V1.LEhighSF;
clear data

load(XT) % use lowSF: highSF data had some funkiness going on
XTdata = data;
XTV4RE = data.V4.RElowSF;
XTV4LE = data.V4.LElowSF;
XTV1RE = data.V1.RElowSF;
XTV1LE = data.V1.LElowSF;
clear data
%% figure 1: preferred location
%     (LEdataXT, REdataXT,LEdataWU,REdataWU, LEdataWV, REdataWV)
% The figure is started with XT's data, but needs to run with the large
% monitor to setup the figure properly with everyone
plotRadFreqLoc_relRFs_prefLoc_allMonk(XTV4LE, XTV4RE, WUV4LE, WUV4RE, WVV4LE, WVV4RE)
plotRadFreqLoc_relRFs_prefLoc_allMonk(XTV1LE, XTV1RE, WUV1LE, WUV1RE, WVV1LE, WVV1RE)
%% figure 2: example tuning curves - get these from 
% get the number of channels that fit into each category for each animal, array, and eye 
%   Responses increase monotonically with amplitude (+correlation & peak
%   amplitude is #5 or 6)

radFreq_posAmpTune_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

% radFreq_plotTuningTypes_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)
% radFreq_plotTuningTypes_notSig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

%%   Tuned for radial frequency (Did I do a test for this??)
%   Responds similarly to all radial frequencies


%% figure 4: IOD and array plotting differences 
radFreq_plotIODsummary
radFreq_plotArrayDiffsummary
