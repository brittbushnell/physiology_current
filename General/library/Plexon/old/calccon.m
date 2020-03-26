clear all;
[PLXimport,ExpoXMLimport] = loadfiles('C:\Data\M638\m638l01#4[ar_rvc11]');
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
TFs  = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'Surface','',0,'Drift Rate')];
Cons = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'DKL Texture','',0,'Contrast')];

TFs(Cons==0) = 100;

UniqueTFs = unique(TFs(~isnan(TFs)));
nUniqueTFs = length(UniqueTFs);


Channel  = 1;
Tuning = nan(PLXimport.Spikes.nChannels,nUniqueTFs);
for kk=0:nUniqueTFs-1
    valid = find(TFs==UniqueTFs(kk+1));
    for jj=1:PLXimport.Spikes.nChannels
        if ~isempty(SpikeCounts{Channel,jj})
            Tuning(jj,kk+1) = mean(SpikeCounts{Channel,jj}(valid));
        else
            Tuning(jj,kk+1) = nan;
        end
    end    
end

TuningBaselineCorrected = Tuning(:,1:nUniqueTFs-1)-repmat(Tuning(:,nUniqueTFs),1,nUniqueTFs-1);
TuningBaselineCorrectedNormMax      = bsxfun(@rdivide,TuningBaselineCorrected,max(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormArea     = bsxfun(@rdivide,TuningBaselineCorrected,sum(abs(TuningBaselineCorrected),2));
TuningBaselineCorrectedNormMaxMean  = nanmean(TuningBaselineCorrectedNormMax,1);
TuningBaselineCorrectedNormAreaMean = nanmean(TuningBaselineCorrectedNormArea,1);

subplot(3,2,1);semilogx(UniqueTFs(1:end-1),TuningBaselineCorrected);
box off;title('all channels');
subplot(3,2,2);semilogx(UniqueTFs(1:end-1),nanmean(TuningBaselineCorrected));
box off;title('all channels mean');
subplot(3,2,3);semilogx(UniqueTFs(1:end-1),TuningBaselineCorrectedNormMax);
box off;title('Norm max');
subplot(3,2,4);semilogx(UniqueTFs(1:end-1),TuningBaselineCorrectedNormMaxMean);
box off;title('Norm max mean');
subplot(3,2,5);semilogx(UniqueTFs(1:end-1),TuningBaselineCorrectedNormArea);
box off;title('Norm area');
subplot(3,2,6);semilogx(UniqueTFs(1:end-1),TuningBaselineCorrectedNormAreaMean);
box off;title('Norm area mean');