function [linNoiseDprime] = GlassTRvNoiseDPrimes_zscore(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% linBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linNoiseDprime = nan(numOris,numCoh,numDots, numDxs, numCh);
%% mean responses and d' to each stimulus

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        for ndot = 1:numDots
            for dx = 1:numDxs
                
                nosTrials = squeeze(dataT.noiseZscore(1,1,ndot,dx,ch,:));
                numNosTrials = round(size(nosTrials,1)*holdout);
                nosTrials(isnan(nosTrials)) = [];
                nosNdx = randi(length(nosTrials),[1,numNosTrials]);  
                nosStim = nosTrials(nosNdx);
                
                for co = 1:numCoh
                    for or = 1:numOris
                        linTrials = squeeze(dataT.GlassTRZscore(or,co,ndot,dx,ch,:));
                        linTrials(isnan(linTrials)) = [];
                        
                        numLinTrials = round(size(linTrials,1)*holdout);
                        
                        linNoiseDprimeBoot  = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            % subsample
                            linNdx = randi(length(linTrials),[1,numLinTrials]);
                            linStim = linTrials(linNdx);
                            
                            %% d'
                            linNoiseDprimeBoot(1,nb) = simpleDiscrim((nosStim),(linStim));
                            
                        end
                        linNoiseDprime(or,co,ndot,dx,ch) = nanmean(linNoiseDprimeBoot);
                        clear linNoiseDprimeBoot
                    end
                end
            end
        end
    end
end

