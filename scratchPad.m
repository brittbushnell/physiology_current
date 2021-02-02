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
figure(8)
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