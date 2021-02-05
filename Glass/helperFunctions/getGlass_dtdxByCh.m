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
%% declair which subplot is the bottom left for axis labels
if contains(trLE.animal,'XT')
    if contains(trLE.array,'V1')
        cornerCh = 81;
    else
        cornerCh = 83;
    end
elseif contains(trLE.animal,'WU')
    if contains(trLE.array,'V1')
        cornerCh = 90;
    else
        cornerCh = 81;
    end
else
    if contains(trLE.array,'V1')
        cornerCh = 73;
    else
        cornerCh = 2;
    end
end
%% LE translational
tmp  = nansum(squeeze(trLE.noiseZscore(1,end,:,:,:,:)),4);
noztLEz(1,:,:,:) = tmp;
clear tmp;
tmp = nansum(squeeze(trLE.GlassTRZscore(:,end,:,:,:,:)),5);
trLEz = cat(1,noztLEz,tmp); % now, the first value is noise

figure(64)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000],'PaperPosition',[-1.2 0.604 18 7.4])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in translational Glass patterns',trLE.animal,trLE.eye, trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trLEz,trLE.goodCh,trLE.inStim,trLE.amap,cornerCh)

figName = [trLE.animal,'_LE_',trLE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-bestfit')
%% RE translational
tmp  = nansum(squeeze(trRE.noiseZscore(1,end,:,:,:,:)),4);
noztREz(1,:,:,:) = tmp;
clear tmp;
tmp = nansum(squeeze(trRE.GlassTRZscore(:,end,:,:,:,:)),5);
trREz = cat(1,noztREz,tmp); % now, the first value is noise

figure(65)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000],'PaperPosition',[-1 0.604 13 7.5])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in translational Glass patterns',trLE.animal,trLE.eye, trLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassTR_dtdxByCh(trREz,trRE.goodCh,trRE.inStim,trRE.amap,cornerCh)

figName = [trRE.animal,'_RE_',trRE.array,'_GlassTR_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-bestfit')
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
conLEz = nansum(squeeze(conRadLE.conZscore(end,:,:,:,:)),4);
radLEz = nansum(squeeze(conRadLE.radZscore(end,:,:,:,:)),4);
nozLEz = nansum(squeeze(conRadLE.noiseZscore(1,:,:,:,:)),4);

figure(66)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000],'PaperPosition',[-1 0.60417 13 7.2917])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in Glass patterns',conRadLE.animal,conRadLE.eye, conRadLE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassCR_dtdxByCh(conLEz,radLEz,nozLEz,conRadLE.goodCh,conRadLE.inStim,conRadLE.amap,cornerCh)

figName = [conRadLE.animal,'_LE_',conRadLE.array,'_Glass_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-bestfit')
%% concentric and radial RE
conREz = nansum(squeeze(conRadRE.conZscore(end,:,:,:,:)),4);
radREz = nansum(squeeze(conRadRE.radZscore(end,:,:,:,:)),4);
nozREz = nansum(squeeze(conRadRE.noiseZscore(1,:,:,:,:)),4);

figure(67)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1200 1000],'PaperPosition',[-1 0.60417 13 7.2917])
set(gcf,'PaperOrientation','Landscape');

s = suptitle(sprintf('%s %s %s mean z scores in Glass patterns',conRadRE.animal,conRadRE.eye, conRadRE.array));
s.FontSize = 20;
s.Position(2) = s.Position(2)+0.01;

plotGlassCR_dtdxByCh(conREz,radREz,nozREz,conRadRE.goodCh,conRadRE.inStim,conRadRE.amap,cornerCh)

figName = [conRadRE.animal,'_RE_',conRadRE.array,'_Glass_','ZscoreVSdtdx.pdf'];
print(gcf,figName,'-dpdf','-bestfit')
