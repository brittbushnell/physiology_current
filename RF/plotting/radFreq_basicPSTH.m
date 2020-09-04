function [] = radFreq_basicPSTH(data)
% input LEdata, REdata.

figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((nanmean(squeeze(data.bins((data.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((nanmean(squeeze(data.bins((data.radius~=100),1:35,ch)),1)./.010),'Color',[0 0.7 0.3],'LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
        annotation('textbox',...
            [0.37 0.94 0.4 0.038],...
            'String',sprintf('LE PSTH raw data %s',date),...
            'FontWeight','bold',...
            'FontSize',16,...
            'FontAngle','italic',...
            'EdgeColor','none');
    end    
end