function GlassCenterOfTriplotMass_permutations(varargin)
%{
Input requirements:

concentric, radial, and dipole matrices that are organized (dt,dx,ch) and
limited to included channels.

steps:

1) setup rcd matrix
    - randomly choose a dt,dx combo rather than choosing best
    - randomly assign stimulus identity
    - To do this, for each channel, make a matrix of d' of all of the
    stimuli (dt/dx and pattern type), then randomly assign to the rcd
    output matrix

2) calculate vector sum
 
3) calculate center of mass
    
4) repeat 1k times, creating a vector of permuted CoM values
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
        conDprimes = varargin{1};
        radDprimes = varargin{2};
        nozDprimes = varargin{3};
        numBoot = 1000;
        holdout = 0.9;
    case 4
        conDprimes = varargin{1};
        radDprimes = varargin{2};
        nozDprimes = varargin{3};
        numBoot = varargin{4};
        holdout = 0.9;
    case 5
        conDprimes = varargin{1};
        radDprimes = varargin{2};
        nozDprimes = varargin{3};
        numBoot = varargin{4};
        holdout = varargin{5};
end
%% initialize response matrices
CoM = nan(1,numBoot);

%%
for nb = 1:numBoot
    rcdT = nan(size(conDprimes,3),4);
    for ch = 1:size(conDprimes,3)
        conT = squeeze(conDprimes(:,:,ch));
        radT = squeeze(radDprimes(:,:,ch));
        nozT = squeeze(conDprimes(:,:,ch));
        
        dpsT = cat(2,conT,radT,nozT);
        randC = randi(numel(dpsT),1);
        randR = randi(numel(dpsT),1);
        
        while randR == randC
            randR = randi(numel(dpsT),1);
        end
        
        randN = randi(numel(dpsT),1);
        
        while randN == randC || randN == randR
            randN = randi(numel(dpsT),1);
        end
        
        rcdT(ch,1:3) = [randC randR randN];  
    end
    rcdT(:,4) = sqrt(rcdT(:,1).^2 + rcdT(:,2).^2 + rcdT(:,3).^2);
    wgtLoc = (rcdT(:,1:3)).*rcdT(:,4);
    CoM(nb) = mean(wgtLoc);
end









