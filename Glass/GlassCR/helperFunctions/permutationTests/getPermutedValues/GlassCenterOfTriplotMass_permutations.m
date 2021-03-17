function [CoM] = GlassCenterOfTriplotMass_permutations(varargin)
%{
Input requirements:

concentric, radial, and dipole matrices that are organized (dt,dx,ch) and
limited to included channels.

Optional inputs:
number of permutations to do.

steps:

1) setup rcd matrix
    - randomly choose a dt,dx combo rather than choosing best
    - randomly assign stimulus identity
    - To do this, for each channel, make a matrix of d' of all of the
    stimuli (dt/dx and pattern type), then randomly assign to the rcd
    output matrix

2) calculate vector sum
 
3) calculate center of mass

4) calculate the distance from permuted CoM and real

5) repeat 1k times, creating a vector of permuted CoM values and
CoM distances
%}
%%
switch nargin
    case 0
        error('Must pass in the d'' matrices')
    case 1
        error('Must pass in the d'' matrices')
    case 2
        error('Must pass in the d'' matrices')
    case 3
        radDprimes = varargin{1};
        conDprimes = varargin{2};
        nozDprimes = varargin{3};
        numBoot = 1000;
    case 4
        radDprimes = varargin{1};
        conDprimes = varargin{2};
        nozDprimes = varargin{3};
        numBoot = varargin{4};
end
%% initialize response matrices
CoM = nan(numBoot,3);
%%
for nb = 1:numBoot
    rcdT = nan(size(conDprimes,3),3); %limited to included channels already, so number of channels will vary.
    for ch = 1:size(conDprimes,3)
        conT = squeeze(conDprimes(:,:,ch));
        radT = squeeze(radDprimes(:,:,ch));
        nozT = squeeze(nozDprimes(:,:,ch));
        
        dpsT = cat(2,conT,radT,nozT);
        r = randi(numel(dpsT),6);
        r = unique(r);
        
        rndC = dpsT(r(1));
        rndR = dpsT(r(2));
        rndN = dpsT(r(3));
        
        rcdT(ch,1:3) = [rndR rndC rndN];  
    end
    
    vSum = sqrt(rcdT(:,1).^2 + rcdT(:,2).^2 + rcdT(:,3).^2);
    wgt = (rcdT).*vSum;
    wgtMu = nanmean(wgt);    
    [thx,phix,rx]=cart2sph(wgtMu(1),wgtMu(2),wgtMu(3));
    CoM(nb,:) = [rad2deg(thx),rad2deg(phix),rx];
    
    clear rcdT; clear wgtLoc; clear vSum;
end









