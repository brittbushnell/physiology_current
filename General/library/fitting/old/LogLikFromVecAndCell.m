function llik = PoisLogLik(rHat,R)
  
if nargin==0
    test
    return
end

fun = @(x,X) sum(log( poisspdf(X,max(1e-4,x)) ));

if iscell(X)
    llik = sum(row(cellfun(fun,num2cell(rHat),R)));