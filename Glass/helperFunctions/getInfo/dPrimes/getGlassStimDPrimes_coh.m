function [dataT] = getGlassStimDPrimes_coh(dataT)
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
                    
                    noiseStim2 = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                    radStim = nansum(dataT.bins(radTrials, (startMean:endMean) ,ch),2);
                    conStim = nansum(dataT.bins(conTrials, (startMean:endMean) ,ch),2);
                    
                    %% d'
                    conNoiseDprimeSimple(co,ndot,dx,ch) = simpleDiscrim((noiseStim2),(conStim));
                    radNoiseDprimeSimple(co,ndot,dx,ch) = simpleDiscrim((noiseStim2),(radStim));                    
                    conRadDprimeSimple(co,ndot,dx,ch)   = simpleDiscrim((conStim),(radStim));
                end
            end
        end
    end
end
dataT.conNoiseDprime = conNoiseDprimeSimple;
dataT.radNoiseDprime = radNoiseDprimeSimple;
dataT.conRadDprime   = conRadDprimeSimple;
