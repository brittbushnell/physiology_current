clear all;
dataDir = '/Volumes/crshooner32';
fileName = 'm638l01#6[ar_LmsAi]';
[PLXimport,ExpoXMLimport] = loadfiles([dataDir,'/',fileName]);
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

%%
close all
Channel  = 2;
% SFs  = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'DKL Texture','',0,'Spatial Frequency X')];
% Cons = [nan;GetEvents(ExpoXMLimport,ExpoXMLimport.passes.IDs(2:end),'DKL Texture','',0,'Contrast')];
blockId = ExpoXMLimport.passes.BlockIDs(2:end);
blockIdVals = unique(blockId);
nCond = 6;
X = nan(nCond,PLXimport.Spikes.nChannels);
for iC = 1:nCond
    bind = blockId==blockIdVals(iC);
    for iU=1:PLXimport.Spikes.nChannels
        if ~isempty(SpikeCounts{Channel,iU})
            X(iC,iU) = mean(SpikeCounts{Channel,iU}(bind));
        else
            X(iC,iU) = nan;
        end
    end    
end
XsubBase = bsxfun(@minus,X,X(6,:));
XsubMean = bsxfun(@minus,X,mean(X));
Xnorm = bsxfun(@rdivide,X,max(abs(X)));
isoLumRat = X(4,:)./X(5,:);
isoLumDif = X(4,:)-X(5,:);
% figure
% plot(X,'.-')

figure
plot(XsubBase,'.-')

% figure
% plot(Xnorm,'.-')

figure
hist(isoLumDif,20)