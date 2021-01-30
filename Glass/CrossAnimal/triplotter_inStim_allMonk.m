function triplotter_inStim_allMonk(data,grayMax)
% create triplots using the preferred dt,dx and channels with receptive
% fields within the stimulus.
%% 
radDps = abs(squeeze(V1.conRadRE.radBlankDprime(end,:,:,:)));
conDps = abs(squeeze(V1.conRadRE.conBlankDprime(end,:,:,:)));
nosDps = abs(squeeze(V1.conRadRE.noiseBlankDprime(1,:,:,:)));

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
%%
figure(14)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500]);
  


subplot(2,2,1) 
triplotter_stereo_Glass(dps,grayMax);

if contains(V1.conRadRE.animal,'XT')
    title(sprintf('LE n: %d',sum(V1.conRadLE.goodCh)))
else
    title(sprintf('FE n: %d',sum(V1.conRadLE.goodCh)))
end


subplot(2,2,2)       

triplotter_stereo_Glass(dps,grayMax);

if contains(V1.conRadRE.animal,'XT')
    title(sprintf('RE n: %d',sum(V1.conRadRE.goodCh)))
else
    title(sprintf('AE n: %d',sum(V1.conRadRE.goodCh)))
end

%
suptitle(sprintf('%s %s stimulus vs blank dPrime at 100%% coherence all parameters cleaned and merged data',V1.conRadRE.animal, V1.conRadRE.array))
% figName = [data.conRadRE.animal,'_BE_',data.conRadRE.array,'_triplot_allParams_clean'];
% print(gcf, figName,'-dpdf','-fillpage')