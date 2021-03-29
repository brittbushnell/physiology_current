function [CoM,CoMsph] = GlassCenterOfTriplotMass_permutations(varargin)
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

4) repeat 1k times, creating a vector of permuted CoM values. Keep in mind
this is just for one eye.

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
        linDprimes = varargin{3};
        numBoot = 1000;
    case 4
        radDprimes = varargin{1};
        conDprimes = varargin{2};
        linDprimes = varargin{3};
        numBoot = varargin{4};
end
%% initialize response matrices
CoM = nan(numBoot,3);
CoMsph = nan(numBoot,3);
%%
figure %(120)
clf
hold on
for nb = 1:numBoot
    rcdT = nan(size(conDprimes,3),3); %limited to included channels already, so number of channels will vary.
    for ch = 1:size(conDprimes,3)
        conT = squeeze(conDprimes(:,:,ch));
        radT = squeeze(radDprimes(:,:,ch));
        linT = squeeze(linDprimes(:,:,ch));
        
        conT = reshape(conT,numel(conT),1);
        radT = reshape(radT,numel(radT),1);
        linT = reshape(linT,numel(linT),1);
        
        dpsT = [conT;radT;linT];
        r = randperm(size(dpsT,1));
        
        rndC = dpsT(r(1));
        rndR = dpsT(r(2));
        rndL = dpsT(r(3));
        
        rcdT(ch,1:3) = [rndR rndC rndL];  
    end
    
    vSum = sqrt(rcdT(:,1).^2 + rcdT(:,2).^2 + rcdT(:,3).^2);
    [Ct,CoMsph(nb,:)] = triplotter_centerMass(rcdT,vSum,[1 0 0],0);
    if isnan(Ct)
        keyboard
    else
        CoM(nb,:) = Ct;
    end

    clear rcdT; clear wgtLoc; clear vSum;
end
hold on
cmap = zeros(numBoot,3);

triplotter_GlassWithTr_noCBar_oneOri(CoM,cmap);








