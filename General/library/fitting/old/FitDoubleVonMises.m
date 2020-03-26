function [P,rHat,explVar,nllik] = FitDoubleVonMises(x,r,nStarts,P0)

if nargin==0
    test
    return
end
if exist('P0','var')
    isP0supplied = 1;
    nStarts = 1;
else
    isP0supplied = 0;
end

nPar = 5;
if ~exist('nStarts','var')
    nStarts = 1;
end

errFun = @(P) sum ( (DoubleVonMises(x,P) - r).^2 );
% errFun = @(P) min(1e5,-PoisLogLik(DoubleVonMises(x,P),r));

if any(size(x)==1)
    x = x(:)';
end

[maxR,ind] = max(mean(r,1));
minR = min(mean(r,1));
mu0 = x(ind);
lb = [0,0,0,5,0];
ub = [inf,inf,360,inf,inf];

if ~isP0supplied    
    P0 = [minR,(maxR-minR),mu0,20,1];
end

P01 = [minR/2  (maxR-minR)/2     0     2    0.01];
P02 = [maxR     (maxR-minR)*2   360    50   4 ];

opt.Algorithm = 'interior-point';
opt.Display = 'none';

Ps = nan(nPar,nStarts);
err = nan(1,nStarts);
for iS = 1:nStarts
    if iS==1
        P0s = P0;
    else
        P0s = P01 + rand(1,nPar).*(P02-P01);
    end
    [Ps(:,iS),err(iS)] = fmincon(errFun,P0s,[],[],[],[],lb,ub,[],opt);
end
[~,iBest] = min(err);

P = Ps(:,iBest);

rHat = DoubleVonMises(x,P);
explVar = ExplanVar(mean(r,1),rHat);
% nllik = NormPoisLogLik(rHat,r);

function test
P = [500,20,45,40,1];
ori = 15:15:360;
r = round(DoubleVonMises(ori,P) + 3*rand(1,numel(ori)));
Pfit = FitDoubleVonMises(ori,r,1);
rHat = DoubleVonMises(ori,Pfit);
plot(ori,r,'k.-',ori,rHat,'b-')