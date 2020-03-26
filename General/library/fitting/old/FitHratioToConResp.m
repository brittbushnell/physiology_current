function P = FitHratioToConResp(x,r,nStart,P0)

nPar = 4;
if exist('P0','var')
    nStart = 1;
else
    b0 = r(1);
    k0 = max(r)-r(1);
    c500 = 0.5;
    n0 = 3;
    P0 = [b0,k0,c500,n0];
end
if ~exist('nStart','var')
    nStart = 1;
end
    
x = x(:);
r = r(:);
errFun = @(P) sum(col( (r-Hratio(x,P)).^2 ));

lb = [0          0.5*(max(r)-min(r))  0.02     1 ];
ub = [abs(min(r))*2    2*(max(r)-min(r))    10      10];

opt.Display = 'none';
opt.MaxFunEvals = 1e5;
opt.MaxIter = 1e5;
opt.Algorithm = 'interior-point';

Pi = nan(nPar,nStart);
err = nan(1,nStart);
for iS = 1:nStart
    if iS==1
        P0i = P0;
    else
        P0i = lb + (ub-lb).*rand(1,nPar);
    end
    [Pi(:,iS),err(iS)] = fmincon(errFun,P0i,[],[],[],[],lb,ub,[],opt);
end
[~,iSbest] = min(err);
P = Pi(:,iSbest);



doDebug = 0;
if doDebug
    rHat = Hratio(x,P);
    figure(1), clf
    semilogx(x,r,'ko'), hold on
    semilogx(x,rHat,'b-')
    title([num2str(P(1)),' ',num2str(P(2)),' ',num2str(P(3)),' ',num2str(P(4))])
    pause
end