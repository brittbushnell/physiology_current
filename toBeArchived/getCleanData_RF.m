function [cleanData] = getCleanData_RF(data,startBin,endBin)


meanBins1 = mean(data.bins(:,startBin:endBin,:),2)./0.01;
useBins = squeeze(meanBins1);
%maxBad = round(size(useBins,1)/10);
badBins = isoutlier(useBins,'grubbs',1); 
%badBins = isoutlier(useBins,'gesd','ThresholdFactor',1,'MaxNumOutliers',maxBad);
badTrials = sum(badBins,2);
%% Create cleaned verison of data structures
cleanXpos = double(data.pos_x);
cleanYpos = double(data.pos_y);
cleanRF = double(data.rf);
cleanAmp = double(data.amplitude);
cleanOri = double(data.orientation);
cleanSF = double(data.spatialFrequency);
cleanRad = double(data.radius);
cleanFile = data.filename;
cleanOn = data.stimOn;
cleanOff = data.stimOff;
cleanBins = double(data.bins); % note, if you don't make it a double, cannot set things to nan.

for trl = 1:size(badBins,1)
    if badTrials(trl,1) > 1
        cleanBins(trl,:,:) = nan; % If that trial is not good, make that trial nan for all channels
        cleanXpos(trl,1) = nan;
        cleanYpos(trl,1) = nan;
        cleanRF(trl,1) = nan;
        cleanAmp(trl,1) = nan;
        cleanOri(trl,1) = nan;
        cleanSF(trl,1) = nan;
        cleanRad(trl,1) = nan;
        %cleanFile(trl,1) = nan;  % not converting cell array of filenames to nan causese problems
        cleanOn(trl,1) = nan;
        cleanOff(trl,1) = nan;
    end
end
    %% Remove nan rows and trials
    
    cleanAmp(isnan(cleanAmp)) = [];
    cleanXpos(isnan(cleanXpos)) = [];
    cleanYpos(isnan(cleanYpos)) = [];
    cleanRF(isnan(cleanRF)) = [];
    cleanOri(isnan(cleanOri)) = [];
    cleanSF(isnan(cleanSF)) = [];
    cleanRad(isnan(cleanRad)) = [];
    
    cleanBins(any(any(isnan(cleanBins),3),2),:,:) = [];
%% organize into cleanData
cleanData.bins = cleanBins;
cleanData.pos_x = cleanXpos;
cleanData.pos_y = cleanYpos;
cleanData.rf = cleanRF;
cleanData.amplitude = cleanAmp;
cleanData.orientation = cleanOri;
cleanData.spatialFrequency = cleanSF;
cleanData.radius = cleanRad;
cleanData.filename = cleanFile;
cleanData.stimOn = cleanOn;
cleanData.stimOff = cleanOff;
