function [numTunedChs, numSigRFsPerCh, pctSigHighAmpChsByRF, numSigHighAmpRFs, pctSigCircleChsByRF, numSigCircleRFs, pctUntunedChs, numUntunedRFs] =  radFreq_getRFsigSummaryStats(dataT)

%% Percentage of channels with significant tuning in at least one RF
numSigRFsPerCh = nansum(dataT.RFcorrSigPerms & dataT.goodCh)
numTunedChs = nansum(numSigRFsPerCh > 0)
%% Breakdown of channels that have significant tuning and prefer high amplitude
posCorrNdx = dataT.stimCorrs > 0;

pctSigHighAmpChsByRF = nansum(dataT.RFcorrSigPerms.*posCorrNdx & dataT.goodCh,2)./(numTunedChs*100)
sigHighAmpRFs = nansum(dataT.RFcorrSigPerms.*posCorrNdx & dataT.goodCh);
numSigHighAmpRFs(1,1) = sum(sigHighAmpRFs == 0); 
numSigHighAmpRFs(2,1) = sum(sigHighAmpRFs == 1); 
numSigHighAmpRFs(3,1) = sum(sigHighAmpRFs == 2); 
numSigHighAmpRFs(4,1) = sum(sigHighAmpRFs == 3) 

pctChsSigHighAmp = (nansum(sigHighAmpRFs > 0))/(numTunedChs*100)
%% Breakdown of channels that prefer circles
negCorrNdx = dataT.stimCorrs < 0;

pctSigCircleChsByRF = nansum(dataT.RFcorrSigPerms.*negCorrNdx & dataT.goodCh,2)./(numTunedChs*100)
sigCircleRFs = nansum(dataT.RFcorrSigPerms.*negCorrNdx & dataT.goodCh);
numSigCircleRFs(1,1) = sum(sigCircleRFs == 0); 
numSigCircleRFs(2,1) = sum(sigCircleRFs == 1); 
numSigCircleRFs(3,1) = sum(sigCircleRFs == 2); 
numSigCircleRFs(4,1) = sum(sigCircleRFs == 3) 

pctChsSigCircle = (nansum(sigCircleRFs > 0))/(numTunedChs*100)
%% Breakdown of channels that are not significantly tuned for RF
untunedNdx = sum(dataT.RFcorrSigPerms) == 0;

pctUntunedChs = (nansum(untunedNdx & dataT.goodCh,2))/(sum(dataT.goodCh))
numUntunedRFs = nansum(untunedNdx & dataT.goodCh);
%% channels that have a mix of positive and neg tuning
highAmpChs = find(sigHighAmpRFs >0); 
circleChs = find(sigCircleRFs >0); 
pctMixedTuning = length(intersect(highAmpChs, circleChs))/(numTunedChs*100)
%%
% negNdx = (sum(negCorrNdx) == 0) & dataT.goodCh;
% posNdx = (sum(posCorrNdx) == 0) & dataT.goodCh;
% noNdx = (sum(untunedNdx) == 0) & dataT.goodCh;
% 
% negNdx.*posNdx