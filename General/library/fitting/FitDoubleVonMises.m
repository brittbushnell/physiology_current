function [P,rHat] = FitDoubleVonMises(x,r,nStarts,P0)

if nargin==0
    test
    return
end
isP0supplied = exist('P0','var');
if ~exist('nStarts','var')
    nStarts = 1;
end
nPar = 5;

errFun = @(P) sum ( (DoubleVonMises(x,P) - r).^2 );

[maxR,ind] = max(r);
minR = min(r);
mu0 = x(ind);

%      Rmax   mu    sig    w   R0
lb = [  0,     0,    0,    0    0];
ub = [ inf,   inf,  360,   1   inf];  

if ~isP0supplied    
    P0 = [maxR-minR,mu0,20,1,minR];
end

P01 = [(maxR-minR)*2    0     2    0.01  minR/2];
P02 = [(maxR-minR)/2   350    50     1   minR*2];

opt.Algorithm = 'interior-point';
opt.Display = 'none';

Ps = nan(nPar,nStarts);
err = nan(1,nStarts);
for iS = 1:nStarts
    if iS==1
        P0i = P0;
    else
        P0i = P01 + rand(1,nPar).*(P02-P01);
    end
    [Ps(:,iS),err(iS)] = fmincon(errFun,P0i,[],[],[],[],lb,ub,[],opt);
end
[~,iSbest] = min(err);
P = Ps(:,iSbest);
rHat = DoubleVonMises(x,P);




function test
Rmax = 50;
mu = 90;
sig = 50;
w = 2;
R0 = 10;
P = [Rmax,mu,sig,w,R0];

ori = 15:15:360;
r = round(DoubleVonMises(ori,P) + 3*rand(1,numel(ori)));
[Pfit,rHat] = FitDoubleVonMises(ori,r,4);
plot(ori,r,'k.-',ori,rHat,'b-')
Pfit