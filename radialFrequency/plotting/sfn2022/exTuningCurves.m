figDir = '~/Dropbox/posters/SfN/2022/figures/Radial/tuning/';
if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)

REdata = WVV4RE; LEdata = WVV4LE;
REdPrime =  REdata.stimCircDprime;
LEdPrime =  LEdata.stimCircDprime;
xs = 0:6;

chs = [12 51];% 34];

figure(8)
clf

pos = get(gcf,'Position');
set(gcf,'Position',[pos(1), pos(2), 950, 900],...
    'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6.5 6],'Color','w')


for i = 1:length(chs)
    ch = chs(i);
    
    rfAmpsLE = nan(3,6);
    dpChLE = squeeze(LEdPrime(:,:,ch));
    
    for rf = 1:3
        rfT = squeeze(dpChLE(rf,:));
        rfAmpsLE(rf,:) = rfT;
        dpZeroAnch = [0, rfT];
    end %rf
    
    rfAmpsRE = nan(3,6);
    dpChRE = squeeze(REdPrime(:,:,ch));
    
    for rf = 1:3
        rfT = squeeze(dpChRE(rf,:));
        rfAmpsRE(rf,:) = rfT;
        dpZeroAnch = [0, rfT];
    end %rf
    
    LEdMax = max(rfAmpsLE,[],'all');
    REdMax = max(rfAmpsRE,[],'all');
    dMax = max([LEdMax,REdMax]);
    dMax = dMax+dMax/5;
    
    LEdMin = min(rfAmpsLE,[],'all');
    REdMin = min(rfAmpsRE,[],'all');
    dMin = min([LEdMin,REdMin]);
    dMin = dMin+dMin/5;
    
    sp = subplot(2,length(chs),i);
    sp.Position(3) = 0.3;
    sp.Position(4) = sp.Position(4);
    
    hold on
    axis square
    
    ylim([dMin,dMax])
    if i == 1
        ti = title({sprintf('ch %d',ch); 'prefers circles'},'FontWeight','normal');
    else
        title({sprintf('ch %d',ch); 'prefers high amplitudes'},'FontWeight','normal')
    end
    ix1 = 2:0.5:7;
    rf4 = squeeze(rfAmpsLE(1,:));
    smooth4 = pchip(2:7,rf4,ix1);
    rf8 = squeeze(rfAmpsLE(2,:));
    smooth8 = pchip(2:7,rf8,ix1);
    rf16 = squeeze(rfAmpsLE(3,:));
    smooth16 = pchip(2:7,rf16,ix1);
    
    plot([-0.5 7.5],[0 0],':k')
    
    %     plot(ix1,smooth4,'Color',[0.7 0 0.7 0.7],'LineWidth',1.25)
    %     plot(ix1,smooth8,'Color',[1 0.5 0.1 0.7],'LineWidth',1.25)
    %     plot(ix1,smooth16,'Color',[0 0.6 0.2 0.7],'LineWidth',1.25)
    
    plot(2:7,rf4,'-o','Color',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerSize',7)
    plot(2:7,rf8,'-o','Color',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor','w','MarkerSize',7)
    plot(2:7,rf16,'-o','Color',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerSize',7)
    plot(0,0,'o','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',7)
    
    xlim([-0.5 7.5])
    %     set(gca,'XTick',1:7,'XTickLabel',0:6,'tickdir','out','FontAngle','italic','FontSize',18)
    set(gca,'XTick',0:7,'XTickLabel',0:7,'tickdir','out','FontAngle','italic','FontSize',18)
    if i == 1
        text(-3,-1.25,'Fellow eye','FontSize',24,'Rotation',90)
        ylabel('d''','FontSize',20)
    end
    
    sp = subplot(2,length(chs),i+2);
    sp.Position(3) = 0.3;
    sp.Position(4) = sp.Position(4);
    
    hold on
    axis square
    ylim([dMin,dMax])
    ix1 = 2:0.5:7;
    rf4 = squeeze(rfAmpsRE(1,:));
    smooth4 = interp1(2:7,rf4,ix1);
    rf8 = squeeze(rfAmpsRE(2,:));
    smooth8 = interp1(2:7,rf8,ix1);
    rf16 = squeeze(rfAmpsRE(3,:));
    smooth16 = interp1(2:7,rf16,ix1);
    
    plot([-0.5 7.5],[0 0],':k')
    %
    %     plot(ix1,smooth4,'Color',[0.7 0 0.7 0.7],'LineWidth',1.25)
    %     plot(ix1,smooth8,'Color',[1 0.5 0.1 0.7],'LineWidth',1.25)
    %     plot(ix1,smooth16,'Color',[0 0.6 0.2 0.7],'LineWidth',1.25)
    
    plot(2:7,rf4,'-o','Color',[0.7 0 0.7],'MarkerFaceColor',[0.7 0 0.7],'MarkerEdgeColor','w','MarkerSize',7)
    plot(2:7,rf8,'-o','Color',[1 0.5 0.1],'MarkerFaceColor',[1 0.5 0.1],'MarkerEdgeColor','w','MarkerSize',7)
    plot(2:7,rf16,'-o','Color',[0 0.6 0.2],'MarkerFaceColor',[0 0.6 0.2],'MarkerEdgeColor','w','MarkerSize',7)
    plot(0,0,'o','MarkerFaceColor','k','MarkerEdgeColor','w','MarkerSize',7)
    
    xlim([-0.5 7.5])
    set(gca,'XTick',0:7,'XTickLabel',0:7,'tickdir','out','FontSize',18,'FontAngle','italic')
    if i == 1
        text(-3,-1.5,'Amblyopic eye','FontSize',24,'Rotation',90)
        ylabel('d''','FontSize',15,'FontWeight','bold')
        xlabel('modulation amplitude','FontSize',15,'FontWeight','bold')
    end
end

figName = ['WV_V4_exTuning_unfit_2chs','.pdf'];
set(gcf,'PaperOrientation','landscape','InvertHardcopy','off','PaperSize',[6.5 6.5],'Color','w')
 print(figure(8), figName,'-dpdf','-bestfit')