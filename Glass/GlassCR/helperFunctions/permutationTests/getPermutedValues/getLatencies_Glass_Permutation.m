function  [dataT] = getLatencies_Glass_Permutation(dataT,numBoot,plotFlag)
% This function returns a vector containing the latency of each channel in response to any
% visual stimulus.
% Latency measurement is the half max. The only other requirement is the
% latency has to come after the minimum response, so if there is an initial
% decrement before the response, it won't count that. offset latency - find the minimum response, then
% the point at which the response drops to within 5% of that.
%
%
% PLOTFLAG = 1 If you want to plot PSTHs with the
% latency marked.
%
%%
onsetLatency = nan(1,96);
offsetLatency = nan(1,96);
onLatBoot = nan(96,numBoot);
offLatBoot = nan(96,numBoot);

maxBin = nan(1,numBoot,96);
minBin = nan(1,numBoot,96);

startCheckOn = 5;
endCheckOn = 20;

startCheckOff = 20;
endCheckOff = 30;

%%
parfor ch = 1:96
    if dataT.goodCh(ch) == 1
        bootRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
        bootRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
        bootMaxBinOn = nan(1,numBoot);
        bootMaxBinOff = nan(1,numBoot);
        bootMinBinOff = nan(1,numBoot);
        onLat = nan(1,numBoot);
        offLat = nan(1,numBoot);
        
        blankNdx = (dataT.numDots == 0);
        stimNdx = (dataT.numDots ~= 0);
        blankTrialsOn = dataT.bins((blankNdx),startCheckOn:endCheckOn,ch);
        blankTrialsOff = dataT.bins((blankNdx),startCheckOff:endCheckOff,ch);
        
        for nb = 1:numBoot
            numTrialsOn = round(size(blankTrialsOn,1)*.8);
            stimNdxOn = subsampleStimuli((stimNdx), numTrialsOn);
            blankNdxOn = subsampleBlanks((blankNdx), numTrialsOn);
            
            % boot strap to find the bin with the maximum response to use
            % to find the onset latency
            stimRespOn = mean(smoothdata(dataT.bins(stimNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
            blankRespOn = mean(smoothdata(dataT.bins(blankNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
            bootRespsOn(nb,:) = stimRespOn - blankRespOn;
            muRespsOnT = abs(bootRespsOn(nb,:));
            [~,bootMaxBinOn(1,nb)] = max(muRespsOnT);
            
            
            numTrialsOff = round(size(blankTrialsOff,1)*.8);
            stimNdxOff = subsampleStimuli((stimNdx), numTrialsOff);
            blankNdxOff = subsampleBlanks((blankNdx), numTrialsOff);
            % bootstrap to find the bin with the minimum response
            stimRespOff = mean(smoothdata(dataT.bins(stimNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
            blankRespOff = mean(smoothdata(dataT.bins(blankNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
            
            bootRespsOff(nb,:) = stimRespOff - blankRespOff;
            muRespsOffT = abs(bootRespsOff(nb,:));
            
            % check for responses that increase during stim off
            % period
            earlyResp = mean(mean(bootRespsOff(nb,1:3)));
            lateResp = mean(mean(bootRespsOff(nb,end-2:end)));
            
            if lateResp > earlyResp
                bootMinBinOff(1,nb) = length(muRespsOffT);
            else
                [~,bootMaxBinOff(1,nb)] = max(muRespsOffT);
                [~,minRadT] = min(muRespsOffT(bootMaxBinOff(1,nb):end));% find the minimum that follows the maximum (this helps with channels that have continually increasing responses).
                bootMinBinOff(1,nb) = minRadT+(bootMaxBinOff(1,nb)-1); %make sure to index the correct bin
            end
            
            %% onset
            
            muRespsOn = abs(bootRespsOn(nb,:));
            maxResp = muRespsOn(bootMaxBinOn(1,nb)); % get the mean response at that bin across all of the bootstraps
            halfMax = maxResp/2; % figure out what value half max is
            maxBin(1,nb,ch) = maxResp;
            
            lat = find((muRespsOn >= halfMax));
            onLat(1,nb) = lat(1)-1;
            %% offset
            % find the minimum response, then
            % the point at which the response drops to 50% above the minimum respons (must occur after the max).
            muRespsOff = abs(bootRespsOff(nb,:));
            minResp = muRespsOff(bootMinBinOff(1,nb)); % get the mean response at that bin across all of the bootstraps
            
            if bootMinBinOff(1,nb) == size(bootRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                offLat(1,nb) = bootMinBinOff(1,nb);
            else
                if minResp < 0
                    minResp = 0.01;
                end
                halfMin = minResp*2;
                
                %muResps2 = muConRespsOff(minConBinOff+1:end);
                muResps2 = muRespsOff(1:bootMinBinOff(1,nb));
                latOff = find((muResps2 <= halfMin));
                offLat(1,nb) = (latOff(1));
            end
        end
        onsetLatency(1,ch) = mean(onLat);
        offsetLatency(1,ch) = mean(offLat);
        
        onLatBoot(ch,:) = onLat;
        offLatBoot(ch,:) = offLat;
    end
end
% need to add on whatever the offset is - right now bin1=startCheck,
% subtract 1 b/c fenceposts
% multiply by 10, so it's in ms, not bin number
onsetLatency = (onsetLatency+(startCheckOn-1))*10;
onLatBoot = (onLatBoot+(startCheckOn-1))*10;
maxBin = maxBin+(startCheckOn-1);


% for offset, we add 1
offsetLatency = (offsetLatency+(startCheckOff-1))*10;
offLatBoot = (offLatBoot+(startCheckOff-1))*10;
%minBin = minBin+(startCheckOff-1);
%%
dataT.onsetLatencyAllStimPerm = onsetLatency;
dataT.maxBinAllStimPerm = maxBin;
dataT.onLatBootAllStimPerm = onLatBoot;

dataT.offsetLatencyAllStimPerm = offsetLatency;
dataT.offLatBootAllStimPerm = offLatBoot;
%% sanity checking plot
if plotFlag == 1
    plotGlassPSTHs_Latency_AllStim(dataT)
end





