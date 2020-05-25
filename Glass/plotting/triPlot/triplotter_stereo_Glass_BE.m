function [] = triplotter_stereo_Glass_BE(data,grayMax)
location = determineComputer;

if contains(data.RE.animal,'WV')
    if location == 1
        if contains(data.RE.programID,'Small')
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps',data.RE.animal, data.RE.array);
        else
            figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps',data.RE.animal, data.RE.array);
        end
    elseif location == 0
        if contains(data.RE.programID,'Small')
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/4Deg/EyeComps',data.RE.animal, data.RE.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/8Deg/EyeComps',data.RE.animal, data.RE.array);
        end
    end
else
    if location == 1
        figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/Glass/%s/EyeComps',data.RE.animal, data.RE.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/Glass/%s/EyeComps',data.RE.animal, data.RE.array);
    end
end
cd(figDir)

folder2 = 'triplot';
mkdir(folder2)
cd(sprintf('%s',folder2))
%% collapsed across all dt dx
figure(7)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 800 500]);


subplot(1,2,1)       
radDps = abs(squeeze(data.LE.radBlankDprime(end,:,:,:)));
conDps = abs(squeeze(data.LE.conBlankDprime(end,:,:,:)));
nosDps = abs(squeeze(data.LE.noiseBlankDprime(:,:,:)));

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
nosDps = abs(squeeze(data.RE.noiseBlankDprime(:,:,:)));

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
suptitle(sprintf('%s %s stimulus vs blank dPrime at 100%% coherence all parameters',data.RE.animal, data.RE.array))
figName = [data.RE.animal,'_BE_',data.RE.array,'_triplot_allParams_equalAllSubs'];
print(gcf, figName,'-dpdf','-fillpage')