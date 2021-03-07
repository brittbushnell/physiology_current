function makeFig_triplotGlass_Noise_coh_sigOnly(V1data, V4data)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/triplot/coh/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/triplot/coh/',V1data.conRadRE.animal);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%

cohs = unique(V1data.trLE.coh);
cohs(cohs == -1) = []; cohs(cohs == 100) = []; cohs(cohs == 0) = [];
numCoh = length(cohs); % coh -1 = disk fade coh 100 = blank
%% get the input matrices for each eye and array using mean orientation
for i = 1:numCoh
    sigCh = 
    V1dataRE  = getGlassDprimeNoiseVectTriplots_meanOri_coh(V1data.conRadRE.radNoiseDprime, V1data.conRadRE.conNoiseDprime, V1data.trRE.linNoiseDprime,...
        (V1data.conRadRE.goodCh & V1data.trRE.goodCh), (V1data.conRadRE.inStim & V1data.trRE.inStim),i);
    
    V1dataLE  = getGlassDprimeNoiseVectTriplots_meanOri_coh(V1data.conRadLE.radNoiseDprime, V1data.conRadLE.conNoiseDprime, V1data.trLE.linNoiseDprime,...
        (V1data.conRadLE.goodCh & V1data.trLE.goodCh), (V1data.conRadLE.inStim & V1data.trLE.inStim),i);
    
    V4dataRE  = getGlassDprimeNoiseVectTriplots_meanOri_coh(V4data.conRadRE.radNoiseDprime, V4data.conRadRE.conNoiseDprime, V4data.trRE.linNoiseDprime,...
        (V4data.conRadRE.goodCh & V4data.trRE.goodCh), (V4data.conRadRE.inStim & V4data.trRE.inStim),i);
    
    V4dataLE  = getGlassDprimeNoiseVectTriplots_meanOri_coh(V4data.conRadLE.radNoiseDprime, V4data.conRadLE.conNoiseDprime, V4data.trLE.linNoiseDprime,...
        (V4data.conRadLE.goodCh & V4data.trLE.goodCh), (V4data.conRadLE.inStim & V4data.trLE.inStim),i);
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
    %% plot
    figure
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 900 700]);
    set(gcf,'PaperOrientation','landscape')
    
    s = suptitle(sprintf('%s stimulus vs dipole d'' mean orientation %d%% coherence sig channels 100% vs dipole',V1data.conRadLE.animal,cohs(i)*100));
    s.Position(2) = s.Position(2) +0.025;
    s.FontWeight = 'bold';
    s.FontSize = 18;
    
    s = subplot(2,2,1);
    hold on
    rct = v1LEsort(:,1:3);
    cmp = v1LEsort(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    triplotter_GlassWithTr_noCBar(rct,cmp);
    v1LEcom(i,:) = triplotter_centerMass(rct,v1LEsort(:,4),[1 0 0]);
    
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
    v1REcom(i,:) = triplotter_centerMass(rct,v1REsort(:,4),[1 0 0]);
    
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
    
    s = subplot(2,2,3);
    hold on
    rct = v4LEsort(:,1:3);
    cmp = v4LEsort(:,6:8);
    [~,V4LEmax] = max(rct,[],2);
    triplotter_GlassWithTr_noCBar(rct,cmp);
    v4LEcom(i,:) = triplotter_centerMass(rct,v4LEsort(:,4),[1 0 0]);
    
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
    v4REcom(i,:) = triplotter_centerMass(rct,v4REsort(:,4),[1 0 0]);
    
    if contains(V1data.conRadLE.animal,'XT')
        title(sprintf('RE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
    else
        title(sprintf('AE n: %d',sum(V4data.conRadRE.goodCh & V4data.conRadRE.inStim)))
    end
    s.Position(1) = s.Position(1) - 0.03;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    
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
    figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_meanOri_coh_sigOnly',num2str(cohs(i)*100)];
    set(gca,'color','none')
    print(gcf, figName,'-dpdf','-bestfit')
    
end
%%
cmap1 = brewermap(4,'set1');
mkSize = 9;

figure
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s center of mass across coherences sig channels 100% vs dipole',V1data.conRadLE.animal));
s.Position(2) = s.Position(2) +0.025;
s.FontWeight = 'bold';
s.FontSize = 18;

s = subplot(2,2,1);
hold on
for c = 1:size(v1LEcom,1)
    triplotter_1Point(v1LEcom(c,:),cmap1(c,:),mkSize);
end

title('FE','FontSize',14)

textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')

text(1.15,1.2,'color key','FontWeight','bold','FontSize',14)
text(1.1,1,'25%','color',cmap1(1,:),'FontWeight','bold','FontSize',14)
text(1.5,1,'50%','color',cmap1(2,:),'FontWeight','bold','FontSize',14)
text(1.1,0.8,'75%','color',cmap1(3,:),'FontWeight','bold','FontSize',14)
text(1.5,0.8,'100%','color',cmap1(4,:),'FontWeight','bold','FontSize',14)

s = subplot(2,2,2);
hold on
for c = 1:size(v1REcom,1)
    triplotter_1Point(v1REcom(c,:),cmap1(c,:),mkSize);
end

title('AE','FontSize',14)

textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;


s = subplot(2,2,3);
hold on
for c = 1:size(v4LEcom,1)
    triplotter_1Point(v4LEcom(c,:),cmap1(c,:),mkSize);
end
if contains(V4data.conRadLE.animal,'XT')
    title('LE','FontSize',14)
else
    title('FE','FontSize',14)
end
textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;

text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')

s = subplot(2,2,4);
hold on
for c = 1:size(v4REcom,1)
    triplotter_1Point(v4REcom(c,:),cmap1(c,:),mkSize);
end
if contains(V4data.conRadLE.animal,'XT')
    title('LE','FontSize',14)
else
    title('FE','FontSize',14)
end
textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;
%%
figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_coh_cmass_sigOnly',num2str(cohs(i)*100)];
set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')