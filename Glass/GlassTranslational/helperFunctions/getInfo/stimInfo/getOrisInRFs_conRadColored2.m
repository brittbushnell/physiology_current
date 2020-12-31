function [quadOris] = getOrisInRFs_conRadColored2(trData,crData)

%% get the preferred stimuli for each channel by quadrant
chRanks = nan(1,96);
prefParams = trData.prefParamsIndex; % this says which dot,dx is preferred

for ch = 1:96
    if trData.goodCh(ch) == 1
        chRanks(1,ch) = crData.dPrimeRankBlank{prefParams(ch)}(1,ch);
    end
end
%% 
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/%s/RF/',trData.animal,trData.programID, trData.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/%s/RF/',trData.animal, trData.programID, trData.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get quadrant locations for all included channels
goodQuads = trData.rfQuadrant(trData.goodCh == 1);
goodPrefs = trData.prefParamsPrefOri(trData.goodCh == 1);
goodRanks = trData.prefParamsPrefOri(trData.goodCh == 1);
[allQuadOris,allQuadRanks] = getGlassPrefsByQuad(goodPrefs,goodQuads,goodRanks);

t1Text = ({'distribution of preferred orientations all included channels';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
GlassPolarPlotsByStimQuadrant(allQuadOris,allQuadRanks,t1Text)
figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_allGoodCh','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% now, for all channels with receptive fields inside the stimulus boundaries
%Make sure that everything going into prefsByQuad is the same size and limitations.  This is passing in a subset in quadInStim, but nothing else.

quadInStim = trData.rfQuadrant(trData.inStim == 1);
inStimPref = trData.prefParamsPrefOri(trData.inStim == 1);
inStimRanks = chRanks(trData.inStim == 1);
[quadOrisInStim,quadRanksInStim] = getGlassPrefsByQuad(inStimPref,quadInStim,inStimRanks);  

t2Text = ({'distribution of preferred orientations all channels within 2 degrees stimulus bounds';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
GlassPolarPlotsByStimQuadrant(quadOrisInStim,quadRanksInStim,t2Text)
figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% outer ring of stimulus
quadNotInCenter = trData.rfQuadrant(trData.inStimCenter == 0 & trData.inStim == 1);
[quadOrisNotInCenter,quadRanksNotInCenter] = getGlassPrefsByQuad(quadNotInCenter,chRanks);

t3Text = ({'distribution of preferred orientations all channels inside outer 2 degrees of stimulus bounds';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
GlassPolarPlotsByStimQuadrant(quadOrisNotInCenter,quadRanksNotInCenter,t3Text)
figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_inStimNotCenter','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% withing two degrees of the stimulus
quadIn2Deg = trData.rfQuadrant(trData.inStimCenter == 0 & trData.inStim == 1 & trData.within2Deg == 1);
[quadOrisIn2Deg,quadRanksIn2Deg] = getGlassPrefsByQuad(quadIn2Deg,chRanks);

t4Text = ({'distribution of preferred orientations all channels within 2 degrees of stimulus bounds no center';...
   sprintf('%s %s %s', trData.animal, trData.eye, trData.array)});
GlassPolarPlotsByStimQuadrant(quadOrisIn2Deg,quadRanksIn2Deg,t4Text)
figName = [trData.animal,'_',trData.eye,'_',trData.array,'_prefOriByRFlocation_radConPref_in2Deg','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')
%% colored histogram according to preferred pattern type

