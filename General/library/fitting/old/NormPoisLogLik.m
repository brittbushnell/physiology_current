function nllik = NormPoisLogLik(rHat,R)
  
if nargin==0
    test
    return
end

if iscell(R)
    error('Cannot do cells')
else
    llik = PoisLogLik(rHat,R);
    llikNull = sum(sum(log(poisspdf(R,mean(mean(R))))));
    llikSat = 0;
    for k = 1:numel(rHat)
        llikSat = llikSat + sum(log(poisspdf(R(:,k),mean(R(:,k)))));
    end
end
nllik = (llik-llikNull)./(llikSat-llikNull);

function test

x = 11:20;
X1 = [x-1;x;x+1];
nllik = NormPoisLogLik(x,X1)
