function [dataT] = getMapNoiseRespDprime(dataT, numBoot, holdout)

xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
numXs = length(xPos);
numYs = length(yPos);
%%
locStimResps  = nan(numXs, numYs, 96);
locBlankResps  = nan(numXs, numYs, 96);
locDprime = nan(numXs, numYs, 96);
locStimSE = nan(numXs, numYs, 96);
locBlankSE = nan(numXs, numYs, 96);
locRespsBaseSub = nan(numXs, numYs, 96);
%%
stimNdx  = dataT.stimulus == 1;
blankNdx = dataT.stimulus == 0;

for ch = 1:96
    for x = 1:numXs
        for y = 1:numYs
            xNdx = dataT.pos_x == xPos(x);
            yNdx = dataT.pos_y == yPos(y);
            
            stimTrials  = stimNdx & yNdx & xNdx;
            blankTrials = blankNdx;
            
            numStimTrials = round(length(find(stimTrials))*holdout);
            numBlankTrials = round(length(find(blankTrials))*holdout);
            
            dPrimeBoot = nan(1,numBoot);
            blankMeanBoot = nan(1,numBoot);
            stimMeanBoot  = nan(1,numBoot);
            
            for nb = 1:numBoot
                blankNdx1 = subsampleBlanks((blankTrials),numBlankTrials);
                blankSpikeCount = nansum(dataT.bins(blankNdx1, 5:25, ch),2);
                blankMeanBoot(1,nb) =  mean(mean(dataT.bins(blankNdx1, 5:25, ch),2))/0.01;
                
                stimNdx1 = subsampleBlanks((stimTrials),numStimTrials);
                stimSpikeCount = nansum(dataT.bins(stimNdx1, 5:25, ch),2);
                stimMeanBoot(1,nb) = mean(mean(dataT.bins(stimNdx1, 5:25, ch),2))/0.01;
                       
                dPrimeBoot(1,nb) = simpleDiscrim((blankSpikeCount),(stimSpikeCount));  
            end
            locDprime(x,y,ch)     = nanmean(dPrimeBoot);
            locStimResps(x,y,ch)  = nanmean(stimMeanBoot);
            locStimSE(x,y,ch)     = nanstd(stimMeanBoot);
            locBlankResps(x,y,ch) = nanmean(blankMeanBoot);
            locBlankSE(x,y,ch)    = nanstd(blankMeanBoot);
        end
    end
    locRespsBaseSub(:,:,ch) = locStimResps(:,:,ch) - locBlankResps(:,:,ch);
end
%%
dataT.locDprime = locDprime;
dataT.locStimResps  = locStimResps;
dataT.locBlankResps = locBlankResps;
dataT.locStimSE  = locStimSE;
dataT.locBlankSE = locBlankSE;
dataT.locRespsBaseSub = locRespsBaseSub;