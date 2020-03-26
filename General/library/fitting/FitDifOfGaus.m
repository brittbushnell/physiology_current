function [P,rHat] = FitDifOfGaus(x,r,doBaseline,nStarts,P0)
% Fit DoG model, with or without baseline.
%
% [P,rHat] = FitDifOfGaus(x,r,[doBaseline],[nStarts],[P0])
%
% Model:
% r = R0 + Rmax.*( exp(-x.^2./(2*s1.^2)) - w.*exp(-x.^2./(2*s2.^2))) .^p;
%
% Inputs: 
% x: independent variable (e.g. SF)
% r: measured respobse (data)
% doBaseline: (optional, default true) Boolean, set to 1 to fit a baseline.
% nStarts: (optional, default 1) Number of fits to peform. First fit is
%           always with chosen starting params, or those proveded (P0).
%           Subsequent fits are done with random starting params.
%           The best fit is returned.
% P0: (optional) Starting parameters to use in first fit
%               (e.g. from a previous fit).
%
% shooner, june 2017



%%%%%%%%%%%%%%%%%%%%%%%%
%%%-- Parse inputs --%%%
%%%%%%%%%%%%%%%%%%%%%%%%
if nargin==0
    test;
    return;
end
isP0supplied = exist('P0','var');
if ~exist('nStarts','var')
    nStarts = 1;
end
if ~exist('doBaseline','var')
    doBaseline = 1;
end
nPar = 5 + doBaseline; % number of parameters


%%%%%%%%%%%%%%%%%%%%%
%%%-- Setup fit --%%%
%%%%%%%%%%%%%%%%%%%%%

% helper function:
row = @(x) x(:);
% Function to minimize:
errFun = @(P) sum ( (row(DifOfGaus(x,P)) - row(r)).^2 );
    
% Bounds and constraints
%       Rmax    s1   s2     w      p
lb = [   0,     0,    0,    0,     0  ];
ub = [   inf,  inf,  inf,   1,    inf ];
if doBaseline
    lb = [lb, -inf];
    ub = [ub, inf];
end
% s2<s1, so then s2-s1 < 0:
A = zeros(1,nPar);
b = 0;
% Want A = [0 -1 1 ...]
A(1,2)=-1; A(1,3)=1;

% Initial parameters:
if ~isP0supplied
    if doBaseline
        P0 = [max(r)-min(r),  2,  1,   0.75,   2, min(r) ];
    else
        P0 = [max(r),  2,  1,   0.75,   2];
    end
end

% Define range over which to pick random starting params:
%        Rmax                 s1     s2      w        p
P01 = [   0,                  0.2,   0.1,    0.1,     1  ];
P02 = [   2*(max(r)-min(r)),  5,     4,      0.99,    4  ];
if doBaseline
    P01 = [P01,-2*abs(min(r))];
    P02 = [P02,max(r)/2];
end

% Fitting options:
opt.Algorithm = 'interior-point';
opt.Display = 'none';


%%%%%%%%%%%%%%%%%%%%%%%
%%%-- Perform fit --%%%
%%%%%%%%%%%%%%%%%%%%%%%

Pi = nan(nPar,nStarts); % vector to store fitted params.
err = nan(1,nStarts); % error of each fit
for iS = 1:nStarts
    if iS==1
        P0i = P0;
    else
        P0i = P01 + rand(1,nPar).*(P02-P01);
        if P0i(3)>P0i(2)
            P0i(3)=P0i(2)*0.5;
        end
    end
    [Pi(:,iS),err(iS)] = fmincon(errFun,P0i,A,b,[],[],lb,ub,[],opt);
end
[~,iSbest] = min(err);
P = Pi(:,iSbest);
rHat = DifOfGaus(x,P);


% End of fitting function



%%%------------- Testing function --------------------%%%
function test
P = [10,2,1,0.2,2,5];
sf = logspace(-1,1,14);
r = DifOfGaus(sf,P) + 3*rand(1,numel(sf));

[~,rHat] = FitDifOfGaus(sf,r,1,10);
semilogx(sf,r,'k.-'), hold on
semilogx(sf,rHat,'b-')
