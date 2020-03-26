function GetBandPower(xmlFileName,nevFileName,ns6fileName,bandPowerFileName,passDuration,bandCutoff,elecs)
% GetBandPower(xmlFileName,nevFileName,ns6fileName,bandPowerFileName,passDuration,bandCutoff,elecs)
%
% Computes spiking-band power from raw Blackrock data.
% Power is averaged over 8.33 ms bins (120 Hz), and saved in an array of
% time series, one for each electrode and each pass of the Expo program. 
% This array (bandPower) has size [nBins x nPasses x 96] 
% E.g. if there are 5000 passes and passDuration=1, 
% size(bandPower) = [120 5000 96]. The array is saved in a mat file 
% (bandPowerFileName). 
%
% Inputs:
% -- All file names are required (Expo-generated XML and Blackrock NEV files 
% are needed to time-align Blackroch data to Expo passes.)
% -- passDuration specifies the length of the time-series, aligned to the
% start of each Expo pass.
% A single pass duration is used for all passes, so provide the duration of
% the longest pass, and note that time series from shorter passes will
% contain data from beyond the end of the pass.
% -- bandCutoff is optional. Default is 300Hz - 6000Hz.
% -- elecs is optional. (Electrodes to process) Default is all 96.
%
% Artefact rejection:
% Recording artefacts are identified using an inter-quartile-range (iqr) metric.
% The 25% and 75% percentiles of the power distribution on one electrode
% are defined as p25 and p75, and the inter-quartile-range score of a single
% bin, p(t), defined as (p(t)-p75)/(p75-p25). Bins with iqr scores > 100 are
% replaced by NaNs. The output should therefore be processed using
% nanmean to ignore artefacts.


% ---------- %
% Parameters %
% ---------- %
% Sample rates
fsExpo = 10000; % of Expo timestamps
fsPow = 120; % of resulting power time-series
nElec = 96;
iqrScoreThresh = 100; % threshold for rejecting artefacts
segN = floor(passDuration*fsPow); % number of bins in each time series
butterworthOrder = 4; % order of Butterworth filter defining frequency band
if ~exist('bandCutoff','var') || isempty(bandCutoff)
    bandCutoff = [300 6000];
end
if ~exist('elecs','var')
   elecs = 1:nElec; 
end

% ----------------------------------- %
% Load raw voltage data from ns6 file %
% ----------------------------------- %
disp('GetBandPower: Loading NS6')
[nsdata,nsheader] = getNSxData(ns6fileName);
% number of blackrock samples (30000Hz) in one power bin (120Hz):
samplesPerPowerBin = nsheader.SamplingFreq/fsPow;
% number of bins in whole file:
nBins = ceil(nsdata.DataPoints/samplesPerPowerBin);
% boxcar filter kernel used to average over 8.3ms bins:
averagingFilt = ones(1,samplesPerPowerBin)./samplesPerPowerBin;


% -------------------------------------------- %
% Load Expo data and align with Blackrock .nev
% -------------------------------------------- %
disp('GetBandPower: Loading XML and NEV')
% D1 = LoadXMLandNEV(xmlFileName,nevFileName);
D1 = ReadXMLandNEV(xmlFileName,nevFileName);
%scale = D1.blackrock.scale;
scale = 1 + 2.5e-5;
offset = D1.blackrock.offset;

startTimes = double(D1.passes.StartTimes);
startTimesRescaled = startTimes(1) + (startTimes-startTimes(1)).*scale;
startTimesShifted = startTimesRescaled + double(offset);
startTimesConverted = startTimesShifted; 
startInd = round(startTimesConverted*fsPow/fsExpo);
startInd(startInd==0)=1;
                
psthInd = bsxfun(@plus,startInd,(0:segN-1)');
nPasses = find(psthInd(end,:)<=nBins,1,'last');
psthInd = psthInd(:,1:nPasses);

% ------------------------- %
% Define Butterworth filter %
% ------------------------- %
[butterCoefB,butterCoefA]=butter(butterworthOrder,bandCutoff./(nsheader.SamplingFreq/2));


% -------------------------------- %
% Filter voltage and average power %
% -------------------------------- %
bandPower = nan(segN,nPasses,nElec);
for iC = elecs
    fprintf('GetBandPower: channel %d: ',iC)
    voltage = cat(2,zeros(1,nsdata.TimeStamps(1)),(double(nsdata.raw{1}(iC,:))),zeros(1,60));    
    voltage = FiltFiltM(butterCoefB,butterCoefA,voltage);
    power0 = voltage.^2;
    powerFiltered = conv(power0,averagingFilt,'same');
    subSampInd = samplesPerPowerBin:samplesPerPowerBin:length(voltage);
    powerSubSamp = powerFiltered(subSampInd);    
    
    % artefact rejection
    quarts = prctile(powerSubSamp,[25 75]);
    iqrScore = (powerSubSamp-quarts(2))./(quarts(2)-quarts(1));
    bindArtefact = iqrScore>iqrScoreThresh;
    powerSubSamp(bindArtefact)=nan;

    bandPower(:,:,iC) = powerSubSamp(psthInd);
    
    fprintf('%d artefacts rejected. ',sum(bindArtefact))
    fprintf('\n')
end

save(bandPowerFileName,'bandPower')

