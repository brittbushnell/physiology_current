% function getGlassTriplotPermStatistics(V1data, V4data)

V4goodChLE = V4data.conRadLE.goodCh;
V4inStimLE = V4data.conRadLE.inStim;

V4conDpLE = V4data.conRadLE.conBlankDprime;
V4radDpLE = V4data.conRadLE.radBlankDprime;
V4nozDpLE = V4data.conRadLE.noiseBlankDprime;

V4rcdLE = getGlassDprimeVectTriplots(V4radDpLE,V4conDpLE,V4nozDpLE,V4goodChLE,V4inStimLE);

V4vSumLE = sqrt(V4rcdLE(:,1).^2 + V4rcdLE(:,2).^2 + V4rcdLE(:,3).^2);
V4comPermLE = GlassCenterOfTriplotMass_permutations(V4conDpLE,V4radDpLE,V4nozDpLE);


V4goodChRE = V4data.conRadRE.goodCh;
V4inStimRE = V4data.conRadRE.inStim;

V4conDpRE = V4data.conRadRE.conBlankDprime;
V4radDpRE = V4data.conRadRE.radBlankDprime;
V4nozDpRE = V4data.conRadRE.noiseBlankDprime;

V4rcdRE = getGlassDprimeVectTriplots(V4radDpRE,V4conDpRE,V4nozDpRE,V4goodChRE,V4inStimRE);

V4vSumRE = sqrt(V4rcdRE(:,1).^2 + V4rcdRE(:,2).^2 + V4rcdRE(:,3).^2);
V4comPermRE = GlassCenterOfTriplotMass_permutations(V4conDpRE,V4radDpRE,V4nozDpRE);
%%
V1goodChLE = V1data.conRadLE.goodCh;
V1inStimLE = V1data.conRadLE.inStim;

V1conDpLE = V1data.conRadLE.conBlankDprime;
V1radDpLE = V1data.conRadLE.radBlankDprime;
V1nozDpLE = V1data.conRadLE.noiseBlankDprime;

V1rcdLE = getGlassDprimeVectTriplots(V1radDpLE,V1conDpLE,V1nozDpLE,V1goodChLE,V1inStimLE);

V1vSumLE = sqrt(V1rcdLE(:,1).^2 + V1rcdLE(:,2).^2 + V1rcdLE(:,3).^2);
V1comPermLE = GlassCenterOfTriplotMass_permutations(V1conDpLE,V1radDpLE,V1nozDpLE);


V1goodChRE = V1data.conRadRE.goodCh;
V1inStimRE = V1data.conRadRE.inStim;
V1conDpRE = V1data.conRadRE.conBlankDprime;
V1radDpRE = V1data.conRadRE.radBlankDprime;
V1nozDpRE = V1data.conRadRE.noiseBlankDprime;

V1rcdRE = getGlassDprimeVectTriplots(V1radDpRE,V1conDpRE,V1nozDpRE,V1goodChRE,V1inStimRE);

V1vSumRE = sqrt(V1rcdRE(:,1).^2 + V1rcdRE(:,2).^2 + V1rcdRE(:,3).^2);
V1comPermRE = GlassCenterOfTriplotMass_permutations(V1conDpRE,V1radDpRE,V1nozDpRE);

%%
figure(1)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')
s = suptitle(sprintf('%s real vs permuted center of mass',V1data.conRadRE.animal));
s.FontSize = 18;
s.Position(2) = s.Position(2)+0.25;
clf

subplot(2,2,1)
hold on
V1comRealLE = triplotter_centerMass(V1rcdLE,V1vSumLE,[1,0,0]);
cmap = zeros(size(V1comPermLE,1),3)+0.5;
triplotter_Glass_noCBar(V1comPermLE,cmap);


subplot(2,2,2)
hold on
V1comRealRE = triplotter_centerMass(V1rcdRE,V1vSumRE,[1,0,0]);
cmap = zeros(size(V1comPermRE,1),3)+0.5;
triplotter_Glass_noCBar(V1comPermRE,cmap);


subplot(2,2,3)
hold on
V4comRealLE = triplotter_centerMass(V4rcdLE,V4vSumLE,[1,0,0]);
cmap = zeros(size(V4comPermLE,1),3)+0.5;
triplotter_Glass_noCBar(V4comPermLE,cmap);


subplot(2,2,4)
hold on
V4comRealRE = triplotter_centerMass(V4rcdRE,V4vSumRE,[1,0,0]);
cmap = zeros(size(V4comPermRE,1),3)+0.5;
triplotter_Glass_noCBar(V4comPermRE,cmap);

%%

figure(2)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 600]);
set(gcf,'PaperOrientation','landscape')

s = subplot(2,2,1);
hold on
comPermDist = mean(V1comPermLE,2);
comRealDist = squeeze(mean(V1comRealLE,2));

permMax = max(comPermDist); permMin = min(comPermDist);
xMax = max(abs([comRealDist,permMax,permMin]));
xlim([-xMax xMax])
title(sprintf('%s LE V1 ',V4data.conRadLE.animal),'FontSize',18)

histogram(comPermDist,12,'FaceColor',[0 0.5 0.1],'EdgeColor','w','Normalization','probability');
plot([comRealDist,comRealDist],[0 0.6],'-r','LineWidth',1)
set(gca,'box','off','tickdir','out','layer','top');
s.Position(3) = s.Position(3) - 0.03;
s.Position(4) = s.Position(4) + 0.03;

s = subplot(2,2,2);
hold on
comPermDist = mean(V1comPermRE,2);
comRealDist = squeeze(mean(V1comRealRE,2));

permMax = max(comPermDist); permMin = min(comPermDist);
xMax = max(abs([comRealDist,permMax,permMin]));

xlim([-xMax xMax])
title(sprintf('%s RE V1 ',V4data.conRadLE.animal),'FontSize',18)
histogram(comPermDist,12,'FaceColor',[0 0.5 0.1],'EdgeColor','w','Normalization','probability');
plot([comRealDist,comRealDist],[0 0.6],'-r','LineWidth',1)
set(gca,'box','off','tickdir','out','layer','top');
s.Position(3) = s.Position(3) - 0.03;
s.Position(4) = s.Position(4) + 0.03;


s = subplot(2,2,3);
hold on
comPermDist = mean(V4comPermLE,2);
comRealDist = squeeze(mean(V4comRealLE,2));

permMax = max(comPermDist); permMin = min(comPermDist);
xMax = max(abs([comRealDist,permMax,permMin]));

xlim([-xMax xMax])
title(sprintf('%s LE V4 ',V4data.conRadLE.animal),'FontSize',18)
histogram(comPermDist,12,'FaceColor',[0 0.5 0.1],'EdgeColor','w','Normalization','probability');
plot([comRealDist,comRealDist],[0 0.6],'-r','LineWidth',1)
set(gca,'box','off','tickdir','out','layer','top');
s.Position(3) = s.Position(3) - 0.03;
s.Position(4) = s.Position(4) + 0.03;

s = subplot(2,2,4);
hold on
comPermDist = mean(V4comPermRE,2);
comRealDist = squeeze(mean(V4comRealRE,2));

permMax = max(comPermDist); permMin = min(comPermDist);
xMax = max(abs([comRealDist,permMax,permMin]));

xlim([-xMax xMax])
title(sprintf('%s RE V4 ',V4data.conRadLE.animal),'FontSize',18)
histogram(comPermDist,12,'FaceColor',[0 0.5 0.1],'EdgeColor','w','Normalization','probability');
plot([comRealDist,comRealDist],[0 0.6],'-r','LineWidth',1)
set(gca,'box','off','tickdir','out','layer','top');
s.Position(3) = s.Position(3) - 0.03;
s.Position(4) = s.Position(4) + 0.03;

%% 

