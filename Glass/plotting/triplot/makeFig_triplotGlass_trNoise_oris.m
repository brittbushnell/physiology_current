function makeFig_triplotGlass_trNoise_oris(V1data, V4data)
location = determineComputer;

if location == 1
    figDir =  sprintf('~/bushnell-local/Dropbox/Figures/%s/GlassCombo/triplot/',V1data.conRadRE.animal);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/GlassCombo/triplot/',V1data.conRadRE.animal);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%% get the input matrices for each eye and array
for i = 1:4
    V1dataRE = getGlassDprimeNoiseVectTriplots_oneOri(V1data.conRadRE.radNoiseDprime, V1data.conRadRE.conNoiseDprime, V1data.trRE.linNoiseDprime,i,...
        (V1data.conRadRE.goodCh & V1data.trRE.goodCh), (V1data.conRadRE.inStim & V1data.trRE.inStim));
    
    V1dataLE  = getGlassDprimeNoiseVectTriplots_oneOri(V1data.conRadLE.radNoiseDprime, V1data.conRadLE.conNoiseDprime, V1data.trLE.linNoiseDprime,i,...
        (V1data.conRadLE.goodCh & V1data.trLE.goodCh), (V1data.conRadLE.inStim & V1data.trLE.inStim));
    
    V4dataRE  = getGlassDprimeNoiseVectTriplots_oneOri(V4data.conRadRE.radNoiseDprime, V4data.conRadRE.conNoiseDprime, V4data.trRE.linNoiseDprime,i,...
        (V4data.conRadRE.goodCh & V4data.trRE.goodCh), (V4data.conRadRE.inStim & V4data.trRE.inStim));
    
    V4dataLE  = getGlassDprimeNoiseVectTriplots_oneOri(V4data.conRadLE.radNoiseDprime, V4data.conRadLE.conNoiseDprime, V4data.trLE.linNoiseDprime,i,...
        (V4data.conRadLE.goodCh & V4data.trLE.goodCh), (V4data.conRadLE.inStim & V4data.trLE.inStim));
    
    %% get the color scaling across dt/dx
    
    ndx1 = ones(size(V1dataLE,1),1);
    ndx2 = ones(size(V1dataRE,1),1)+1;
    ndx3 = ones(size(V4dataLE,1),1)+2;
    ndx4 = ones(size(V4dataRE,1),1)+3;
    
    catdps = cat(1,V1dataLE, V1dataRE, V4dataLE, V4dataRE);
    catdps(:,4) = sqrt(catdps(:,1).^2 + catdps(:,2).^2 + catdps(:,3).^2); % vector sum of the responses to radial, concentric, and dipole used to rank order for colormapping
    catdps(:,5) = [ndx1;ndx2;ndx3;ndx4];
    
    [~,sortNdx] = sort(catdps(:,4),'descend');
    sortDps = catdps(sortNdx,:);
    if i == 1
        cmap = brewermap(length(catdps),'blues');
    elseif i == 2
        cmap = brewermap(length(catdps),'greens');
    elseif i == 3
        cmap = brewermap(length(catdps),'purples');
    else
        cmap = brewermap(length(catdps),'reds');
    end
    sortDps(:,6:8) = cmap; % make black be highest, white lowest
    %% break sortDps into smaller matrices for each of the subplots
    v1LEsort{i} = sortDps(sortDps(:,5) == 1,:);
    v1REsort{i} = sortDps(sortDps(:,5) == 2,:);
    v4LEsort{i} = sortDps(sortDps(:,5) == 3,:);
    v4REsort{i} = sortDps(sortDps(:,5) == 4,:);
    
    ors = unique(V1data.trLE.rotation);
    
    % make one figure per orientation
    figure
    hold on
    clf
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 900 700]);
    set(gcf,'PaperOrientation','landscape')
    if i == 1
    s = suptitle(sprintf('%s stimulus vs dipole d'' translational using %d deg (horizontal) only',V1data.conRadLE.animal,ors(i)));
    elseif i == 4
         s = suptitle(sprintf('%s stimulus vs dipole d'' translational using %d deg (vertical) only',V1data.conRadLE.animal,ors(i)));
    else
         s = suptitle(sprintf('%s stimulus vs dipole d'' translational using %d deg only',V1data.conRadLE.animal,ors(i)));
    end
    s.Position(2) = s.Position(2) +0.025;
    s.FontWeight = 'bold';
    s.FontSize = 18;

    s = subplot(2,2,1);
    rct = v1LEsort{i}(:,1:3);
    cmp = v1LEsort{i}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    textm(2,2,sprintf('%d',inRad),'FontSize',12,'FontWeight','bold')
    textm(5,83,sprintf('%d',inCon),'FontSize',12,'FontWeight','bold')
    textm(91,101,sprintf('\n\n %d',inTr),'horizontalalignment','center','FontSize',12,'FontWeight','bold')

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
    rct = v1REsort{i}(:,1:3);
    cmp = v1REsort{i}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    textm(2,2,sprintf('%d',inRad),'FontSize',12,'FontWeight','bold')
    textm(5,83,sprintf('%d',inCon),'FontSize',12,'FontWeight','bold')
    textm(91,101,sprintf('\n\n %d',inTr),'horizontalalignment','center','FontSize',12,'FontWeight','bold')

    if contains(V1data.conRadLE.animal,'XT')
        title(sprintf('RE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)))
    else
        title(sprintf('AE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim  & V1data.trLE.goodCh & V1data.trLE.inStim)))
    end
    clear dps;
    s.Position(1) = s.Position(1) + 0.01;
    s.Position(2) = s.Position(2) - 0.075;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;

    
    s = subplot(2,2,3);
    rct = v4LEsort{i}(:,1:3);
    cmp = v4LEsort{i}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    textm(2,2,sprintf('%d',inRad),'FontSize',12,'FontWeight','bold')
    textm(5,83,sprintf('%d',inCon),'FontSize',12,'FontWeight','bold')
    textm(91,101,sprintf('\n\n %d',inTr),'horizontalalignment','center','FontSize',12,'FontWeight','bold')
    
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
    
    text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')
    
    s = subplot(2,2,4);
    rct = v4REsort{i}(:,1:3);
    cmp = v4REsort{i}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    textm(2,2,sprintf('%d',inRad),'FontSize',12,'FontWeight','bold')
    textm(5,83,sprintf('%d',inCon),'FontSize',12,'FontWeight','bold')
    textm(91,101,sprintf('\n\n %d',inTr),'horizontalalignment','center','FontSize',12,'FontWeight','bold')
    
    if contains(V1data.conRadLE.animal,'XT')
        title(sprintf('RE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim & V1data.trLE.goodCh & V1data.trLE.inStim)))
    else
        title(sprintf('AE n: %d',sum(V1data.conRadLE.goodCh & V1data.conRadLE.inStim  & V1data.trLE.goodCh & V1data.trLE.inStim)))
    end
    clear dps;
    s.Position(1) = s.Position(1) + 0.01;
    s.Position(2) = s.Position(2) - 0.075;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    ax = gca;
    colormap(ax,cmap);
    c2 = colorbar(ax,'Position',[0.91 0.31 0.0178 0.37]);
    c2.TickDirection = 'out';
    c2.Ticks = 0:0.25:1;
    c2.FontAngle = 'italic';
    c2.FontSize = 12;
    c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
    c2.Label.String = 'Vector sum of dPrimes';
    c2.Label.FontSize = 14;
    %%
    figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_',num2str(ors(i))];
    set(gca,'color','none')
    print(gcf, figName,'-dpdf','-bestfit')
end
%%
figure (24)
hold on
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1) pos(2) 900 700]);
set(gcf,'PaperOrientation','landscape')

s = suptitle(sprintf('%s stimulus vs dipole d'' with each orientation',V1data.conRadLE.animal));
s.Position(2) = s.Position(2) +0.025;
s.FontWeight = 'bold';
s.FontSize = 18;

s = subplot(2,2,1);
hold on
text(0.5,1,'color key','FontWeight','bold','FontSize',14)
text(1.1,1,'0','color','b','FontWeight','bold','FontSize',14)
text(1.2,1,'45','color',[0 0.6 0.2],'FontWeight','bold','FontSize',14)
text(1.4,1,'90','color',[0.6 0 0.6],'FontWeight','bold','FontSize',14)
text(1.6,1,'135','color',[0.7 0 0],'FontWeight','bold','FontSize',14)
for o = 1:4
    rct = v1LEsort{o}(:,1:3);
    cmp = v1LEsort{o}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    if o == 1
        textm(2,1,sprintf('%d',inRad),'FontSize',12,'Color','b','FontWeight','bold')
        textm(2,83,sprintf('%d',inCon),'FontSize',12,'Color','b','FontWeight','bold')
        textm(91,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color','b','FontWeight','bold')
    elseif o == 2
        textm(2,8,sprintf('%d',inRad),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(3,78,sprintf('%d',inCon),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(84,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
    elseif o == 3
        textm(2,15,sprintf('%d',inRad),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(3,71,sprintf('%d',inCon),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(78,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
    else
        textm(2,22,sprintf('%d',inRad),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(3,64,sprintf('%d',inCon),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(70,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
    end
    
end
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
for o = 1:4
    rct = v1REsort{o}(:,1:3);
    cmp = v1REsort{o}(:,6:8);
    [~,V1REmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    if o == 1
        textm(2,1,sprintf('%d',inRad),'FontSize',12,'Color','b','FontWeight','bold')
        textm(2,83,sprintf('%d',inCon),'FontSize',12,'Color','b','FontWeight','bold')
        textm(91,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color','b','FontWeight','bold')
    elseif o == 2
        textm(2,8,sprintf('%d',inRad),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(3,78,sprintf('%d',inCon),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(84,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
    elseif o == 3
        textm(2,15,sprintf('%d',inRad),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(3,71,sprintf('%d',inCon),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(78,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
    else
        textm(2,22,sprintf('%d',inRad),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(3,64,sprintf('%d',inCon),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(70,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
    end
    
end
if contains(V1data.conRadRE.animal,'XT')
    title(sprintf('RE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1data.trRE.goodCh & V1data.trRE.inStim)))
else
    title(sprintf('AE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim  & V1data.trRE.goodCh & V1data.trRE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;



s = subplot(2,2,3);
hold on
for o = 1:4
    rct = v4LEsort{o}(:,1:3);
    cmp = v4LEsort{o}(:,6:8);
    [~,V1LEmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    if o == 1
        textm(2,1,sprintf('%d',inRad),'FontSize',12,'Color','b','FontWeight','bold')
        textm(2,83,sprintf('%d',inCon),'FontSize',12,'Color','b','FontWeight','bold')
        textm(91,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color','b','FontWeight','bold')
    elseif o == 2
        textm(2,8,sprintf('%d',inRad),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(3,78,sprintf('%d',inCon),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(84,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
    elseif o == 3
        textm(2,15,sprintf('%d',inRad),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(3,71,sprintf('%d',inCon),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(78,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
    else
        textm(2,22,sprintf('%d',inRad),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(3,64,sprintf('%d',inCon),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(70,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
    end
    
end
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

text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')


s = subplot(2,2,4);
hold on
for o = 1:4
    rct = v4REsort{o}(:,1:3);
    cmp = v4REsort{o}(:,6:8);
    [~,V1REmax] = max(rct,[],2);
    [inRad,inCon,inTr] = triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    
    textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
    textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
    textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
    
    if o == 1
        textm(2,1,sprintf('%d',inRad),'FontSize',12,'Color','b','FontWeight','bold')
        textm(2,83,sprintf('%d',inCon),'FontSize',12,'Color','b','FontWeight','bold')
        textm(91,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color','b','FontWeight','bold')
    elseif o == 2
        textm(2,8,sprintf('%d',inRad),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(3,78,sprintf('%d',inCon),'FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
        textm(84,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0 0.6 0.2],'FontWeight','bold')
    elseif o == 3
        textm(2,15,sprintf('%d',inRad),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(3,71,sprintf('%d',inCon),'FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
        textm(78,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.6 0 0.6],'FontWeight','bold')
    else
        textm(2,22,sprintf('%d',inRad),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(3,64,sprintf('%d',inCon),'FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
        textm(70,101,sprintf('%d',inTr),'horizontalalignment','center','FontSize',12,'Color',[0.7 0 0],'FontWeight','bold')
    end
    
end
if contains(V1data.conRadRE.animal,'XT')
    title(sprintf('RE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim & V1data.trRE.goodCh & V1data.trRE.inStim)))
else
    title(sprintf('AE n: %d',sum(V1data.conRadRE.goodCh & V1data.conRadRE.inStim  & V1data.trRE.goodCh & V1data.trRE.inStim)))
end
clear dps;
s.Position(1) = s.Position(1) + 0.01;
s.Position(2) = s.Position(2) - 0.075;
s.Position(3) = s.Position(3) + 0.02;
s.Position(4) = s.Position(4) + 0.02;


%%
figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_allOris'];
set(gca,'color','none')
print(gcf, figName,'-dpdf','-bestfit')



