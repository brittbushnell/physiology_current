clear all;
[PLXimport,ExpoXMLimport] = loadfiles('C:\Data\M638\m638l01#4[ar_size9]');
%%
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
SizesA  = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end-50),'Surface','',0,'Width')];
SizesB  = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end-50),'Surface','',1,'Width')];
Cons   = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end-50),'DKL Texture','',0,'Contrast')];

SizesA(Cons==0) = 101;
SizesA(SizesB > 0) = 100; 

UniqueSizes = unique(SizesA(~isnan(SizesA)));
nUniqueSizes = length(UniqueSizes);


Channel  = 1;
Tuning = nan(PLXimport.Spikes.nChannels,nUniqueSizes);
for kk=0:nUniqueSizes-1
    valid = find(SizesA==UniqueSizes(kk+1));
    for jj=1:PLXimport.Spikes.nChannels
        if ~isempty(SpikeCounts{Channel,jj})
            Tuning(jj,kk+1) = mean(SpikeCounts{Channel,jj}(valid));
        else
            Tuning(jj,kk+1) = nan;
        end
    end    
end

TuningBaselineCorrected = Tuning(:,1:nUniqueSizes-2)-repmat(Tuning(:,nUniqueSizes),1,nUniqueSizes-2);
TuningBaselineCorrectedNormMax      = bsxfun(@rdivide,TuningBaselineCorrected,max(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormArea     = bsxfun(@rdivide,TuningBaselineCorrected,sum(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormMaxMean  = nanmean(TuningBaselineCorrectedNormMax,1);
TuningBaselineCorrectedNormAreaMean = nanmean(TuningBaselineCorrectedNormArea,1);

subplot(3,2,1);plot(UniqueSizes(1:end-2),TuningBaselineCorrected);
box off;title('all channels');
subplot(3,2,2);plot([0;UniqueSizes(1:end-2)],[0 nanmean(TuningBaselineCorrected)]);
box off;title('all channels mean');
subplot(3,2,3);plot(UniqueSizes(1:end-2),TuningBaselineCorrectedNormMax);
box off;title('Norm max');
subplot(3,2,4);plot(UniqueSizes(1:end-2),TuningBaselineCorrectedNormMaxMean);
box off;title('Norm max mean');
subplot(3,2,5);plot(UniqueSizes(1:end-2),TuningBaselineCorrectedNormArea);
box off;title('Norm area');
subplot(3,2,6);plot(UniqueSizes(1:end-2),TuningBaselineCorrectedNormAreaMean);
box off;title('Norm area mean');