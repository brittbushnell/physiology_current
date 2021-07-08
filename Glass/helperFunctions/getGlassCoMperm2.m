function [pVal,sigDif] = getGlassCoMperm2(REdata,LEdata,realCoMdistance)

CoMdist = GlassCenterOfTriplotMass_perm2(REdata,LEdata);

%% do permutation test

high = find(CoMdist>realCoMdistance);
pVal = ((length(high)+1)/(length(CoMdist)+1));

if  (pVal < 0.05)
    sigDif = 1;
else
    sigDif = 0;
end

