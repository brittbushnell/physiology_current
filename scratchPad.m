allDps = cat(1,v1dLE, v1dRE, v4dLE, v4dRE); 
vSum = sqrt(allDps(:,1).^2 + allDps(:,2).^2 + allDps(:,3).^2);
vSumNdx = [ndx1;ndx2;ndx3;ndx4];

[sortSum,sortNdx] = sort(vSum,'descend');

cmap = gray(length(allDps)); 
cmap = flipud(cmap); % make black be highest, white lowest
cmapSort = cmap(sortNdx);
vSumCmap = [sortSum, cmap(sortNdx), vSumNdx(sortNdx)];
%% This part is into plotGlass_triplot...
figure(1)
clf

hold on
v1Lndx = vSumCmap(vSumCmap(:,3) == 1);
v1Lsum = sortSum(v1Lndx,:);
v1Cmap = cmapSort(v1Lndx);
rcb = v1Lsum;
%% This part will become the new triplotter_Glass function that makes the figure


h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)

% draw dots for edge of vertices
[th,phi,r]=cart2sph(1,1,1); plot3m(rad2deg(phi),rad2deg(th),r,'ro','LineWidth',0.6)

[thl,phil,rl]=cart2sph(1,0,1); plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1) % left
[thr,phir,rr]=cart2sph(0,1,1); plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1) %right
[thb,phib,rb]=cart2sph(1,1,0); plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1) % bottom

% change data points to appropriate projections
x = rcb(:,1);
y = rcb(:,2);
z = rcb(:,3);

[th,phi,r]=cart2sph(x,y,z);

% plot3m(


