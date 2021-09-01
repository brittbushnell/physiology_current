function [LEcorrPval,LEcorrSigPerms,REcorrPval,REcorrSigPerms] = radFreq_getSigTuningRFs(LEdata, REdata,numBoot)
%%
LEdPrimes = LEdata.stimCircDprime;
REdPrimes = REdata.stimCircDprime;

maxDpBoot = nan(3,96,numBoot);
corrBoot = nan(3,96,numBoot);

filler = [0;0;0];
%%
for ey = 1:2
    if ey == 1
        dPrimes = LEdPrimes;
    else
        dPrimes = REdPrimes;
    end
    
    for ch = 1:96
        for nb = 1:numBoot
            
            chD = squeeze(dPrimes(:,:,ch));
            permAmps = nan(3,6);
            
            for amp = 1:6
                ampTmp = squeeze(chD(:,amp));
                permAmps(:,amp) = datasample(ampTmp,3,'Replace',false);
                clear ampTmp
            end
            maxDpBoot(:,ch,nb) = max(permAmps,[],2);
            
            zed = [filler permAmps];
            for i = 1:3
                corMtx = corrcoef(0:6,zed(i,:));
                corrBoot(i,ch,nb) = corMtx(2);
            end
            
            clear permAmps zed
        end %bootstrap
    end% ch
end % eye
%% do permutation test
corrPval = nan(3,96);
corrSigPerms = nan(3,96);

for ey = 1:2
    if ey == 1
        dataT = LEdata;
    else
        dataT = REdata;
    end
    trueCorr = dataT.stimCorrs;
    for ch = 1:96
        figure(1)
        hold on
        if ey == 1
            s = suptitle(sprintf('%s %s LE correlation permutations ch %d', dataT.animal, dataT.array, ch));
        else
            s = suptitle(sprintf('%s %s RE correlation permutations ch %d', dataT.animal, dataT.array, ch));
        end
        s.Position(2) = s.Position(2) +0.025;
        
        
        for rf = 1:3
            chCorr = trueCorr(rf,ch);
            permCorr = squeeze(corrBoot(rf,ch,:));
            
            high = find(permCorr > chCorr);
            pV = round(((length(high)+1)/(length(permCorr)+1)),3);
            
            if pV > 0.5
                pV = 1-pV;
            end
            
            corrPval(rf,ch) = pV;
            
            if  pV <= 0.05
                corrSigPerms(rf,ch) = 1;
            else
                corrSigPerms(rf,ch) = 0;
            end
            
            subplot(3,1,rf)
            hold on
            histogram(permCorr,'BinWidth',0.1,'Normalization','probability')
            plot([chCorr, chCorr], [0 0.55],'k-')
            text(chCorr,0.53,sprintf(' %.2f',chCorr))
            if corrSigPerms(rf,ch) == 1
                text( -0.95,0.57,sprintf('p = %.2f*',corrPval(rf,ch)),'FontWeight','bold')
            else
                text( -0.95,0.57,sprintf('p = %.2f',corrPval(rf,ch)))
            end
            xlim([-1 1])
            ylim([0 0.6])
            
            set(gca,'tickdir','out')
        end % rf    
    end % ch
    if ey == 1
        LEcorrPval = corrPval;
        LEcorrSigPerms = corrSigPerms;
    else
        REcorrPval = corrPval;
        REcorrSigPerms = corrSigPerms;
    end
end %eye

