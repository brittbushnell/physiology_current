function [dpPval,dpSigPerms,corrPval,corrSigPerms, maxDpPopDiff,maxDpChDiff,corrChDiff,corrPopDiff] = radFreq_V1vsV4dPrimeCorr(V1dataT,V4dataT,numBoot)


%%
V1dPrimes = V1dataT.stimCircDprime;
V4dPrimes = V4dataT.stimCircDprime;

maxDpPopDiff = nan(3,numBoot);
maxDpChDiff = nan(3,96,numBoot);

V1maxDp = nan(3,96,numBoot);
V4maxDp = nan(3,96,numBoot);

V1corrBoot = nan(3,96,numBoot);
V4corrBoot = nan(3,96,numBoot);

corrChDiff = nan(3,96,numBoot);
corrPopDiff = nan(3,numBoot);
%%
for rf = 1:3
    for ch = 1:96
        V1dP = squeeze(V1dPrimes(rf,:,ch));
        V4dP = squeeze(V4dPrimes(rf,:,ch));
        
        for nb = 1:numBoot
            V1permAmp = nan(1,6);
            V4permAmp = nan(1,6);
            
            for amp = 1:6
                V1amp = datasample(V1dP(amp),1);
                V4amp = datasample(V4dP(amp),1);
                
                randOrder = randperm(2);
                
                if randOrder(1) == 1
                    V1permAmp(1,amp) = V1amp;
                else
                    V1permAmp(1,amp) = V4amp;
                end
                
                if randOrder(2) == 1
                    V4permAmp(1,amp) = V1amp;
                else
                    V4permAmp(1,amp) = V4amp;
                end
                
                clear V1amp V4amp randOrder
            end %amp
            
            V1dT = max(abs(V1permAmp));
            V4dT = max(abs(V4permAmp));
            
            V1maxDp(rf,ch,nb) = V1dT;
            V4maxDp(rf,ch,nb) = V4dT;
            
            V1zed = [0, V1permAmp];
            V1corMtx = corrcoef(0:6,V1zed);
            V1corrBoot(rf,ch,nb) = V1corMtx(2);
            
            V4zed = [0, V4permAmp];
            V4corMtx = corrcoef(0:6,V4zed);
            V4corrBoot(rf,ch,nb) = V4corMtx(2);
            
            maxDpChDiff(rf,ch,nb) = V1dT - V4dT;
            corrChDiff(rf,ch,nb) = V1corMtx(2) - V4corMtx(2);
            
            clear V1dT V4dT V1permAmp V4permAmp V1zed V4zed V1corMtx V4corMtx
        end %bootstrap
    end %ch
    maxDpPopDiff(rf,:) = (nanmedian(squeeze(V1maxDp(rf,:,:)))) - (nanmedian(squeeze(V4maxDp(rf,:,:))));
    corrPopDiff(rf,:) = nanmedian(squeeze(V1corrBoot(rf,:,:))) - nanmedian(squeeze(V4corrBoot(rf,:,:)));
end %rf
%% do permutation test
V1maxCh = nan(3,96);
V4maxCh = nan(3,96);

for ch = 1:96
    for rf = 1:3
        V1maxCh(rf,ch) = max(abs(V1dataT.stimCircDprime(rf,:,ch)));
        V4maxCh(rf,ch) = max(abs(V4dataT.stimCircDprime(rf,:,ch)));
    end
end
% median of maximum d' across channels
V1realDp = nanmedian(V1maxCh,2);
V4realDp = nanmedian(V4maxCh,2);

% median correlation across channels
V1realCor = nanmedian(squeeze(V1dataT.stimCorrs(:,:)),2);
V4realCor = nanmedian(squeeze(V4dataT.stimCorrs(:,:)),2);

trueDp = V1realDp - V4realDp;

V1corr = V1realCor;
V4corr = V4realCor;
trueCorr = V1corr - V4corr;

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
%%
a = max(abs(maxDpPopDiff),[],'all');
b = max(abs(corrPopDiff),[],'all');

c = max(abs(trueDp));
d = max(abs(trueCorr));

xMaxD = max([a c])+0.15;
xMaxC = max([b d])+0.15;

figure%(3)
clf
if contains(V1dataT.animal,'XT')
    s = suptitle(sprintf('%s %s population differences in medians between V1 and V4',V1dataT.animal, V1dataT.array));
else
    s = suptitle(sprintf('%s %s population differences in medians between V1 and V4',V1dataT.animal, V1dataT.array));
end
s.Position(2) = s.Position(2)+0.026;

subplot(3,2,1)
hold on
title('RF4 max d'' differences')
histogram(squeeze(maxDpPopDiff(1,:)),'Normalization','probability','BinWidth',0.025)
plot([trueDp(1), trueDp(1)], [0 0.45],'k-')
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
ylim([0 0.6])
xlim([-xMaxC xMaxC])

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
ylim([0 0.6])
xlim([-xMaxC xMaxC])

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
ylim([0 0.6])
xlim([-xMaxC xMaxC])
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
    if contains(V1dataT.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',V1dataT.animal,V1dataT.array);
    elseif contains(V1dataT.animal,'XT')
        if contains(V1dataT.programID,'low','IgnoreCase',true)
            if contains(V1dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',V1dataT.animal,V1dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',V1dataT.animal,V1dataT.array);
            end
        else
            if contains(V1dataT.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',V1dataT.animal,V1dataT.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',V1dataT.animal,V1dataT.array);
            end
        end
    else
        if contains(V1dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',V1dataT.animal,V1dataT.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',V1dataT.animal,V1dataT.array);
        end
    end
elseif location == 0
    if contains(V1dataT.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',V1dataT.animal,V1dataT.array);
    elseif contains(V1dataT.animal,'XT')
        if contains(V1dataT.programID,'low','IgnoreCase',true)
            if contains(V1dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',V1dataT.animal,V1dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',V1dataT.animal,V1dataT.array);
            end
        else
            if contains(V1dataT.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',V1dataT.animal,V1dataT.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',V1dataT.animal,V1dataT.array);
            end
        end
    else
        if contains(V1dataT.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',V1dataT.animal,V1dataT.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',V1dataT.animal,V1dataT.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)


figName = [V4dataT.animal,'_',V4dataT.programID,'_DistPermV1vsV4','.pdf'];
% print(gcf, figName,'-dpdf','-bestfit')
%%
figName = [V4dataT.animal,'_',V4dataT.eye,'_',V4dataT.programID,'_dPrimeVsCorr_xArrays','.pdf'];
plotRadFreq_DprimeVsCorr_sig(V1dataT,V4dataT,'V1/V2','V4', corrSigPerms, dpSigPerms, figName)
