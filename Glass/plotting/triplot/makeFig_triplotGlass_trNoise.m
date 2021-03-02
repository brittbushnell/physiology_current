location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

%%
V1dataRE  = getGlassDprimeNoiseVectTriplots(V1data.conRadLE.radNoiseDprime,V1data.conRadLE.conNoiseDprime,V1data.trLE.linNoiseDprime, (V1data.conRadRE.goodCh + V1data.trLE.goodCh), (V1data.conRadRE.inStim + V1data.trLE.inStim))
% V1dataRE = getGlassDprimeVectTriplots(V1data.conRadRE.radBlankDprime,V1data.conRadRE.conBlankDprime,V1data.conRadRE.noiseBlankDprime, V1data.conRadRE.goodCh, V1data.conRadRE.inStim);   
V1dataLE = getGlassDprimeVectTriplots(V1data.conRadLE.radBlankDprime,V1data.conRadLE.conBlankDprime,V1data.conRadLE.noiseBlankDprime, V1data.conRadLE.goodCh, V1data.conRadLE.inStim);
V4dataRE = getGlassDprimeVectTriplots(V4data.conRadRE.radBlankDprime,V4data.conRadRE.conBlankDprime,V4data.conRadRE.noiseBlankDprime, V4data.conRadRE.goodCh, V4data.conRadRE.inStim);
V4dataLE = getGlassDprimeVectTriplots(V4data.conRadLE.radBlankDprime,V4data.conRadLE.conBlankDprime,V4data.conRadLE.noiseBlankDprime, V4data.conRadLE.goodCh, V4data.conRadLE.inStim);
