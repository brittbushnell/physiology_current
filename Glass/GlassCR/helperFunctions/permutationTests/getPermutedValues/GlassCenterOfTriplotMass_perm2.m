function [CoMdist,CoMLE,CoMsphLE,CoMRE,CoMsphRE] = GlassCenterOfTriplotMass_perm2(REdata,LEdata)
%{
Input requirements:

3-dimenstional matrix where each row is a channel, and columns are d' for
radial, concentric, and translational. Input should still be separated by
eye so data can be separated into RE or LE in appropriate numbers to match
the actual data.

steps:
1) combine LE and RE data into one big matrix

2) set up blank matrices for RE and LE that's the same dimensions as the
input matrices.
 
3) randomly assign rows (so keeping the triplets together) to either RE or
LE matrices
 
4) calculate vector sum and center of mass

5) repeat 1k times, creating a vector of permuted CoM values. Keep in mind
this is just for one eye.

%}
%%
numBoot = 1000;
cmap = zeros(numBoot,3);
%% initialize response matrices
CoMLE = nan(numBoot,3);
CoMsphLE = nan(numBoot,3);

CoMRE = nan(numBoot,3);
CoMsphRE = nan(numBoot,3);

BEdata = cat(1,REdata,LEdata);
CoMdist = nan(numBoot,1);
%%
for nb = 1:numBoot
    
    r = randperm(size(BEdata,1));
    LEndxs = r(1:size(LEdata,1));
    REndxs = r(size(LEdata,1)+1:end);
    
    LErcdT = BEdata(LEndxs,:);
    
    vSumLE = sqrt(LErcdT(:,1).^2 + LErcdT(:,2).^2 + LErcdT(:,3).^2);
    [CtLE,CoMsphLE(nb,:)] = triplotter_centerMass(LErcdT,vSumLE,[1 0 0],0);
    
    if isnan(CtLE)
        keyboard
    else
        CoMLE(nb,:) = CtLE;
    end
    if nb == numBoot
        subplot(2,2,1)
        triplotter_GlassWithTr_noCBar_oneOri(LErcdT,cmap);
        title(sprintf('AE/RE n: %d',size(LEdata,1)))
        text(-1,-0.78,'Radial','FontSize',12)
        text(0.8,-0.78,'Concentric','FontSize',12)
        text(-0.25,0.87,'Translational','FontSize',12)
    end
    clear LErcdT;
    
    RErcdT = BEdata(REndxs,:);
    
    vSumRE = sqrt(RErcdT(:,1).^2 + RErcdT(:,2).^2 + RErcdT(:,3).^2);
    [CtRE,CoMsphRE(nb,:)] = triplotter_centerMass(RErcdT,vSumRE,[1 0 0],0);
    
    if isnan(CtRE)
        keyboard
    else
        CoMRE(nb,:) = CtRE;
    end
    if nb == numBoot
        subplot(2,2,2)
        triplotter_GlassWithTr_noCBar_oneOri(RErcdT,cmap);
        title(sprintf('AE/RE n: %d',size(REdata,1)))
        text(-1,-0.78,'Radial','FontSize',12)
        text(0.8,-0.78,'Concentric','FontSize',12)
        text(-0.25,0.87,'Translational','FontSize',12)
    end
    clear RErcdT;
    
    CoMdist(nb) = vecnorm(CoMsphLE(nb,:) - CoMsphRE(nb,:),2,2);
end

hold on

subplot(2,2,3)
triplotter_GlassWithTr_noCBar_oneOri(CoMLE,cmap);
title(sprintf('FE/LE n: %d',size(LEdata,1)))
text(-1,-0.78,'Radial','FontSize',12)
text(0.8,-0.78,'Concentric','FontSize',12)
text(-0.25,0.87,'Translational','FontSize',12)

subplot(2,2,4)
triplotter_GlassWithTr_noCBar_oneOri(CoMRE,cmap);
title(sprintf('AE/RE n: %d',size(REdata,1)))
text(-1,-0.78,'Radial','FontSize',12)
text(0.8,-0.78,'Concentric','FontSize',12)
text(-0.25,0.87,'Translational','FontSize',12)

%%



