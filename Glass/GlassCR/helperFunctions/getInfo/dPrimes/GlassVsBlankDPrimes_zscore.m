function [conBlankDprime,radBlankDprime,noiseBlankDprime] = GlassVsBlankDPrimes_zscore(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

noiseBlankDprime = nan(numCoh,numDots, numDxs, numCh); %coherence is meaningless here, but all zscore matrices are the same dimensions, so keeping it that way
radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%% mean responses and d' to each stimulus

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        blankTrials = squeeze(dataT.blankZscore(ch,:))';
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    
                    conTrials = squeeze(dataT.conZscore(co,ndot,dx,ch,:));
                    radTrials = squeeze(dataT.radZscore(co,ndot,dx,ch,:));
                    nosTrials = squeeze(dataT.noiseZscore(co,ndot,dx,ch,:));
                    
                    conTrials(isnan(conTrials)) = [];
                    radTrials(isnan(radTrials)) = [];
                    nosTrials(isnan(nosTrials)) = [];
                    
                    numConTrials = round(size(conTrials,1)*holdout);
                    numRadTrials = round(size(radTrials,1)*holdout);
                    numNosTrials = round(size(nosTrials,1)*holdout);
                    numBlankTrials = round(size(blankTrials,1)*holdout);
                    
                    conBlankDprimeBoot   = nan(numBoot,1);
                    radBlankDprimeBoot   = nan(numBoot,1);
                    noiseBlankDprimeBoot = nan(numBoot,1);
                    
                    for nb = 1:numBoot
                        % subsample
                        radNdx = randi(length(radTrials),[1,numRadTrials]);
                        conNdx = randi(length(conTrials),[1,numConTrials]);
                        blankNdx = randi(length(blankTrials),[1,numBlankTrials]);
                        
                        radStim = radTrials(radNdx);
                        conStim = conTrials(conNdx);
                        blankStim = blankTrials(blankNdx);
                        %% d'
                        conBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(conStim));
                        radBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(radStim));
                        if co == 1
                            nosNdx = randi(length(nosTrials),[1,numNosTrials]);
                            nosStim = nosTrials(nosNdx);
                            noiseBlankDprimeBoot(nb,1) = simpleDiscrim((blankStim),(nosStim));
                        end
                    end
                    conBlankDprime(co,ndot,dx,ch) = nanmean(conBlankDprimeBoot);
                    radBlankDprime(co,ndot,dx,ch) = nanmean(radBlankDprimeBoot);
                    if co == 1
                        noiseBlankDprime(co,ndot,dx,ch) = nanmean(noiseBlankDprimeBoot);
                    end
                end
            end
        end
    end
end
%%