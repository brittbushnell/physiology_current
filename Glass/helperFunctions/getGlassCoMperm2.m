function [pVal,sigDif] = getGlassCoMperm2(V1dataRE,V1dataLE,V4dataRE,V4dataLE,realCoMdistance)












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

 

