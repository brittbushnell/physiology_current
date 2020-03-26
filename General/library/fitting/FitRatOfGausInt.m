function [P,rHat] = FitRatOfGausInt(x,r,nStarts,P0)

if nargin==0; test; return; end
nPar = 5;
isP0provided = exist('P0','var');
if ~exist('nStarts','var')
    nStarts = 1;
end
   
errFun = @(P) sum( (RatOfGausInt(x,P)-r).^2 );

%       k      c       s1     s2      p
lb = [  0,     0,      0,     0,      0 ];
ub = [  inf,   10,    inf,   inf,   inf ];

P01 = [max(r)*0.5,  0.01, 0.1,  0.1, 0.5   ];
P02 = [max(r)*2,    1,    5,    5,   5     ];

% constraints:
% want s2>s1 so s1-s2 < 0
A = [0 0 1 -1 0];
b = 0;

opt.Algorithm = 'interior-point';
opt.Display = 'none';

if ~isP0provided
    k = max(r);
    c = 1;
    s1 = 0.5;
    s2 = 1;
    p = 2;
    P0 = [k c s1 s2 p];
end

Pi = nan(nPar,nStarts);
err = nan(1,nStarts);
for iS = 1:nStarts 
    if iS==1
        P0i = P0;
    else
        P0i = P01 + (P02-P01).*rand(1,nPar);
        if P0i(4)<=P0i(3)
            P0i(4) = P0i(3)*2;
        end
    end
        [Pi(:,iS),err(iS)] = fmincon(errFun,P0i,A,b,[],[],lb,ub,[],opt);
end

[~,iSbest] = min(err);
P = Pi(:,iSbest);

rHat = RatOfGausInt(x,P);





function test

k = 10;
c = 0.7;
s1 = 1;
s2 = 3;
p = 1;

nStarts = 1;
P0 = [k*1.2,c*1.5,s1*2,s2/2,p];

x = logspace(-2,1,16);
r = RatOfGausInt(x,[k,c,s1,s2,p]) + rand(1,16);
[~,rHat] = FitRatOfGausInt(x,r,nStarts,P0);

close all
semilogx(x,r,'ko-'), hold on
semilogx(x,rHat,'b-')