function llik = PoisLogLik(rHat,R)
  
if nargin==0
    test
    return
end

llik = 0;

if iscell(R)
    for k = 1:numel(rHat)
        llik = llik + sum(log(poisspdf(R{k},max(1e-4,rHat(k)))));
    end
else
    for k = 1:numel(rHat)
        llik = llik + sum(log(poisspdf(R(:,k),max(1e-4,rHat(k)))));
    end
end



function test

x = 0:9;

% Matrix input
X1 = round(bsxfun(@plus,x,3*rand(4,10)));
llik = PoisLogLik(x,X1)

% Cell input
for k = 1:numel(x)
    X2{k} = X1(:,k);
end
llik = PoisLogLik(x,X2)