function [xPref,xHigh,bandwidth,zeroResp] = DifOfGausZcStats(x1,x2,P)

if nargin==0
    test;
    return
end

nX = 1000;
x = logspace(log10(x1),log10(x2),nX);
y = DifOfGausZc(x,P);
yZero = DifOfGausZc(0,P);
yInf = DifOfGausZc(inf,P);
y = y-yInf;
yZero = yZero-yInf;

if sum(y)==0;
    xPref = nan;
    xHigh = nan;
    bandwidth = nan;
    zeroResp = nan;
    return
end
yMax = max(y);
indPref = find(y>yMax*0.95,1,'last');
if indPref==nX
    xPref = inf;
    xHigh = inf;
    bandwidth = inf;
    zeroResp = nan;
else
    xPref = x(indPref);
    indHigh = find(y<0.05*yMax & x>xPref,1,'first');
    if isempty(indHigh)
        xHigh = inf;
    else
        xHigh = x(indHigh);
    end
    ind1 = find(y>0.5*yMax & x<=xPref,1,'first');
    if ind1==1
        bandwidth=-inf;
    else
        ind2 = find(y<0.5*yMax & x>xPref,1,'first');
        if isempty(ind2)
            bandwidth = inf;
        else
            bandwidth = log2(x(ind2)./x(ind1));
        end
    end
    zeroResp = yZero/yMax;
    
    if zeroResp>1
        zeroResp = 1;
    end

end

function test
P = [10,100,2,1,0.9,0.5];
sf = logspace(-1,2,14);
r = round(DifOfGausZc(sf,P) + 3*rand(1,numel(sf)));
[~,rHat] = FitDifOfGausZc(sf,r,3);
semilogx(sf,r,'k.-'), hold on
semilogx(sf,rHat,'b-')
[xPref,xHigh,bandwidth,zeroResp] = DifOfGausZcStats(0.001,10,P)