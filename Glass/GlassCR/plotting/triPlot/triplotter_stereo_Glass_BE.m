function [] = triplotter_stereo_Glass_BE(data,grayMax)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/EyeComps/triplot/',data.RE.animal, data.RE.programID, data.RE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/EyeComps/triplot/',data.RE.animal, data.RE.programID, data.RE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% collapsed across all dt dx
figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500]);


subplot(1,2,1)       
radDps = abs(squeeze(data.LE.radBlankDprime(end,:,:,:)));
conDps = abs(squeeze(data.LE.conBlankDprime(end,:,:,:)));
nosDps = abs(squeeze(data.LE.noiseBlankDprime(1,:,:,:)));

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]);
rDp = max(rDp');
rDp = rDp';
cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = max(cDp');
cDp = cDp';
nDp = squeeze([squeeze(nosDps(1,1,:)),squeeze(nosDps(1,2,:)),squeeze(nosDps(2,1,:)),squeeze(nosDps(2,2,:))]);
nDp = max(nDp');
nDp = nDp';

dps = [rDp,cDp,nDp];

triplotter_stereo_Glass(dps,grayMax);

if contains(data.RE.animal,'XT')
    title(sprintf('LE n: %d',sum(data.LE.goodCh)))
else
    title(sprintf('FE n: %d',sum(data.LE.goodCh)))
end


subplot(1,2,2)       
radDps = abs(squeeze(data.RE.radBlankDprime(end,:,:,:)));
conDps = abs(squeeze(data.RE.conBlankDprime(end,:,:,:)));
nosDps = abs(squeeze(data.RE.noiseBlankDprime(1,:,:,:)));

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]);
rDp = max(rDp');
rDp = rDp';
cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = max(cDp');
cDp = cDp';
nDp = squeeze([squeeze(nosDps(1,1,:)),squeeze(nosDps(1,2,:)),squeeze(nosDps(2,1,:)),squeeze(nosDps(2,2,:))]);
nDp = max(nDp');
nDp = nDp';

dps = [rDp,cDp,nDp];

triplotter_stereo_Glass(dps,grayMax);

if contains(data.RE.animal,'XT')
    title(sprintf('RE n: %d',sum(data.RE.goodCh)))
else
    title(sprintf('AE n: %d',sum(data.RE.goodCh)))
end

%
suptitle(sprintf('%s %s stimulus vs blank dPrime at 100%% coherence all parameters cleaned and merged data',data.RE.animal, data.RE.array))
figName = [data.RE.animal,'_BE_',data.RE.array,'_triplot_allParams_clean'];
print(gcf, figName,'-dpdf','-fillpage')