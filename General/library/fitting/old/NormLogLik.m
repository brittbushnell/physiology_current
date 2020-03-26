function nllik = NormPoisLogLik(llik,R)
  
if nargin==0
    test
    return
end

if iscell(R)
    error('Cannot do cells')
else
    llikSat


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