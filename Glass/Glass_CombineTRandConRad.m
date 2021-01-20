clear
close all
% clc
%%
load('WV_BE_GlassTRCoh_V1_cleanMerged');
trLE = data.LE;
trRE = data.RE;
trData = data;
clear data;

load('WV_BE_V1_Glass_Aug2017_clean_merged');
conRadLE = data.LE;
conRadRE = data.RE;
conRadData = data;
clear data

newName = 'WV_BE_V1_bothGlass_cleanMerged';
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
% load('XT_BE_GlassTR_V4_cleanMerged');
% trLE = data.LE;
% trRE = data.RE;
% trData = data;
% clear data;
% 
% load('XT_BE_V4_Glass_clean_merged');
% conRadLE = data.LE;
% conRadRE = data.RE;
% conRadData = data;
% clear data
% 
% newName = 'XT_BE_V4_bothGlass_cleanMerged';
%%  get receptive field information
% It doesn't matter if you use the conRad or translational inputs, they'll
% both return the same thing, just need one from each eye.

trLE = callReceptiveFieldParameters(trLE);
trRE = callReceptiveFieldParameters(trRE);
%% LE move to directory for saving the figures
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/%s/',trLE.animal,trLE.programID,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/%s/',trLE.animal, trLE.programID,trLE.array);
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
%% Get preferred pattern for each cell
chRanksLE = nan(1,96);
prefParams = trLE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if trLE.goodCh(ch) == 1
        chRanksLE(1,ch) = conRadLE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end
trLE.prefPatternsPrefParams = chRanksLE;
%% LE: look at all responsive channels
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1);
goodRanks = chRanksLE(trLE.goodCh == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1);
t1Text = ({'Distribution of preferred orientations all included channels';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.allQuadOris, trLE.allQuadRanks, trLE.allQuadOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

%% LE: all channels inside stimulus boundaries
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStim == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStim == 1);
goodRanks = chRanksLE(trLE.goodCh == 1 & trLE.inStim == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStim == 1);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.inStimOris, trLE.inStimRanks,trLE.inStimOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% LE: all channels in the outer portion of the stimulus
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
goodRanks = chRanksLE(trLE.goodCh == 1& trLE.inStim == 1 & trLE.inStimCenter == 0);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStim == 1 & trLE.inStimCenter == 0);
t1Text = ({'Distribution of preferred orientations all channels in outer ring of the stimulus';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.outer2Oris, trLE.outer2Ranks, trLE.outer2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_outerRingOfStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% LE: All channels within 2 degrees of the stimulus (no center)
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStimCenter == 0  & trLE.within2Deg == 1);
goodRanks = chRanksLE(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (no center)';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.within2Oris, trLE.within2Ranks,trLE.within2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trLE.animal,'_',trLE.eye,'_',trLE.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%  LE: All channels within 2 degrees of the stimulus (no center) and have OSIs > 0.5
goodQuads = trLE.rfQuadrant(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodOris = trLE.prefParamsPrefOri(trLE.goodCh == 1 & trLE.inStimCenter == 0  & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodRanks = chRanksLE(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
goodOSI = trLE.prefParamSI(trLE.goodCh == 1 & trLE.inStimCenter == 0 & trLE.within2Deg == 1 & trLE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (no center)';...
   sprintf('%s LE %s', trLE.animal,trLE.array)});

[trLE.within2OrisHighSI, trLE.within2RanksHighSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

%% LE: histograms separated and color coded by preferred stimulus 
figure(9)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
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
%% RE
trRE = GlassTR_bestSumDOris(trRE);
[trRE.rfQuadrant, trRE.inStim, trRE.inStimCenter, trRE.within2Deg,trLE.rfParamsRelGlassFix] = getRFsRelGlass_ecc_Sprinkles(trRE, conRadRE);

conRadRE.rfQuadrant   = trRE.rfQuadrant;
conRadRE.inStim       = trRE.inStim;
conRadRE.inStimCenter = trRE.inStimCenter;
conRadRE.within2Deg   = trRE.within2Deg;
%% Get preferred pattern for each cell
chRanksRE = nan(1,96);
prefParams = trRE.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if trRE.goodCh(ch) == 1
        chRanksRE(1,ch) = conRadRE.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end
trRE.prefPatternsPrefParams = chRanksRE;
%% move to directory for saving the figures
if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/RF/%s/',trLE.animal,trLE.programID,trLE.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/RF/%s/',trLE.animal, trLE.programID,trLE.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% RE: look at all responsive channels
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1);
goodRanks = chRanksRE(trRE.goodCh == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1);
t1Text = ({'Distribution of preferred orientations all included channels';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.allQuadOris, trRE.allQuadRanks, trRE.allQuadOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI,t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')

%% RE: all channels inside stimulus boundaries
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1);
goodRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStim == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1  & trRE.inStim == 1);
t1Text = ({'Distribution of preferred orientations all channels with centers in the stimulus';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.inStimOris, trRE.inStimRanks, trRE.inStimOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_allInStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% RE: all channels in the outer portion of the stimulus
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.inStimCenter == 0);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStim == 1 & trRE.inStimCenter == 0);
goodRanks = chRanksRE(trRE.goodCh == 1& trRE.inStim == 1 & trRE.inStimCenter == 0);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1  & trRE.inStim == 1 & trRE.inStimCenter == 0);
t1Text = ({'Distribution of preferred orientations all channels in outer ring of the stimulus';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.outer2Oris, trRE.outer2Ranks, trRE.outer2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_outerRingOfStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% RE: All channels within 2 degrees of the stimulus (no center)
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStimCenter == 0  & trRE.within2Deg == 1);
goodRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (no center)';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.within2Oris, trRE.within2Ranks, trRE.within2OSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);

figName = [trRE.animal,'_',trRE.eye,'_',trRE.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%  RE: All channels within 2 degrees of the stimulus (no center) and have OSIs > 0.5
goodQuads = trRE.rfQuadrant(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodOris = trRE.prefParamsPrefOri(trRE.goodCh == 1 & trRE.inStimCenter == 0  & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodRanks = chRanksRE(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
goodOSI = trRE.prefParamSI(trRE.goodCh == 1 & trRE.inStimCenter == 0 & trRE.within2Deg == 1 & trRE.prefParamSI' >=0.5);
t1Text = ({'Distribution of preferred orientations all channels within 2deg of the stimulus (no center)';...
   sprintf('%s RE %s', trRE.animal,trRE.array)});

[trRE.within2OrisHighSI, trRE.within2RanksHighSI, trRE.within2RanksHighSIOSI] = getOrisInRFs_plotDists(goodQuads, goodRanks, goodOris, goodOSI, t1Text);
%%
figure(9)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 1000 800])
set(gcf,'PaperOrientation','Landscape');
clf
set(gca,'tickdir','out','XAxisLocation','origin','XTickLabel',[],'YAxisLocation','origin','YTickLabel',[],'TickLength',[0 0])
ylim([-1 1])
xlim([-1 1])
t = suptitle({'Distributions of preferred orientations and pattern type based on RF location';...
    sprintf('%s RE %s',trRE.animal, trRE.array)});
t.Position(2) = -0.025;
t.FontSize = 18;
text(-0.26, -1.2, 'Concentric','Color',[0.7 0 0.7],'FontWeight','Bold','FontSize',14)
text(0, -1.2, 'Dipole','Color',[1 0.5 0.1],'FontWeight','Bold','FontSize',14)
text(0.19, -1.2, 'Radial','Color',[0 0.6 0.2],'FontWeight','Bold','FontSize',14)

plotQuadHist_conRadDipSep(trRE.within2Oris, trRE.within2Ranks)

figName = [trRE.animal,'_RE_',trRE.array,'_prefOriByRFlocation_radConColored_in2Deg_separate','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%
figure(9)
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
%% plot differences between preferred and dominant orientations
[trLE.conDiff, trLE.radDiff] = diffPrefOriPrefStimOri(trLE);
[trRE.conDiff, trRE.radDiff] = diffPrefOriPrefStimOri(trRE);
%% plot distributions of preferred patterns at the center of the stimulus

figure (21)
clf

conLE = trLE.inStimCenter(chRanksLE == 1);
radLE = trLE.inStimCenter(chRanksLE == 2);
nosLE = trLE.inStimCenter(chRanksLE == 3);
numCh = sum(trLE.inStimCenter);

subplot(1,2,1)
hold on
bar(1,sum(conLE)/numCh,'FaceColor',[0.7 0 0.7])
bar(2,sum(radLE)/numCh,'FaceColor',[0 0.6 0.2])
bar(3,sum(nosLE)/numCh,'FaceColor',[1 0.5 0.1])
title(sprintf('LE n: %d', numCh))
ylim([0 0.7])
ylabel('Proportion')
set(gca,'tickdir','out','box','off',...
    'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'})


conRE = trRE.inStimCenter(chRanksRE == 1);
radRE = trRE.inStimCenter(chRanksRE == 2);
nosRE = trRE.inStimCenter(chRanksRE == 3);

subplot(1,2,2)
hold on
bar(1,sum(conRE)/numCh,'FaceColor',[0.7 0 0.7])
bar(2,sum(radRE)/numCh,'FaceColor',[0 0.6 0.2])
bar(3,sum(nosRE)/numCh,'FaceColor',[1 0.5 0.1])
title(sprintf('RE n: %d', numCh))
ylim([0 0.7])
set(gca,'tickdir','out','box','off',...
    'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'})
suptitle({'Breakdown of Glass pattern preferences in center 2 degrees of stimuli';...
    sprintf('%s %s',trLE.animal, trLE.array)})

figName = [trRE.animal,trRE.array,'_prefPattern_centerStim','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%%
figure (22)
clf

conLE = trLE.inStimCenter(chRanksLE == 1);
radLE = trLE.inStimCenter(chRanksLE == 2);
nosLE = trLE.inStimCenter(chRanksLE == 3);

conRE = trRE.inStimCenter(chRanksRE == 1);
radRE = trRE.inStimCenter(chRanksRE == 2);
nosRE = trRE.inStimCenter(chRanksRE == 3);

con = sum(conLE)+sum(conRE);
rad = sum(radLE)+sum(radRE);
nos = sum(nosLE)+sum(nosRE);

numCh = sum(trLE.inStimCenter) + sum(trRE.inStimCenter);

hold on
bar(1,con/numCh,'FaceColor',[0.7 0 0.7])
bar(2,rad/numCh,'FaceColor',[0 0.6 0.2])
bar(3,nos/numCh,'FaceColor',[1 0.5 0.1])
title(sprintf('RE n: %d', numCh))
ylim([0 0.7])
set(gca,'tickdir','out','box','off',...
    'XTick',1:3,'XTickLabel',{'Con','Radial','Dipole'})
suptitle({'Breakdown of Glass pattern preferences in center 2 degrees of stimuli';...
    sprintf('%s %s',trLE.animal, trLE.array)})

figName = [trRE.animal,trRE.array,'_prefPattern_centerStimBE','.pdf'];
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