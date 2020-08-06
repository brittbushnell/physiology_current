function [filter_response] = gauss_rf(x,y,params)
%% DOG_FILTER: implements a model version of the dog filter discussed in chichilnisky and kalmar (2002). 

if isvector(x) && isvector(y)
    [x,y] = meshgrid(x,y);
end


x0 = params(1);
y0 = params(2);
xstd = params(3);
ystd = params(4);
rot = params(5);
gain = params(6);
offset = params(7);

x2 = x(:);
y2 = y(:);
x2 = x2-x0;
y2 = y2-y0;

xvar = xstd.^2;
yvar = ystd.^2;

a = cos(rot).^2 / (2*xvar) + sin(rot).^2/(2*yvar);
b = -sin(2*rot)/(4*xvar) + sin(2*rot)/(2*yvar);
c = sin(rot).^2/(2*xvar) + cos(rot).^2/(2*yvar);

p1 = exp(-(a*x2.^2 + 2*b.*x2.*y2 + c*y2.^2));


filter_response = offset + gain.*reshape(p1,size(x));



end