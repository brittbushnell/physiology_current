function [P,rHat,minErr] = FitSizeModel(x,r,nStarts,P0)

if exist('P0','var')
   nStarts = 1;
   isP0provided = 1;
else
    isP0provided = 0;
end
   
nPar = 6;
errFun = @(P) sum( (SizeModel(x,P)-r).^2 );

%       R0     s1     s2   k1    k2    p
lb = [  0      0,     0,   0,    0,    0 ];
ub = [  inf,   inf,   inf, inf, inf,   inf ];

% constraints:
% s2>1 -> s1-s2 < 0
A = [0 1 -1  0  0 0];
A = [A;zeros(nPar-1,nPar)];
b = zeros(nPar,1);

opt.Algorithm = 'interior-point';
opt.Display = 'none';

for iS = 1:nStarts
    
    if ~isP0provided
        R0 = min(r);
        s1 = 0.1 + 3*rand;
        s2 = s1 + 2*rand;
        kC = 2 + 100*rand;
        kS = 2 + 5*rand;
        p = 1+3*rand;
        P0 = [R0,s1,s2,kC,kS,p];
    end
    
    [Pi(:,iS),err(iS)] = fmincon(errFun,P0,A,b,[],[],lb,ub,[],opt);
end

[minErr,iBest] = min(err);
P = Pi(:,iBest);
rHat = SizeModel(x,P);
