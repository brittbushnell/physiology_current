function makeFig_triplotGlass_Noise_coh(V1data, V4data)
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

oris = unique(V1data.trLE.rotation);
%% get the input matrices for each eye and array using mean orientation
for orNdx = 1:4
    figure
    hold on
    pos = get(gcf,'Position');
    set(gcf,'Position',[pos(1) pos(2) 900 700]);
    set(gcf,'PaperOrientation','landscape')
    
    %s = suptitle(sprintf('%s stimulus vs dipole d'' %d%% coherence',V1data.conRadLE.animal,cohs(cohNdx)*100));
    s = suptitle(sprintf('%s stimulus vs dipole d'' %d%c at all coherences',V1data.conRadLE.animal,oris(orNdx),char(176)));
    s.Position(2) = s.Position(2) +0.025;
    s.FontWeight = 'bold';
    s.FontSize = 18;
    for cohNdx = 1:4
        V4dataRE  = getGlassDprimeNoiseVectTriplots_Ori_coh(V4data,'RE',cohNdx,orNdx);
        V4dataLE  = getGlassDprimeNoiseVectTriplots_Ori_coh(V4data,'LE',cohNdx,orNdx);
        
        V1dataRE  = getGlassDprimeNoiseVectTriplots_Ori_coh(V1data,'RE',cohNdx,orNdx);
        V1dataLE  = getGlassDprimeNoiseVectTriplots_Ori_coh(V1data,'LE',cohNdx,orNdx);
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
        
        if cohNdx == 1
            cmap = brewermap(size(catdps,1),'Blues');
        elseif cohNdx == 2
            cmap = brewermap(size(catdps,1),'Greens');
        elseif cohNdx == 3
            cmap = brewermap(size(catdps,1),'Purples');
        else
            cmap = brewermap(size(catdps,1),'Reds');
        end
        sortDps(:,6:8) = cmap; % make black be highest, white lowest
        %% break sortDps into smaller matrices for each of the subplots
        v1LEsort{cohNdx} = sortDps(sortDps(:,5) == 1,:);
        v1REsort{cohNdx} = sortDps(sortDps(:,5) == 2,:);
        v4LEsort{cohNdx} = sortDps(sortDps(:,5) == 3,:);
        v4REsort{cohNdx} = sortDps(sortDps(:,5) == 4,:);
    end
    %% plot
    s = subplot(2,2,1);
    hold on
    for i = 1:4
        rct = v1LEsort{i}(:,1:3);
        if i == 1
            cmp = zeros(size(rct));
            cmp(:,3) = 1;
        elseif i == 2
            cmp = zeros(size(rct));
            cmp(:,2) = 0.6;
            cmp(:,3) = 0.2;
        elseif i == 3
            cmp = zeros(size(rct));
            cmp(:,1) = 0.6;
            cmp(:,3) = 0.6;
        elseif i == 4
            cmp = zeros(size(rct));
            cmp(:,1) = 0.85;
        end
        triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    end
    title(sprintf('FE %d ch',size(rct,1)))
    
    text(-1,-0.8,'Radial','horizontalalignment','left','FontSize',13);
    text(1,-0.8,'Concentric','FontSize',13,'horizontalalignment','right');
    text(0,0.9,'Translational','FontSize',13,'horizontalalignment','center');
    
    text(1.1,1,'25%','color','b','FontWeight','bold','FontSize',14)
    text(1.4,1,'50%','color',[0 0.6 0.2],'FontWeight','bold','FontSize',14)
    text(1.7,1,'75%','color',[0.6 0 0.6],'FontWeight','bold','FontSize',14)
    text(2,1,'100%','color',[0.85 0 0],'FontWeight','bold','FontSize',14)
    
    s.Position(1) = s.Position(1) + 0.01;
    s.Position(2) = s.Position(2) - 0.075;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    
    text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')
    %%
    s = subplot(2,2,2);
    hold on
    for i = 1:4
        rct = v1REsort{i}(:,1:3);
        if i == 1
            cmp = zeros(size(rct));
            cmp(:,3) = 1;
        elseif i == 2
            cmp = zeros(size(rct));
            cmp(:,2) = 0.6;
            cmp(:,3) = 0.2;
        elseif i == 3
            cmp = zeros(size(rct));
            cmp(:,1) = 0.6;
            cmp(:,3) = 0.6;
        elseif i == 4
            cmp = zeros(size(rct));
            cmp(:,1) = 0.85;
        end
        triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    end
    title(sprintf('AE %d ch',size(rct,1)))
    text(-1,-0.8,'Radial','horizontalalignment','left','FontSize',13);
    text(1,-0.8,'Concentric','FontSize',13,'horizontalalignment','right');
    text(0,0.9,'Translational','FontSize',13,'horizontalalignment','center');
    
    s.Position(1) = s.Position(1) - 0.03;
    s.Position(2) = s.Position(2) - 0.075;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    
    s = subplot(2,2,3);
    hold on
    for i = 1:4
        rct = v4LEsort{i}(:,1:3);
        if i == 1
            cmp = zeros(size(rct));
            cmp(:,3) = 1;
        elseif i == 2
            cmp = zeros(size(rct));
            cmp(:,2) = 0.6;
            cmp(:,3) = 0.2;
        elseif i == 3
            cmp = zeros(size(rct));
            cmp(:,1) = 0.6;
            cmp(:,3) = 0.6;
        elseif i == 4
            cmp = zeros(size(rct));
            cmp(:,1) = 0.85;
        end
        triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    end
    title(sprintf('FE %d ch',size(rct,1)))
    text(-1,-0.8,'Radial','horizontalalignment','left','FontSize',13);
    text(1,-0.8,'Concentric','FontSize',13,'horizontalalignment','right');
    text(0,0.9,'Translational','FontSize',13,'horizontalalignment','center');
    s.Position(1) = s.Position(1) + 0.01;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')
    
    s = subplot(2,2,4);
    hold on
    for i = 1:4
        rct = v4REsort{i}(:,1:3);
        if i == 1
            cmp = zeros(size(rct));
            cmp(:,3) = 1;
        elseif i == 2
            cmp = zeros(size(rct));
            cmp(:,2) = 0.6;
            cmp(:,3) = 0.2;
        elseif i == 3
            cmp = zeros(size(rct));
            cmp(:,1) = 0.6;
            cmp(:,3) = 0.6;
        elseif i == 4
            cmp = zeros(size(rct));
            cmp(:,1) = 0.85;
        end
        triplotter_GlassWithTr_noCBar_oneOri(rct,cmp);
    end
    title(sprintf('AE %d ch',size(rct,1)))
    text(-1,-0.8,'Radial','horizontalalignment','left','FontSize',13);
    text(1,-0.8,'Concentric','FontSize',13,'horizontalalignment','right');
    text(0,0.9,'Translational','FontSize',13,'horizontalalignment','center');
    s.Position(1) = s.Position(1) - 0.03;
    s.Position(3) = s.Position(3) + 0.02;
    s.Position(4) = s.Position(4) + 0.02;
    
    %     colormap(ax,(cmap));
    %     c2 = colorbar(ax,'Position',[0.9 0.31 0.0178 0.37]);
    %     c2.TickDirection = 'out';
    %     c2.Ticks = 0:0.25:1;
    %     c2.FontAngle = 'italic';
    %     c2.FontSize = 12;
    %     c2.TickLabels = round(linspace(0,sortDps(1,4),5),1);
    %     c2.Label.String = 'Vector sum of dPrimes';
    %     c2.Label.FontSize = 14;
    %%
    figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_',num2str(oris(orNdx)),'deg_allCoh'];
    set(gca,'color','none')
    print(gcf, figName,'-dpdf','-bestfit')
end
%%
% cmap1 = brewermap(4,'set1');
% mkSize = 9;
%
% figure
% pos = get(gcf,'Position');
% set(gcf,'Position',[pos(1) pos(2) 900 700]);
% set(gcf,'PaperOrientation','landscape')
%
% s = suptitle(sprintf('%s center of mass across coherences',V1data.conRadLE.animal));
% s.Position(2) = s.Position(2) +0.025;
% s.FontWeight = 'bold';
% s.FontSize = 18;
%
% s = subplot(2,2,1);
% hold on
% for c = 1:size(v1LEcom,1)
%     triplotter_1Point(v1LEcom(c,:),cmap1(c,:),mkSize);
% end
%
% title('FE','FontSize',14)
%
% textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
% textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
% textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
%
% text(-1.5,0.1,'V1','FontSize',22,'FontWeight','bold')
%
% text(1.15,1.2,'color key','FontWeight','bold','FontSize',14)
% text(1.1,1,'25%','color',cmap1(1,:),'FontWeight','bold','FontSize',14)
% text(1.5,1,'50%','color',cmap1(2,:),'FontWeight','bold','FontSize',14)
% text(1.1,0.8,'75%','color',cmap1(3,:),'FontWeight','bold','FontSize',14)
% text(1.5,0.8,'100%','color',cmap1(4,:),'FontWeight','bold','FontSize',14)
%
% s = subplot(2,2,2);
% hold on
% for c = 1:size(v1REcom,1)
%     triplotter_1Point(v1REcom(c,:),cmap1(c,:),mkSize);
% end
%
% title('AE','FontSize',14)
%
% textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
% textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
% textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
%
%
% s = subplot(2,2,3);
% hold on
% for c = 1:size(v4LEcom,1)
%     triplotter_1Point(v4LEcom(c,:),cmap1(c,:),mkSize);
% end
% if contains(V4data.conRadLE.animal,'XT')
%     title('LE','FontSize',14)
% else
%     title('FE','FontSize',14)
% end
% textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
% textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
% textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
%
% text(-1.5,0.1,'V4','FontSize',22,'FontWeight','bold')
%
% s = subplot(2,2,4);
% hold on
% for c = 1:size(v4REcom,1)
%     triplotter_1Point(v4REcom(c,:),cmap1(c,:),mkSize);
% end
% if contains(V4data.conRadLE.animal,'XT')
%     title('LE','FontSize',14)
% else
%     title('FE','FontSize',14)
% end
% textm(0,0,sprintf('\n\nRadial    '),'horizontalalignment','left','FontSize',13);
% textm(0,90,sprintf('\n\n\n      Concentric'),'FontSize',13,'horizontalalignment','right');
% textm(90,90,sprintf('Translational\n\n'),'FontSize',13,'horizontalalignment','center');
% clear dps;
% s.Position(1) = s.Position(1) + 0.01;
% s.Position(2) = s.Position(2) - 0.075;
% s.Position(3) = s.Position(3) + 0.02;
% s.Position(4) = s.Position(4) + 0.02;
% %%
% figName = [V1data.conRadLE.animal,'_BE_bothArrays_triplot_coh_cmass',num2str(cohs(cohNdx)*100)];
% set(gca,'color','none')
% print(gcf, figName,'-dpdf','-bestfit')