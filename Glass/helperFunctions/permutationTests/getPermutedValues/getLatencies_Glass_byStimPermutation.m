function  [dataT] = getLatencies_Glass_byStimPermutation(dataT,numBoot,holdout)
% This function returns a vector containing the latency of each channel in
% response to each Glass pattern.
% Latency measurement is the half max. The only other requirement is the
% latency has to come after the minimum response, so if there is an initial
% decrement before the response, it won't count that. offset latency - find the minimum response, then
% the point at which the response drops to within 5% of that.
%%
[~,numDots,numDxs,numCoh,~,~,dots,dxs,coherences,~] = getGlassParameters(dataT);
numCh = size(dataT.bins,3);
%%
conBlankOnLat = nan(numCoh,numDots, numDxs, numCh);
radBlankOnLat = nan(numCoh,numDots, numDxs, numCh);
noiseBlankOnLat = nan(numDots, numDxs, numCh);

conBlankOffLat = nan(numCoh,numDots, numDxs, numCh);
radBlankOffLat = nan(numCoh,numDots, numDxs, numCh);
noiseBlankOffLat = nan(numDots, numDxs, numCh);

conBlankOnLatBoot = nan(numCoh,numDots, numDxs, numCh, numBoot);
radBlankOnLatBoot = nan(numCoh,numDots, numDxs, numCh, numBoot);
noiseBlankOnLatBoot = nan(numDots, numDxs, numCh, numBoot);

conBlankOffLatBoot = nan(numCoh,numDots, numDxs, numCh, numBoot);
radBlankOffLatBoot = nan(numCoh,numDots, numDxs, numCh, numBoot);
noiseBlankOffLatBoot = nan(numDots, numDxs, numCh, numBoot);
%%
for ch = 1:numCh
    if dataT.goodCh(ch) == 1
        startCheckOn = 5;
        endCheckOn = 20;
        
        startCheckOff = 20;
        endCheckOff = 35;
        
        conNdx   = (dataT.type == 1);
        noiseNdx = (dataT.type == 0);
        radNdx   = (dataT.type == 2);
        blankNdx = (dataT.numDots == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    conLatOn = nan(1,numBoot);
                    radLatOn = nan(1,numBoot);
                    noiseLatOn = nan(1,numBoot);
                    
                    conLatOff = nan(1,numBoot);
                    radLatOff = nan(1,numBoot);
                    noiseLatOff = nan(1,numBoot);
                    
                    dotNdx = (dataT.numDots == dots(ndot));
                    dxNdx = (dataT.dx == dxs(dx));
                    cohNdx = (dataT.coh == coherences(co));
                    
                    bootConRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
                    bootConRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
                    bootConMaxBinOn = nan(1,numBoot);
                    bootConMaxBinOff = nan(1,numBoot);
                    bootConMinBinOff = nan(1,numBoot);
                    
                    bootRadRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
                    bootRadRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
                    bootRadMaxBinOn = nan(1,numBoot);
                    bootRadMaxBinOff = nan(1,numBoot);
                    bootRadMinBinOff = nan(1,numBoot);
                    
                    bootNoiseRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
                    bootNoiseRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
                    bootNoiseMaxBinOn = nan(1,numBoot);
                    bootNoiseMaxBinOff = nan(1,numBoot);
                    bootNoiseMinBinOff = nan(1,numBoot);
                    
                    blankTrials = blankNdx;
                    conTrials = (dotNdx & dxNdx & conNdx & cohNdx);
                    radTrials = (dotNdx & dxNdx & radNdx & cohNdx);
                    noiseTrials = (dotNdx & dxNdx & noiseNdx);
                    trials = 1:size(dataT.bins,1);
                    
                    numConTrials = round(length(find(conTrials))*holdout);
                    numRadTrials = round(length(find(radTrials))*holdout);
                    numNoiseTrials = round(length(find(noiseTrials))*holdout);
                    numBlankTrials = round(length(find(blankTrials))*holdout);
                    
                    %% bootstrap
                    for nb = 1:numBoot
                        
                        % subsample for onset and offset
                        [blankNdxOn, unusedNdxs] = subsampleBlanks((trials), numBlankTrials);
                        conNdxOn = subsampleStimuli((unusedNdxs), numConTrials);
                        radNdxOn = subsampleStimuli((unusedNdxs), numRadTrials);
                        noiseNdxOn = subsampleStimuli((unusedNdxs), numNoiseTrials);
                        
                        
                        [blankNdxOff, unusedNdxs] = subsampleBlanks((trials), numBlankTrials);
                        conNdxOff = subsampleStimuli((unusedNdxs), numConTrials);
                        radNdxOff = subsampleStimuli((unusedNdxs), numRadTrials);
                        noiseNdxOff = subsampleStimuli((unusedNdxs), numNoiseTrials); 
                        
                        % boot strap to find the bin with the maximum response to use
                        % to find the onset latency
                        conRespOn = mean(smoothdata(dataT.bins(conNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                        radRespOn = mean(smoothdata(dataT.bins(radNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                        noiseRespOn = mean(smoothdata(dataT.bins(noiseNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                        blankRespOn = mean(smoothdata(dataT.bins(blankNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                        
                        bootConRespsOn(nb,:) = conRespOn - blankRespOn;
                        muConRespsOnT = abs(bootConRespsOn(nb,:));
                        [~,bootConMaxBinOn(1,nb)] = max(muConRespsOnT);
                        
                        bootRadRespsOn(nb,:) = radRespOn - blankRespOn;
                        muRadRespsOnT = abs(bootRadRespsOn(nb,:));
                        [~,bootRadMaxBinOn(1,nb)] = max(muRadRespsOnT);
                        
                        bootNoiseRespsOn(nb,:) = noiseRespOn - blankRespOn;
                        muNoiseRespsOnT = abs(bootNoiseRespsOn(nb,:));
                        [~,bootNoiseMaxBinOn(1,nb)] = max(muNoiseRespsOnT);
                        
                        % Now, do the same but for the offset latency
                        conRespOff = mean(smoothdata(dataT.bins(conNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                        radRespOff = mean(smoothdata(dataT.bins(radNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                        noiseRespOff = mean(smoothdata(dataT.bins(noiseNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                        blankRespOff = mean(smoothdata(dataT.bins(blankNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                        
                        %concentric
                        bootConRespsOff(nb,:) = conRespOff - blankRespOff;
                        muConRespsOffT = abs(bootConRespsOff(nb,:));
                        
                        % check for responses that increase during stim off
                        % period
                        earlyConResp = mean(mean(bootConRespsOff(nb,1:3)));
                        lateConResp = mean(mean(bootConRespsOff(nb,end-2:end)));
                        
                        if lateConResp > earlyConResp
                            bootConMinBinOff(1,nb) = length(muConRespsOffT);
                        else
                            [~,bootConMaxBinOff(1,nb)] = max(muConRespsOffT);
                            [~,minConT] = min(muConRespsOffT(bootConMaxBinOff(1,nb):end));% find the minimum that follows the maximum (this helps with channels that have continually increasing responses).
                            bootConMinBinOff(1,nb) = minConT+(bootConMaxBinOff(1,nb)-1); %make sure to index the correct bin
                        end
                        
                        %radial
                        bootRadRespsOff(nb,:) = radRespOff - blankRespOff;
                        muRadRespsOffT = abs(bootRadRespsOff(nb,:));
                        
                        % check for responses that increase during stim off
                        % period
                        earlyRadResp = mean(mean(bootRadRespsOff(nb,1:3)));
                        lateRadResp = mean(mean(bootRadRespsOff(nb,end-2:end)));
                        
                        if lateRadResp > earlyRadResp
                            bootRadMinBinOff(1,nb) = length(muRadRespsOffT);
                        else
                            [~,bootRadMaxBinOff(1,nb)] = max(muRadRespsOffT);
                            [~,minRadT] = min(muRadRespsOffT(bootRadMaxBinOff(1,nb):end));% find the minimum that follows the maximum (this helps with channels that have continually increasing responses).
                            bootRadMinBinOff(1,nb) = minRadT+(bootRadMaxBinOff(1,nb)-1); %make sure to index the correct bin
                        end
                        
                        %noise
                        bootNoiseRespsOff(nb,:) = noiseRespOff - blankRespOff;
                        muNoiseRespsOffT = abs(bootNoiseRespsOff(nb,:));
                        
                        % check for responses that increase during stim off
                        % period
                        earlyNoiseResp = mean(mean(bootNoiseRespsOff(nb,1:3)));
                        lateNoiseResp = mean(mean(bootNoiseRespsOff(nb,end-2:end)));
                        
                        if lateNoiseResp > earlyNoiseResp
                            bootNoiseMinBinOff(1,nb) = length(muNoiseRespsOffT);
                        else
                            [~,bootNoiseMaxBinOff(1,nb)] = max(muNoiseRespsOffT);
                            [~,minNoiseT] = min(muNoiseRespsOffT(bootNoiseMaxBinOff(1,nb):end));% find the minimum that follows the maximum (this helps with channels that have continually increasing responses).
                            bootNoiseMinBinOff(1,nb) = minNoiseT+(bootNoiseMaxBinOff(1,nb)-1); %make sure to index the correct bin
                        end
                        
                        %% Onset
                        % concentric
                        muConRespsOn = abs(bootConRespsOn(nb,:));
                        maxResp = muConRespsOn(bootConMaxBinOn(1,nb)); % get the mean response at that bin across all of the bootstraps
                        halfMax = maxResp/2; % figure out what value half max is
                        maxConBin(1,nb) = maxResp;
                        
                        lat = find((muConRespsOn >= halfMax));
                        conLatOn(1,nb) = lat(1)-1;
                        
                        % radial
                        muRadRespsOn = abs(bootRadRespsOn(nb,:));
                        maxResp = muRadRespsOn(bootRadMaxBinOn(1,nb)); % get the mean response at that bin across all of the bootstraps
                        halfMax = maxResp/2; % figure out what value half max is
                        maxRadBin(1,nb) = maxResp;
                        
                        lat = find((muRadRespsOn >= halfMax));
                        radLatOn(1,nb) = lat(1)-1;
                        
                        % noise
                        muNoiseRespsOn = abs(bootNoiseRespsOn(nb,:));
                        maxResp = muNoiseRespsOn(bootNoiseMaxBinOn(1,nb)); % get the mean response at that bin across all of the bootstraps
                        halfMax = maxResp/2; % figure out what value half max is
                        maxNoiseBin(1,nb) = maxResp;
                        
                        lat = find((muNoiseRespsOn >= halfMax));
                        noiseLatOn(1,nb) = lat(1)-1;
                        %% Offset
                        
                        % find the minimum response, then
                        % the point at which the response drops to 50% above the minimum respons (must occur after the max).
                        muConRespsOff = abs(bootConRespsOff(nb,:));
                        minResp = muConRespsOff(bootConMinBinOff(1,nb)); % get the mean response at that bin across all of the bootstraps
                        
                        if bootConMinBinOff(1,nb) == size(bootConRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                            conLatOff(1,nb) = bootConMinBinOff(1,nb);
                        else
                            if minResp < 0
                                minResp = 0.01;
                            end
                            halfMin = minResp*2;
                            
                            %muResps2 = muConRespsOff(minConBinOff+1:end);
                            muResps2 = muConRespsOff(1:bootConMinBinOff(1,nb));
                            latOff = find((muResps2 <= halfMin));
                            conLatOff(1,nb) = (latOff(1));
                        end
                        
                        % radial
                        muRadRespsOff = abs(bootRadRespsOff(nb,:));
                        minResp = muRadRespsOff(bootRadMinBinOff(1,nb)); % get the mean response at that bin across all of the bootstraps
                        
                        if bootRadMinBinOff(1,nb) == size(bootRadRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                            radLatOff(1,nb) = bootRadMinBinOff(1,nb);
                        else
                            if minResp < 0
                                minResp = 0.01;
                            end
                            halfMin = minResp*2;
                            
                            %muResps2 = muConRespsOff(minConBinOff+1:end);
                            muResps2 = muRadRespsOff(1:bootRadMinBinOff(1,nb));
                            latOff = find((muResps2 <= halfMin));
                            radLatOff(1,nb) = (latOff(1));
                        end
                        
                        % noise
                        muNoiseRespsOff = abs(bootNoiseRespsOff(nb,:));
                        minResp = muNoiseRespsOff(bootNoiseMinBinOff(1,nb)); % get the mean response at that bin across all of the bootstraps
                        
                        if bootNoiseMinBinOff(1,nb) == size(bootNoiseRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                            noiseLatOff(1,nb) = bootNoiseMinBinOff(1,nb);
                        else
                            if minResp < 0
                                minResp = 0.01;
                            end
                            halfMin = minResp*2;
                            
                            %muResps2 = muConRespsOff(minConBinOff+1:end);
                            muResps2 = muNoiseRespsOff(1:bootNoiseMinBinOff(1,nb));
                            latOff = find((muResps2 <= halfMin));
                            noiseLatOff(1,nb) = (latOff(1));
                        end
                    end
                    
                    conBlankOnLat(co,ndot,dx,ch) = mean(conLatOn);
                    radBlankOnLat(co,ndot,dx,ch) = mean(radLatOn);
                    noiseBlankOnLat(ndot,dx,ch) = mean(noiseLatOn);
                    
                    conBlankOnLatBoot(co,ndot,dx,ch,:) = conLatOn;
                    radBlankOnLatBoot(co,ndot,dx,ch,:) = radLatOn;
                    noiseBlankOnLatBoot(ndot,dx,ch,:)  = noiseLatOn;
                    
                    conBlankOffLat(co,ndot,dx,ch) = mean(conLatOff);
                    radBlankOffLat(co,ndot,dx,ch) = mean(radLatOff);
                    noiseBlankOffLat(ndot,dx,ch) = mean(noiseLatOff);
                    
                    conBlankOffLatBoot(co,ndot,dx,ch,:) = conLatOff;
                    radBlankOffLatBoot(co,ndot,dx,ch,:) = radLatOff;
                    noiseBlankOffLatBoot(ndot,dx,ch,:)  = noiseLatOff;
                end
            end
        end
    end
end
%% adjust offsets and save to data structure
dataT.conBlankOnLatPerm = (conBlankOnLat+(startCheckOn-1))*10;
dataT.radBlankOnLatPerm = (radBlankOnLat+(startCheckOn-1))*10;
dataT.noiseBlankOnLatPerm = (noiseBlankOnLat+(startCheckOn-1))*10;

dataT.conBlankOffLatPerm = (conBlankOffLat+(startCheckOff-1))*10;
dataT.radBlankOffLatPerm = (radBlankOffLat+(startCheckOff-1))*10;
dataT.noiseBlankOffLatPerm = (noiseBlankOffLat+(startCheckOff-1))*10;

dataT.conBlankOffLatBootPerm = (conBlankOffLatBoot+(startCheckOff-1))*10;
dataT.radBlankOffLatBootPerm = (radBlankOffLatBoot+(startCheckOff-1))*10;
dataT.noiseBlankOffLatBootPerm = (noiseBlankOffLatBoot+(startCheckOff-1))*10;

dataT.conBlankOnLatBootPerm = (conBlankOnLatBoot+(startCheckOn-1))*10;
dataT.radBlankOnLatBootPerm = (radBlankOnLatBoot+(startCheckOn-1))*10;
dataT.noiseBlankOnLatBootPerm = (noiseBlankOnLatBoot+(startCheckOn-1))*10;




