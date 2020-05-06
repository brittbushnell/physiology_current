function [dataT] = getGlassStimDPrimes_coh(dataT, numBoot, holdout)
% This function will compute d' for stimulus vs  noise screen using only
% noise and 100% coherence stimuli, and gives an option to subsample the
% stimuli or not.
%
% 1/7/2020
%%
[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);

conRadDprimeSimple = nan(numCoh,numDots,numDxs,96);
radNoiseDprimeSimple = nan(numCoh,numDots,numDxs,96);
conNoiseDprimeSimple = nan(numCoh,numDots,numDxs,96);
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startMean = 5;
        endMean = 25;
        
        noiseNdx = (dataT.type == 0);
        conNdx = (dataT.type == 1);
        radNdx = (dataT.type == 2);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx = (dataT.dx == dxs(dx));
                    cohNdx = (dataT.coh == coherences(co));
                    
                    conTrials = (conNdx & dotNdx & dxNdx & cohNdx);
                    radTrials = (radNdx & dotNdx & dxNdx & cohNdx);
                    noiseTrials = (noiseNdx & dotNdx & dxNdx);
                    
                    numConTrials = round(length(find(conTrials))*holdout);
                    numRadTrials = round(length(find(radTrials))*holdout);
                    numNoiseTrials = round(length(find(noiseTrials))*holdout);
                    
                    conNoiseDprimePerm = nan(numBoot,1);
                    radNoiseDprimePerm = nan(numBoot,1);
                    conRadDprimePerm   = nan(numBoot,1);
                    
                    for nb = 1:numBoot
                        
                        % subsample stimuli
                        radNdx1 = subsampleStimuli(radTrials, numRadTrials);
                        radStim = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                        
                        conNdx1 = subsampleStimuli(conTrials, numConTrials);
                        conStim = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                        
                        nosNdx1 = subsampleStimuli(noiseTrials, numNoiseTrials);
                        nosStim = nansum(dataT.bins(nosNdx1, (startMean:endMean) ,ch),2);
                        
%                         % get spike counts
%                         radStim2 = nansum(dataT.bins(radStim, (startMean:endMean) ,ch),2);
%                         conStim2 = nansum(dataT.bins(conStim, (startMean:endMean) ,ch),2);
%                         noiseStim2 = nansum(dataT.bins(nosStim, (startMean:endMean), ch),2);
                        
                        %% d'
                        conNoiseDprimePerm(nb,1) = simpleDiscrim((nosStim),(conStim));
                        radNoiseDprimePerm(nb,1) = simpleDiscrim((nosStim),(radStim));
                        conRadDprimePerm(nb,1)   = simpleDiscrim((conStim),(radStim));
                    end
                    
                    conNoiseDprimeSimple(co,ndot,dx,ch) = nanmean(conNoiseDprimePerm);
                    radNoiseDprimeSimple(co,ndot,dx,ch) = nanmean(radNoiseDprimePerm);
                    conRadDprimeSimple(co,ndot,dx,ch)   = nanmean(conRadDprimePerm);
                end
            end
        end
    end
end
dataT.conNoiseDprime = conNoiseDprimeSimple;
dataT.radNoiseDprime = radNoiseDprimeSimple;
dataT.conRadDprime   = conRadDprimeSimple;
