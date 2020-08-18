clc;

radDps = abs(squeeze(dataT.radBlankDprime(end,dt,dx,:)));
conDps = abs(squeeze(dataT.conBlankDprime(end,dt,dx,:)));
nosDps = abs(squeeze(dataT.noiseBlankDprime(dt,dx,:)));

dps = [conDps,radDps,nosDps];
dpMax = max(dps(:))+0.2;
dpMin = min(dps(:))-0.2;
cmaplarge = (gray(110));
cmap = flipud(cmaplarge(1:96,:));

sortDPs = sortrows(dps);
pointSize = 30.*ones(size(nosDps));

model1name = 'Concentric';
model2name = 'Radial';
model3name = 'Bipole';

x = sortDPs(:,1);
y = sortDPs(:,2);
z = sortDPs(:,3);
%%
figure(1)
clf
pause(0.02)

% convert to spherical coordinates
[az,elev,r] = cart2sph(x,y,z);

% force radius to be 1, thus all vectors are unit vectors.
r2 = ones(size(r,1),size(r,2));
r2(find(r==0)) = 0;

% convert to cartesian coordinates
[x,y,z] = sph2cart(az,elev,r2);

subplot(1,2,1)
%plot3(y,x,z,'ko');
scatter3(x,y,z,'k','filled');

% draw pure X, Y and Z lines
line([0 1],[0 0],[0 0],'color','k','LineStyle','--');
line([0 0],[0 1],[0 0],'color','k','LineStyle','--');
line([0 0],[0 0],[0 1],'color','k','LineStyle','--');

% draw pure X, Y and Z lines
line([0 1],[0 0],[0 0],'color','k','LineStyle','--');
line([0 0],[0 1],[0 0],'color','k','LineStyle','--');
line([0 0],[0 0],[0 1],'color','k','LineStyle','--');

% draw arcs
nPoints = 1000;
temp=linspace(0,1,nPoints);
line(temp,sqrt(1-temp.^2),zeros(1,nPoints),'color','k');
line(temp,zeros(1,nPoints),sqrt(1-temp.^2),'color','k');
line(zeros(1,nPoints),temp,sqrt(1-temp.^2),'color','k');

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

text(0,1.0,1.0,model1name,'HorizontalAlignment','left','FontSize',12);
text(1.0,0,1.0,model2name,'HorizontalAlignment','right','FontSize',12);
text(1.0,1.0,0,model3name,'HorizontalAlignment','center','FontSize',12);
%%
