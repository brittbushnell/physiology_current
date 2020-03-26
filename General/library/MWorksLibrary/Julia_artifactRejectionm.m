    
%% Artifact rejection -- remove trials with spurious activity across channels.
    % Determine number of channels that have any kind of response (and are
    % capable of registering artifacts)
    nChanWithSignal      = 0;
    indChanWithSignal    = [];
    for iC = 1:nChan
        randDist    = normrnd(1,1,[1 nTrials]);
        chanDist    = sum(data.bins(:,1:nBins,iC));
        p  = shuffleTest2Dist(randDist, chanDist, 1000);
        if p < 0.05
            nChanWithSignal = nChanWithSignal+1;
            indChanWithSignal(end+1) = iC;
        end
    end
    
    trialResp       = squeeze(sum(data.bins(:,1:30,:),2));
    respAvgAllChan  = nanmean(trialResp,2);
    maxAvg          = max(respAvgAllChan(:));
    
    threshMult      = 3;                                                   % number of standard deviations to count as outlier
    nThreshChan     = ceil(nChanWithSignal * 0.4);                         % Number of channels that have to show simultaneous outlier activity
    threshCutoff    = mean(respAvgAllChan) +  std(respAvgAllChan)*threshMult;
   
    % If majority of channels have outlier activity at the same time, is
    % likely an artifact.
    % Outlier activity (for each channel) defined as trial activity that
    % exceeds the mean + thresh*SD
    indOutliers     = find(respAvgAllChan > threshCutoff);
    chanIndOutliers = zeros(nChan, length(indOutliers));
    chanThresh      = nan(1,nChan);
    for iC = 1:nChan
        chanThresh(iC)  = getThresh(trialResp(:,iC), threshMult);
        temp            = find(trialResp(:,iC) > chanThresh(iC));
        matchInd        = intersect(temp, indOutliers);
        chanIndOutliers(iC,:) = ismember(indOutliers, matchInd);
    end
    nChanWithOutlier = sum(chanIndOutliers,1);
    badTrials = indOutliers(find(nChanWithOutlier > nThreshChan));
    %%
        function threshVal = getThresh(resp, threshMult)
        threshVal = nanmean(resp) + std(resp)*threshMult;
    end