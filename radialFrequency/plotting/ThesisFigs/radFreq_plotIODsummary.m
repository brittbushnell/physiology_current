function radFreq_plotIODsummary%(XTV4LE, XTV4RE, XTV1LE, XTV1RE, WUV4LE, WUV4RE, WUV1LE, WUV1RE, WVV4LE, WVV4RE, WVV1LE, WVV1RE)
%% median IODs

% columns: rf 4,8,16. rows: LE medians RE medians, significance 
XTv1MedIODdP = [0.35 0.36 0.37; 0.34 0.40 0.35; 0 1 0];
XTv1MedIODcor = [0.36 0.48 0.43; 0.09 0.11 0.19; 1 1 1];

XTv4MedIODdP = [0.67 0.61 0.58; 0.72 0.68 0.58; 0 0 0];
XTv4MedIODcor = [0.77 0.73 0.68; 0.78 0.8 0.72; 0 1 0];

WUv1MedIODdP = [0.39 0.54 0.56; 0.41 0.44 0.43; 0 1 1];
WUv1MedIODcor = [0.47 0.71 0.71; 0.57 0.71 0.79; 0 0 1];

WUv4MedIODdP = [0.88 0.95 0.70; 0.61 0.54 0.53; 1 1 1];
WUv4MedIODcor = [0.84 0.85 0.82; 0.76 0.63 0.68; 1 1 1];

WVv1MedIODdP = [0.37 0.43 0.46; 0.39 0.45 0.39; 0 0 1];
WVv1MedIODcor = [0.15 0.51 0.51; 0.32 0.45 0.34; 1 0 1];

WVv4MedIODdP = [0.54 0.69 0.68; 0.49 0.63 0.42; 0 0 1];
WVv4MedIODcor = [0.47 0.72 0.71; 0.61 0.72 0.61; 1 0 0];
%%
rfColors = [0.7 0 0.7; 1 0.5 0.1; 0 0.6 0.2];

figure(5)
clf
pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 500, 500],'PaperSize',[7.5 4.75])
s = suptitle('Differences between eyes');
s.Position(2) = s.Position(2) + 0.035;

subplot(2,2,1)
hold on

ylim([0 1])
xlim([0 1])
t = title('V1/V2 d''');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:) ;
    if XTv1MedIODdP(3,i) == 1
        s1 = scatter(XTv1MedIODdP(1,i),XTv1MedIODdP(2,i),75,'s','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(XTv1MedIODdP(1,i),XTv1MedIODdP(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WUv1MedIODdP(3,i) == 1
        s2 = scatter(WUv1MedIODdP(1,i),WUv1MedIODdP(2,i),70,'^','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WUv1MedIODdP(1,i),WUv1MedIODdP(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WVv1MedIODdP(3,i) == 1
        s3 = scatter(WVv1MedIODdP(1,i),WVv1MedIODdP(2,i),70,'v','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WVv1MedIODdP(1,i),WVv1MedIODdP(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end 
end

l = legend([s1 s2 s3],'Control','A1','A2','Location','northwest');
l.Box = 'off';
l.FontSize = 10;

% xlabel('LE/FE')  
ylabel('RE/AE')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,2)
hold on

ylim([0 1])
xlim([0 1])
t = title('V4 d''');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:) ;
    if XTv4MedIODdP(3,i) == 1
        s1 = scatter(XTv4MedIODdP(1,i),XTv4MedIODdP(2,i),75,'s','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(XTv4MedIODdP(1,i),XTv4MedIODdP(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WUv4MedIODdP(3,i) == 1
        s2 = scatter(WUv4MedIODdP(1,i),WUv4MedIODdP(2,i),70,'^','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WUv4MedIODdP(1,i),WUv4MedIODdP(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WVv4MedIODdP(3,i) == 1
        s3 = scatter(WVv4MedIODdP(1,i),WVv4MedIODdP(2,i),70,'v','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WVv4MedIODdP(1,i),WVv4MedIODdP(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end 
end

% xlabel('LE/FE')  
% ylabel('RE/AE')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,3)
hold on

ylim([0 1])
xlim([0 1])
t = title('V1/V2 correlation');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:) ;
    if XTv1MedIODcor(3,i) == 1
        s1 = scatter(XTv1MedIODcor(1,i),XTv1MedIODcor(2,i),75,'s','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(XTv1MedIODcor(1,i),XTv1MedIODcor(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WUv1MedIODcor(3,i) == 1
        s2 = scatter(WUv1MedIODcor(1,i),WUv1MedIODcor(2,i),70,'^','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WUv1MedIODcor(1,i),WUv1MedIODcor(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WVv1MedIODcor(3,i) == 1
        s3 = scatter(WVv1MedIODcor(1,i),WVv1MedIODcor(2,i),70,'v','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WVv1MedIODcor(1,i),WVv1MedIODcor(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end 
end

xlabel('LE/FE')  
ylabel('RE/AE')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)

subplot(2,2,4)
hold on

ylim([0 1])
xlim([0 1])
t = title('V4 correlation');
axis square
plot([0 1], [0 1],':k')

for i = 1:3
    markerColor = rfColors(i,:) ;
    if XTv4MedIODcor(3,i) == 1
        s1 = scatter(XTv4MedIODcor(1,i),XTv4MedIODcor(2,i),75,'s','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(XTv4MedIODcor(1,i),XTv4MedIODcor(2,i),70,'s','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WUv4MedIODcor(3,i) == 1
        s2 = scatter(WUv4MedIODcor(1,i),WUv4MedIODcor(2,i),70,'^','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WUv4MedIODcor(1,i),WUv4MedIODcor(2,i),65,'^','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end
    
    if WVv4MedIODcor(3,i) == 1
        s3 = scatter(WVv4MedIODcor(1,i),WVv4MedIODcor(2,i),70,'v','MarkerFaceColor',markerColor,'MarkerEdgeColor','w','MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7);
    else
        scatter(WVv4MedIODcor(1,i),WVv4MedIODcor(2,i),65,'v','MarkerFaceColor','w','MarkerEdgeColor',markerColor,'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',0.7)
    end 
end

text(0.8, 0.25,'RF4','color',rfColors(1,:),'FontSize',10,'FontWeight','bold')
text(0.8, 0.15,'RF8','color',rfColors(2,:),'FontSize',10,'FontWeight','bold')
text(0.8, 0.05,'RF16','color',rfColors(3,:),'FontSize',10,'FontWeight','bold')

xlabel('LE/FE')  
% ylabel('RE/AE')
set(gca,'tickdir','out','FontAngle','italic','FontSize',10,'FontName','Arial',...     
    'YTick',0:.2:1,'XTick',0:0.2:1)
%%
figDir = '~/Dropbox/Thesis/radialFrequency/Figures/Results/diffSummaries';

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

figName = ['IODsummary','.pdf'];
set(gcf,'InvertHardcopy','off','Color','w')
print(gcf, figName,'-dpdf','-bestfit')