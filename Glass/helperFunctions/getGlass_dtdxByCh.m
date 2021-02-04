function getGlass_dtdxByCh(trLE,trRE,conRadLE,conRadRE)

trLEz(:,:,:,:) = nanmean(squeeze(trLE.GlassTRZscore(:,end,:,:,:,:)),5);
trREz(:,:,:,:) = nanmean(squeeze(trRE.GlassTRZscore(:,end,:,:,:,:)),5);

conLEz(:,:,:) = nanmean(squeeze(conRadLE.conZscore(end,:,:,:,:)),4);
radLEz(:,:,:) = nanmean(squeeze(conRadLE.radZscore(end,:,:,:,:)),4);
nozLEz(:,:,:) = nanmean(squeeze(conRadLE.noiseZscore(1,:,:,:,:)),4);

conREz(:,:,:) = nanmean(squeeze(conRadRE.conZscore(end,:,:,:,:)),4);
radREz(:,:,:) = nanmean(squeeze(conRadRE.radZscore(end,:,:,:,:)),4);
nozREz(:,:,:) = nanmean(squeeze(conRadRE.noiseZscore(1,:,:,:,:)),4);
%%
figure(64)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in translational Glass patterns',trLE.animal,trLE.eye, trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trLEz,trLE.goodCh,trLE.inStim,trLE.amap)

figName = [trLE.animal,'_LE_',trLE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
% print(gcf,figName,'-dpdf','-fillpage')
%%
figure(65)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in translational Glass patterns',trLE.animal,trLE.eye, trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trREz,trRE.goodCh,trRE.inStim,trRE.amap)

figName = [trRE.animal,'_RE_',trRE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
