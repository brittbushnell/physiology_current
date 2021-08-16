function [stimDps] = getGlassDprimeNoiseVect_meanOri(radNoiseDprime,conNoiseDprime,goodCh,inStim)
%%
% output is a matrix where each row is a different channel and columns are
% radial, concentric, and translational respectively.
%%
radDps = abs(squeeze(radNoiseDprime(end,:,:,:)));
conDps = abs(squeeze(conNoiseDprime(end,:,:,:)));

rDp = squeeze([squeeze(radDps(1,1,:)),squeeze(radDps(1,2,:)),squeeze(radDps(2,1,:)),squeeze(radDps(2,2,:))]); 
rDp = max(rDp');
rDp = rDp(goodCh == 1 & inStim == 1);
rDp = rDp';

cDp = squeeze([squeeze(conDps(1,1,:)),squeeze(conDps(1,2,:)),squeeze(conDps(2,1,:)),squeeze(conDps(2,2,:))]);
cDp = max(cDp');
cDp = cDp(goodCh == 1 & inStim == 1);
cDp = cDp';

stimDps = [rDp,cDp]; % this will create a pair of radial, and concentric d's that will be used as inputs for the triplotter.