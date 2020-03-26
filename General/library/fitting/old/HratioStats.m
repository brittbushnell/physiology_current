function [thresh,maxGain,area,range] = HratioStats(P,threshLev,xMax)

if nargin==0
    test;
    return
end

nX = 2000;
x = logspace(-3,log10(xMax),nX);
y = Hratio(x,P);
range = max(y) - min(y);
dy = HratioDeriv(x,P(1),P(2),P(3));             
maxGain = max(dy);

area = trapz(x,y-y(1));

ind = find( (y-y(1))>threshLev,1);
if isempty(ind)
    thresh = nan;
else
    thresh = x(ind);
end




function test
P = [5,20,0.3,2];
con = logspace(-2,1,100);
r = round(Hratio(con,P) + 3*rand(1,numel(con)));
[~,~,~,~,rHat] = FitHratioToConResp(con,r,3);
semilogx(con,r,'k.-'), hold on
semilogx(con,rHat,'b-')
[thresh,maxGain,area] = HratioStats(P,8,0.5)