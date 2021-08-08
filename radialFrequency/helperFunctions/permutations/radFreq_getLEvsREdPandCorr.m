function [dpPval,dpSigPerms,corrPval,corrSigPerms, maxDpPopDiff,maxDpChDiff,corrChDiff,corrPopDiff] = radFreq_getLEvsREdPandCorr(LEdata,REdata,numBoot)


%%
LEdPrimes = LEdata.stimCircDprimeBootPerm;
REdPrimes = REdata.stimCircDprimeBootPerm;

maxDpPopDiff = nan(3,numBoot);
maxDpChDiff = nan(3,96,numBoot);

LEmaxDp = nan(3,96,numBoot);
REmaxDp = nan(3,96,numBoot);

LEcorrBoot = nan(3,96,numBoot);
REcorrBoot = nan(3,96,numBoot);

corrChDiff = nan(3,96,numBoot);
corrPopDiff = nan(3,numBoot);

for nb = 1:numBoot
    for ch = 1:96
        for rf = 1:3
            LEdP = squeeze(LEdPrimes(rf,:,ch,:));
            REdP = squeeze(REdPrimes(rf,:,ch,:));
            
            LEuseAmp = nan(1,6);
            REuseAmp = nan(1,6);
            
            for amp = 1:6
                LEuseAmp(1,amp) = datasample(LEdP(amp,:),1);
                REuseAmp(1,amp) = datasample(REdP(amp,:),1);
            end %amp
            
            LEdT = max(abs(LEuseAmp));
            REdT = max(abs(REuseAmp));
            
            LEmaxDp(rf,ch,nb) = LEdT;
            REmaxDp(rf,ch,nb) = REdT;
            
            LEzed = [0, LEuseAmp];
            LEcorMtx = corrcoef(0:6,LEzed);
            LEcorrBoot(rf,ch,nb) = LEcorMtx(2);
            
            REzed = [0, REuseAmp];
            REcorMtx = corrcoef(0:6,REzed);
            REcorrBoot(rf,ch,nb) = REcorMtx(2);
            
            maxDpChDiff(rf,ch,nb) = LEdT - REdT;
            corrChDiff(rf,ch,nb) = LEcorMtx(2) - REcorMtx(2);
            
            clear LEdT REdT LEuseAmp REuseAmp
        end %RF
    end %ch
    for i = 1:3
        maxDpPopDiff(i,nb) = abs(nanmean(squeeze(LEmaxDp(i,:,nb)))) - abs(nanmean(squeeze(REmaxDp(i,:,nb))));
        corrPopDiff(i,nb) = nanmean(squeeze(LEcorrBoot(i,:,nb))) - nanmean(squeeze(REcorrBoot(i,:,nb)));
    end
end %bootstrap
%% do permutation test
for ch = 1:96
    for rf = 1:3
        LEmaxCh(rf,ch) = max(abs(LEdata.stimCircDprime(rf,:,ch)));
        REmaxCh(rf,ch) = max(abs(REdata.stimCircDprime(rf,:,ch)));
    end
end
% mean of maximum d' across channels
LErealDp = nanmean(LEmaxCh,2);
RErealDp = nanmean(REmaxCh,2);

% mean correlation across channels
LErealCor = nanmean(squeeze(LEdata.stimCorrs(:,:)),2);
RErealCor = nanmean(squeeze(REdata.stimCorrs(:,:)),2);

for i = 1:3
    %% d'
    trueDp(i) = LErealDp(i) - RErealDp(i);
    dPdiff = squeeze(maxDpPopDiff(i,:));
    
    high = find(dPdiff >trueDp(i));
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
    LEcorr = LErealCor(i);
    REcorr = RErealCor(i);
    trueCorr(i) = LEcorr - REcorr;
    
    high = find(corrs>trueCorr(i));
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
a = max(maxDpPopDiff,[],'all');
b = max(corrPopDiff,[],'all');

c = max(trueDp);
d = max(trueCorr);

xMaxD = max([a c])+0.05;
xMaxC = max([b d])+0.05;

figure%(3)
clf
if contains(LEdata.animal,'XT')
    s = suptitle(sprintf('%s %s population differences in means between LE and RE',LEdata.animal, LEdata.array));
else
    s = suptitle(sprintf('%s %s population differences in means between FE and AE',LEdata.animal, LEdata.array));
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
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('/users/bushnell/bushnell-local/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
elseif location == 0
    if contains(LEdata.animal,'WU')
        figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/',LEdata.animal,LEdata.array);
    elseif contains(LEdata.animal,'XT')
        if contains(LEdata.programID,'low','IgnoreCase',true)
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        else
            if contains(LEdata.programID,'V4')
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V4locations/%s/stats/',LEdata.animal,LEdata.array);
            else
                figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/V1locations/%s/stats/',LEdata.animal,LEdata.array);
            end
        end
    else
        if contains(LEdata.programID,'low','IgnoreCase',true)
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/lowSF/%s/stats/',LEdata.animal,LEdata.array);
        else
            figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/highSF/%s/stats/',LEdata.animal,LEdata.array);
        end
    end
end

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)


figName = [REdata.animal,'_',REdata.array,'_',REdata.programID,'_DistPermLEvsRE','.pdf'];
print(gcf, figName,'-dpdf','-bestfit')