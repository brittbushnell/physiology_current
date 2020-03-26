function triplotter(x,y,z,model1name,model2name,model3name)
% Romesh's code for a 3-way scatter plot.

% for i=1:size(x,1)
%     normalizer = max([x(i),y(i),z(i)]);
%     if (normalizer == 0)
%         normalizer = 1;
%     end
%     x(i) = (x(i) ./ normalizer);
%     y(i) = (y(i) ./ normalizer);
%     z(i) = (z(i) ./ normalizer);
% end


% convert to spherical coordinates
[th,phi,r] = cart2sph(x,y,z);

% force radius to be 1, thus all vectors are unit vectors.
r2 = ones(size(r,1),size(r,2));
r2(find(r==0)) = 0;


%th = (pi/2) - th;
%phi = (pi/2) - phi;

disp(th*180/pi);
disp(phi*180/pi);

% convert to cartesian coordinates
[x,y,z] = sph2cart(th,phi,r2);


% plot results.
%plot3(1-x,1-y,1-z,'ko');
plot3(x,y,z,'k.');
%plot3(x,y,z,'k.');

% draw pure X, Y and Z lines
% line([0 0],[0 1],[0 1],'color','k');
% line([0 1],[0 1],[0 0],'color','k');
% line([0 1],[0 0],[0 1],'color','k');
line([0 1],[0 0],[0 0],'color','k');
line([0 0],[0 1],[0 0],'color','k');
line([0 0],[0 0],[0 1],'color','k');

% draw arcs
nPoints = 1000;
temp=linspace(0,1,nPoints);
line(temp,sqrt(1-temp.^2),zeros(1,nPoints),'color','b');
line(temp,zeros(1,nPoints),sqrt(1-temp.^2),'color','b');
line(zeros(1,nPoints),temp,sqrt(1-temp.^2),'color','b');

% setup the view 
box off;
axis off;
axis square;
axis([0 1 0 1 0 1]);
view(180-45,35);

if ~exist('model1name','var')
    model1name = 'model 1';
end
if ~exist('model2name','var')
    model2name = 'model 2';
end
if ~exist('model3name','var')
    model3name = 'model 3';
end

%text(1.05,0,0,model1name,'HorizontalAlignment','right');
%text(0,1.05,0,model2name,'HorizontalAlignment','left');
%text(0,0,1.05,model3name,'HorizontalAlignment','center');
text(0,1.0,1.0,model1name,'HorizontalAlignment','left');
text(1.0,0,1.0,model2name,'HorizontalAlignment','right');
text(1.0,1.0,0,model3name,'HorizontalAlignment','center');

