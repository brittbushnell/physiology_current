function [CoMLE,CoMsphLE,CoMRE,CoMsphRE] = GlassCenterOfTriplotMass_perm2(REdata,LEdata)
%{
Input requirements:

3-dimenstional matrix where each row is a channel, and columns are d' for
radial, concentric, and translational. Input should still be separated by
eye so data can be separated into RE or LE in appropriate numbers to match
the actual data.

steps:
1) set up blank matrices for RE and LE that's the same dimensions as the
input matrices.

2) fill the matrices with random d' from either input matrix.

3) calculate vector sum
 
4) calculate center of mass

5) repeat 1k times, creating a vector of permuted CoM values. Keep in mind
this is just for one eye.

%}
%%
numBoot = 100;
%% initialize response matrices
CoMLE = nan(numBoot,3);
CoMsphLE = nan(numBoot,3);

CoMRE = nan(numBoot,3);
CoMsphRE = nan(numBoot,3);

dataBE = cat(1,REdata,LEdata);
CoMdist = nan(numBoot,1);
%%
figure %(120)
clf
hold on
for nb = 1:numBoot
    LErcdT = nan(size(LEdata));
    RErcdT = nan(size(REdata));
    randNdx = randperm(numel(dataBE));
    LEndxs = randNdx(1:numel(LEdata));
    REndxs = randNdx(numel(LEdata,1):end);
    
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
title('FE/LE')

subplot(1,2,2)
triplotter_GlassWithTr_noCBar_oneOri(CoMRE,cmap);
title('AE/RE')
%%



