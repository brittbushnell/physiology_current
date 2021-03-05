function [stimDps] = getGlassDprimeNoiseVectTriplots_meanOri(radNoiseDprime,conNoiseDprime,trNoiseDprime,goodCh,inStim)
%%
% output is a matrix where each row is a different channel and columns are
% radial, concentric, and translational respectively.
%%
radDps = abs(squeeze(radNoiseDprime(end,:,:,:)));
conDps = abs(squeeze(conNoiseDprime(end,:,:,:)));
trDps = abs(squeeze(trNoiseDprime(:,end,:,:,:)));
trDps = squeeze(mean(trDps,1)); % pick the orientation with the highest d'

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]); 
rDp = max(rDp');
rDp = rDp(goodCh == 1 & inStim == 1);
rDp = rDp';

cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = max(cDp');
cDp = cDp(goodCh == 1 & inStim == 1);
cDp = cDp';

tDp = squeeze([squeeze(trDps(1,1,:)),squeeze(trDps(1,2,:)),squeeze(trDps(2,1,:)),squeeze(trDps(2,2,:))]);
tDp = max(tDp');
tDp = tDp(goodCh == 1 & inStim == 1);
tDp = tDp';

stimDps = [rDp,cDp,tDp]; % t