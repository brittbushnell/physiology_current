function [blankSpikeCount,stimSpikeCount] = getGratSpikeCount(dataT)

blankNdx = (dataT.spatial_frequency == 0);
stimNdx  = (dataT.spatial_frequency > 0);

for ch = 1:96
    
    blankSpikeCount(ch,:) = sum(dataT.bins(blankNdx, 5:25, ch),2);
    stimSpikeCount(ch,:)  = sum(dataT.bins(stimNdx, 5:25, ch),2);
end