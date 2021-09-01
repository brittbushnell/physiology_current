function [numTunedChs, numUntunedChs, numChsTunedHighAmp, numChsTunedCircle, numChsMixedTuning,...
          numSigRFsPerCh, numRFsSigHighAmp, numRFsSigCircle, numSigChsHighAmpPerRF, numSigChsCirclePerRF] = radFreq_getRFsigSummaryStats2(dataT)
%% Percentage of channels with significant tuning in at least one RF
numSigRFsPerCh = nansum(dataT.RFcorrSigPerms & dataT.goodCh)
numTunedChs = nansum(numSigRFsPerCh > 0)
%% Breakdown of channels that are not significantly tuned for RF
untunedNdx = (numSigRFsPerCh == 0);

% pctUntunedChs = (nansum(untunedNdx & dataT.goodCh,2))/(sum(dataT.goodCh));
numUntunedChs = nansum(untunedNdx & dataT.goodCh);
%% Breakdown of channels that have significant tuning and prefer high amplitude
posCorrNdx = dataT.stimCorrs > 0;

numRFsSigHighAmp = nansum(dataT.RFcorrSigPerms.*posCorrNdx & dataT.goodCh);
numSigChsHighAmpPerRF = nansum(dataT.RFcorrSigPerms.*posCorrNdx & dataT.goodCh,2)

numChsTunedHighAmp = nansum(numRFsSigHighAmp > 0);
numRFsTunedHighAmpPerCh(1,1) = sum(numRFsSigHighAmp == 0);
numRFsTunedHighAmpPerCh(2,1) = sum(numRFsSigHighAmp == 1);
numRFsTunedHighAmpPerCh(3,1) = sum(numRFsSigHighAmp == 2);
numRFsTunedHighAmpPerCh(4,1) = sum(numRFsSigHighAmp == 3);
%% Channels that prefer circles
negCorrNdx = dataT.stimCorrs < 0;

numRFsSigCircle = nansum(dataT.RFcorrSigPerms.*negCorrNdx & dataT.goodCh);
numSigChsCirclePerRF = nansum(dataT.RFcorrSigPerms.*negCorrNdx & dataT.goodCh,2);

numChsTunedCircle = nansum(numRFsSigCircle > 0)
numRFsTunedCirclePerCh(1,1) = sum(numRFsSigCircle == 0);
numRFsTunedCirclePerCh(2,1) = sum(numRFsSigCircle == 1);
numRFsTunedCirclePerCh(3,1) = sum(numRFsSigCircle == 2);
numRFsTunedCirclePerCh(4,1) = sum(numRFsSigCircle == 3);
%% channels that have mixed tuning depending on RF
circleChs = find(numRFsSigCircle > 0);
highAmpChs = find(numRFsSigHighAmp > 0);
chsMixedTuning = intersect(circleChs, highAmpChs);
numChsMixedTuning = length(chsMixedTuning)
%% number checks

% if numChsTunedCircle + numChsTunedHighAmp ~= numTunedChs
%     fprintf('%s %s %s number of good channels and tuned and untuned are not equal', dataT.animal, dataT.array, dataT.eye)end

if numTunedChs + numUntunedChs ~= sum(dataT.goodCh)
    fprintf('%s %s %s number of good channels and tuned and untuned are not equal', dataT.animal, dataT.array, dataT.eye)
end
%% pie chart
figure

s = suptitle(sprintf('%s %s %s RF tuning type breakdown',dataT.animal, dataT.array, dataT.eye));
s.Position(2) = s.Position(2) +0.025;

tuningMtx = [numUntunedChs, numChsTunedHighAmp, numChsTunedCircle];
axis off
axis square

p = pie(tuningMtx);
p(1).FaceColor = [0.5 0.5 0.5];
p(3).FaceColor = [1 0.4 0.8];
p(5).FaceColor = [0 0.6 1];

l = legend('Untuned','High amp','circle');
l.Box = 'off';
l.FontSize = 10;
l.FontAngle = 'italic';


%%
figDir = sprintf('~/Dropbox/Thesis/radialFrequency/Figures/Results/TuningPies');

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = [dataT.animal,'_',dataT.array,'_',dataT.eye,'_tuningPieChart','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

