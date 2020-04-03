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
   end
end
dataT.numSigStimComps = numSig;
%% break up by which stimulus is preferred
% dataT.dprimeRankBlank matrices layout
% row1 = concentric
% row2 = radial
% row3 = noise

% 
conSig = nan(numDots,numDxs,4,96);
radSig = nan(numDots,numDxs,4,96);
noiseSig = nan(numDots,numDxs,4,96);

for dt = 1:numDots
    for dx = 1:numDxs
        theseRanks = dataT.dPrimeRankBlank{dt,dx};
        % go through each of the three stimuli, and find out how many
        % significant comparisons there are when it is deemed the preferred
        % stimulus.  That is, how frequently are the different forms
        % distinguishable from one another vs stimulus is simply
        % significantly different from noise.  
        
        con1 = find(theseRanks(1,:) == 1);  
        conSig(dt,dx,1,:) = sum(numSig(dt,dx,con1) == 0);% no difference between the stimulus types
        conSig(dt,dx,2,:) = sum(numSig(dt,dx,con1) == 1);
        conSig(dt,dx,3,:) = sum(numSig(dt,dx,con1) == 2);
        conSig(dt,dx,4,:) = sum(numSig(dt,dx,con1) == 3);% all three stimuli are significantly different from zero and one another.
        
        rad1 = find(theseRanks(2,:) == 1);  
        radSig(dt,dx,1,:) = sum(numSig(dt,dx,rad1) == 0);
        radSig(dt,dx,2,:) = sum(numSig(dt,dx,rad1) == 1);
        radSig(dt,dx,3,:) = sum(numSig(dt,dx,rad1) == 2);
        radSig(dt,dx,4,:) = sum(numSig(dt,dx,rad1) == 3);
        
        noise1 = find(theseRanks(3,:) == 1);  
        noiseSig(dt,dx,1,:) = sum(numSig(dt,dx,noise1) == 0);
        noiseSig(dt,dx,2,:) = sum(numSig(dt,dx,noise1) == 1);
        noiseSig(dt,dx,3,:) = sum(numSig(dt,dx,noise1) == 2);
        noiseSig(dt,dx,4,:) = sum(numSig(dt,dx,noise1) == 3);
    end
end

dataT.numConSigComps = conSig;
dataT.numRadSigComps = radSig;
dataT.numNoiseSigComps = noiseSig;
%% plotting
dt = 2;
dx = 2;

figure(1)
clf

hold on
ranks = dataT.dPrimeRankBlank{dt,dx};

con1st = sum(ranks(1,:) == 1);
rad1st = sum(ranks(2,:) == 1);
noise1st = sum(ranks(3,:) == 1);
totalSig = (con1st+rad1st+noise1st);

conProp = con1st/totalSig;
radProp = rad1st/totalSig;
noiseProp = noise1st/totalSig;

nsubplot(2,2,1,dx);

hold on
bar(1,con1st,0.75,'FaceColor','none','EdgeColor','k')
bar(1.75,rad1st,0.75,'FaceColor','none','EdgeColor','k')
bar(2.5,noise1st,0.75,'FaceColor','none','EdgeColor','k')


ylim([0 sum(dataT.goodCh)])
xlim([0.5, 3])

set(gca,'XTick',[1, 1.75 2.5],'XTickLabel',{'concentric','radial','dipole'})
xtickangle(45)

 %%
conSig2 = squeeze(dataT.numConSigComps(dt,dx,:,:)); 
radSig2 = squeeze(dataT.numRadSigComps(dt,dx,:,:)); 
nosSig2 = squeeze(dataT.numNoiseSigComps(dt,dx,:,:)); 

SigSum(1,1) = sum(conSig2(:) == 0);
SigSum(1,2) = sum(conSig2(:) == 1);
SigSum(1,3) = sum(conSig2(:) == 2);
SigSum(1,4) = sum(conSig2(:) == 3);


SigSum(2,1) = sum(radSig2(:) == 0);
SigSum(2,2) = sum(radSig2(:) == 1);
SigSum(2,3) = sum(radSig2(:) == 2);
SigSum(2,4) = sum(radSig2(:) == 3);


SigSum(3,1) = sum(nosSig2(:) == 0);
SigSum(3,2) = sum(nosSig2(:) == 1);
SigSum(3,3) = sum(nosSig2(:) == 2);
SigSum(3,4) = sum(nosSig2(:) == 3);

%%
nsubplot(2,2,dt,dx);
hold on

bar(SigSum','stacked')








