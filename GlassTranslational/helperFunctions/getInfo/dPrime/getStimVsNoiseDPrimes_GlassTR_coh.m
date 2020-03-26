function [dataT] = getStimVsNoiseDPrimes_GlassTR_coh(dataT)
% This function will compute d' for stimulus vs  noise at each different
% orientation
%
% 1/14/2020
%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences,~] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);

linNoiseDprimeSimple = nan(numOris,numCoh,numDots,numDxs,96);
stimNoiseDprimeSimple = nan(numDots,numDxs,96);
%% mean responses and d' to each stimulus
% type codes 1=lincentric  2=radial 0=noise  100=blank

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startMean= 5;
        endMean  = 25;
        
        noiseNdx = (dataT.type == 0);
        linearNdx = (dataT.type == 3);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for or = 1:numOris
                    for co = 1:numCoh
                        cohNdx = (dataT.coh == coherences(co));
                        dotNdx = (dataT.numDots == dots(ndot));
                        dxNdx = (dataT.dx == dxs(dx));
                        oriNdx = (dataT.rotation == oris(or));
                        
                        linTrials = (linearNdx & dotNdx & dxNdx & oriNdx & cohNdx);
                        noiseTrials = (noiseNdx & dotNdx & dxNdx);
                        stimTrials = (linearNdx & dotNdx & dxNdx);
                        
                        noiseStim2 = nansum(dataT.bins(noiseTrials, startMean:endMean, ch),2);
                        linStim = nansum(dataT.bins(linTrials, (startMean:endMean) ,ch),2);
                        stim = nansum(dataT.bins(stimTrials, (startMean:endMean) ,ch),2);
                        
                        %% d'
                        
                        linNoiseDprimeSimple(or,co,ndot,dx,ch)= simpleDiscrim((noiseStim2),(linStim));
                        if or == 1 && coherences(co) == 1
                            stimNoiseDprimeSimple(ndot,dx,ch)  = simpleDiscrim((noiseStim2),(stim));
                        end
                    end
                end
            end
        end
    end
end

dataT.linNoiseDprime = linNoiseDprimeSimple;
dataT.stimNoiseDprime = stimNoiseDprimeSimple;
