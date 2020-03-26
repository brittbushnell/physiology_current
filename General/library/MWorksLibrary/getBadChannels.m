% function [goodCh] = getBadChannels(stimulus, blank)

filename = 'XT_RE_mapNoise_nsp1_Oct2018';
data = load(filename);

figure;
for ch = 1:96
    subplot(10,10,ch);
    hold on;
    plot((mean(squeeze(REdata.bins((REdata.radius==100),1:35,ch)),1)./.010),'k','LineWidth',2);
    plot((mean(squeeze(REdata.bins((REdata.radius~=100),1:35,ch)),1)./.010),'r','LineWidth',2);
    
    title(ch)
    set(gca,'Color','none','XColor','none')
    ylim([0 inf])
    if ch == 1
    annotation('textbox',...
        [0.37 0.94 0.4 0.038],...
        'String',sprintf('RE PSTH raw data %s',date),...
        'FontWeight','bold',...
        'FontSize',16,...
        'FontAngle','italic',...
        'EdgeColor','none');
    end

end
%% define good channels
goodCh = ones(1,96);

% V1 lowSF
badCh = [];%[1 4 7 8 9 10 11 12 13 14 15 19 23 24 26 27 28 229 31 33 34 35 36 37 39 40 41 42 44 45 48 49 52 53 54 56 58 59 61 62 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 80 8182 83 84 86 90];
%%
for badC = 1:length(badCh)
    goodCh(badCh(badC)) = 0;
end