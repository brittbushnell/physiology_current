clear all;
[PLXimport,ExpoXMLimport] = loadfiles('C:\Data\M638\m638l01#1[ar_ori16]');

x = [PLXimport.Events.Times{8};PLXimport.Events.Times{8}(end)+mean(diff(PLXimport.Events.Times{8}))];

SpikeCounts = cell(PLXimport.Spikes.nUnits_max,PLXimport.Spikes.nChannels);
for ii=1:PLXimport.Spikes.nUnits_max
    for jj=1:PLXimport.Spikes.nChannels
        temp = histc(PLXimport.Spikes.Times{ii,jj},x);
        SpikeCounts{ii,jj} = temp(1:end-1);
    end
end
clear temp;

%
Oris = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'Surface','',0,'Orientation')];
Cons = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'DKL Texture','',0,'Contrast')];
Oris(Cons==0) = 360;

Channel  = 1;
Tuning = nan(PLXimport.Spikes.nChannels,17);
for kk=0:16
    valid = find(Oris==(kk*22.5));
    for jj=1:PLXimport.Spikes.nChannels
        if ~isempty(SpikeCounts{Channel,jj})
            Tuning(jj,kk+1) = mean(SpikeCounts{Channel,jj}(valid));
        else
            Tuning(jj,kk+1) = nan;
        end
    end    
end

TuningBaselineCorrected = Tuning(:,1:16)-repmat(Tuning(:,17),1,16);
plot(0:22.5:337.5,TuningBaselineCorrected);

TuningBaselineCorrectedNormMax      = bsxfun(@rdivide,TuningBaselineCorrected,max(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormArea     = bsxfun(@rdivide,TuningBaselineCorrected,sum(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormMaxMean  = nanmean(TuningBaselineCorrectedNormMax,1);
TuningBaselineCorrectedNormAreaMean = nanmean(TuningBaselineCorrectedNormArea,1);