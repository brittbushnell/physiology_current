function makeFig_triplotGlass_trNoise(V1data, V4data)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/triplot/ori/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/triplot/ori/',V1data.conRadRE.animal);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get the input matrices for each eye and array
% V1dataRE  = getGlassDprimeNoiseVectTriplots(V1data.conRadRE.radNoiseDprime, V1data.conRadRE.conNoiseDprime, V1data.trRE.linNoiseDprime,...
%                                            (V1data.conRadRE.goodCh & V1data.trRE.goodCh), (V1data.conRadRE.inStim & V1data.trRE.inStim));
% 
% V1dataLE  = getGlassDprimeNoiseVectTriplots(V1data.conRadLE.radNoiseDprime, V1data.conRadLE.conNoiseDprime, V1data.trLE.linNoiseDprime,...
%                                            (V1data.conRadLE.goodCh & V1data.trLE.goodCh), (V1data.conRadLE.inStim & V1data.trLE.inStim));
% 
% V4dataRE  = getGlassDprimeNoiseVectTriplots(V4data.conRadRE.radNoiseDprime, V4data.conRadRE.conNoiseDprime, V4data.trRE.linNoiseDprime,...
%                                            (V4data.conRadRE.goodCh & V4data.trRE.goodCh), (V4data.conRadRE.inStim & V4data.trRE.inStim));
% 
% V4dataLE  = getGlassDprimeNoiseVectTriplots(V4data.conRadLE.radNoiseDprime, V4data.conRadLE.conNoiseDprime, V4data.trLE.linNoiseDprime,...
%                                            (V4data.conRadLE.goodCh & V4data.trLE.goodCh), (V4data.conRadLE.inStim & V4data.trLE.inStim));
% %% get the gray scaling across all 4 
% ndx1 = ones(size(V1dataLE,1),1);
% ndx2 = ones(size(V1dataRE,1),1)+1;
% ndx3 = ones(size(V4dataLE,1),1)+2;
% ndx4 = ones(size(V4dataRE,1),1)+3;
% 
% catdps = cat(1,V1dataLE, V1dataRE, V4dataLE, V4dataRE); 
% catdps(:,4) = sqrt(catdps(:,1).^2 + catdps(:,2).^2 + catdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping 
% catdps(:,5) = [ndx1;ndx2;ndx3;ndx4];
% 
% [~,sortNdx] = sort(catdps(:,4),'descend');
% sortDps = catdps(sortNdx,:);
% 
% cmap = gray(length(catdps)); 
% sortDps(:,6:8) = cmap; % make black be highest, white lowest
% %% break sortDps into smaller matrices for each of the subplots
% v1LEsort = sortDps(sortDps(:,5) == 1,:);
% v1REsort = sortDps(sortDps(:,5) == 2,:);
% v4LEsort = sortDps(sortDps(:,5) == 3,:);
% v4REsort = sortDps(sortDps(:,5) == 4,:);
% %%
% figure (22)
% clf
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 900 700]);
% set(gcf,'PaperOrientation','landscape')
% 
% s = suptitle(sprintf('%s stimulus vs dipole d'' using best orientation',V1data.conRadLE.animal));
% s.Position(2) = s.Position(2) +0.025;
% s.FontWeight = 'bold';
% s.FontSize = 18;
% 
% s = subplot(2,2,1); 
% hold on
% rct = v1LEsort(:,1:3);
% cmp = v1LEsort(:,6:8);
% [~,V1LEmax] = max(rct,[],2);
% triplotter_GlassWithTr_noCBar(rct,cmp);
% v1ComLE = triplotter_centerMass(rct,v1LEsort(:,4),[1 0 0]);
% 
% if contains(V1data.conRadLE.animal,'XT')
%     title(sprintf('LE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)))
% else
%     title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim  & V1data.trLE.goodCh & V1data.trLE.inStim)))
% end
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
% 
% text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')
% 
% s = subplot(2,2,2);     
% hold on
% rct = v1REsort(:,1:3);
% cmp = v1REsort(:,6:8);
% [~,V1REmax] = max(rct,[],2);
% triplotter_GlassWithTr_noCBar(rct,cmp);
% v1ComRE = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0]);
% 
% if contains(V1data.conRadLE.animal,'XT')
%     title(sprintf('RE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim)))
% else
%     title(sprintf('AE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim)))
% end
% clear dps;
% s.Position(1) = s.Position(1) - 0.03;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
% 
% v1Dist = vecnorm(v1ComLE - v1ComRE,2,2);
% text(-2,-1,sprintf('V1 distance between CoM: %.3f',v1Dist),'FontSize',12)
% 
% s = subplot(2,2,3);  
% hold on
% rct = v4LEsort(:,1:3);
% cmp = v4LEsort(:,6:8);
% [~,V4LEmax] = max(rct,[],2);
% triplotter_GlassWithTr_noCBar(rct,cmp);
% v4ComLE = triplotter_centerMass(rct,v4LEsort(:,4),[1 0 0]);
% 
% if contains(V1data.conRadLE.animal,'XT')
%     title(sprintf('LE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim)))
% else
%     title(sprintf('FE n: %d',sum(V4data.conRadLE.goodCh & V4data.conRadLE.inStim)))
% end
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
% text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')
% 
% s = subplot(2,2,4);       
% hold on
% rct = v4REsort(:,1:3);
% cmp = v4REsort(:,6:8);
% [~,V4REmax] = max(rct,[],2);
% ax = triplotter_GlassWithTr_noCBar(rct,cmp);
% v4ComRE = triplotter_centerMass(rct,v4REsort(:,4),[1 0 0]);
% 
% if contains(V1data.conRadLE.animal,'XT')
%     title(sprintf('RE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
% else
%     title(sprintf('AE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
% end
% s.Position(1) = s.Position(1) - 0.03;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
% 
% v4Dist = vecnorm(v4ComLE - v4ComRE,2,2);
% text(-2,-1,sprintf('V4 distance between CoM: %.3f',v4Dist),'FontSize',12)
% 
% colormap(ax,flipud(cmap));
% c2 = colorbar(ax,'Position',[0.9 0.31 0.0178 0.37]);
% c2.TickDirection = 'out';
% c2.Ticks = 0:0.25:1;
% c2.FontAngle = 'italic';
% c2.FontSize = 12;
% c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
% c2.Label.String = 'Vector sum of dPrimes';
% c2.Label.FontSize = 14;
% %%
% figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_vsNoise'];
% set(gca,'color','none')
% print(gcf, figName,'-dpdf','-bestfit')
%% get the input matrices for each eye and array using mean orientation
V1dataRE  = getGlassDprimeNoiseVectTriplots_meanOri(V1data.conRadRE.radNoiseDprime, V1data.conRadRE.conNoiseDprime, V1data.trRE.linNoiseDprime,...
                                           (V1data.conRadRE.goodCh & V1data.trRE.goodCh), (V1data.conRadRE.inStim & V1data.trRE.inStim));

V1dataLE  = getGlassDprimeNoiseVectTriplots_meanOri(V1data.conRadLE.radNoiseDprime, V1data.conRadLE.conNoiseDprime, V1data.trLE.linNoiseDprime,...
                                           (V1data.conRadLE.goodCh & V1data.trLE.goodCh), (V1data.conRadLE.inStim & V1data.trLE.inStim));

V4dataRE  = getGlassDprimeNoiseVectTriplots_meanOri(V4data.conRadRE.radNoiseDprime, V4data.conRadRE.conNoiseDprime, V4data.trRE.linNoiseDprime,...
                                           (V4data.conRadRE.goodCh & V4data.trRE.goodCh), (V4data.conRadRE.inStim & V4data.trRE.inStim));

V4dataLE  = getGlassDprimeNoiseVectTriplots_meanOri(V4data.conRadLE.radNoiseDprime, V4data.conRadLE.conNoiseDprime, V4data.trLE.linNoiseDprime,...
                                           (V4data.conRadLE.goodCh & V4data.trLE.goodCh), (V4data.conRadLE.inStim & V4data.trLE.inStim));
%% get the gray scaling across all 4 
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
figure (23)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s stimulus vs dipole d'' using mean orientation',V1data.conRadLE.animal));
s.Position(2) = s.Position(2) +0.025;
s.FontWeight = 'bold';
s.FontSize = 18;

s = subplot(2,2,1); 
hold on
rct = v1LEsort(:,1:3);
cmp = v1LEsort(:,6:8);
[~,V1LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComLEmu,v1ComLEsph] = triplotter_centerMass(rct,v1LEsort(:,4),[1 0 0]);


if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('LE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)))
else
    title(sprintf('FE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim  & V1data.trLE.goodCh & V1data.trLE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')

s = subplot(2,2,2);     
hold on
rct = v1REsort(:,1:3);
cmp = v1REsort(:,6:8);
[~,V1REmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v1ComREmu,v1ComREsph] = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0]);

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

v1Dist = vecnorm((v1ComLEsph) - (v1ComREsph),2,2);

% if sigDifV1 == 1
%     text(-2,-1,sprintf('V1 distance between CoM: %.3f* p = %.3f',v1Dist,pValV1),'FontSize',12)
% else
%     text(-2,-1,sprintf('V1 distance between CoM: %.3f p = %.3f',v1Dist,pValV1),'FontSize',12)
% end

s = subplot(2,2,3);  
hold on
rct = v4LEsort(:,1:3);
cmp = v4LEsort(:,6:8);
[~,V4LEmax] = max(rct,[],2);
triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComLEmu,v4ComLEsph] = triplotter_centerMass(rct,v4LEsort(:,4),[1 0 0]);

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


s = subplot(2,2,4);       
hold on
rct = v4REsort(:,1:3);
cmp = v4REsort(:,6:8);
[~,V4REmax] = max(rct,[],2);
ax = triplotter_GlassWithTr_noCBar(rct,cmp);
[v4ComREmu,v4ComREsph] = triplotter_centerMass(rct,v4REsort(:,4),[1 0 0]);

if contains(V1data.conRadLE.animal,'XT')
    title(sprintf('RE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
else
    title(sprintf('AE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
end
s.Position(1) = s.Position(1) - 0.03;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

v4Dist = vecnorm((v4ComLEsph) - (v4ComREsph),2,2);

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
figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_meanOri'];
set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')
%%
[pValV1,sigDifV1] = getGlassCoMperm(V1data.conRadRE,V1data.conRadLE,V1data.trRE,V1data.trLE,v1Dist);
[pValV4,sigDifV4] = getGlassCoMperm(V4data.conRadRE,V4data.conRadLE,V4data.trRE,V4data.trLE,v4Dist);
%%
figure(18)
 clf
hold on
triplotter_GlassWithTr_noCBar_oneOri(v1ComREmu,[1 0 0]);
triplotter_GlassWithTr_noCBar_oneOri(v1ComLEmu,[0 0 1]);

triplotter_GlassWithTr_noCBar_oneOri(v4ComREmu,[1 0.5 0.1]);
triplotter_GlassWithTr_noCBar_oneOri(v4ComLEmu,[0.8 0.3 0.8]);

% reDist = vecnorm(v4ComREsph - v1ComREsph,2,2);
% leDist = vecnorm(v4ComLEsph - v1ComLEsph,2,2);

text(-1,-1.05,sprintf('V4 CoM distance: %.3f ',v4Dist),'FontSize',12)
text(-1,-1,sprintf('V1 CoM distance: %.3f ',v1Dist),'FontSize',12)

text(-0.25,-1.05,sprintf('p = %.3f',pValV4),'FontSize',12)
text(-0.25,-1,sprintf('p = %.3f',pValV1),'FontSize',12)

text(0.5,0.75,'V1 RE','FontWeight','bold','color',[1 0 0],'FontSize',12)
text(0.5,0.7,'V1 LE','FontWeight','bold','color',[0 0 1],'FontSize',12)
text(0.7,0.75,'V4 RE','FontWeight','bold','color',[1 0.5 0.1],'FontSize',12)
text(0.7,0.7,'V4 LE','FontWeight','bold','color',[0.8 0.3 0.8],'FontSize',12)
% text(0.5, 0.65,'permuted CoM','FontWeight','bold','FontSize',12)

text(-1,-0.75,'Radial','FontSize',12)
text(0.8,-0.75,'Concentric','FontSize',12)
text(-0.128,0.87,'Translational','FontSize',12)

title(sprintf('%s center of mass comparisons',V1data.conRadLE.animal),'FontSize',18,'FontAngle','italic')

figName = [V1data.conRadLE.animal,'_CoMcomp'];
set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')