function [dataT] = getGratMapRespDprime(dataT, numBoot, holdout)

xPos = unique(dataT.pos_x);
yPos = unique(dataT.pos_y);
numXs = length(xPos);
numYs = length(yPos);
%%
% need to be y,x to plot properly
locStimResps  = nan(numYs,numXs, 96);
locBlankResps  = nan(numYs,numXs, 96);
locDprime = nan(numYs,numXs, 96);
locStimSE = nan(numYs,numXs, 96);
locBlankSE = nan(numYs,numXs, 96);
locRespsBaseSub = nan(numYs,numXs, 96);
%%
stimNdx  = dataT.spatial_frequency ~=0;
blankNdx = dataT.spatial_frequency == 0;

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
            locDprime(y,x,ch)     = nanmean(dPrimeBoot);
            locStimResps(y,x,ch)  = nanmean(stimMeanBoot);
            locStimSE(y,x,ch)     = nanstd(stimMeanBoot);
            locBlankResps(y,x,ch) = nanmean(blankMeanBoot);
            locBlankSE(y,x,ch)    = nanstd(blankMeanBoot);
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