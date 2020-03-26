function [P,rHat,explVar,nllik] = FitDifOfExp(x,r,nStarts,doPlot,errType,P0)

if nargin==0
    clc
    test
    return
end

nPar = 6;
if exist('P0','var')
    isP0supplied = 1;
    nStarts = 1;
else
    isP0supplied = 0;
end
if ~exist('errType','var') || isempty(errType)
    errType = 'gaussian';
end
if ~exist('doPlot','var') || isempty(doPlot)
    doPlot = 0;
end
if ~exist('nStarts','var') || isempty(nStarts)
    nStarts = 1;
end

if strcmp(errType,'poisson')
    errFun = @(P) min(1e5,-PoisLogLik(DifOfExp(x,P),r));
elseif strcmp(errType,'gaussian')
    errFun = @(P) sum ( (DifOfExp(x,P) - r).^2 );
end

if any(size(x)==1)
    x = x(:)';
end
[maxR,~] = max(mean(r,1));
minR = min(mean(r,1));
%       R0      Rmax        s1     pow     wSur       sRat
if ~isP0supplied
    P0 = [  minR   maxR-minR    2       1       0.9       0.5   ];
end
lb = [    0       0         0       0       0          0     ];
ub = [   inf      inf       inf     5       1          1     ];
P01 = [ minR/2   minR      0.2      0.1     0.1       0.1    ];
P02 = [  minR*2  maxR*2       10      6      0.95      0.5   ];  

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

rHat = DifOfExp(x,P);
explVar = ExplanVar(mean(r,1),rHat);
% if isnan(explVar)
%     keyboard
% end
% nllik = NormPoisLogLik(rHat,r);
nllik = nan;

if doPlot
    plot(x,mean(r,1),'k.-',x,rHat,'-')
end

function test
P = [10,100,5,1,0.9,0.5];
sf = logspace(-1,1,14);
r = round(DifOfExp(sf,P) + 3*rand(1,numel(sf)));
[~,rHat] = FitDifOfExp(sf,r,3);
semilogx(sf,r,'k.-'), hold on
semilogx(sf,rHat,'b-')
