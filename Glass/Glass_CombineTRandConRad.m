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
%%
% load('WU_BE_GlassTR_V1_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('WU_BE_V1_Glass_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'WU_BE_V1_bothGlass_cleanMerged';
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
%%  get receptive field information
% It doesn't matter if you use the conRad or translational inputs, they'll
% both return the same thing, just need one from each eye.

trLE = callReceptiveFieldParameters(trLE);
trRE = callReceptiveFieldParameters(trRE);
%% LE move to directory for saving the figures
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
trLE = GlassTR_bestSumDOris(trLE);
[trLE.rfQuadrant, trLE.inStim, trLE.inStimCenter, trLE.within2Deg, trLE.rfParamsRelGlassFix] = getRFsRelGlass_ecc_Sprinkles(trLE, conRadLE);

conRadLE.rfQuadrant   = trLE.rfQuadrant;
conRadLE.inStim       = trLE.inStim;
conRadLE.inStimCenter = trLE.inStimCenter;
conRadLE.within2Deg   = trLE.within2Deg;

%% Get preferred pattern for each cell's translational data

% problem: this is using the preferred dt,dx for translational which is not always the same as in concentric/radial. 
% Need to determine what preferences to use, or to just use all dt.dx.

chRanksTRLE = nan(1,96);
chRanksCRLE = nan(1,96);
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
%% LE: look at all responsive channels
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
centerRanks = chRanksTRLE(trLE.goodCh == 1 & trLE.inStimCenter == 1);

% fill empty matrices
if isempty(centerRanks)
    centerRanks = zeros(1);
end
trLE.centerRanks = centerRanks; 
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
%% LE: all channels inside stimulus boundaries and with an OSI >=0.5
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.prefParamSI' >=0.5);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.prefParamSI' >=0.5);
goodRanks = chRanksTRLE(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.prefParamSI' >=0.5);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.inStimOrisHighOSI, trLE.inStimRanksHighOSI,trLE.inStimHighOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% LE: all channels in the outer portion of the stimulus
% goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
% goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
% goodRanks = chRanksLE(trLE.goodCh == 1& trLE.inStim == 1 & trLE.inStimCenter == 0);
% goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
% t1Text = ({'Distribution of preferred orientations all channels in outer ring of the stimulus';...
%    sprintf('%s LE %s', trLE.animal,trLE.array)});
% 
% [trLE.outer2Oris, trLE.outer2Ranks, trLE.outer2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);
% 
% figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_outerRingOfStim','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%% LE: All channels within 2 degrees of the stimulus 
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1  & trLE.within2Deg == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1   & trLE.within2Deg == 1);
goodRanks = chRanksTRLE(trLE.goodCh == 1  & trLE.within2Deg == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1  & trLE.within2Deg == 1);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (and center)';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.within2Oris, trLE.within2Ranks,trLE.within2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%  LE: All channels within 2 degrees of the stimulus and have OSIs > 0.5
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1  & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1   & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodRanks = chRanksTRLE(trLE.goodCh == 1  & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1  & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (and center)';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.within2OrisHighSI, trLE.within2RanksHighSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% LE: histograms separated and color coded by preferred stimulus 
figure(9)
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

plotQuadHist_conRadDipSep(trLE.within2Oris, trLE.within2Ranks)

figName = [trLE.animal,'_LE_',trLE.array,'_prefOriByRFlocation_radConColored_in2Deg_separate','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% same as 9 but limited to high OSI
figure(10)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s LE %s OSI > 0.5',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(-0.26, -1.2, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.19, -1.2, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trLE.within2OrisHighSI, trLE.within2RanksHighSI)

figName = [trLE.animal,'_LE_',trLE.array,'_prefOriByRFlocation_radConColored_in2Deg_separateHighOSI','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% LE: histograms separated and color coded by preferred stimulus 
figure(11)
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

figName = [trLE.animal,'_LE_',trLE.array,'_prefOriByRFlocation_radConColored_inStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% same as 9 but limited to high OSI
figure(12)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s LE %s OSI > 0.5',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(-0.26, -1.2, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.19, -1.2, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trLE.inStimOrisHighOSI, trLE.inStimRanksHighOSI)

figName = [trLE.animal,'_LE_',trLE.array,'_prefOriByRFlocation_radConColored_inStimHighOSI','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%%
trRE = GlassTR_bestSumDOris(trRE);
[trRE.rfQuadrant, trRE.inStim, trRE.inStimCenter, trRE.within2Deg, trRE.rfParamsRelGlassFix] = getRFsRelGlass_ecc_Sprinkles(trRE, conRadRE);

conRadRE.rfQuadrant   = trRE.rfQuadrant;
conRadRE.inStim       = trRE.inStim;
conRadRE.inStimCenter = trRE.inStimCenter;
conRadRE.within2Deg   = trRE.within2Deg;
%% Get preferred pattern for each cell
chRanksRE = nan(1,96);
prefParamsCr = conRadRE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if trRE.goodCh(ch) == 1
        chRanksRE(1,ch) = conRadRE.dPrimeRankBlank{prefParamsCr(ch)}(1,ch);
    end
end
trRE.prefPatternsPrefParams = chRanksRE;

%% RE: look at all responsive channels
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1);
goodRanks = chRanksRE(trRE.goodCh == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1);
t1Text = ({'Distribution of preferred orientations all included channels';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.allQuadOris, trRE.allQuadRanks, trRE.allQuadOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% RE: look at the channels in the center of the stimulus
centerRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStimCenter == 1);

% fill empty matrices
if isempty(centerRanks)
    centerRanks = zeros(1);
end
trRE.centerRanks = centerRanks; 
%% RE: all channels inside stimulus boundaries
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1);
goodRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStim == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStim == 1);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.inStimOris, trRE.inStimRanks,trRE.inStimOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% RE: all channels inside stimulus boundaries and with an OSI >=0.5
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.prefParamSI' >=0.5);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.prefParamSI' >=0.5);
goodRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.prefParamSI' >=0.5);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.inStimOrisHighOSI, trRE.inStimRanksHighOSI,trRE.inStimHighOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% RE: all channels in the outer portion of the stimulus
% goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.inStimCenter == 0);
% goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.inStimCenter == 0);
% goodRanks = chRanksRE(trRE.goodCh == 1& trRE.inStim == 1 & trRE.inStimCenter == 0);
% goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.inStimCenter == 0);
% t1Text = ({'Distribution of preferred orientations all channels in outer ring of the stimulus';...
%    sprintf('%s RE %s', trRE.animal,trRE.array)});
% 
% [trRE.outer2Oris, trRE.outer2Ranks, trRE.outer2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);
% 
% figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_outerRingOfStim','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%% RE: All channels within 2 degrees of the stimulus 
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1  & trRE.within2Deg == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1   & trRE.within2Deg == 1);
goodRanks = chRanksRE(trRE.goodCh == 1  & trRE.within2Deg == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1  & trRE.within2Deg == 1);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (and center)';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.within2Oris, trRE.within2Ranks,trRE.within2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%  RE: All channels within 2 degrees of the stimulus and have OSIs > 0.5
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1  & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1   & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodRanks = chRanksRE(trRE.goodCh == 1  & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1  & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (and center)';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.within2OrisHighSI, trRE.within2RanksHighSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% RE: histograms separated and color coded by preferred stimulus 
figure(13)
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

plotQuadHist_conRadDipSep(trRE.within2Oris, trRE.within2Ranks)

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConColored_in2Deg_separate','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% same as 9 but limited to high OSI
figure(14)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s RE %s OSI > 0.5',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(-0.26, -1.2, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.19, -1.2, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trRE.within2OrisHighSI, trRE.within2RanksHighSI)

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConColored_in2Deg_separateHighOSI','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% RE: histograms separated and color coded by preferred stimulus 
figure(15)
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

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConColored_inStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% same as 9 but limited to high OSI
figure(16)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s RE %s OSI > 0.5',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(-0.26, -1.2, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.19, -1.2, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trRE.inStimOrisHighOSI, trRE.inStimRanksHighOSI)

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConColored_inStimHighOSI','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

clear goodQuads; clear goodRanks; clear goodOris; clear goodOSI; clear t1Text;
%% plot differences between preferred and dominant orientations
[trLE.conDiff, trLE.radDiff] = diffPrefOriPrefStimOri(trLE);
[trRE.conDiff, trRE.radDiff] = diffPrefOriPrefStimOri(trRE);
%% get prefered dt,dx parameters for concentric and radial data

conRadLE.prefParamsIndex = getGlassConRadPrefParamIndex(conRadLE);
conRadRE.prefParamsIndex = getGlassConRadPrefParamIndex(conRadRE);

%% compare preferred pattern from translational and concentric
figure(20)
clf
set(gcf,'PaperOrientation','Landscape');

leNdx = (trLE.inStim == 1) & (trLE.goodCh == 1);
reNdx = (trRE.inStim == 1) & (trRE.goodCh == 1);

subplot(1,2,1)
hold on
scatter(1:sum(leNdx),trLE.prefParamsIndex(trLE.inStim == 1 & trLE.goodCh == 1),30,'filled','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(1:sum(leNdx),conRadLE.prefParamsIndex(trLE.inStim == 1 & trLE.goodCh == 1),60,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

axis square
title('LE/FE')
xlabel('channel')
ylabel('preferred dt dx pair')

set(gca,'tickdir','out','YTick',1:4,'YTickLabel',{'200, 0.02','200,0.03','400, 0.02','400,0.03'},'FontSize',12,'FontAngle','italic','FontWeight','bold')
l = legend('translational','concentric and radial');
l.Position(1) = l.Position(1) + 0.2;
l.Position(2) = l.Position(2) - 0.5;
l.Box = 'off';
l.FontSize = 14;

subplot(1,2,2)
hold on
scatter(1:sum(reNdx),trRE.prefParamsIndex(trRE.inStim == 1 & trRE.goodCh == 1),30,'filled','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)
scatter(1:sum(reNdx),conRadRE.prefParamsIndex(trRE.inStim == 1 & trRE.goodCh == 1),60,'d','MarkerEdgeColor','k','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6)

axis square
title('RE/AE')
xlabel('channel')

set(gca,'tickdir','out','YTick',1:4,'YTickLabel',[],'FontSize',12,'FontAngle','italic','FontWeight','bold')
s = suptitle(sprintf('%s %s preferred dots,dx combo in Glass experiments',trLE.animal, trLE.array));
s.Position(2) = s.Position(2) - 0.13;
s.FontSize = 18;
s.FontWeight = 'bold';
figName = [trLE.animal,'_',trLE.array,'_prefParamsTRvsCR','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
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