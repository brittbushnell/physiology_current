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
numBoot = 2000;
%% figure 1: preferred location
%     (LEdataXT, REdataXT,LEdataWU,REdataWU, LEdataWV, REdataWV)
% The figure is started with XT's data, but needs to run with the large
% monitor to setup the figure properly with everyone
% plotRadFreqLoc_relRFs_prefLoc_allMonk(XTV4LE, XTV4RE, WUV4LE, WUV4RE, WVV4LE, WVV4RE)
% plotRadFreqLoc_relRFs_prefLoc_allMonk(XTV1LE, XTV1RE, WUV1LE, WUV1RE, WVV1LE, WVV1RE)
%%   Tuned for radial frequency 
%   Responds similarly to all radial frequencies
[XTV1LE.RFcorrPval,XTV1LE.RFcorrSigPerms,XTV1RE.RFcorrPval,XTV1RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(XTV1LE, XTV1RE,numBoot);
[XTV4LE.RFcorrPval,XTV4LE.RFcorrSigPerms,XTV4RE.RFcorrPval,XTV4RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(XTV4LE, XTV4RE,numBoot);

[WUV1LE.RFcorrPval,WUV1LE.RFcorrSigPerms,WUV1RE.RFcorrPval,WUV1RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(WUV1LE, WUV1RE,numBoot);
[WUV4LE.RFcorrPval,WUV4LE.RFcorrSigPerms,WUV4RE.RFcorrPval,WUV4RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(WUV4LE, WUV4RE,numBoot);

[WVV1LE.RFcorrPval,WVV1LE.RFcorrSigPerms,WVV1RE.RFcorrPval,WVV1RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(WVV1LE, WVV1RE,numBoot);
[WVV4LE.RFcorrPval,WVV4LE.RFcorrSigPerms,WVV4RE.RFcorrPval,WVV4RE.RFcorrSigPerms] = radFreq_getSigTuningRFs(WVV4LE, WVV4RE,numBoot);
%% XT tuning summary stats
fprintf('\n\n*** XT V1 RE ***\n')
[XTV1RE.numTunedChs, XTV1RE.numUntunedChs, XTV1RE.numChsTunedHighAmp, XTV1RE.numChsTunedCircle,...
    XTV1RE.numChsMixedTuning, XTV1RE.numSigRFsPerCh, XTV1RE.numRFsSigHighAmp, XTV1RE.numRFsSigCircle,...
    XTV1RE.numSigChsHighAmpPerRF,  XTV1RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(XTV1RE);

fprintf('*** XT V1 LE *** \n')
[XTV1LE.numTunedChs, XTV1LE.numUntunedChs, XTV1LE.numChsTunedHighAmp, XTV1LE.numChsTunedCircle,...
    XTV1LE.numChsMixedTuning, XTV1LE.numSigRFsPerCh, XTV1LE.numRFsSigHighAmp, XTV1LE.numRFsSigCircle,...
    XTV1LE.numSigChsHighAmpPerRF,  XTV1LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(XTV1LE);

fprintf('*** XT V4 RE ***\n')
[XTV4RE.numTunedChs, XTV4RE.numUntunedChs, XTV4RE.numChsTunedHighAmp, XTV4RE.numChsTunedCircle,...
    XTV4RE.numChsMixedTuning, XTV4RE.numSigRFsPerCh, XTV4RE.numRFsSigHighAmp, XTV4RE.numRFsSigCircle,...
    XTV4RE.numSigChsHighAmpPerRF,  XTV4RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(XTV4RE);

fprintf('*** XT V4 LE *** \n')
[XTV4LE.numTunedChs, XTV4LE.numUntunedChs, XTV4LE.numChsTunedHighAmp, XTV4LE.numChsTunedCircle,...
    XTV4LE.numChsMixedTuning, XTV4LE.numSigRFsPerCh, XTV4LE.numRFsSigHighAmp, XTV4LE.numRFsSigCircle,...
    XTV4LE.numSigChsHighAmpPerRF,  XTV4LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(XTV4LE);

%% WU tuning summary stats
fprintf('\n\n*** WU V1 RE ***\n')
[WUV1RE.numTunedChs, WUV1RE.numUntunedChs, WUV1RE.numChsTunedHighAmp, WUV1RE.numChsTunedCircle,...
    WUV1RE.numChsMixedTuning, WUV1RE.numSigRFsPerCh, WUV1RE.numRFsSigHighAmp, WUV1RE.numRFsSigCircle,...
    WUV1RE.numSigChsHighAmpPerRF,  WUV1RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WUV1RE);

fprintf('*** WU V1 LE *** \n')
[WUV1LE.numTunedChs, WUV1LE.numUntunedChs, WUV1LE.numChsTunedHighAmp, WUV1LE.numChsTunedCircle,...
    WUV1LE.numChsMixedTuning, WUV1LE.numSigRFsPerCh, WUV1LE.numRFsSigHighAmp, WUV1LE.numRFsSigCircle,...
    WUV1LE.numSigChsHighAmpPerRF,  WUV1LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WUV1LE);

fprintf('*** WU V4 RE ***\n')
[WUV4RE.numTunedChs, WUV4RE.numUntunedChs, WUV4RE.numChsTunedHighAmp, WUV4RE.numChsTunedCircle,...
    WUV4RE.numChsMixedTuning, WUV4RE.numSigRFsPerCh, WUV4RE.numRFsSigHighAmp, WUV4RE.numRFsSigCircle,...
    WUV4RE.numSigChsHighAmpPerRF,  WUV4RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WUV4RE);

fprintf('*** WU V4 LE *** \n')
[WUV4LE.numTunedChs, WUV4LE.numUntunedChs, WUV4LE.numChsTunedHighAmp, WUV4LE.numChsTunedCircle,...
    WUV4LE.numChsMixedTuning, WUV4LE.numSigRFsPerCh, WUV4LE.numRFsSigHighAmp, WUV4LE.numRFsSigCircle,...
    WUV4LE.numSigChsHighAmpPerRF,  WUV4LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WUV4LE);
%% WV tuning summary stats
fprintf('\n\n*** WV V1 RE ***\n')
[WVV1RE.numTunedChs, WVV1RE.numUntunedChs, WVV1RE.numChsTunedHighAmp, WVV1RE.numChsTunedCircle,...
    WVV1RE.numChsMixedTuning, WVV1RE.numSigRFsPerCh, WVV1RE.numRFsSigHighAmp, WVV1RE.numRFsSigCircle,...
    WVV1RE.numSigChsHighAmpPerRF,  WVV1RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WVV1RE);

fprintf('*** WV V1 LE *** \n')
[WVV1LE.numTunedChs, WVV1LE.numUntunedChs, WVV1LE.numChsTunedHighAmp, WVV1LE.numChsTunedCircle,...
    WVV1LE.numChsMixedTuning, WVV1LE.numSigRFsPerCh, WVV1LE.numRFsSigHighAmp, WVV1LE.numRFsSigCircle,...
    WVV1LE.numSigChsHighAmpPerRF,  WVV1LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WVV1LE);

fprintf('*** WV V4 RE ***\n')
[WVV4RE.numTunedChs, WVV4RE.numUntunedChs, WVV4RE.numChsTunedHighAmp, WVV4RE.numChsTunedCircle,...
    WVV4RE.numChsMixedTuning, WVV4RE.numSigRFsPerCh, WVV4RE.numRFsSigHighAmp, WVV4RE.numRFsSigCircle,...
    WVV4RE.numSigChsHighAmpPerRF,  WVV4RE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WVV4RE);

fprintf('*** WV V4 LE *** \n')
[WVV4LE.numTunedChs, WVV4LE.numUntunedChs, WVV4LE.numChsTunedHighAmp, WVV4LE.numChsTunedCircle,...
    WVV4LE.numChsMixedTuning, WVV4LE.numSigRFsPerCh, WVV4LE.numRFsSigHighAmp, WVV4LE.numRFsSigCircle,...
    WVV4LE.numSigChsHighAmpPerRF,  WVV4LE.numSigChsCirclePerRF]...
    = radFreq_getRFsigSummaryStats2(WVV4LE);
%% plot preference breakdowns

plotRadFreq_tuningIOD(XTV1LE, XTV1RE)
plotRadFreq_tuningIOD(XTV4LE, XTV4RE)

plotRadFreq_tuningIOD(WUV1LE, WUV1RE)
plotRadFreq_tuningIOD(WUV4LE, WUV4RE)

plotRadFreq_tuningIOD(WVV1LE, WVV1RE)
plotRadFreq_tuningIOD(WVV4LE, WVV4RE)
%% figure 2: example tuning curves - get these from 
% get the number of channels that fit into each category for each animal, array, and eye 
%   Responses increase monotonically with amplitude (+correlation & peak
%   amplitude is #5 or 6)

% radFreq_posAmpTune_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

% radFreq_plotTuningTypes_sig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)
% radFreq_plotTuningTypes_notSig(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)

%% figure 4: IOD and array plotting differences 
% radFreq_plotIODsummary
% radFreq_plotArrayDiffsummary
%%
toc/60