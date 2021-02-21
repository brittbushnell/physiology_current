figure(1)
clf
hold on

goodCh = V4data.conRadLE.goodCh;
inStim = V4data.conRadLE.inStim;

conDp = squeeze(V4data.conRadLE.conBlankDprime);
radDp = squeeze(V4data.conRadLE.radBlankDprime);
nozDp = squeeze(V4data.conRadLE.noiseBlankDprime);

rcd = getGlassDprimeVectTriplots(radDp,conDp,nozDp,goodCh,inStim);

vSum = sqrt(rcd(:,1).^2 + rcd(:,2).^2 + rcd(:,3).^2);
comReal = triplotter_centerMass(rcd,vSum,[1,0,0]);

[comPerm,vSumPerm] = GlassCenterOfTriplotMass_permutations(conDp,radDp,nozDp);

%%
figure(1)
% clf
hold on

for nb = 1:size(comPerm,1)
    [thx,phix,rx]=cart2sph(comPerm(nb,1),comPerm(nb,2),comPerm(nb,3));
    plot3m(rad2deg(phix),rad2deg(thx),rx+4, 'o','MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.99 0.99 0.99],'MarkerSize',7,'LineWidth',0.2);
end
%%


figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 700 400]);
set(gcf,'PaperOrientation','landscape')

hold on
comPermDist = mean(comPerm,2);
comRealDist = squeeze(mean(comReal,2));

permMax = max(comPermDist); permMin = min(comPermDist);
xMax = max(abs([comRealDist,permMax,permMin]));

xlim([-xMax xMax])
title(sprintf('%s LE V4 mean distance between d'' values',V4data.conRadLE.animal),'FontSize',18)
histogram(comPermDist,12,'FaceColor',[0 0.5 0.1],'EdgeColor','w','Normalization','probability');
plot([comRealDist,comRealDist],[0 0.6],'-r','LineWidth',1)
set(gca,'box','off','tickdir','out','layer','top');
%%


%% 