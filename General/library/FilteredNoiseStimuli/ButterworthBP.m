function f = ButterworthBP(w,wLp,wHp,ord)
% f = ButterworthBP(w,wLp,wHp,ord)

f1 = sqrt(1./(1+(w./wLp).^(2*ord)));
f2 = 1 - sqrt(1./(1+(w./wHp).^(2*ord)));
f = f1.*f2;