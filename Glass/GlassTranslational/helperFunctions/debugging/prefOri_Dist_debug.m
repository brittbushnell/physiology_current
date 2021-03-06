clc
for i = 1%:4
    numGood = i-1;
    figure(1)
    clf
     
    SIGood = squeeze(data.LE.OSI2thetaNoiseSig(end,:,:,data.LE.goodCh == 1));
    silA = sum(SIGood,1);
    silA = squeeze(sum(silA,2));
     
    SIL = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,:,:,silA>numGood)));
    SIL = reshape(SIL,[1,numel(SIL)]);
    SIL(isnan(SIL)) = [];
    cirMu = circ_mean(SIL(:));
    cirMu2 = cirMu+pi;
    
    subplot(1,1,1,polaraxes)
    hold on
    
   p1 = polarhistogram(SIL,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w');
    polarhistogram(SIL+pi,'BinWidth',pi/6,'normalization','probability','FaceColor','b','EdgeColor','w')    
    
    polarplot([cirMu 0 cirMu2],[1.5 0 1.5],'b-','LineWidth',.75)
    polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])
    ax = gca;
    ax.RLim = [0,0.5];
    
    text(cirMu+0.2,0.4,sprintf('mean: %.1f degrees',rad2deg(cirMu)),'FontSize',11)
    text(cirMu2+0.2,0.4,sprintf('mean: %.1f degrees',rad2deg(cirMu2)),'FontSize',11)
    title(sprintf('%s FE, channels with at least 1 configuration with significant tuning',data.LE.animal))



%% using pdf normalization
clc
for i = 1%:4
    numGood = i-1;
    figure(2)
    clf
     
    SIGood = squeeze(data.LE.OSI2thetaNoiseSig(end,:,:,data.LE.goodCh == 1));
    silA = sum(SIGood,1);
    silA = squeeze(sum(silA,2));
     
    SIL = deg2rad(squeeze(data.LE.prefOri2thetaNoise(end,:,:,silA>numGood)));
    SIL = reshape(SIL,[1,numel(SIL)]);
    SIL(isnan(SIL)) = [];
    cirMu = circ_mean(SIL(:));
    cirMu2 = cirMu+pi;
    
    subplot(1,1,1,polaraxes)
    hold on
    
   p1 = polarhistogram(SIL,'BinWidth',pi/6,'normalization','pdf','FaceColor','b','EdgeColor','w');
    polarhistogram(SIL+pi,'BinWidth',pi/6,'normalization','pdf','FaceColor','b','EdgeColor','w')    
    
    polarplot([cirMu 0 cirMu2],[1.5 0 1.5],'b-','LineWidth',.75)
    polarplot([1.57 0 4.71],[1.5 0 1.5],'-','color',[0.4 0.4 0.4])
    
    
%     a = 0:0.025:0.25;
%     rTks = round(sqrt(a),2);
%     set(gca,'RTick',rTks);
    ax = gca;
    ax.RLim = [0,0.5];
    
    text(cirMu+0.2,0.4,sprintf('mean: %.1f degrees',rad2deg(cirMu)),'FontSize',11)
    text(cirMu2+0.2,0.4,sprintf('mean: %.1f degrees',rad2deg(cirMu2)),'FontSize',11)
    title(sprintf('%s FE, channels with at least 1 configuration with significant tuning',data.LE.animal))

end