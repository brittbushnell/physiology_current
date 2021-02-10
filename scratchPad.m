% at the end of this section, you end up with a n x 8 matrix.  Each row is
% a channel from one of the 4 eyes/arrays/animals matrices. 
% 
% column 1:3 are the d' to  radial, concentric, and dipole 
% column 4 is the vector sum of columns 1:3
% column 5 is an index for which of the eye/array matrices the data belong
% to
% column 6:8 are the (r,g,b) values for the data based on sorted vector sum

ndx1 = ones(size(v1dLE,1),1);
ndx2 = ones(size(v1dRE,1),1)+1;
ndx3 = ones(size(v4dLE,1),1)+2;
ndx4 = ones(size(v4dRE,1),1)+3;

allDps = cat(1,v1dLE, v1dRE, v4dLE, v4dRE); 
allDps(:,4) = sqrt(allDps(:,1).^2 + allDps(:,2).^2 + allDps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
allDps(:,5) = [ndx1;ndx2;ndx3;ndx4];

[~,sortNdx] = sort(allDps(:,4),'descend');
sortDps = allDps(sortNdx,:);

cmap = gray(length(allDps)); 
sortDps(:,6:8) = cmap; % make black be highest, white lowest
%% break sortDps into smaller matrices for each of the subplots

v1LEsort = sortDps(sortDps(:,5) == 1,:);
v1REsort = sortDps(sortDps(:,5) == 2,:);
v4LEsort = sortDps(sortDps(:,5) == 3,:);
v4REsort = sortDps(sortDps(:,5) == 4,:);
%% This part is into plotGlass_triplot...
figure(1)
clf

hold on
% get the d' and color mapping values  
rcd = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
%% This part will become the new triplotter_Glass function that makes the figure
% inputs(rcb,cmap)
% rcd are d' vs blank for radial, concentric, and dipole
% cmap are the (r,g,b) values to be used for each data point based on their
% vector sum ranking. 
hold on;  
h=axesm('stereo','origin',[45 45 0]);
axis off;

% draw the outlines of the triangle
plot3m(linspace(0,90,90), 0.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(linspace(0,90,90),90.*ones(1,90),ones(1,90),'k','LineWidth',0.6)
plot3m(0.*ones(1,90),linspace(0,90,90),ones(1,90),'k','LineWidth',0.6)


% change data points to appropriate projections
x = rcd(:,1);
y = rcd(:,2);
z = rcd(:,3);

[th,phi,r]=cart2sph(x,y,z);

for i = 1:size(rcd,1)
    plot3m(rad2deg(phi(i)),rad2deg(th(i)),r(i), 'o','MarkerFaceColor',  cmp(i,:),'MarkerSize', 7,'MarkerEdgeColor',[0.99 0.99 0.99],'LineWidth',0.4);
end

% draw dots for edge of vertices
[thc,phic,rc]=cart2sph(1,1,1); plot3m(rad2deg(phic),rad2deg(thc),rc,'ro','LineWidth',0.6,'MarkerSize', 7)

[thl,phil,rl]=cart2sph(1,0,1); plot3m(rad2deg(phil),rad2deg(thl),rl,'ro','LineWidth',1,'MarkerSize', 7) % left
[thr,phir,rr]=cart2sph(0,1,1); plot3m(rad2deg(phir),rad2deg(thr),rr,'ro','LineWidth',1,'MarkerSize', 7) %right
[thb,phib,rb]=cart2sph(1,1,0); plot3m(rad2deg(phib),rad2deg(thb),rb,'ro','LineWidth',1,'MarkerSize', 7) % bottom

% draw lines for the subsections
plot3m([rad2deg(phic),rad2deg(phil)],[rad2deg(thc),rad2deg(thl)],[rc,rl],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phir)],[rad2deg(thc),rad2deg(thr)],[rc,rr],'-','color',[0.6 0.6 0.6])
plot3m([rad2deg(phic),rad2deg(phib)],[rad2deg(thc),rad2deg(thb)],[rc,rb],'-','color',[0.6 0.6 0.6])