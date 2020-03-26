function [dataT] = getStimResps_GlassTR(dataT,numBoot)
% This function returns matrices of the mean of the summed responses and standard errors to each stimulus
% Output matrices for means and standard errors are organized the same:
%       blankMeans = nan(1, numCh);
%
%       linStimMeans   = nan(numCoh, numDots, numDxs, numCh);
%       radStimMeans   = nan(numCoh, numDots, numDxs, numCh);
%       noiseStimMeans   = nan(numCoh, numDots, numDxs, numCh);
%
% blank and noise stimuli are subsampled, so the same number of repeats are
% used for all stimuli.
%
% Brittany Bushnell April 29, 2019
%
% September 10 - edited to add bootstrapping
%% get parameter information
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);
%% Initialize matrices
blankMeans = nan(1, numCh);
blankSD = nan(1, numCh);

linMeans = nan(numOris,numCoh, numDots, numDxs, numCh);
noiseMeans   = nan(numDots, numDxs, numCh);

linStimSD = nan(numOris,numCoh, numDots, numDxs, numCh);
noiseSD   = nan(numDots, numDxs, numCh);

linStimBoot = nan(numOris,numCoh, numDots, numDxs, numCh,numBoot);
noiseStimBoot = nan(numDots, numDxs, numCh,numBoot);
blankRespBoot = nan(numCh,numBoot);
%%
blankNdx = (dataT.numDots == 0);
noiseNdx = (dataT.type == 0);
linNdx = (dataT.type == 3);
startMean = 5;
endMean = 25;

noiseBoot = nan(1,numBoot);
blankBoot = nan(1,numBoot);

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        for ndot = 1:numDots
            for dx = 1:numDxs
                for or = 1:numOris
                    for co = 1:numCoh
                        
                        dotNdx = (dataT.numDots == dots(ndot));
                        dxNdx  = (dataT.dx == dxs(dx));
                        cohNdx = (dataT.coh == coherences(co));
                        oriNdx = (dataT.rotation == oris(or));
                        
                        linBoot   = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            linTrials = (linNdx & dotNdx & dxNdx & cohNdx & oriNdx);
                            noiseTrials = (noiseNdx & dotNdx & dxNdx);
                            numTrials   = round(length(find(linTrials))*0.8);
                            
                            % subsample 75% of trials to do statistics on
                            blankNdx1  = subsampleBlanks(blankNdx,numTrials);
                            noiseNdx1  = subsampleStimuli((noiseTrials),numTrials);
                            linNdx1 = subsampleStimuli(linTrials, numTrials);
                            
                            linBoot(1,nb) = nanmean(mean(dataT.bins(linNdx1, (startMean:endMean) ,ch),2))./0.01;
                            
                            if co == 1 && or == 1
                                noiseBoot(1,nb) = nanmean(mean(dataT.bins(noiseNdx1, (startMean:endMean) ,ch),2))./0.01;
                                %fprintf('noiseBoot\n')
                                if ndot == 1 && dx == 1 && or == 1
                                    blankBoot(1,nb) = nanmean(mean(dataT.bins(blankNdx1, (startMean:endMean) ,ch),2))./0.01;
                                    %fprintf('blankeBoot\n')
                                end
                            end
                        end
                        linMeans(or,co,ndot,dx,ch) = nanmean(linBoot);
                        linStimBoot(or,co,ndot,dx,ch,:) = linBoot;
                        % doing standard deviation of the means is the most
                        % appropriate
                        % (https://support.minitab.com/en-us/minitab-express/1/help-and-how-to/basic-statistics/inference/how-to/resampling/bootstrapping-for-1-sample-mean/interpret-the-results/all-statistics-and-graphs/bootstrap-sample/)
                        linStimSD(or,co,ndot,dx,ch) = nanstd(linBoot);
                        
                        if co == 1 && or == 1
                            noiseMeans(ndot,dx,ch) = nanmean(noiseBoot);
                            noiseSD(ndot,dx,ch) = nanstd(noiseBoot);
                            noiseStimBoot(ndot,dx,ch,:) = noiseBoot;
                            noiseBoot = nan(1,numBoot);
                        end
                    end
                end
            end
        end
        blankMeans(1,ch) = nanmean(blankBoot);
        blankSD(1,ch) = nanstd(blankBoot);
        blankRespBoot(ch,:) = blankBoot;
        blankBoot = nan(1,numBoot);
    end
end
%%
dataT.linStimMeans = linMeans;
dataT.linStimSD = linStimSD;
dataT.linMeanBoot = linStimBoot;

dataT.noiseMeans = noiseMeans;
dataT.noiseSD = noiseSD;
dataT.noiseMeanBoot = noiseStimBoot;

dataT.blankMeans = blankMeans;
dataT.blankSD = blankSD;
dataT.blankMeanBoot = blankRespBoot;








