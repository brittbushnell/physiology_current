function [dataT] = GlassTR_StimVsNoisePermutations_coh(dataT, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli.
%
% In this version, there are stim vs blank, but it's subdivided by "dots
% and dx" not ALL stimuli collapsed, just type.
%
%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);
%% Make matrices of responses
% Initialize matrices
linNoiseDprimePerm = nan(numOris,numCoh,numDots, numDxs, numCh);
linNoiseSDPerm = nan(numOris,numCoh,numDots, numDxs, numCh);
linNoiseDprimeBootPerm = nan(numOris,numCoh,numDots, numDxs, numCh,numBoot);
%% mean responses and d' to each stimulus
% type codes 1=lincentric  2=radial 0=noise  100=blank

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startMean = 5;
        endMean = 25;
        
        stimNdx = (dataT.numDots > 0);
        linNdx   = (dataT.type == 3);
        noiseNdx = (dataT.type == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        dotNdx = (dataT.numDots == dots(ndot));
                        dxNdx = (dataT.dx == dxs(dx));
                        coNdx = (dataT.coh == coherences(co));
                        oriNdx = (dataT.rotation == oris(or));
                        
                        linNoiseBootSimple  = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            stimTrials = (dotNdx & dxNdx & stimNdx);
                            linTrials = (dotNdx & dxNdx & linNdx & coNdx & oriNdx);
                            noiseTrials = (dotNdx & dxNdx & noiseNdx);
                            
                            numLinTrials  = round(length(find(linTrials))*holdout);
                            numNoiseTrials = round(length(find(noiseTrials))*holdout);                            
                            
                            % randomly assign trials to the different linditions. make
                            % sure not to use the same trials for both linditions.                            
                            [noiseNdx1,unusedLin] = subsampleBlanks((stimTrials),numNoiseTrials);
                            noiseForLin = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                            
                            linNdx1 = subsampleStimuli(unusedLin, numLinTrials);
                            linStim = nansum(dataT.bins(linNdx1, (startMean:endMean) ,ch),2);

                            %% d'
                            linNoiseBootSimple(1,nb)   = simpleDiscrim((noiseForLin),(linStim));
                        end
                        %% create matrices of bootstrapped d', standard deviations, and the mean d' from simplified d' code
                        linNoiseDprimePerm(or,co,ndot,dx,ch)   = nanmean(linNoiseBootSimple);
                        linNoiseSDPerm(or,co,ndot,dx,ch)   = nanstd(linNoiseBootSimple);
                        linNoiseDprimeBootPerm(or,co,ndot,dx,ch,:) = linNoiseBootSimple;
                    end
                end
            end
        end
    end
end
%% commit everything to the data structure
dataT.linNoiseDprimePerm = linNoiseDprimePerm;
dataT.linNoiseDprimeBootPerm = linNoiseDprimeBootPerm;
dataT.linNoiseDprimeSDPerm = linNoiseSDPerm;





