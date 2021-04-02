function [CoMdist,CoMLE,CoMsphLE,CoMRE,CoMsphRE] = GlassCenterOfTriplotMass_perm2(REdata,LEdata)
%{
Input requirements:

3-dimenstional matrix where each row is a channel, and columns are d' for
radial, concentric, and translational. Input should still be separated by
eye so data can be separated into RE or LE in appropriate numbers to match
the actual data.

steps:
1) set up blank matrices for RE and LE that's the same dimensions as the
input matrices.

2) randomly assign each element as to if it will get the LE or RE data

3) calculate vector sum
 
4) calculate center of mass

5) repeat 1k times, creating a vector of permuted CoM values. Keep in mind
this is just for one eye.

%}
%%
numBoot = 1000;
%% initialize response matrices
CoMLE = nan(numBoot,3);
CoMsphLE = nan(numBoot,3);

CoMRE = nan(numBoot,3);
CoMsphRE = nan(numBoot,3);

CoMdist = nan(numBoot,1);
%%
for nb = 1:numBoot
    LErcdT = nan(size(LEdata));
    RErcdT = nan(size(REdata));
    
    
    
    for ndx = 1:numel(LEdata)
        LErcdT(ndx) = dataBE(LEndxs(ndx));
    end
    
    vSum = sqrt(LErcdT(:,1).^2 + LErcdT(:,2).^2 + LErcdT(:,3).^2);
    [Ct,CoMsphLE(nb,:)] = triplotter_centerMass(LErcdT,vSum,[1 0 0],0);
    
    if isnan(Ct)
        keyboard
    else
        CoMLE(nb,:) = Ct;
    end
    clear LErcdT; clear vSum; clear Ct;
    
    for ndx = 1:numel(REdata)
        RErcdT(ndx) = dataBE(REndxs(ndx));
    end

    vSum = sqrt(RErcdT(:,1).^2 + RErcdT(:,2).^2 + RErcdT(:,3).^2);
    [Ct,CoMsphRE(nb,:)] = triplotter_centerMass(RErcdT,vSum,[1 0 0],0);
    
    if isnan(Ct)
        keyboard
    else
        CoMRE(nb,:) = Ct;
    end
    clear RErcdT; clear vSum; clear Ct;
    
    CoMdist(nb) = vecnorm(CoMsphLE(nb,:) - CoMsphRE(nb,:),2,2);
end
hold on
cmap = zeros(numBoot,3);

subplot(1,2,1)
triplotter_GlassWithTr_noCBar_oneOri(CoMLE,cmap);
title(sprintf('FE/LE n: %d',size(LEdata,1)))
text(-1,-0.78,'Radial','FontSize',12)
text(0.8,-0.78,'Concentric','FontSize',12)
text(-0.2,0.87,'Translational','FontSize',12)

subplot(1,2,2)
triplotter_GlassWithTr_noCBar_oneOri(CoMRE,cmap);
title(sprintf('AE/RE n: %d',size(REdata,1)))
text(-1,-0.78,'Radial','FontSize',12)
text(0.8,-0.78,'Concentric','FontSize',12)
text(-0.2,0.87,'Translational','FontSize',12) 
%%



