function [dpPval,dpSigPerms,corrPval,corrSigPerms, maxDpPopDiff,maxDpChDiff,corrChDiff,corrPopDiff, corrSigCh] = radFreq_highSFvslowSFdPandCorr(highSFdata,lowSFdata,numBoot)
% only including channels that are significant in both high and low SF
% programs

%%
highSFdPrimes = highSFdata.stimCircDprime;
lowSFdPrimes = lowSFdata.stimCircDprime;

maxDpPopDiff = nan(3,numBoot);
maxDpChDiff = nan(3,96,numBoot);

highMaxDp = nan(3,96,numBoot);
lowMaxDp = nan(3,96,numBoot);

highCorrBoot = nan(3,96,numBoot);
lowCorrBoot = nan(3,96,numBoot);

corrChDiff = nan(3,96,numBoot);
corrPopDiff = nan(3,numBoot);
%%
for rf = 1:3
    for ch = 1:96
        if highSFdata.goodCh(ch) && lowSFdata.goodCh(ch)
            highDp = squeeze(highSFdPrimes(rf,:,ch));
            lowDp = squeeze(lowSFdPrimes(rf,:,ch));
            
            for nb = 1:numBoot
                highPermAmp = nan(1,6);
                lowPermAmp = nan(1,6);
                
                for amp = 1:6
                    highAmp = datasample(highDp(amp),1);
                    lowAmp = datasample(lowDp(amp),1);
                    
                    randOrder = randperm(2);
                    
                    if randOrder(1) == 1
                        highPermAmp(1,amp) = highAmp;
                    else
                        highPermAmp(1,amp) = lowAmp;
                    end
                    
                    if randOrder(2) == 1
                        lowPermAmp(1,amp) = highAmp;
                    else
                        lowPermAmp(1,amp) = lowAmp;
                    end
                    
                    clear highAmp lowAmp randOrder
                end %amp
                
                highDt = max(abs(highPermAmp));
                lowDt = max(abs(lowPermAmp));
                
                highMaxDp(rf,ch,nb) = highDt;
                lowMaxDp(rf,ch,nb) = lowDt;
                
                highZed = [0, highPermAmp];
                highCorMtx = corrcoef(0:6,highZed);
                highCorrBoot(rf,ch,nb) = highCorMtx(2);
                
                lowZed = [0, lowPermAmp];
                lowCorMtx = corrcoef(0:6,lowZed);
                lowCorrBoot(rf,ch,nb) = lowCorMtx(2);
                
                maxDpChDiff(rf,ch,nb) = highDt - lowDt;
                corrChDiff(rf,ch,nb) = highCorMtx(2) - lowCorMtx(2);
                
                clear highDt lowDt highPermAmp lowPermAmp highZed lowZed highCorMtx lowCorMtx
            end %bootstrap
        end
    end %ch
    maxDpPopDiff(rf,:) = (nanmedian(squeeze(highMaxDp(rf,:,:)))) - (nanmedian(squeeze(lowMaxDp(rf,:,:))));
    corrPopDiff(rf,:) = nanmedian(squeeze(highCorrBoot(rf,:,:))) - nanmedian(squeeze(lowCorrBoot(rf,:,:)));
end %rf
%% do permutation test on full population
highMaxCh = nan(3,96);
lowMaxCh = nan(3,96);

for ch = 1:96
    for rf = 1:3
        highMaxCh(rf,ch) = max(abs(highSFdata.stimCircDprime(rf,:,ch)));
        lowMaxCh(rf,ch) = max(abs(lowSFdata.stimCircDprime(rf,:,ch)));
    end
end

% median of maximum d' across channels
highRealDp = nanmedian(highMaxCh,2);
lowRealDp = nanmedian(lowMaxCh,2);

% median correlation across channels
highRealCor = nanmedian(squeeze(highSFdata.stimCorrs(:,:)),2);
lowRealCor = nanmedian(squeeze(lowSFdata.stimCorrs(:,:)),2);

trueDp = highRealDp - lowRealDp;

highCorr = highRealCor;
lowCorr = lowRealCor;
trueCorr = highCorr - lowCorr;

dpPval = nan(3,1);
dpSigPerms = nan(3,1);
corrPval = nan(3,1);
corrSigPerms = nan(3,1);


for i = 1:3
    %% d'
    
    dPdiff = squeeze(maxDpPopDiff(i,:));
    
    high = find(dPdiff >trueDp(i,1));
    pV = round(((length(high)+1)/(length(dPdiff )+1)),3);
    
    if pV > 0.5
        pV = 1-pV;
    end
    
    dpPval(i,1) = pV;
    
    if  pV <= 0.05
        dpSigPerms(i,1) = 1;
    else
        dpSigPerms(i,1) = 0;
    end
    clear pV
    %% correlations
    corrs = squeeze(corrPopDiff(i,:));
    
    high = find(corrs>trueCorr(i,1));
    pV = round(((length(high)+1)/(length(corrs)+1)),3);
    
    if pV > 0.5
        pV = 1-pV;
    end
    
    corrPval(i,1) = pV;
    
    if  pV <= 0.05
        corrSigPerms(i,1) = 1;
    else
        corrSigPerms(i,1) = 0;
    end
    clear pV
end
%% plot full population distributions and p-values
a = max(abs(maxDpPopDiff),[],'all');
b = max(abs(corrPopDiff),[],'all');

c = max(abs(trueDp));
d = max(abs(trueCorr));

xMaxD = max([a c])+0.15;
xMaxC = max([b d])+0.15;

figure%(3)
clf

s = suptitle(sprintf('%s %s %s population differences in medians between high and low SF',highSFdata.animal, highSFdata.array, highSFdata.eye));
s.Position(2) = s.Position(2)+0.026;

subplot(3,2,1)
hold on
title('RF4 max d'' differences')
histogram(squeeze(maxDpPopDiff(1,:)),'Normalization','probability','BinWidth',0.025)
plot([trueDp(1), trueDp(1)], [0 0.45],'k-')
text(trueDp(1)+0.01,0.445, sprintf('%.2f',trueDp(1)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-xMaxD xMaxD])

if dpSigPerms(1) == 1
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f*',dpPval(1)),'FontWeight','bold')
else
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f',dpPval(1)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')

subplot(3,2,3)
hold on
title('RF8 max d'' differences')
histogram(squeeze(maxDpPopDiff(2,:)),'Normalization','probability','BinWidth',0.025)
plot([trueDp(2), trueDp(2)], [0 0.45],'k-')
text(trueDp(2)+0.01,0.445, sprintf('%.2f',trueDp(2)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-xMaxD xMaxD])

if dpSigPerms(2) == 1
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f*',dpPval(2)),'FontWeight','bold')
else
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f',dpPval(2)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')

subplot(3,2,5)
hold on
title('RF16 max d'' differences')
histogram(squeeze(maxDpPopDiff(3,:)),'Normalization','probability','BinWidth',0.025)
plot([trueDp(3), trueDp(3)], [0 0.45],'k-')
text(trueDp(3)+0.01,0.445, sprintf('%.2f',trueDp(3)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-xMaxD xMaxD])
ylabel('probability')
xlabel('Permuted difference in max d''')

if dpSigPerms(3) == 1
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f*',dpPval(3)),'FontWeight','bold')
else
    text(-xMaxD+0.02,0.55,sprintf('p = %.2f',dpPval(3)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')

subplot(3,2,2)
hold on
title('RF4 correlation differences')
histogram(squeeze(corrPopDiff(1,:)),'Normalization','probability','BinWidth',0.025)
plot([trueCorr(1), trueCorr(1)], [0 0.45],'k-')
text(trueCorr(1)+0.01,0.445, sprintf('%.2f',trueCorr(1)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-1 1])

if corrSigPerms(1) == 1
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f*',corrPval(1)),'FontWeight','bold')
else
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f',corrPval(1)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')


subplot(3,2,4)
hold on
title('RF8 correlation differences')
histogram(squeeze(corrPopDiff(2,:)),'Normalization','probability','BinWidth',0.025)
plot([trueCorr(2), trueCorr(2)], [0 0.45],'k-')
text(trueCorr(2)+0.01,0.445, sprintf('%.2f',trueCorr(2)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-1 1])

if corrSigPerms(2) == 1
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f*',corrPval(2)),'FontWeight','bold')
else
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f',corrPval(2)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')


subplot(3,2,6)
hold on
title('RF16 correlation differences')
histogram(squeeze(corrPopDiff(3,:)),'Normalization','probability','BinWidth',0.025)
plot([trueCorr(3), trueCorr(3)], [0 0.45],'k-')
text(trueCorr(3)+0.01,0.445, sprintf('%.2f',trueCorr(3)),'FontSize',10,'FontAngle','italic')
ylim([0 0.6])
xlim([-1 1])
xlabel('Permuted difference in correlation')

if corrSigPerms(3) == 1
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f*',corrPval(3)),'FontWeight','bold')
else
    text(-xMaxC+0.02,0.55,sprintf('p = %.2f',corrPval(3)))
end
set(gca,'box','off','tickdir','out','FontAngle','italic')
%%
location = determineComputer;

if location == 1
    figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',highSFdata.animal,highSFdata.array);
elseif location == 0
    figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',highSFdata.animal,highSFdata.array);
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)


figName = [lowSFdata.animal,'_',lowSFdata.array,'_RadFreq_DistPermSFdiff','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%% permutation test and plotting of each channel
% for this one, only need to see if there's a significant difference for
% correlation, not d'.
corrSigCh = nan(3,96);
corrPval = nan(3,96);
trueCorrDiff = nan(3,96);
rfs = [4 8 16];

for ch = 1:96
    figure(3)
    clf
    
    s = suptitle(sprintf('%s %s %s population differences in correlations between high and low SF ch %d',highSFdata.animal, highSFdata.array, highSFdata.eye, ch));
    s.Position(2) = s.Position(2)+0.026;
    
    xMaxC = max(abs(corrChDiff),[],'all');
    
    
    for i = 1:3
        
        permCorrDiff = squeeze(corrChDiff(i,ch,:));
        permCorrDiff(isnan(permCorrDiff)) = [];
        
        trueHigh = squeeze(highSFdata.stimCorrs(i,ch));
        trueLow = squeeze(lowSFdata.stimCorrs(i,ch));
        trueCorrDiff(i,ch) = trueHigh - trueLow;
        
        high = find(permCorrDiff >trueCorrDiff(i,ch));
        pV = round(((length(high)+1)/(length(permCorrDiff )+1)),3);
        
        if pV > 0.5
            pV = 1-pV;
        end
        
        corrPval(i,ch) = pV;
        
        if  pV <= 0.05
            corrSigCh(i,ch) = 1;
        else
            corrSigCh(i,ch) = 0;
        end
        clear pV

        subplot(3,1,i)
        hold on
        title(sprintf('RF%d correlation differences',rfs(i)))
        histogram(permCorrDiff,'Normalization','probability','BinWidth',0.1)
        plot([trueCorrDiff(i,ch), trueCorrDiff(i,ch)], [0 0.45],'k-')
        text(trueCorrDiff(i,ch)+0.01, 0.25, sprintf('%.2f',trueCorrDiff(i,ch)),'FontSize',10,'FontAngle','italic','FontWeight','normal')
        ylim([0 0.3])
        xlim([-xMaxC xMaxC])
        
        if corrSigCh(i,ch) == 1
            text(-xMaxC+0.02, 0.28, sprintf('p = %.2f*', corrPval(i,ch)), 'FontWeight', 'bold')
        else
            text(-xMaxC+0.02, 0.28, sprintf('p = %.2f', corrPval(i,ch)))
        end
        set(gca,'box','off','tickdir','out','FontAngle','italic')
        
        clear permCorrDiff
    end
    %%
    location = determineComputer;
    
    if location == 1
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/SFperm/Ch',highSFdata.animal,highSFdata.array);
    elseif location == 0
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/SFperm/Ch',highSFdata.animal,highSFdata.array);
    end
    
    if ~exist(figDir,'dir')
        mkdir(figDir)
    end
    cd(figDir)
    
    
%     figName = [lowSFdata.animal,'_',lowSFdata.array,'_RadFreq_DistPermSFdiff_ch',num2str(ch),'.pdf'];
%     print(gcf, figName,'-dpdf','-bestfit')
end
%
figName = [highSFdata.animal,'_', highSFdata.eye,'_',highSFdata.array,'_',highSFdata.programID,'_dPrimeVsCorr_SF','.pdf'];
plotRadFreq_DprimeVsCorr_sig(highSFdata,lowSFdata,'high SF','low SF', corrSigPerms, dpSigPerms, figName)