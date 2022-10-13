function [rf4LE, rf8LE,rf16LE,rf4RE, rf8RE,rf16RE ] = plotNumChsPref1RF(LEdata,REdata)
%%
sigRFpChLE = LEdata.RFcorrSigPerms;
ch1sigRFLE = find(LEdata.numRFsSigHighAmp == 1);

rf4LE = 0;
rf8LE = 0;
rf16LE = 0;

for i = 1:length(ch1sigRFLE)
    ch = ch1sigRFLE(i);
    sigRF = find(squeeze(sigRFpChLE(:,ch)) == 1);
    
    if sigRF == 1
        rf4LE = rf4LE+1;
    elseif sigRF == 2
        rf8LE = rf8LE+1;
    else
        rf16LE = rf16LE+1;
    end
end

rf4LE = (rf4LE/length(ch1sigRFLE))*100;
rf8LE = (rf8LE/length(ch1sigRFLE))*100;
rf16LE = (rf16LE/length(ch1sigRFLE))*100;
%%
sigRFpChRE = REdata.RFcorrSigPerms;
ch1sigRFRE = find(REdata.numRFsSigHighAmp == 1);

rf4RE = 0;
rf8RE = 0;
rf16RE = 0;

for i = 1:length(ch1sigRFRE)
    ch = ch1sigRFRE(i);
    sigRF = find(squeeze(sigRFpChRE(:,ch)) == 1);
    
    if sigRF == 1
        rf4RE = rf4RE+1;
    elseif sigRF == 2
        rf8RE = rf8RE+1;
    else
        rf16RE = rf16RE+1;
    end
end

rf4RE = (rf4RE/length(ch1sigRFRE))*100;
rf8RE = (rf8RE/length(ch1sigRFRE))*100;
rf16RE = (rf16RE/length(ch1sigRFRE))*100;

%%

if contains(LEdata.animal,'XT')
    if contains(LEdata.array,'V4')
        subplot(2,3,4)
        ylabel('% channels that only respond to 1 RF','HorizontalAlignment','left');
        text(-2.5, 30, 'V4','FontAngle','italic','FontWeight','bold')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,1)
        title('XT')
        text(-2.5, 30, 'V1/V2','FontAngle','italic','FontWeight','bold')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'Layer','top','YTick',0:30:60,'XTickLabel',{'', '', ''})
    end
elseif contains(LEdata.animal,'WU')
    if contains(LEdata.array,'V4')
        subplot(2,3,5)
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,2)
        title('WU')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'Layer','top','YTick',0:30:60,'XTickLabel',{'', '', ''})
    end
elseif contains(LEdata.animal,'WV')
    if contains(LEdata.array,'V4')
        subplot(2,3,6)
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,3)
        title('WV')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',14,...
            'XTick',[0.75,2,3.25],'Layer','top','YTick',0:30:60,'XTickLabel',{'', '', ''})
    end
end

gax = get(gca,'Position');
gax(3) = 0.25;
gax(4) = 0.2;
set(gca,'Position',gax)

axis tight

hold on

bar(0.5,rf4LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)
bar(1.75,rf8LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)
bar(3,rf16LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)

bar(1,rf8RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(2.25,rf8RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(3.5,rf16RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)



ylim([0 60])
 xlim([-0.5 4.5])




