function [] = triplotter_Glass_BExArrays_optimalForPattern(V1data,V4data)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/%s/',V1data.conRadRE.animal, V1data.conRadRE.programID);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% to do in this version:
%{
DONE:
1) V1 and V4  
2) limit everything to good ch and in stim 
3) plot the dashed lines for each subsection
4) switch to triplotter_glass
5) verify center of mass plotted clearly
6) alter figures so only one color bar on the far right of the figure window. 
7) count how many points fall within the different sections
%}
%%

V1dataRE = getGlassDprimeVectTriplots(V1data.conRadRE.radBlankDprime,V1data.conRadRE.conBlankDprime,V1data.conRadRE.noiseBlankDprime, V1data.conRadRE.goodCh, V1data.conRadRE.inStim);   
V1dataLE = getGlassDprimeVectTriplots(V1data.conRadLE.radBlankDprime,V1data.conRadLE.conBlankDprime,V1data.conRadLE.noiseBlankDprime, V1data.conRadLE.goodCh, V1data.conRadLE.inStim);
V4dataRE = getGlassDprimeVectTriplots(V4data.conRadRE.radBlankDprime,V4data.conRadRE.conBlankDprime,V4data.conRadRE.noiseBlankDprime, V4data.conRadRE.goodCh, V4data.conRadRE.inStim);
V4dataLE = getGlassDprimeVectTriplots(V4data.conRadLE.radBlankDprime,V4data.conRadLE.conBlankDprime,V4data.conRadLE.noiseBlankDprime, V4data.conRadLE.goodCh, V4data.conRadLE.inStim);

%%
ndx1 = ones(size(V1dataLE,1),1);
ndx2 = ones(size(V1dataRE,1),1)+1;
ndx3 = ones(size(V4dataLE,1),1)+2;
ndx4 = ones(size(V4dataRE,1),1)+3;

catdps = cat(1,V1dataLE, V1dataRE, V4dataLE, V4dataRE); 
catdps(:,4) = sqrt(catdps(:,1).^2 + catdps(:,2).^2 + catdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
catdps(:,5) = [ndx1;ndx2;ndx3;ndx4];

[~,sortNdx] = sort(catdps(:,4),'descend');
sortDps = catdps(sortNdx,:);

cmap = gray(length(catdps)); 
sortDps(:,6:8) = cmap; % make black be highest, white lowest
%% break sortDps into smaller matrices for each of the subplots
v1LEsort = sortDps(sortDps(:,5) == 1,:);
v1REsort = sortDps(sortDps(:,5) == 2,:);
v4LEsort = sortDps(sortDps(:,5) == 3,:);
v4REsort = sortDps(sortDps(:,5) == 4,:);
%% 
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s stimulus vs blank d''',V1data.conRadLE.animal));
s.Position(2) = s.Position(2) +0.025;
s.FontWeight = 'bold';
s.FontSize = 18;

s = subplot(2,2,1); 
hold on
rcd = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
triplotter_Glass_noCBar(rcd,cmp);
triplotter_centerMass(rcd,v1LEsort(:,4),[1 0 0])

if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('LE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim)))
else
    title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')
% variances
% LEv1Vars = var(rcd,v1LEsort(:,4));
% text(-1.1, 0.6,sprintf('radial var: %.2f',LEv1Vars(1)),'FontSize',12) 
% text(-1.1, 0.5,sprintf('con var: %.2f',LEv1Vars(2)),'FontSize',12) 
% text(-1.1, 0.4,sprintf('dipole var: %.2f',LEv1Vars(3)),'FontSize',12) 

%
s = subplot(2,2,2);     
hold on
rcd = v1REsort(:,1:3);
cmp = v1REsort(:,6:8);
triplotter_Glass_noCBar(rcd,cmp);
triplotter_centerMass(rcd,v1REsort(:,4),[1 0 0])

if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('RE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim)))
else
    title(sprintf('AE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) - 0.03;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

% variances
REv1Vars = var(rcd,v1REsort(:,4));
% text(-1.1, 0.6,sprintf('radial var: %.2f',REv1Vars(1)),'FontSize',12) 
% text(-1.1, 0.5,sprintf('con var: %.2f',REv1Vars(2)),'FontSize',12) 
% text(-1.1, 0.4,sprintf('dipole var: %.2f',REv1Vars(3)),'FontSize',12) 

s = subplot(2,2,3);  
hold on
rcd = v4LEsort(:,1:3);
cmp = v4LEsort(:,6:8);
triplotter_Glass_noCBar(rcd,cmp);
triplotter_centerMass(rcd,v4LEsort(:,4),[1 0 0])

if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('LE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim)))
else
    title(sprintf('FE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;
text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')
% variances
% LEv4Vars = var(rcd,v4LEsort(:,4));
% text(-1.1, 0.6,sprintf('radial var: %.2f',LEv4Vars(1)),'FontSize',12) 
% text(-1.1, 0.5,sprintf('con var: %.2f',LEv4Vars(2)),'FontSize',12) 
% text(-1.1, 0.4,sprintf('dipole var: %.2f',LEv4Vars(3)),'FontSize',12) 



s = subplot(2,2,4);       
hold on
rcd = v4REsort(:,1:3);
cmp = v4REsort(:,6:8);
ax = triplotter_Glass_noCBar(rcd,cmp);
triplotter_centerMass(rcd,v4REsort(:,4),[1 0 0])

if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('RE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
else
    title(sprintf('AE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
end
s.Position(1) = s.Position(1) - 0.03;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

% variances
% REv4Vars = var(rcd,v4REsort(:,4));
% text(-1.1, 0.6,sprintf('radial var: %.2f',REv4Vars(1)),'FontSize',12) 
% text(-1.1, 0.5,sprintf('con var: %.2f',REv4Vars(2)),'FontSize',12) 
% text(-1.1, 0.4,sprintf('dipole var: %.2f',REv4Vars(3)),'FontSize',12) 

colormap(ax,flipud(cmap));
c2 = colorbar(ax,'Position',[0.9 0.31 0.0178 0.37]);
c2.TickDirection = 'out';
c2.Ticks = 0:0.25:1;
c2.FontAngle = 'italic';
c2.FontSize = 12;
c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
c2.Label.String = 'Vector sum of dPrimes';
c2.Label.FontSize = 14;

%%
figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_bestDtDx_cMAss'];
set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')