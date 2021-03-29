function [pVal,sigDif] = getGlassCoMperm(REcrData,LEcrData,REtrData,LEtrData,realCoMdistance)
useCh = (REcrData.inStim == 1 & REcrData.goodCh == 1 & LEcrData.inStim == 1 & LEcrData.goodCh == 1 & ...
   REtrData.inStim == 1 & REtrData.goodCh == 1 & LEtrData.inStim == 1 & LEtrData.goodCh == 1);

con = abs(squeeze(REcrData.conNoiseDprime(end,:,:,useCh)));
rad = abs(squeeze(REcrData.radNoiseDprime(end,:,:,useCh)));
lin = abs(squeeze(mean(REtrData.linNoiseDprime(:,end,:,:,useCh),1)));

[permCoMRE,permCoMREsph] = GlassCenterOfTriplotMass_permutations(con,rad,lin);


con = abs(squeeze(LEcrData.conNoiseDprime(end,:,:,useCh)));
rad = abs(squeeze(LEcrData.radNoiseDprime(end,:,:,useCh)));
lin = abs(squeeze(mean(LEtrData.linNoiseDprime(:,end,:,:,useCh),1)));

[permCoMLE,permCoMLEsph] = GlassCenterOfTriplotMass_permutations(con,rad,lin);

%%
figure%(18)
clf
hold on

cmap = zeros(50,3);
triplotter_GlassWithTr_noCBar_oneOri(permCoMLE(1:50,:),brewermap(50,'Blues'));

cmap = zeros(50,3);
triplotter_GlassWithTr_noCBar_oneOri(permCoMRE(1:50,:),brewermap(50,'Reds'));

%% get permuted distances
permComDist = vecnorm(permCoMLEsph - permCoMREsph,2,2);
%% do permutation test

high = find(permComDist>realCoMdistance);
pVal = ((length(high)+1)/(length(permComDist)+1));

if  (pVal < 0.05)
    sigDif = 1;
else
    sigDif = 0;
end
%%
figure
clf
hold on
title(sprintf('permuted distance between LE and RE %s %s',REcrData.animal, REcrData.array))
histogram(permComDist,'Normalization','probability')
plot([realCoMdistance, realCoMdistance],[0 0.6],'r-','LineWidth',0.75)

 

