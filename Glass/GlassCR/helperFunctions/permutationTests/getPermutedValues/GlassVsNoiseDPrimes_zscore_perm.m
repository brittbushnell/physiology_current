function [dataT] = GlassVsNoiseDPrimes_zscore_perm(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

conRadDprimePerm = nan(numCoh,numDots, numDxs, numCh); %coherence is meaningless here, but all zscore matrices are the same dimensions, so keeping it that way
radNosDprimePerm = nan(numCoh, numDots, numDxs, numCh);
conNosDprimePerm = nan(numCoh, numDots, numDxs, numCh);
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
                    
                    stimTrials = [conTrials;radTrials;nosTrials];
                    stimTrials(isnan(stimTrials)) = [];
                    
                    conTrials(isnan(conTrials)) = [];
                    radTrials(isnan(radTrials)) = [];
                    
                    numConTrials = round(size(conTrials,1)*holdout);
                    numRadTrials = round(size(radTrials,1)*holdout);
                    
                    conNosDprimeBoot = nan(numBoot,1);
                    radNosDprimeBoot = nan(numBoot,1);
                    conRadDprimeBoot = nan(numBoot,1);
                    
                    for nb = 1:numBoot
                        % subsample
                        radNdx = randi(length(stimTrials),[1,numRadTrials]);
                        conNdx = datasample(setdiff(1:length(stimTrials),radNdx),numConTrials);
                        nosNdx = datasample(setdiff(1:length(stimTrials),conNdx),numNosTrials);
                        %% d'
                        conNosDprimeBoot(nb,1) = simpleDiscrim(stimTrials(nosNdx),stimTrials(conNdx));
                        radNosDprimeBoot(nb,1) = simpleDiscrim(stimTrials(nosNdx),stimTrials(radNdx));
                        conRadDprimeBoot(nb,1) = simpleDiscrim(stimTrials(radNdx),stimTrials(conNdx));
                    end
                    conNosDprimePerm(co,ndot,dx,ch) = nanmean(conNosDprimeBoot);
                    radNosDprimePerm(co,ndot,dx,ch) = nanmean(radNosDprimeBoot);
                    conRadDprimePerm(co,ndot,dx,ch) = nanmean(conRadDprimeBoot);

                    conNosDprimePermBoot(co,ndot,dx,ch,:) = conNosDprimeBoot;
                    radNosDprimePermBoot(co,ndot,dx,ch,:) = radNosDprimeBoot;                  
                    conRadDprimePermBoot(co,ndot,dx,ch,:) = conRadDprimeBoot;
                end
            end
        end
    end
end
%% commit everything to the data structure
dataT.conNoiseDprimePerm = conNosDprimePerm;
dataT.radNoiseDprimePerm = radNosDprimePerm;
dataT.conRadDprimePerm = conRadDprimePerm;

dataT.radNoiseDprimeBootPerm = radNosDprimePermBoot;
dataT.conNoiseDprimeBootPerm = conNosDprimePermBoot;
dataT.conRadDprimeBootPerm = conRadDprimePermBoot;
