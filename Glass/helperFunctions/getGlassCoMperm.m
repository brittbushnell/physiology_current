function [pVal,sigDif] = getGlassCoMperm(REcrData,LEcrData,REtrData,LEtrData,realCoMdistance)
useCh = (REcrData.inStim == 1 & REcrData.goodCh == 1 & LEcrData.inStim == 1 & LEcrData.goodCh == 1);
con = squeeze(REcrData.conNoiseDprime(end,:,:,useCh));
rad = squeeze(REcrData.radNoiseDprime(end,:,:,useCh));
lin = squeeze(mean(REtrData.linNoiseDprime(:,end,:,:,useCh),1));

permCoMRE = GlassCenterOfTriplotMass_permutations(con,rad,lin);


con = squeeze(LEcrData.conNoiseDprime(end,:,:,useCh));
rad = squeeze(LEcrData.radNoiseDprime(end,:,:,useCh));
lin = squeeze(mean(LEtrData.linNoiseDprime(:,end,:,:,useCh),1));

permCoMLE = GlassCenterOfTriplotMass_permutations(con,rad,lin);
%% get permuted distances
permComDist = vecnorm(permCoMLE - permCoMRE,2,2);
%% do permutation test

high = find(permComDist>realCoMdistance);
pVal = round((length(high)+1)/(length(permComDist)+1),3);

if (pVal > 0.95) || (pVal < 0.05) % two tailed test
    sigDif = 1;
end
%%
figure
clf
hold on
title(sprintf('permuted distance between LE and RE %s %s',REcrData.animal, REcrData.array))
histogram(permComDist,'Normalization','probability')
plot([realCoMdistance, realCoMdistance],[0 0.6],'r-','LineWidth',0.75)


