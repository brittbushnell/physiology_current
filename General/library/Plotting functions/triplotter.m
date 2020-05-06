function triplotter(x,y,z,model1name,model2name,model3name)

% old code to plot triplotter (2008) - uses orthographic projection
% not steteographic (angle preserving). use triplotter_stereo instead

% convert to spherical coordinates
[th,phi,r] = cart2sph(x,y,z);

% force radius to be 1, thus all vectors are unit vectors.
r2 = ones(size(r,1),size(r,2));

% th = (pi/2) - th;
% phi = (pi/2) - phi;
% 
% disp(th*180/pi);
% disp(phi*180/pi);

% convert to cartesian coordinates
[x,y,z] = sph2cart(th,phi,r2);

% plot results and set up the view
plot3(x,y,z,'k.');
% box off;
% axis off;
% axis([0 1 0 1 0 1]);
axis square;
axis([-1 1 -1 1 -1 1]);
view(180-45,35);


% draw pure X, Y and Z lines
line([0 1],[0 0],[0 0],'color','r');
line([0 0],[0 1],[0 0],'color','r');
line([0 0],[0 0],[0 1],'color','r');

% draw arcs
nPoints = 1000;
temp=linspace(0,1,nPoints);
line(temp,sqrt(1-temp.^2),zeros(1,nPoints),'color','g');
line(temp,zeros(1,nPoints),sqrt(1-temp.^2),'color','g');
line(zeros(1,nPoints),temp,sqrt(1-temp.^2),'color','g');

if ~exist('model1name','var')
    model1name = 'model 1';
end
if ~exist('model2name','var')
    model2name = 'model 2';
end
if ~exist('model3name','var')
    model3name = 'model 3';
end


text(1.05,0,0,model1name,'HorizontalAlignment','right');
text(0,1.05,0,model2name,'HorizontalAlignment','left');
text(0,0,1.05,model3name,'HorizontalAlignment','center');
% text(0,1.0,1.0,model1name,'HorizontalAlignment','left');
% text(1.0,0,1.0,model2name,'HorizontalAlignment','right');
% text(1.0,1.0,0,model3name,'HorizontalAlignment','center');

