clear
close all
clc
%%
% load('WV_BE_GlassTRCoh_V4_cleanMerged');
% trLE = data.LE; 
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WV_BE_V4_Glass_Aug2017_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WV_BE_V4_bothGlass_cleanMerged';
%  %%
% load('WU_BE_GlassTR_V4_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WU_BE_V4_Glass_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WU_BE_V4_bothGlass_cleanMerged';
%% 
load('XT_BE_GlassTR_V4_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('XT_BE_V4_Glass_clean_merged');
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data

newName = 'XT_BE_V4_bothGlass_cleanMerged';
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/%s/',trLE.animal,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/%s/',trLE.animal, trLE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
filename = [trLE.animal,'_',trLE.array];
trLE.amap = getBlackrockArrayMap(filename);
trRE.amap = getBlackrockArrayMap(filename);
conRadLE.amap = getBlackrockArrayMap(filename);
conRadLE.amap = getBlackrockArrayMap(filename);
%%  get receptive field information
trLE = callReceptiveFieldParameters(trLE);
trRE = callReceptiveFieldParameters(trRE);
%% print to command window number of channels that don't match on inclusion
fprintf('\n%d channels in %s %s array LE differ on inclusion\n',sum(trLE.goodCh ~= conRadLE.goodCh),trLE.animal,trLE.array)
fprintf('%d channels in %s %s array RE differ on inclusion\n',sum(trRE.goodCh ~= conRadRE.goodCh),trRE.animal,trRE.array)
%% get preferred parameters for translational
trLE = GlassTR_bestSumDOris(trLE);
trRE = GlassTR_bestSumDOris(trRE);
%% get prefered dt,dx parameters for concentric and radial data
conRadLE.prefParamsIndex = getGlassConRadPrefParamIndex(conRadLE);
conRadRE.prefParamsIndex = getGlassConRadPrefParamIndex(conRadRE);
%% Get preferred pattern at the preferred dt,dx
chRanksCRLE = nan(1,96);
chRanksTRLE = nan(1,96);
prefParamsCr = conRadLE.prefParamsIndex; % this says which dot,dx is preferred
prefParamsTr = trLE.prefParamsIndex;
for ch = 1:96
    if trLE.goodCh(ch) == 1
        chRanksCRLE(1,ch) = conRadLE.dPrimeRankBlank{prefParamsCr(ch)}(1,ch);
        chRanksTRLE(1,ch) = conRadLE.dPrimeRankBlank{prefParamsTr(ch)}(1,ch);
    end
end
conRadLE.prefPatternsPrefParams = chRanksCRLE;
trLE.prefPatternsPrefParams = chRanksTRLE;
clear prefParamsTr; clear prefParamsCr;

chRanksCRRE = nan(1,96);
chRanksTRRE = nan(1,96);
prefParamsCr = conRadRE.prefParamsIndex; % this says which dot,dx is preferred
prefParamsTr = trRE.prefParamsIndex;
for ch = 1:96
    if trRE.goodCh(ch) == 1
        chRanksCRRE(1,ch) = conRadRE.dPrimeRankBlank{prefParamsCr(ch)}(1,ch);
        chRanksTRRE(1,ch) = conRadRE.dPrimeRankBlank{prefParamsTr(ch)}(1,ch);
    end
end
conRadRE.prefPatternsPrefParams = chRanksCRLE;
trRE.prefPatternsPrefParams = chRanksTRLE;
%% identify receptive field locations relative to stimulus

[trLE.rfQuadrant, trLE.inStim, trLE.inStimCenter, trLE.within2Deg, trLE.rfParamsRelGlassFix] = getRFsRelGlass_ecc_Sprinkles(trLE, conRadLE);

conRadLE.rfQuadrant   = trLE.rfQuadrant;
conRadLE.inStim       = trLE.inStim;
conRadLE.inStimCenter = trLE.inStimCenter;
conRadLE.within2Deg   = trLE.within2Deg;

[trRE.rfQuadrant, trRE.inStim, trRE.inStimCenter, trRE.within2Deg, trRE.rfParamsRelGlassFix] = getRFsRelGlass_ecc_Sprinkles(trRE, conRadRE);

conRadRE.rfQuadrant   = trRE.rfQuadrant;
conRadRE.inStim       = trRE.inStim;
conRadRE.inStimCenter = trRE.inStimCenter;
conRadRE.within2Deg   = trRE.within2Deg;

%% plot responses by dt,dx
getGlass_dtdxByCh(trLE,trRE,conRadLE,conRadRE)
%
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/%s/',trLE.animal,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/%s/',trLE.animal, trLE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% compare preferred pattern from translational and concentric
plotGlassPrefParamsTRvsCR(trLE,trRE,conRadRE,conRadLE) % figure 1
%% LE: look at all included channels
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1);
goodRanks = chRanksTRLE(trLE.goodCh == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1);
t1Text = ({'Distribution of preferred orientations all included channels';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.allQuadOris, trLE.allQuadRanks, trLE.allQuadOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% LE: look at the channels in the center of the stimulus
centerRanksTR = chRanksTRLE(trLE.goodCh == 1 & trLE.inStimCenter == 1);
centerRanksCR = chRanksCRLE(conRadLE.goodCh == 1 & conRadLE.inStimCenter == 1);
% fill empty matrices
if isempty(centerRanksTR)
    centerRanksTR = zeros(1);
end
if isempty(centerRanksCR)
    centerRanksCR = zeros(1);
end
trLE.centerRanks = centerRanksTR; 
conRadLE.centerRanks = centerRanksCR; 
%% LE: all channels inside stimulus boundaries
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStim == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStim == 1);
goodRanks = chRanksTRLE(trLE.goodCh == 1 & trLE.inStim == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStim == 1);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.inStimOris, trLE.inStimRanks,trLE.inStimOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% LE: polar histograms separated and color coded by preferred stimulus 
figure(8)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s LE %s',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;

text(-0.15, -1.12, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)
text(0.01, -1.12, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(-0.05, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trLE.inStimOris, trLE.inStimRanks)

figName = [trLE.animal,'_LE_',trLE.array,'_prefOriByRFlocation_radConPref_inStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% plot differences between preferred and dominant orientations
[trLE.conDiff, trLE.radDiff] = diffPrefOriPrefStimOri(trLE);
%% RE: look at all included channels
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1);
goodRanks = chRanksTRRE(trRE.goodCh == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1);
t1Text = ({'Distribution of preferred orientations all included channels';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.allQuadOris, trRE.allQuadRanks, trRE.allQuadOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% RE: look at the channels in the center of the stimulus
centerRanksTR = chRanksTRRE(trRE.goodCh == 1 & trRE.inStimCenter == 1);
centerRanksCR = chRanksCRRE(conRadRE.goodCh == 1 & conRadRE.inStimCenter == 1);
% fill empty matrices
if isempty(centerRanksTR)
    centerRanksTR = zeros(1);
end
if isempty(centerRanksCR)
    centerRanksCR = zeros(1);
end
trRE.centerRanks = centerRanksTR; 
conRadRE.centerRanks = centerRanksCR; 
%% RE: all channels inside stimulus boundaries
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1);
goodRanks = chRanksTRRE(trRE.goodCh == 1 & trRE.inStim == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStim == 1);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.inStimOris, trRE.inStimRanks,trRE.inStimOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% RE: polar histograms separated and color coded by preferred stimulus 
figure(16)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');

set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s RE %s',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;

text(-0.15, -1.12, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)
text(0.01, -1.12, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(-0.05, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trRE.inStimOris, trRE.inStimRanks)

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConPref_inStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% plot differences between preferred and dominant orientations
[trRE.conDiff, trRE.radDiff] = diffPrefOriPrefStimOri(trRE);
%%
trLEz(:,:,:,:) = nanmean(squeeze(trLE.GlassTRZscore(:,end,:,:,:,:)),5);
trREz(:,:,:,:) = nanmean(squeeze(trRE.GlassTRZscore(:,end,:,:,:,:)),5);

conLEz(:,:,:) = nanmean(squeeze(conRadLE.conZscore(end,:,:,:,:)),4);
radLEz(:,:,:) = nanmean(squeeze(conRadLE.radZscore(end,:,:,:,:)),4);
nozLEz(:,:,:) = nanmean(squeeze(conRadLE.noiseZscore(1,:,:,:,:)),4);

conREz(:,:,:) = nanmean(squeeze(conRadRE.conZscore(end,:,:,:,:)),4);
radREz(:,:,:) = nanmean(squeeze(conRadRE.radZscore(end,:,:,:,:)),4);
nozREz(:,:,:) = nanmean(squeeze(conRadRE.noiseZscore(1,:,:,:,:)),4);
%% plot density dx by pattern for each channel. 
plotGlass_dtDxPref_bych(trLE,trRE,conRadLE,conRadRE)
%% save combined data

location = determineComputer;
if location == 1
    outputDir =  sprintf('~/bushnell-local/Dropbox/ArrayData/matFiles/%s/Glass/allTypes/%s/',trRE.array,trRE.animal);
elseif location == 0
    outputDir =  sprintf('~/Dropbox/ArrayData/matFiles/%s/Glass/allTypes/%s/',trRE.array,trRE.animal);
end
if ~exist(outputDir,'dir')
    mkdir(outputDir)
end

data.trLE = trLE;
data.trRE = trRE;
data.conRadLE = conRadLE;
data.conRadRE = conRadRE;

saveName = [outputDir newName '.mat'];
save(saveName,'data','-v7.3');
fprintf('%s saved\n', saveName)