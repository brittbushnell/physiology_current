function [linBlankDprime, noiseBlankDprime] = GlassTRvBlankDPrimes_zscore(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

%%
[numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linBlankDprime = nan(numOris,numCoh,numDots, numDxs, numCh);
noiseBlankDprime = nan(numOris, numCoh, numDots, numDxs, numCh);
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
                        
                        linTrials(isnan(linTrials)) = [];
                        nosTrials(isnan(nosTrials)) = [];
                        
                        numLinTrials = round(size(linTrials,1)*holdout);
                        numNosTrials = round(size(nosTrials,1)*holdout);
                        numBlankTrials = round(size(blankTrials,1)*holdout);
                        
                        linBlankDprimeBoot  = nan(1,numBoot);
                        noiseBlankDprimeBoot = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            % subsample
                            linNdx = randi(length(linTrials),[1,numLinTrials]);
                            blankNdx = randi(length(blankTrials),[1,numBlankTrials]);
                            
                            linStim = linTrials(linNdx);
                            blankStim = blankTrials(blankNdx);
                            %% d'
                            linBlankDprimeBoot(1,nb) = simpleDiscrim((blankStim),(linStim));
                            
                            if co == 1 && or == 1
                                nosNdx = randi(length(nosTrials),[1,numNosTrials]);
                                nosStim = nosTrials(nosNdx);
                                noiseBlankDprimeBoot(1,nb) = simpleDiscrim((blankStim),(nosStim));
                            end
                        end
                        linBlankDprime(or,co,ndot,dx,ch) = nanmean(linBlankDprimeBoot);
                        clear linBlankDprimeBoot
                        if co == 1  && or == 1
                            noiseBlankDprime(or,co,ndot,dx,ch) = nanmean(noiseBlankDprimeBoot);
                            clear noiseBlankDprimeBoot
                        end
                    end
                end
            end
        end
    end
end

