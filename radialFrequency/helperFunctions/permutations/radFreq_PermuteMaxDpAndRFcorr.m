function [LEdata, REdata] = radFreq_PermuteMaxDpAndRFcorr(LEdata,REdata,numBoot)
%%

figDir =  sprintf('~/Dropbox/Figures/%s/RadialFrequency/%s/stats/Perm/maxDpCorr/',LEdata.animal,LEdata.array);

if ~exist(figDir,'dir')
    mkdir(figDir)
end
cd(figDir)
%%
LEdPrimes = LEdata.stimCircDprimeBootPerm;
REdPrimes = REdata.stimCircDprimeBootPerm;

maxDpBoot = nan(3,96,numBoot);
corrBoot = nan(3,96,numBoot);

meanMaxDp = nan(3,numBoot);
meanCorr = nan(3,numBoot);
%%
for ey = 1:2
    if ey == 1
        dPrimes = LEdPrimes;
    else
        dPrimes = REdPrimes;
    end
    for rf = 1:3
        for nb = 1:numBoot
            for ch = 1:96
                
                chD = squeeze(dPrimes(rf,:,ch,:));
                useAmps = nan(1,6);
                
                for amp = 1:6
                    useAmps(1,amp) = datasample(chD(amp,:),1);
                end
                
                maxDpBoot(rf,ch,nb) = max(useAmps);
                % get correlations
                
                zed = [0, useAmps];
                corMtx = corrcoef(0:6,zed);
                corrBoot(rf,ch,nb) = corMtx(2);
                
                clear  corMtx zero
            end %ch
            meanMaxDp(rf,nb) = nanmedian(squeeze(maxDpBoot(rf,:,nb)));
            meanCorr(rf,nb) = nanmdiean(squeeze(corrBoot(rf,:,nb)));
            
        end %bootstrap
        %% sanity check figures
        if ey == 1
            figure(1)
        else
            figure(2)
        end
        clf
        s = suptitle(sprintf('%s %s permutations eye %d RF %d',LEdata.animal,LEdata.array,ey,rf));
        s.Position(2) = s.Position(2) +0.025;
        
        subplot(2,1,1)
        hold on
        histogram(squeeze(meanMaxDp(rf,:)),'Normalization','probability');
        title('Mean of max d''s')
        set(gca, 'tickdir','out')
        
        subplot(2,1,2)
        hold on
        histogram(squeeze(meanCorr(rf,:)),'Normalization','probability');
        title('Mean Correlations')
        set(gca,'tickdir','out')
        if ey == 1
            figName = [LEdata.animal,'_',LEdata.eye,'_',LEdata.array,'_',LEdata.programID,'_DistPermMaxDpCorr_RF',num2str(rf),'.pdf'];
        else
            figName = [REdata.animal,'_',REdata.eye,'_',REdata.array,'_',REdata.programID,'_DistPermMaxDpCorr_RF',num2str(rf),'.pdf'];
        end
        print(gcf, figName,'-dpdf','-bestfit')
    end %RF
    if ey == 1
        LEdata.meanMaxDp = meanMaxDp;
        LEdata.meanCorr = meanCorr;
        LEdata.maxDpBoot = maxDpBoot;
    else
        REdata.meanMaxDp = meanMaxDp;
        REdata.meanCorr = meanCorr;
        REdata.maxDpBoot = maxDpBoot;
    end
end %eye





