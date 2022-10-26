function [rf4LE, rf8LE,rf16LE,rf4RE, rf8RE,rf16RE ] = plotNumChsPrefRFcorrs(LEdata,REdata)
%%
sigRFpChLE = LEdata.RFcorrSigPerms;

sigRFLE = sum(sigRFpChLE,2);

rf4LE = (sigRFLE(1)/length(sigRFpChLE))*100;
rf8LE = (sigRFLE(2)/length(sigRFpChLE))*100;
rf16LE = (sigRFLE(3)/length(sigRFpChLE))*100;
%%
sigRFpChRE = REdata.RFcorrSigPerms;

sigRFRE = sum(sigRFpChRE,2);

rf4RE = (sigRFRE(1)/length(sigRFpChRE))*100;
rf8RE = (sigRFRE(2)/length(sigRFpChRE))*100;
rf16RE = (sigRFRE(3)/length(sigRFpChRE))*100;
%%

if contains(LEdata.animal,'XT')
    if contains(LEdata.array,'V4')
        subplot(2,3,4)
        ylabel('% channels with significant tuning','HorizontalAlignment','left');
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
%%


bar(0.5,rf4LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)
bar(1.75,rf8LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)
bar(3,rf16LE,'FaceColor','b','EdgeColor','k','BarWidth',0.5)

bar(1,rf8RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(2.25,rf8RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(3.5,rf16RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)



ylim([0 60])
xlim([-0.5 4.5])
