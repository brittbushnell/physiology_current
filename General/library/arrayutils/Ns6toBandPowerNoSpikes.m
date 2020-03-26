function varargout = Ns6toBandPowerNoSpikes(ns6fileName,nevFileName,iM,iP,iR,unitChan,bandCutoff,bandPowerFileName)
    
doSave = 1;
fsPow = 120; % of resulting power time-series
nElec = 96;
iqrScoreThresh = 100; % threshold for rejecting artefacts
butterworthOrder = 4; % order of Butterworth filter defining frequency band
if ~exist('bandCutoff','var') || isempty(bandCutoff)
    bandCutoff = [300 6000];
end

% ----------------------------- %
% Load spike data from nev file %
% ----------------------------- %
disp('GetBandPowerNoSpikes: Loading NEV')
% if (iM==4&&iP==2) || (iM==7&&iP==3)
%     nevIn = openNEV_rk(nevFileName,'nomat');
% else
    nevIn = openNEV_rk(nevFileName);
% end



% ----------------------------------- %
% Load raw voltage data from ns6 file %
% ----------------------------------- %
disp('GetBandPowerNoSpikes: Loading NS6')
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
for iC = unitChan
    fprintf('Ns6toBandPowerNoSpikes: channel %d: ',iC)
    voltage = cat(2,zeros(1,nsdata.TimeStamps(1)),(double(nsdata.raw{1}(iC,:))),zeros(1,60));    
    voltage = FiltFiltM(butterCoefB,butterCoefA,voltage);
    
    st = double(nevIn.Data.Spikes.TimeStamp(nevIn.Data.Spikes.Electrode==iC & nevIn.Data.Spikes.Unit==1));
    ST = bsxfun(@plus,st,(-200:200)');
    ST = ST(:,~any(ST<=0,1));
    ST = ST(:,~any(ST>numel(voltage),1));
    spikeMean = mean(voltage(ST),2);
    del = zeros(size(voltage));
    del(st) = 1;
    spikes = conv(del,spikeMean,'same');
    mua = voltage - spikes;
    
    %plotInd = 4800:5400; % example spike for iM=6, iP=2, electrode 67
    plotInd(:,1) = ST(:,5);
    plotInd(:,2) = ST(:,end-5);
    yL = [min(spikeMean),max(spikeMean)];
    for i = 1:2
        subplot2(3,2,1,i)
        plot(voltage(plotInd(:,i)),'k-');
        ylim(yL)
        subplot2(3,2,2,i)
        plot(spikes(plotInd(:,i)),'r-');
        ylim(yL)
        subplot2(3,2,3,i)
        plot(mua(plotInd(:,i)),'b-');
        ylim(yL)
    end
    print(['/home/shooner/spikeSubFigs/spikeSub_iM',...
        num2str(iM),'_iP',num2str(iP),'_iR',num2str(iR),'_iC',num2str(iC),'.eps'],'-depsc')
    
    
%     power0 = voltage.^2;
    power0 = mua.^2;
    
    
    powerFiltered = conv(power0,averagingFilt,'same');
    subSampInd = samplesPerPowerBin:samplesPerPowerBin:length(voltage);
    powerSubSamp = powerFiltered(subSampInd);    
    
    % artefact rejection
    quarts = prctile(powerSubSamp,[25 75]);
    iqrScore = (powerSubSamp-quarts(2))./(quarts(2)-quarts(1));
    bindArtefact = iqrScore>iqrScoreThresh;
    powerSubSamp(bindArtefact)=nan;

    bandPower(1:numel(powerSubSamp),iC) = powerSubSamp;
    
    fprintf('%d artefacts rejected. ',sum(bindArtefact))
    fprintf('\n')
end

if doSave
    save(bandPowerFileName,'bandPower')
else
    varargout{1} = bandPower;
end

