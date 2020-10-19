function [linBlankDprimePerm, noiseBlankDprimePerm, linBlankDprimeBootPerm,noiseBlankDprimeBootPerm] = GlassTR_StimVsBlankPermutations_coh(dataT, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli.
%
% In this version, there are stim vs blank, but it's subdivided by "dots
% and dx" not ALL stimuli collapsed, just type. I'm essentially randomizing
% the orientation label.
%
%%
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);
%% Make matrices of responses
% Initialize matrices

linBlankDprimePerm   = nan(numOris,numCoh,numDots, numDxs, numCh);
noiseBlankDprimePerm = nan(numOris,numCoh,numDots, numDxs, numCh);

linBlankDprimeBootPerm   = nan(numOris,numCoh,numDots, numDxs, numCh,numBoot);
noiseBlankDprimeBootPerm = nan(numOris,numCoh,numDots, numDxs, numCh,numBoot);
%% mean responses and d' to each stimulus
% type codes 1=lincentric  2=radial 0=noise  100=blank
gch = dataT.goodCh;
for ch = 1:96
    if gch(ch) == 1
        startMean = 5;
        endMean = 25;
        
        stimNdx = (dataT.numDots > 0);
        blankNdx = (dataT.numDots == 0);
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
                        
                        linBlankBootSimple  = nan(1,numBoot);
                        noiseBlankBootSimple = nan(1,numBoot);
                        stimBlankBootSimple = nan(1,numBoot);
                        
                        for nb = 1:numBoot
                            stimTrials = (dotNdx & dxNdx & stimNdx);
                            blankTrials = blankNdx;
                            linTrials = (dotNdx & dxNdx & linNdx & coNdx & oriNdx);
                            noiseTrials = (dotNdx & dxNdx & noiseNdx);
                            trials = 1:size(dataT.bins,1);
                            
                            if holdout == 0
                                numStimTrials = sum(linTrials);
                            else
                                numStimTrials = round(length(find(stimTrials))*holdout);
                                numLinTrials  = round(length(find(linTrials))*holdout);
                                numNoiseTrials = round(length(find(noiseTrials))*holdout);
                                numBlankTrials = round(length(find(blankTrials))*holdout);
                            end
                            
                            % randomly assign trials to the different linditions. make
                            % sure not to use the same trials for both linditions.
                            
                            [noiseNdx1, unusedNdxs]  = subsampleStimuli((stimNdx & dxNdx & dotNdx),numNoiseTrials);
                            noiseStim2 = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                            
                            blankNdx1 = subsampleBlanks((blankTrials),numBlankTrials);
                            noiseBlanks = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
%                             
                            blankNdx1 = subsampleBlanks((trials),numBlankTrials);
                            blanksForLin = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
%                             
%                             [blankNdx1,unusedStim] = subsampleBlanks((trials),numBlankTrials);
%                             blanksForStim = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                            
                            linNdx1 = subsampleStimuli(unusedNdxs & stimTrials, numLinTrials);
                            linStim = nansum(dataT.bins(linNdx1, (startMean:endMean) ,ch),2);    
                            %% d'
                            linBlankBootSimple(1,nb)   = simpleDiscrim((blanksForLin),(linStim));
                            noiseBlankBootSimple(1,nb) = simpleDiscrim((noiseBlanks),(noiseStim2));
                        end
                        %% create matrices of bootstrapped d', standard deviations, and the mean d' from simplified d' code
                        linBlankDprimePerm(or,co,ndot,dx,ch)   = nanmean(linBlankBootSimple);
                        linBlankSDPerm(or,co,ndot,dx,ch)   = nanstd(linBlankBootSimple);
                        linBlankDprimeBootPerm(or,co,ndot,dx,ch,:) = linBlankBootSimple;
                        
                        if coherences(co) == 1 && or == 1                            
                            noiseBlankDprimePerm(or,co,ndot,dx,ch) = nanmean(noiseBlankBootSimple);                            
                            noiseBlankSDPerm(or,co,ndot,dx,ch) = nanstd(noiseBlankBootSimple);                           
                            noiseBlankDprimeBootPerm(or,co,ndot,dx,ch,:) = noiseBlankBootSimple;
                        end
                    end
                end
            end
        end
    end
end
%% commit everything to the data structure
dataT.linBlankDprimePerm = linBlankDprimePerm;
dataT.noiseBlankDprimePerm = noiseBlankDprimePerm;

dataT.linBlankDprimeBootPerm = linBlankDprimeBootPerm;
dataT.noiseBlankDprimeBootPerm = noiseBlankDprimeBootPerm;





