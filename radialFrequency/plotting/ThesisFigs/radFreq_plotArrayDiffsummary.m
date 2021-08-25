function radFreq_plotArrayDiffsummary
%% median IODs

% rows: rf 4,8,16. columns: v1 medians v4 medians, significance 
XTleMedArraydP = [0.35 0.36 0.37; 0.67 0.61 0.58; 1 1 1];
XTleMedArrayCor = [0.36 0.48 0.43; 0.77 0.73 0.68; 1 1 1];

XTreMedArraydP = [0.34 0.40 0.35; 0.72 0.68 0.58; 1 1 1];
XTreMedArrayCor = [0.09 0.11 0.19; 0.78 0.80 0.72; 1 1 1];

WUleMedArraydP = [0.39 0.54 0.56; 0.88 0.91 0.66; 1 1 1];
WUleMedArrayCor = [0.47 0.71 0.71; 0.84 0.85 0.82; 1 1 1];

WUreMedArraydP = [0.41 0.44 0.43; 0.58 0.52 0.51; 1 1 0];
WUreMedArrayCor = [0.57 0.71 0.79; 0.76 0.63 0.68; 1 0 1];

WVleMedArraydP = [0.37 0.43 0.46; 0.54 0.69 0.68; 1 1 1];
WVleMedArrayCor = [0.15 0.51 0.51; 0.47 0.72 0.71; 1 1 1];

WVreMedArraydP = [0.39 0.45 0.39; 0.49 0.63 0.41; 1 1 0];
WVreMedArrayCor = [0.32 0.45 0.34; 0.61 0.72 0.61; 1 1 1];
%%
rfColors = [0.7 0 0.7; 1 0.5 0.1; 0 0.6 0.2];

figure(4)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 500, 500],'PaperSize',[7.5 4.75])
s = suptitle('Differences between V1/V2 and V4');
s.Position(2) = s.Position(2) + 0.035;

subplot(2,2,1)
hold on

ylim([0 1])
xlim([0 1])
t = title('LE/RE d''');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:);
    if XTleMedArraydP(3,i) == 1
        s1 = scatter(XTleMedArraydP(1,i),XTleMedArraydP(2,i),75,'s','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6);
    else
        scatter(XTleMedArraydP(1,i),XTleMedArraydP(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WUleMedArraydP(3,i) == 1
        s2 = scatter(WUleMedArraydP(1,i),WUleMedArraydP(2,i),75,'^','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6);
    else
        scatter(WUleMedArraydP(1,i),WUleMedArraydP(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WVleMedArraydP(3,i) == 1
        s3 = scatter(WVleMedArraydP(1,i),WVleMedArraydP(2,i),70,'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6);
    else
        scatter(WVleMedArraydP(1,i),WVleMedArraydP(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end 
end
l = legend([s1 s2 s3],'Control','A1','A2','Location','southeast');
l.Box = 'off';
l.FontSize = 10;

% xlabel('V1/V2')  
ylabel('V4')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,2)
hold on

ylim([0 1])
xlim([0 1])
t = title('RE/AE d''');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:);
    if XTreMedArraydP(3,i) == 1
        scatter(XTreMedArraydP(1,i),XTreMedArraydP(2,i),75,'s','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(XTreMedArraydP(1,i),XTreMedArraydP(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WUreMedArraydP(3,i) == 1
        scatter(WUreMedArraydP(1,i),WUreMedArraydP(2,i),75,'^','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WUreMedArraydP(1,i),WUreMedArraydP(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WVreMedArraydP(3,i) == 1
        scatter(WVreMedArraydP(1,i),WVreMedArraydP(2,i),70,'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WVreMedArraydP(1,i),WVreMedArraydP(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
end

set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,3)
hold on

ylim([0 1])
xlim([0 1])
t = title('LE/FE correlation');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:);
    if XTreMedArrayCor(3,i) == 1
        scatter(XTreMedArrayCor(1,i),XTreMedArrayCor(2,i),75,'s','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(XTreMedArrayCor(1,i),XTreMedArrayCor(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WUreMedArrayCor(3,i) == 1
        scatter(WUreMedArrayCor(1,i),WUreMedArrayCor(2,i),75,'^','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WUreMedArrayCor(1,i),WUreMedArrayCor(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WVreMedArrayCor(3,i) == 1
        scatter(WVreMedArrayCor(1,i),WVreMedArrayCor(2,i),70,'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WVreMedArrayCor(1,i),WVreMedArrayCor(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
end

xlabel('V1/V2')  
ylabel('V4')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,4)
hold on

ylim([0 1])
xlim([0 1])
t = title('RE/AE correlation');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:);
    if XTleMedArrayCor(3,i) == 1
        scatter(XTleMedArrayCor(1,i),XTleMedArrayCor(2,i),65,'s','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(XTleMedArrayCor(1,i),XTleMedArrayCor(2,i),60,'s','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WUleMedArrayCor(3,i) == 1
        scatter(WUleMedArrayCor(1,i),WUleMedArrayCor(2,i),60,'^','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WUleMedArrayCor(1,i),WUleMedArrayCor(2,i),55,'^','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
    if WVleMedArrayCor(3,i) == 1
        scatter(WVleMedArrayCor(1,i),WVleMedArrayCor(2,i),60,'v','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    else
        scatter(WVleMedArrayCor(1,i),WVleMedArrayCor(2,i),55,'v','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.6)
    end
    
end

xlabel('V1/V2')  
% ylabel('V4')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)
%%
figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/diffSummaries';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['arrayDiffSummary','.pdf'];
set(gcf,'InvertHardcopy','off','Color','w')
print(gcf, figName,'-dpdf','-bestfit')