function plotMaxDprimeDist(LEdata, REdata)
fprintf ('\n*** %s RE %s ***\n',REdata.animal, REdata.array)
dPRE = REdata.stimCircDprime;
dPRE(REdata.stimCircDprimeSig == 0) = 0;
absDP = abs(dPRE);
% for each channel, get the max d' for each RF that is significant 
maxDpAllRFre = squeeze(max(absDP,[],2));
sumMaxRE = sum(maxDpAllRFre);
sum0re = find((sumMaxRE == 0));
maxDpAllRFre(:,sum0re) = [];

% for each channel, find which of the significant d' RF is the highest
[highDpRE, highRFre] = max(maxDpAllRFre,[],1);

% get a count of how many channels have the max for each RF.
rf4RE = sum(highRFre == 1);
rf8RE = sum(highRFre == 2);
rf16RE = sum(highRFre == 3);

fprintf('%d ch with RF4 as highest d''\n',rf4RE)
fprintf('%d ch with RF8 as highest d''\n',rf8RE)
fprintf('%d ch with RF16 as highest d''\n',rf16RE)

% make these into %ages
rf4RE = (rf4RE/length(highRFre))*100;
rf8RE = (rf8RE/length(highRFre))*100;
rf16RE = (rf16RE/length(highRFre))*100;

dPLE = LEdata.stimCircDprime;
dPLE(LEdata.stimCircDprimeSig == 0) = 0;
absDP = abs(dPLE);
% for each channel, get the max d' for each RF that is significant 
maxDpAllRFle = squeeze(max(absDP,[],2));
sumMaxLE = sum(maxDpAllRFle);
sum0le = find((sumMaxLE == 0));
maxDpAllRFle(:,sum0le) = [];

% for each channel, find which of the significant d' RF is the highest
[highDpLE, highRFle] = max(maxDpAllRFle,[],1);

% get a count of how many channels have the max for each RF.
rf4LE = sum(highRFle == 1);
rf8LE = sum(highRFle == 2);
rf16LE = sum(highRFle == 3);
fprintf ('\n*** %s LE %s ***\n',REdata.animal, REdata.array)
fprintf('%d ch with RF4 as highest d''\n',rf4LE)
fprintf('%d ch with RF8 as highest d''\n',rf8LE)
fprintf('%d ch with RF16 as highest d''\n',rf16LE)
% make these into %ages
rf4LE = (rf4LE/length(highRFle))*100;
rf8LE = (rf8LE/length(highRFle))*100;
rf16LE = (rf16LE/length(highRFle))*100;
%% plot 
if contains(LEdata.animal,'XT')
    if contains(LEdata.array,'V4')
        subplot(2,3,4)
        ylabel('% channels with significant tuning','HorizontalAlignment','left');
        text(-2.5, 30, 'V4','FontAngle','italic','FontWeight','bold')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,1)
        title('XT')
        text(-2.5, 30, 'V1/V2','FontAngle','italic','FontWeight','bold')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'Layer','top','XTickLabel',{'', '', ''},'YTick',0:30:60)
    end
elseif contains(LEdata.animal,'WU')
    if contains(LEdata.array,'V4')
        subplot(2,3,5)
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,2)
        title('WU')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'Layer','top','XTickLabel',{'', '', ''},'YTick',0:30:60)
    end
elseif contains(LEdata.animal,'WV')
    if contains(LEdata.array,'V4')
        subplot(2,3,6)
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'XTickLabel',{'RF4','RF8','RF16'},'Layer','top','XTickLabelRotation',45,'YTick',0:30:60)
    else
        subplot(2,3,3)
        title('WV')
        set(gca,'TickDir','out','FontAngle','italic','FontSize',18,...
            'XTick',[0.75,2,3.25],'Layer','top','XTickLabel',{'', '', ''},'YTick',0:30:60)
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

bar(1,rf4RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(2.25,rf8RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)
bar(3.5,rf16RE,'FaceColor','r','EdgeColor','k','BarWidth',0.5)

text(0, 65,sprintf('n %d',length(highRFle)),'Color','b','FontWeight','bold','FontSize',18)
text(1, 65,sprintf('n %d',length(highRFre)),'Color','r','FontWeight','bold','FontSize',18)

ylim([0 70])
xlim([-0.5 4.5])