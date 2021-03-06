function [dataT] = numSigGlassComparisons(dataT)
%%
[~,numDots,numDxs] = getGlassParameters(dataT);
%% get number of significant comparisons per channel
numSig = nan(numDots,numDxs,96);

for ch = 1:96
   if dataT.goodCh(ch) == 1
       for dt = 1:numDots
           for dx = 1:numDxs
               conNoiseSig = dataT.conNoiseSig(end,dt,dx,ch);
               conRadSig = dataT.conRadSig(end,dt,dx,ch);
               radNoiseSig = dataT.radNoiseSig(end,dt,dx,ch);
               
               numSig(dt,dx,ch) = conNoiseSig+conRadSig+radNoiseSig;
           end
       end
   else
       numSig(dt,dx,ch) = nan;
   end
end
dataT.numSigStimComps = numSig;
%% break up by which stimulus is preferred
% dataT.dprimeRankBlank matrices layout
% row1 = concentric
% row2 = radial
% row3 = noise

% 
conSig = nan(numDots,numDxs,4);
radSig = nan(numDots,numDxs,4);
noiseSig = nan(numDots,numDxs,4);

for dt = 1:numDots
    for dx = 1:numDxs
        theseRanks = dataT.dPrimeRankBlank{dt,dx};
        % go through each of the three stimuli, and find out how many
        % significant comparisons there are when it is deemed the preferred
        % stimulus.  That is, how frequently are the different forms
        % distinguishable from one another vs stimulus is simply
        % significantly different from noise.  
        
        con1 = find(theseRanks(1,:) == 1);  
        conSig(dt,dx,1) = sum(numSig(dt,dx,con1) == 0);% no difference between the stimulus types
        conSig(dt,dx,2) = sum(numSig(dt,dx,con1) == 1);
        conSig(dt,dx,3) = sum(numSig(dt,dx,con1) == 2);
        conSig(dt,dx,4) = sum(numSig(dt,dx,con1) == 3);% all three stimuli are significantly different from zero and one another.
        
        rad1 = find(theseRanks(2,:) == 1);  
        radSig(dt,dx,1) = sum(numSig(dt,dx,rad1) == 0);
        radSig(dt,dx,2) = sum(numSig(dt,dx,rad1) == 1);
        radSig(dt,dx,3) = sum(numSig(dt,dx,rad1) == 2);
        radSig(dt,dx,4) = sum(numSig(dt,dx,rad1) == 3);
        
        noise1 = find(theseRanks(3,:) == 1);  
        noiseSig(dt,dx,1) = sum(numSig(dt,dx,noise1) == 0);
        noiseSig(dt,dx,2) = sum(numSig(dt,dx,noise1) == 1);
        noiseSig(dt,dx,3) = sum(numSig(dt,dx,noise1) == 2);
        noiseSig(dt,dx,4) = sum(numSig(dt,dx,noise1) == 3);
    end
end

dataT.numConSigComps = conSig;
dataT.numRadSigComps = radSig;
dataT.numNoiseSigComps = noiseSig;
