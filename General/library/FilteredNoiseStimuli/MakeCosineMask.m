function A = MakeCosineMask(imN,ppd,idod)
% A = MakeCosineMask(imN,ppd,idod)

r1 = idod(1)./2;
r2 = idod(2)./2;
xVals = (-imN/2:imN/2-1)./ppd;
[x,y] = meshgrid(xVals,xVals);
r = sqrt(x.^2+y.^2);
z = pi*(r-r1)./(r2-r1);
A = 0.5 + 0.5.*cos(z);
A(r<r1) = 1;
A(r>r2) = 0;






