function [conNosDprime,radNosDprime,conRadDprime] = GlassVsNoiseDPrimes_zscore(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

conRadDprime = nan(numCoh, numDots, numDxs, numCh);
radNosDprime = nan(numCoh, numDots, numDxs, numCh);
conNosDprime = nan(numCoh, numDots, numDxs, numCh);
%% mean responses and d' to each stimulus

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        for ndot = 1:numDots
            for dx = 1:numDxs
                nosTrials = squeeze(dataT.noiseZscore(1,ndot,dx,ch,:));
                nosTrials(isnan(nosTrials)) = [];
                numNosTrials = round(size(nosTrials,1)*holdout);
                for co = 1:numCoh
                    
                    conTrials = squeeze(dataT.conZscore(co,ndot,dx,ch,:));
                    radTrials = squeeze(dataT.radZscore(co,ndot,dx,ch,:));
                    
                    conTrials(isnan(conTrials)) = [];
                    radTrials(isnan(radTrials)) = [];
                    
                    numRadTrials = round(size(radTrials,1)*holdout);
                    numConTrials = round(size(conTrials,1)*holdout);
                    
                    conNosDprimeBoot = nan(numBoot,1);
                    radNosDprimeBoot = nan(numBoot,1);
                    conRadDprimeBoot = nan(numBoot,1);
                    
                    for nb = 1:numBoot
                        % subsample
                        radNdx = randi(length(radTrials),[1,numRadTrials]);
                        conNdx = randi(length(conTrials),[1,numConTrials]);
                        nosNdx = randi(length(nosTrials),[1,numNosTrials]);
                        
                        nosStim = nosTrials(nosNdx);
                        radStim = radTrials(radNdx);
                        conStim = conTrials(conNdx);
                        %% d'
                        conNosDprimeBoot(nb,1) = simpleDiscrim((nosStim),(conStim));
                        radNosDprimeBoot(nb,1) = simpleDiscrim((nosStim),(radStim));
                        conRadDprimeBoot(nb,1) = simpleDiscrim((radStim),(conStim));
                    end
                    conNosDprime(co,ndot,dx,ch) = nanmean(conNosDprimeBoot);
                    radNosDprime(co,ndot,dx,ch) = nanmean(radNosDprimeBoot);
                    conRadDprime(co,ndot,dx,ch) = nanmean(conRadDprimeBoot);
                end
            end
        end
    end
end
%%