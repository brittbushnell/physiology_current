function [dataT] = GlassStimVsNoisePermutation_coh(dataT, numBoot,holdout)
% This function will compute d' for stimulus vs  blank screen using only
% noise and 100% coherence stimuli.
%
% In this version, there are stim vs blank, but it's subdivided by "dots
% and dx" not ALL stimuli collapsed, just type.
%
%%
[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);
%% Make matrices of responses
% Initialize matrices

conNoiseDprimePerm = nan(numCoh,numDots, numDxs, numCh);
radNoiseDprimePerm = nan(numCoh,numDots, numDxs, numCh);
% %conRadDprimePerm = nan(numCoh,numDots, numDxs, numCh);

conNoiseSDPerm = nan(numCoh,numDots, numDxs, numCh);
radNoiseSDPerm = nan(numCoh,numDots, numDxs, numCh);
% %conRadSDPerm = nan(numCoh,numDots, numDxs, numCh);

radDprimeBootPerm = nan(numCoh,numDots, numDxs, numCh,numBoot);
conDprimeBootPerm = nan(numCoh,numDots, numDxs, numCh,numBoot);
% %conRadDprimeBootPerm = nan(numCoh,numDots, numDxs, numCh,numBoot);
%% mean responses and d' to each stimulus
% type codes 1=concentric  2=radial 0=noise  100=blank 3 = translational

for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startMean = 5;
        endMean = 25;
        
        conNdx   = (dataT.type == 1);
        radNdx   = (dataT.type == 2);
        noiseNdx = (dataT.type == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx = (dataT.dx == dxs(dx));
                    coNdx = (dataT.coh == coherences(co));
                    stimNdx = dataT.numDots > 0;
                    
                    conNoiseBoot  = nan(1,numBoot);
                    radNoiseBoot  = nan(1,numBoot);
                    %conRadBoot = nan(1,numBoot);
                    
                    for nb = 1:numBoot
                        % make the list of trials to randomly pull from to
                        % assign coherences to. Inlclude 0 coherence in
                        % these, but limit to concentric or radial
                        % otherwise.
                        conTrials = (dotNdx & dxNdx & stimNdx & ~radNdx);
                        radTrials = (dotNdx & dxNdx & stimNdx & ~conNdx);
                        
                        % how many trials were run for each unique stimulus
                        numConCoh = round(sum(conTrials & coNdx) * holdout);
                        numRadCoh = round(sum(radTrials & coNdx) * holdout);
                        numNoiseTrials  = round(sum(dotNdx & dxNdx & noiseNdx) * holdout);
                        
                        % from conTrials and radTrials, randomly choose
                        % trials to be counted as 0 coherence
                        [noiseNdx1,unusedCon] = subsampleStimuli((conTrials),numNoiseTrials);
                        noiseForCon = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                        
                        [noiseNdx1,unusedRad] = subsampleStimuli((radTrials),numNoiseTrials);
                        noiseForRad = nansum(dataT.bins(noiseNdx1, startMean:endMean, ch),2);
                        
                        % Using the leftover stimuli, randomly assign other
                        % trials for the coherence.
                        radNdx1 = subsampleStimuli(unusedRad, numRadCoh);
                        radStim = nansum(dataT.bins(radNdx1, (startMean:endMean) ,ch),2);
                        
                        conNdx1 = subsampleStimuli(unusedCon, numConCoh);
                        conStim = nansum(dataT.bins(conNdx1, (startMean:endMean) ,ch),2);
                        
                        %% d'
                        conNoiseBoot(1,nb) = simpleDiscrim((noiseForCon),(conStim));
                        radNoiseBoot(1,nb) = simpleDiscrim((noiseForRad),(radStim));
                        %conRadBoot(1,nb) = simpleDiscrim((conForRad),(radForCon));
                    end
                    %% create matrices of bootstrapped d', standard deviations, and the mean d'
                    conNoiseDprimePerm(co,ndot,dx,ch)   = nanmedian(conNoiseBoot);
                    radNoiseDprimePerm(co,ndot,dx,ch)   = nanmedian(radNoiseBoot);
                    
                    conNoiseSDPerm(co,ndot,dx,ch)   = nanstd(conNoiseBoot);
                    radNoiseSDPerm(co,ndot,dx,ch)   = nanstd(radNoiseBoot);
                    
                    conDprimeBootPerm(co,ndot,dx,ch,:) = conNoiseBoot;
                    radDprimeBootPerm(co,ndot,dx,ch,:) = radNoiseBoot;
                    
                    %conRadDprimePerm(co,ndot,dx,ch)  = nanmedian(%conRadBoot);
                    %conRadSDPerm(co,ndot,dx,ch)  = nanstd(%conRadBoot);
                    %conRadDprimeBootPerm(co,ndot,dx,ch,:) = %conRadBoot;
                end
            end
        end
    end
end
%% commit everything to the data structure
dataT.conNoiseDprimePerm = conNoiseDprimePerm;
dataT.radNoiseDprimePerm = radNoiseDprimePerm;
% dataT.conRadDprimePerm = conRadDprimePerm;

dataT.radNoiseDprimeBootPerm = radDprimeBootPerm;
dataT.conNoiseDprimeBootPerm = conDprimeBootPerm;
% dataT.%conRadDprimeBootPerm = %conRadDprimeBootPerm;

dataT.conNoiseDprimeSDPerm = conNoiseSDPerm;
dataT.radNoiseDprimeSDPerm = radNoiseSDPerm;
% dataT.%conRadDprimeSDPerm = %conRadSDPerm;
