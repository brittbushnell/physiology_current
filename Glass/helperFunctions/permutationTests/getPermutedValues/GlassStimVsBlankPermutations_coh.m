function [dataT] = GlassStimVsBlankPermutations_coh(dataT, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli.
%
% In this version, there are stim vs blank, but it's subdivided by "dots
% and dx" not ALL stimuli collapsed, just type.
%
%%
[numTypes,numDots,numDxs,numCoh,numSamp,types,dots,dxs,coherences,samples] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);
%% Make matrices of responses
% Initialize matrices

conBlankDprimePerm = nan(numCoh,numDots, numDxs, numCh);
radBlankDprimePerm = nan(numCoh,numDots, numDxs, numCh);
noiseBlankDprimePerm = nan(numDots, numDxs, numCh);
stimBlankDprimePerm = nan(numDots, numDxs, numCh);

conBlankSDPerm = nan(numCoh,numDots, numDxs, numCh);
radBlankSDPerm = nan(numCoh,numDots, numDxs, numCh);
noiseBlankSDPerm = nan(numDots, numDxs, numCh);
stimBlankSDPerm = nan(numDots, numDxs, numCh);

radDprimeBootPerm = nan(numCoh,numDots, numDxs, numCh,numBoot);
conDprimeBootPerm = nan(numCoh,numDots, numDxs, numCh,numBoot);
noiseDprimeBootPerm=nan(numDots, numDxs, numCh,numBoot);
stimDprimeBootPerm=nan(numDots, numDxs, numCh,numBoot);
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank

parfor ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startMean = 5;
        endMean = 25;
        
        stimNdx  = (dataT.numDots > 0);
        blankNdx = (dataT.numDots == 0);
        conNdx   = (dataT.type == 1);
        radNdx   = (dataT.type == 2);
        noiseNdx = (dataT.type == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx = (dataT.dx == dxs(dx));
                    coNdx = (dataT.coh == coherences(co));
                    
                    conBlankBoot  = nan(1,numBoot);
                    radBlankBoot  = nan(1,numBoot);
                    noiseBlankBoot = nan(1,numBoot);
                    stimBlankBoot = nan(1,numBoot);
                    
                    for nb = 1:numBoot
                        stimTrials = (dotNdx & dxNdx & stimNdx);
                        blankTrials = blankNdx;
                        conTrials = (dotNdx & dxNdx & conNdx & coNdx);
                        radTrials = (dotNdx & dxNdx & radNdx & coNdx);
                        noiseTrials = (dotNdx & dxNdx & noiseNdx);
                        trials = 1:size(dataT.bins,1);
                        
                        if holdout == 0
                            numStimTrials = sum(conTrials);
                        else
                            numStimTrials = round(length(find(stimTrials))*holdout);
                            numConTrials = round(length(find(conTrials))*holdout);
                            numRadTrials = round(length(find(radTrials))*holdout);
                            numNoiseTrials = round(length(find(noiseTrials))*holdout);
                            numBlankTrials = round(length(find(blankTrials))*holdout);
                        end
                        
                        % randomly assign trials to the different conditions. make
                        % sure not to use the same trials for both conditions.
                        
                        [noiseNdx1, unusedNdxs]  = subsampleStimuli((trials),numNoiseTrials);
                        noiseStim2 = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                        
                        blankNdx1 = subsampleBlanks((unusedNdxs),numBlankTrials);
                        noiseBlanks = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                        
                        [blankNdx1,unusedCon] = subsampleBlanks((trials),numBlankTrials);
                        blanksForCon = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                        
                        [blankNdx1,unusedRad] = subsampleBlanks((trials),numBlankTrials);
                        blanksForRad = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                        
                        [blankNdx1,unusedStim] = subsampleBlanks((trials),numBlankTrials);
                        blanksForStim = nansum(dataT.bins(blankNdx1, startMean:endMean, ch),2);
                        
                        radNdx1 = subsampleStimuli(unusedRad, numRadTrials);
                        radStim = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                        
                        conNdx1 = subsampleStimuli(unusedCon, numConTrials);
                        conStim = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                        
                        stim1 = subsampleStimuli(unusedStim,numStimTrials);
                        stim = nansum(dataT.bins(stim1, (startMean:endMean) ,ch),2);
                        %% d'
                        
                        conBlankBoot(1,nb)   = simpleDiscrim((blanksForCon),(conStim));
                        radBlankBoot(1,nb)   = simpleDiscrim((blanksForRad),(radStim));
                        stimBlankBoot(1,nb)  = simpleDiscrim((blanksForStim),(stim));
                        noiseBlankBoot(1,nb) = simpleDiscrim((noiseBlanks),(noiseStim2));
                    end
                    %% create matrices of bootstrapped d', standard deviations, and the mean d'
                    
                    conBlankDprimePerm(co,ndot,dx,ch)   = nanmedian(conBlankBoot);
                    radBlankDprimePerm(co,ndot,dx,ch)   = nanmedian(radBlankBoot);
                    
                    conBlankSDPerm(co,ndot,dx,ch)   = nanstd(conBlankBoot);
                    radBlankSDPerm(co,ndot,dx,ch)   = nanstd(radBlankBoot);
                    
                    conDprimeBootPerm(co,ndot,dx,ch,:) = conBlankBoot;
                    radDprimeBootPerm(co,ndot,dx,ch,:) = radBlankBoot;
                    
                    if coherences(co) == 1
                        noiseBlankDprimePerm(ndot,dx,ch)  = nanmedian(noiseBlankBoot);
                        stimBlankDprimePerm(ndot,dx,ch)  = nanmean(stimBlankBoot);
                        
                        noiseBlankSDPerm(ndot,dx,ch)  = nanstd(noiseBlankBoot);
                        stimBlankSDPerm(ndot,dx,ch)  = nanstd(stimBlankBoot);
                        
                        noiseDprimeBootPerm(ndot,dx,ch,:) = noiseBlankBoot;
                        stimDprimeBootPerm(ndot,dx,ch,:) = stimBlankBoot;
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
dataT.stimBlankDprimePerm = stimBlankDprimePerm;

dataT.radBlankDprimeBootPerm = radDprimeBootPerm;
dataT.conBlankDprimeBootPerm = conDprimeBootPerm;
dataT.noiseBlankDprimeBootPerm = noiseDprimeBootPerm;
dataT.stimBlankDprimeBootPerm = stimDprimeBootPerm;

dataT.conBlankDprimeSDPerm = conBlankSDPerm;
dataT.radBlankDprimeSDPerm = radBlankSDPerm;
dataT.noiseBlankDprimeSDPerm = noiseBlankSDPerm;
dataT.stimBlankDprimeSDPerm = stimBlankSDPerm;

