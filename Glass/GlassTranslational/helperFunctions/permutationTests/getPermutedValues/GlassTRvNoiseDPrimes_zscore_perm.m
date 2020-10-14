function [linNoiseDprimePerm,linNoiseDprimePermBoot] = GlassTRvNoiseDPrimes_zscore_perm(dataT,numBoot, holdout)
% This function will compute d' for stimulus vs  blank screen based off of
% zscored spike counts

% noiseBlankDprime = nan(numDots, numDxs, numCh);
% stimBlankDprime = nan(numDots, numDxs, numCh);
% radBlankDprime = nan(numCoh, numDots, numDxs, numCh);
% linBlankDprime = nan(numCoh, numDots, numDxs, numCh);
%%
[numOris,numDots,numDxs,numCoh] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linNoiseDprimePerm = nan(numOris,numCoh,numDots, numDxs, numCh);
linNoiseDprimePermBoot = nan(numOris,numCoh,numDots, numDxs, numCh, numBoot);
%% mean responses and d' to each stimulus

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        for ndot = 1:numDots
            for dx = 1:numDxs
                
                nosTrials = squeeze(dataT.noiseZscore(1,1,ndot,dx,ch,:));
                nosTrials(isnan(nosTrials)) = [];
                               
                for co = 1:numCoh
                    for or = 1:numOris
                        linTrials = squeeze(dataT.GlassTRZscore(or,co,ndot,dx,ch,:));
                        stimTrials = [linTrials;nosTrials];
                        
                        linTrials(isnan(linTrials))   = [];
                        stimTrials(isnan(stimTrials)) = [];
                        
                        numLinTrials = round(size(linTrials,1)*holdout);
                        numNosTrials = round(size(nosTrials,1)*holdout);
                        
                        linNoiseDprimeBoot  = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            % subsample
                            nosNdx = randi(length(nosTrials),[1,numNosTrials]);
                            linNdx = datasample(setdiff(1:length(stimTrials),nosNdx),numLinTrials);
                            
                            nosStim = stimTrials(nosNdx);
                            linStim = stimTrials(linNdx);
                            
                            %% d'
                            linNoiseDprimeBoot(1,nb) = simpleDiscrim((nosStim),(linStim));
                            
                        end
                        linNoiseDprimePerm(or,co,ndot,dx,ch) = nanmean(linNoiseDprimeBoot);
                        linNoiseDprimePermBoot(or,co,ndot,dx,ch,:) = linNoiseDprimeBoot;

                        clear linNoiseDprimeBoot
                    end
                end
            end
        end
    end
end

