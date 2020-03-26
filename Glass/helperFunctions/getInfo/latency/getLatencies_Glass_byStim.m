function  [dataT] = getLatencies_Glass_byStim(dataT,numBoot,holdout)
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
                    %% bootstrap
                    for nb = 1:numBoot
                        blankTrials = blankNdx;
                        conTrials = (dotNdx & dxNdx & conNdx & cohNdx);
                        radTrials = (dotNdx & dxNdx & radNdx & cohNdx);
                        noiseTrials = (dotNdx & dxNdx & noiseNdx);
                        trials = 1:size(dataT.bins,1);
                        
                        if holdout == 0
                            numStimTrials = sum(conTrials);
                        else
                            numConTrials = round(length(find(conTrials))*holdout);
                            numRadTrials = round(length(find(radTrials))*holdout);
                            numNoiseTrials = round(length(find(noiseTrials))*holdout);
                            numBlankTrials = round(length(find(blankTrials))*holdout);
                        end
                        % subsample for onset and offset
                        conNdxOn = subsampleStimuli((conTrials), numConTrials);
                        radNdxOn = subsampleStimuli((radTrials), numRadTrials);
                        noiseNdxOn = subsampleStimuli((noiseTrials), numNoiseTrials);
                        blankNdxOn = subsampleBlanks((blankNdx), numBlankTrials);
                        
                        conNdxOff = subsampleStimuli((conTrials), numConTrials);
                        radNdxOff = subsampleStimuli((radTrials), numRadTrials);
                        noiseNdxOff = subsampleStimuli((noiseTrials), numNoiseTrials);
                        blankNdxOff = subsampleBlanks((blankNdx), numBlankTrials);
                        
                        % blank
                        blankTrialsOn = dataT.bins((blankNdxOn),startCheckOn:endCheckOn,ch);
                        blankTrialsOff = dataT.bins((blankNdxOff),startCheckOff:endCheckOff,ch);
                        
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
                    end
                    %% Onset
                    % concentric
                    maxConBinT = mode(bootConMaxBinOn); % find the bin that is most often designated as the max.
                    muConRespsOn = mean(abs(bootConRespsOn));
                    maxConResp = muConRespsOn(maxConBinT); % get the mean response at that bin across all of the bootstraps
                    halfMaxConOn = maxConResp/2; % figure out what value half max is
                    
                    lat = find((muConRespsOn >= halfMaxConOn));
                    conBlankOnLat(co,ndot,dx,ch) = lat(1)-1;
                    
                    % radial
                    maxRadBinT = mode(bootRadMaxBinOn); % find the bin that is most often designated as the max.
                    muRadRespsOn = mean(abs(bootRadRespsOn));
                    maxRadResp = muRadRespsOn(maxRadBinT); % get the mean response at that bin across all of the bootstraps
                    halfMaxRadOn = maxRadResp/2; % figure out what value half max is
                    
                    lat = find((muRadRespsOn >= halfMaxRadOn));
                    radBlankOnLat(co,ndot,dx,ch) = lat(1)-1;
                    
                    % noise
                    maxNoiseBinT = mode(bootNoiseMaxBinOn); % find the bin that is most often designated as the max.
                    muNoiseRespsOn = mean(abs(bootNoiseRespsOn));
                    maxNoiseResp = muNoiseRespsOn(maxNoiseBinT); % get the mean response at that bin across all of the bootstraps
                    halfMaxNoiseOn = maxNoiseResp/2; % figure out what value half max is
                    
                    lat = find((muNoiseRespsOn >= halfMaxNoiseOn));
                    noiseBlankOnLat(ndot,dx,ch) = lat(1)-1;
                    
                    conBlankOnLatBoot(co,ndot,dx,ch,:) = bootConMaxBinOn;
                    radBlankOnLatBoot(co,ndot,dx,ch,:) = bootRadMaxBinOn;
                    noiseBlankOnLatBoot(ndot,dx,ch,:) = bootNoiseMaxBinOn;
                    %% Offset
                    % find the minimum response, then
                    % the point at which the response drops to 50% above the minimum respons (must occur after the max).
                    muConRespsOff = mean(abs(bootConRespsOff));
                    minConBinOff = mode(bootConMinBinOff); % find the bin that is most often designated as the min.
                    minConResp = muConRespsOff(minConBinOff); % get the mean response at that bin across all of the bootstraps
                    
                    if minConBinOff == size(bootConRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                        conBlankOffLat(co,ndot,dx,ch) = minConBinOff;
                    else
                        if minConResp < 0
                            minConResp = 0.01;
                        end
                        halfMin = minConResp*2;

                        %muResps2 = muConRespsOff(minConBinOff+1:end);
                        muResps2 = muConRespsOff(1:minConBinOff);
                        latOff = find((muResps2 <= halfMin));
                        conBlankOffLat(co,ndot,dx,ch) = (latOff(1));
                    end
                    
                    % radial
                    muRadRespsOff = mean(abs(bootRadRespsOff));
                    minRadBinOff = mode(bootRadMinBinOff); % find the bin that is most often designated as the min.
                    minRadResp = muRadRespsOff(minRadBinOff); % get the mean response at that bin across all of the bootstraps
                    
                    if minRadBinOff == size(bootRadRespsOff,2)
                        radBlankOffLat(co,ndot,dx,ch) = minRadBinOff;
                    else
                        if minRadResp < 0
                            minRadResp = 0.01;
                        end
                        
                        halfMin = minRadResp*2;
                        
                        %muResps2 = muRadRespsOff(maxRadBinOff+1:end);
                        muResps2 = muRadRespsOff(1:minRadBinOff);
                        latOff = find((muResps2 <= halfMin));
                        radBlankOffLat(co,ndot,dx,ch) = (latOff(1));
                    end
                    
                    % noise
                    muNoiseRespsOff = mean(abs(bootNoiseRespsOff));
                    minNoiseBinOff = mode(bootNoiseMinBinOff); % find the bin that is most often designated as the min.
                    minNoiseResp = muNoiseRespsOff(minNoiseBinOff); % get the mean response at that bin across all of the bootstraps
                    
                    if minNoiseBinOff == size(bootNoiseRespsOff,2)
                        noiseBlankOffLat(ndot,dx,ch) = minNoiseBinOff;
                    else
                        if minNoiseResp < 0
                            minNoiseResp = 0.01;
                        end
                        
                        halfMin = minNoiseResp*2;
                        
                        muResps2 = muNoiseRespsOff(1:minNoiseBinOff);
                        latOff = find((muResps2 <= halfMin));
                        noiseBlankOffLat(ndot,dx,ch) = (latOff(1));
                    end
                    
                    conBlankOffLatBoot(co,ndot,dx,ch,:) = bootConMaxBinOff;
                    radBlankOffLatBoot(co,ndot,dx,ch,:) = bootRadMaxBinOff;
                    noiseBlankOffLatBoot(ndot,dx,ch,:)  = bootNoiseMaxBinOff;
                end
            end
        end
    end
end
%% adjust offsets and save to data structure
dataT.conBlankOnLat = (conBlankOnLat+(startCheckOn-1))*10;
dataT.radBlankOnLat = (radBlankOnLat+(startCheckOn-1))*10;
dataT.noiseBlankOnLat = (noiseBlankOnLat+(startCheckOn-1))*10;

dataT.conBlankOffLat = (conBlankOffLat+(startCheckOff-1))*10;
dataT.radBlankOffLat = (radBlankOffLat+(startCheckOff-1))*10;
dataT.noiseBlankOffLat = (noiseBlankOffLat+(startCheckOff-1))*10;

dataT.conBlankOffLatBoot = (conBlankOffLatBoot+(startCheckOff-1))*10;
dataT.radBlankOffLatBoot = (radBlankOffLatBoot+(startCheckOff-1))*10;
dataT.noiseBlankOffLatBoot = (noiseBlankOffLatBoot+(startCheckOff-1))*10;

dataT.conBlankOnLatBoot = (conBlankOnLatBoot+(startCheckOn-1))*10;
dataT.radBlankOnLatBoot = (radBlankOnLatBoot+(startCheckOn-1))*10;
dataT.noiseBlankOnLatBoot = (noiseBlankOnLatBoot+(startCheckOn-1))*10;




