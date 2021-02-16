function getGlass_dtdxByCh(trLE,trRE,conRadLE,conRadRE)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/',trLE.animal,trLE.programID,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/',trLE.animal,trLE.programID,trLE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% LE translational
nozTmp  = nanmean(squeeze(trLE.noiseZscore(1,end,:,:,:,:)),4);
noztLEz(1,:,:,:) = nozTmp;

blankZ = (nanmean(trLE.blankZscore,2));

tmp = nanmean(squeeze(trLE.GlassTRZscore(:,end,:,:,:,:)),5);
trLEz = cat(1,noztLEz,tmp); % now, the first value is noise
%%
figure(64)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1000],'PaperPosition',[-1.2 0.604 18 7.4])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s LE %s mean z scores in translational Glass patterns',trLE.animal,trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trLEz,blankZ,trLE.goodCh,trLE.inStim,trLE.amap,trLE.animal)

figName = [trLE.animal,'_LE_',trLE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-fillpage')
%% RE translational
nozTmp  = nanmean(squeeze(trRE.noiseZscore(1,end,:,:,:,:)),4);
noztREz(1,:,:,:) = nozTmp;

blankZ = (nanmean(trRE.blankZscore,2));

tmp = nanmean(squeeze(trRE.GlassTRZscore(:,end,:,:,:,:)),5);
trREz = cat(1,noztREz,tmp); % now, the first value is noise
%%
figure(65)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1000],'PaperPosition',[-1 0.604 13 7.5])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s RE %s mean z scores in translational Glass patterns',trLE.animal, trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trREz,blankZ,trRE.goodCh,trRE.inStim,trRE.amap,trRE.animal)

figName = [trRE.animal,'_RE_',trRE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-fillpage')
%%
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/',trLE.animal,conRadLE.programID,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/',trLE.animal,conRadLE.programID,trLE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% concentric and radial LE
conLEz = nanmean(squeeze(conRadLE.conZscore(end,:,:,:,:)),4);
radLEz = nanmean(squeeze(conRadLE.radZscore(end,:,:,:,:)),4);
nozLEz = nanmean(squeeze(conRadLE.noiseZscore(1,:,:,:,:)),4);
bnkLEz = nanmean(conRadLE.blankZscore,2);
%%
figure(66)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1000],'PaperPosition',[-1 0.60417 13 7.2917])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s LE %s mean z scores in Glass patterns',conRadLE.animal, conRadLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassCR_dtdxByCh(conLEz,radLEz,nozLEz,bnkLEz,conRadLE.goodCh,conRadLE.inStim,conRadLE.amap,conRadLE.animal)

figName = [conRadLE.animal,'_LE_',conRadLE.array,'_Glass_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-fillpage')
%% concentric and radial RE
conREz = nanmean(squeeze(conRadRE.conZscore(end,:,:,:,:)),4);
radREz = nanmean(squeeze(conRadRE.radZscore(end,:,:,:,:)),4);
nozREz = nanmean(squeeze(conRadRE.noiseZscore(1,:,:,:,:)),4);
bnkREz = nanmean(conRadRE.blankZscore,2);
%%
figure(67)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1400 1000],'PaperPosition',[-1 0.60417 13 7.2917])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s RE %s mean z scores in Glass patterns',conRadRE.animal, conRadRE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassCR_dtdxByCh(conREz,radREz,nozREz,bnkREz,conRadRE.goodCh,conRadRE.inStim,conRadRE.amap,conRadRE.animal)

figName = [conRadRE.animal,'_RE_',conRadRE.array,'_Glass_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-fillpage')