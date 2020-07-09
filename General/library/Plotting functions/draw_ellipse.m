function [] = draw_ellipse(p,varargin)
%%
%INPUT:
%     p: parameter output from fit_gaussianrf. 
%OUTPUT:
%     draws the ellipse. 
%
if ~isempty(varargin)
    c = varargin{1};
else
    c = [0 0 0];
end
thetas = linspace(0,2*pi,100);
x = 1*p(3)*cos(thetas);
y = 1*p(4)*sin(thetas);

R = @(th) [cos(th) -sin(th);+sin(th) cos(th)];
A = [x(:) y(:)]*R(p(5)) +[p(1) p(2)];
plot(A(:,1),A(:,2),'Color',c);
