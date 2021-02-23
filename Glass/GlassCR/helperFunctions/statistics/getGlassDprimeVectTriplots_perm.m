function [stimDps] = getGlassDprimeVectTriplots_perm(radBlankDprime,conBlankDprime,noiseBlankDprime,goodCh,inStim)


radDps = abs(squeeze(radBlankDprime(end,:,:,:)));
conDps = abs(squeeze(conBlankDprime(end,:,:,:)));
nosDps = abs(squeeze(noiseBlankDprime(1,:,:,:)));

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]); 
rDp = rDp(goodCh == 1 & inStim == 1);
rDp = rDp';

cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = cDp(goodCh == 1 & inStim == 1);
cDp = cDp';

nDp = squeeze([squeeze(nosDps(1,1,:)),squeeze(nosDps(1,2,:)),squeeze(nosDps(2,1,:)),squeeze(nosDps(2,2,:))]);
nDp = nDp(goodCh == 1 & inStim == 1);
nDp = nDp';

stimDps = [rDp,cDp,nDp]; % this matrix is the input to the triplot figure. Each row is a channel, each column is a different stimulus