function varargout = Ns6toBandPowerAlt(ns6fileName,bandCutoff,bandPowerFileName)

if nargout==0
    if nargin<3
        error('Ns6toBandPower: must supply file name for saving or accept output variable.')
    else
        doSave=1;
    end
else
    doSave=0;
end
    
fsPow = 120; % of resulting power time-series
nElec = 96;
iqrScoreThresh = 100; % threshold for rejecting artefacts
butterworthOrder = 4; % order of Butterworth filter defining frequency band
if ~exist('bandCutoff','var') || isempty(bandCutoff)
    bandCutoff = [300 6000];
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

% ------------------------- %
% Define Butterworth filter %
% ------------------------- %
[butterCoefB,butterCoefA]=butter(butterworthOrder,bandCutoff./(nsheader.SamplingFreq/2));

% -------------------------------- %
% Filter voltage and average power %
% -------------------------------- %
bandPower = nan(nBins,nElec);
sumVolt = zeros(1,nsdata.DataPoints);
for iC = 1:2%nElec
    fprintf('Ns6toBandPower: channel %d: ',iC)
    voltage = cat(2,zeros(1,nsdata.TimeStamps(1)),(double(nsdata.raw{1}(iC,:))),zeros(1,60));    
    voltage = FiltFiltM(butterCoefB,butterCoefA,voltage);
    
    sumVolt = nansum([sumVolt;voltage(1:nsdata.DataPoints)]);
    
    power0 = voltage.^2;
    powerFiltered = conv(power0,averagingFilt,'same');
    subSampInd = samplesPerPowerBin:samplesPerPowerBin:length(voltage);
    powerSubSamp = powerFiltered(subSampInd);    
    
%     voltSubSamp = voltage(subSampInd);
    
    % artefact rejection
    quarts = prctile(powerSubSamp,[25 75]);
    iqrScore = (powerSubSamp-quarts(2))./(quarts(2)-quarts(1));
    bindArtefact = iqrScore>iqrScoreThresh;
    powerSubSamp(bindArtefact)=nan;

    bandPower(1:numel(powerSubSamp),iC) = powerSubSamp;
%     bandVolt(:,iC) = voltage(1:nsdata.DataPoints);
    
    fprintf('%d artefacts rejected. ',sum(bindArtefact))
    fprintf('\n')
end

if doSave
    save(bandPowerFileName,'bandPower','sumVolt')
else
    varargout{1} = bandPower;
    varargout{2} = sumVolt;
end

