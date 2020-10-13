function [dataT] = GlassVsBlankDPrimes_zscore_perm(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% conBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[~,numDots,numDxs,numCoh] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

noiseBlankDprimePerm = nan(numCoh,numDots, numDxs, numCh); %coherence is meaningless here, but all zscore matrices are the same dimensions, so keeping it that way
radBlankDprimePerm = nan(numCoh, numDots, numDxs, numCh);
conBlankDprimePerm = nan(numCoh, numDots, numDxs, numCh);
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
                    
                    stimTrials = [conTrials;radTrials;nosTrials];
                    stimTrials(isnan(stimTrials)) = [];
                    
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
                        radNdx = randi(length(stimTrials),[1,numRadTrials]);
                        conNdx = datasample(setdiff(1:length(stimTrials),radNdx),numConTrials);
                        blankNdx = datasample(setdiff(1:length(stimTrials),conNdx),numBlankTrials);
                        %% d'
                        conBlankDprimeBoot(nb,1) = simpleDiscrim(stimTrials(blankNdx),stimTrials(conNdx));
                        radBlankDprimeBoot(nb,1) = simpleDiscrim(stimTrials(blankNdx),stimTrials(radNdx));
                        if co == 1
                            nosNdx = datasample(setdiff(1:length(stimTrials),blankNdx),numNosTrials);
                            noiseBlankDprimeBoot(nb,1) = simpleDiscrim(stimTrials(blankNdx),stimTrials(nosNdx));
                        end
                    end
                    conBlankDprimePerm(co,ndot,dx,ch) = nanmean(conBlankDprimeBoot);
                    radBlankDprimePerm(co,ndot,dx,ch) = nanmean(radBlankDprimeBoot);
                    
                     conBlankDprimePermBoot(co,ndot,dx,ch,:) = conBlankDprimeBoot;
                     radBlankDprimePermBoot(co,ndot,dx,ch,:) = radBlankDprimeBoot;
                    
                    if co == 1
                        noiseBlankDprimePerm(co,ndot,dx,ch) = nanmean(noiseBlankDprimeBoot);
                        noiseBlankDprimePermBoot(co,ndot,dx,ch,:) = noiseBlankDprimeBoot;
                    end
                end
            end
        end
    end
end
%% commit everything to the data structure
dataT.conBlankDprimePerm = conBlankDprimePerm;
dataT.radBlankDprimePerm = radBlankDprimePerm;
dataT.noiseBlankDprimePerm = noiseBlankDprimePerm;

dataT.radBlankDprimeBootPerm = radBlankDprimePermBoot;
dataT.conBlankDprimeBootPerm = conBlankDprimePermBoot;
dataT.noiseBlankDprimeBootPerm = noiseBlankDprimePermBoot;
