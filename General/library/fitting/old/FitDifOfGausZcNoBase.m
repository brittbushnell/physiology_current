function [P,rHat] = FitDifOfGausZcNoBase(x,r,nStarts,P0)
%
% INPUTS
% x: variables of interest (ex: spatial frequency)
% r: nerual responses baseline subtracted
% nStarts: number of times to do the fit with random starting points
%
% OUTPUTS
% P: fitted parameters
% rHat: estimated 

nPar = 5;
if exist('P0','var')
    isP0supplied = 1;
    nStarts = 1;
else
    isP0supplied = 0;
end
if ~exist('nStarts','var')
    nStarts = 1;
end

errFun = @(P) sum ( (DifOfGausZcNoBase(x,P) - r).^2 );

%            Rmax     s1    s2    w     p   
if ~isP0supplied
    P0 = [   max(r),  0.5,  2,   0.75,   2];
end
%        Rmax     s1    s2    w     p   
lb = [    0,     0,    0,    0,    0];
ub = [    inf,   inf,   inf,   1,   10];

P01 = [  1      0.1  0.2  0.1   1];
P02 = [  100    5     4   0.99  4];  

% constraints:
% s2<s1 -> s2-s1 < 0
A = [0  -1  1  0  0];
A = [A;zeros(nPar-1,nPar)];
b = zeros(nPar,1);

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
    [Ps(:,iS),err(iS)] = fmincon(errFun,P0s,A,b,[],[],lb,ub,[],opt);
%     [Ps(:,iS),err(iS)] = fminsearch(errFun,P0s,opt);
end
[~,iBest] = min(err);

P = Ps(:,iBest);

rHat = DifOfGausZcNoBase(x,P);