function [linBlankDprimePerm, noiseBlankDprimePerm, linBlankDprimeBootPerm, noiseBlankDprimeBootPerm] = GlassTRvBlankDPrimes_zscorePerm(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

%%
[numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linBlankDprimePerm = nan(numOris,numCoh,numDots, numDxs, numCh);
noiseBlankDprimePerm = nan(numOris, numCoh, numDots, numDxs, numCh);

linBlankDprimeBootPerm = nan(numOris,numCoh,numDots, numDxs, numCh, numBoot);
noiseBlankDprimeBootPerm = nan(numOris, numCoh, numDots, numDxs, numCh, numBoot);
%% mean responses and d' to each stimulus

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        blankTrials = squeeze(dataT.blankZscore(ch,:))';        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        linTrials = squeeze(dataT.GlassTRZscore(or,co,ndot,dx,ch,:));
                        nosTrials = squeeze(dataT.noiseZscore(or,co,ndot,dx,ch,:));
                        stimTrials = [linTrials;nosTrials];
                        
                        linTrials(isnan(linTrials))   = [];
                        nosTrials(isnan(nosTrials))   = [];
                        stimTrials(isnan(stimTrials)) = [];
                        
                        numLinTrials = round(size(linTrials,1)*holdout);
                        numNosTrials = round(size(nosTrials,1)*holdout);
                        numBlankTrials = round(size(blankTrials,1)*holdout);
                        
                        linBlankDprimeBoot  = nan(1,numBoot);
                        noiseBlankDprimeBoot = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            % subsample
                            linNdx = randi(length(linTrials),[1,numLinTrials]);
                            blankNdx = datasample(setdiff(1:length(stimTrials),linNdx),numBlankTrials);
                            
                            linStim = stimTrials(linNdx);
                            blankStim = stimTrials(blankNdx);
                            %% d'
                            linBlankDprimeBoot(1,nb) = simpleDiscrim((blankStim),(linStim));
                            
                            if co == 1 && or == 1
                                nosNdx = datasample(setdiff(1:length(stimTrials),blankNdx),numNosTrials);
                                nosStim = stimTrials(nosNdx);
                                noiseBlankDprimeBoot(1,nb) = simpleDiscrim((blankStim),(nosStim));
                            end
                        end
                        linBlankDprimePerm(or,co,ndot,dx,ch) = nanmean(linBlankDprimeBoot);
                        linBlankDprimeBootPerm(or,co,ndot,dx,ch,:) = linBlankDprimeBoot;
                        clear linBlankDprimeBoot
                        if co == 1  && or == 1
                            noiseBlankDprimePerm(or,co,ndot,dx,ch) = nanmean(noiseBlankDprimeBoot);
                            noiseBlankDprimeBootPerm(or,co,ndot,dx,ch,:) = noiseBlankDprimeBoot;
                            clear noiseBlankDprimeBoot
                        end
                    end
                end
            end
        end
    end
end

