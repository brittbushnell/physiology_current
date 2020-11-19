function [] = draw_ellipse(p,varargin)
%%
%INPUT:
%     p: parameter output from fit_gaussianrf. 
%     optional: [r,g,b] for color of the line, otherwise it will plot black
%OUTPUT:
%     draws the ellipse. 

if ~isempty(varargin)
    c = varargin{1};
else
    c = [0 0 0];
end
thetas = linspace(0,2*pi,100); % this is 0:360 in 100 steps, so we get a smooth edge of the ellipse
x = 1*p(3)*cos(thetas);  % uses the standard deviation of the recpetive field to get the x and y points
y = 1*p(4)*sin(thetas);

R = @(th) [cos(th) -sin(th);+sin(th) cos(th)];
A = [x(:) y(:)]*R(p(5)) +[p(1) p(2)];
  % take each x and y point from above, multiply those points by the
  % product of the rotation and the R function, then center it around the
  % x,y center points. 
  
if isempty(varargin)  
    plot(A(:,1),A(:,2),'Color',c,'LineWidth',0.5);
else
    plot(A(:,1),A(:,2),'Color',c);
end
