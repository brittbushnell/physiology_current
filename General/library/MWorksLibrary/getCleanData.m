function [cleanData] = getCleanData_RF(data,startBin,endBin)

nChan = size(data.bins,3);
nStimShown = size(data.bins,1);
%% artifact rejection
% Determine number of channels that have any kind of response (and are
% capable of registering artifacts)
nChanWithSignal      = 0;
indChanWithSignal    = [];

for iC = 1:nChan
    randDist    = normrnd(1,1,[1 nStimShown]);
    chanDist    = sum(data.bins(:,startBin:endBin,iC));
    p  = shuffleTest2Dist(randDist, chanDist, 1000);
    if p < 0.05
        nChanWithSignal = nChanWithSignal+1;
        indChanWithSignal(end+1) = iC;
    end
end

trialResp       = squeeze(sum(data.bins(:,startBin:endBin,:),2));
respAvgAllChan  = nanmean(trialResp,2);
maxAvg          = max(respAvgAllChan(:));

numStDev        = 3;
nThreshChan     = 1; %ceil(nChanWithSignal * 0.3);         % Number of channels that have to show simultaneous outlier activity  11/8/18 changed to 1 so can remove trials from each channel separately.
threshCutoff    = mean(respAvgAllChan) +  std(respAvgAllChan)*numStDev;

% If majority of channels have outlier activity at the same time, is
% likely an artifact.
% Outlier activity (for each channel) defined as trial activity that
% exceeds the mean + thresh*SD
indOutliers     = find(respAvgAllChan > threshCutoff);
chanIndOutliers = zeros(nChan, length(indOutliers));
chanThresh      = nan(1,nChan);

for iC = 1:nChan
    chanThresh(iC)  = getThresh(trialResp(:,iC), numStDev);
    temp            = find(trialResp(:,iC) > chanThresh(iC));
    matchInd        = intersect(temp, indOutliers);
    chanIndOutliers(iC,:) = ismember(indOutliers, matchInd);
end

nChanWithOutlier = sum(chanIndOutliers,1);
badTrials = indOutliers(find(nChanWithOutlier > nThreshChan));
trialResp(badTrials,:) = NaN;
%% Test to see if there is any tuning 

%     JTS = nan(1, nChan);
%     for iC = 1:nChan
%         trimRep = @(x, nRepMin) x(1:nRepMin);
%         respAvgPerRepTrimmed = cellfun(@(x) trimRep(x,nRepMin), respAvgPerRep(:,:,iC), 'un', 0);
%         respAvgPerRepTrimmed = cellfun(@(x) reshape(x,1,1,[]), respAvgPerRepTrimmed,'un',0);
%         respAvgPerRepTrimmed = cell2mat(respAvgPerRepTrimmed);
%         [JTS(iC),~,~] = JT_VarOfMeans(respAvgPerRepTrimmed);
%     end
%% Create cleanData matrix
cleanData.trialResp  =  trialResp;
cleanData.badTrials  = badTrials;
cleanData.chanThresh = chanThresh;
%%
function threshVal = getThresh(resp, threshMult)
    threshVal = nanmean(resp) + std(resp) * threshMult;
