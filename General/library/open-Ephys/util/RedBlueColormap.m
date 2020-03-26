function cmap = RedBlueColormap(N,p)

hMax = 0.75;
x = linspace(0,1,N);
incFun = x.^p;

b = 0.7;
r = 0;
h = [b.*ones(N,1) ; r.*ones(N,1)];
s = [flipud(incFun(:));incFun(:)];
v = ones(2*N,1);

cmap = hsv2rgb([h,s,v]);
