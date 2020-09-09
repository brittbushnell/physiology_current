function [goodCh] = getGoodCh_radFreq(bins,rf,numBoot,startMean,endMean)

goodCh = zeros(1,96);
tmpStim = [];

for ch = 1:96
    bootSig = nan(1,numBoot);
    blankTrials = mean(bins(rf == 10000, startMean:endMean, ch),2)./0.01;
    stimTrials  = mean(bins(rf ~= 10000, startMean:endMean, ch),2)./0.01;
    
    for i = 1:numBoot
        tmpStim(:,i) = randsample(stimTrials, size(blankTrials,1));
        bootSig(1,i) = ttest2(tmpStim(:,i),blankTrials);
    end
    % quick check to make sure everything is actually working
    test = sum(tmpStim,1);
    test = diff(test);
    if sum(test) == 0
        fprintf('Problem with defining good channels, everything from tmpStim is the same for ch %d \r',ch)
    end
    
    if sum(bootSig)/numel(bootSig) >= .95 % if the ttest is significant on 95% of samples, then count it as a good channel.
        goodCh(1,ch) = 1;
    end
end