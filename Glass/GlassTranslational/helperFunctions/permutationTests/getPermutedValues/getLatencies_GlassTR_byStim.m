function  [dataT] = getLatencies_GlassTR_byStim(dataT,numBoot,holdout)
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
[numOris,numDots,numDxs,numCoh,~,oris,dots,dxs,coherences] = getGlassTRParameters(dataT);
numCh = size(dataT.bins,3);
%%
linBlankOnLat = nan(numOris,numCoh,numDots, numDxs, numCh);
noiseBlankOnLat = nan(numDots, numDxs, numCh);

linBlankOffLat = nan(numOris,numCoh,numDots, numDxs, numCh);
noiseBlankOffLat = nan(numDots, numDxs, numCh);

linBlankOnLatBoot = nan(numOris,numCoh,numDots, numDxs, numCh, numBoot);
noiseBlankOnLatBoot = nan(numDots, numDxs, numCh, numBoot);

linBlankOffLatBoot = nan(numOris,numCoh,numDots, numDxs, numCh, numBoot);
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
        blankNdx = (dataT.numDots == 0);
        
        for ndot = 1:numDots
            for dx = 1:numDxs
                for co = 1:numCoh
                    for or = 1:numOris
                        
                        dotNdx = (dataT.numDots == dots(ndot));
                        dxNdx = (dataT.dx == dxs(dx));
                        cohNdx = (dataT.coh == coherences(co));
                        orNdx = (dataT.rotation == oris(or));
                        
                        bootLinRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
                        bootLinRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
                        bootLinMaxBinOn = nan(1,numBoot);
                        bootLinMaxBinOff = nan(1,numBoot);
                        bootLinMinBinOff = nan(1,numBoot);
                        
                        bootNoiseRespsOn = nan(numBoot,length(startCheckOn:endCheckOn));
                        bootNoiseRespsOff = nan(numBoot,length(startCheckOff:endCheckOff));
                        bootNoiseMaxBinOn = nan(1,numBoot);
                        bootNoiseMaxBinOff = nan(1,numBoot);
                        bootNoiseMinBinOff = nan(1,numBoot);
                        %% bootstrap
                        for nb = 1:numBoot
                            blankTrials = blankNdx;
                            linTrials = (dotNdx & dxNdx & cohNdx & orNdx);
                            noiseTrials = (dotNdx & dxNdx & noiseNdx);

                            numLinTrials = round(length(find(linTrials))*holdout);
                            numNoiseTrials = round(length(find(noiseTrials))*holdout);
                            numBlankTrials = round(length(find(blankTrials))*holdout);
                            
                            % subsample for onset and offset
                            linNdxOn = subsampleStimuli((linTrials), numLinTrials);
                            noiseNdxOn = subsampleStimuli((noiseTrials), numNoiseTrials);
                            blankNdxOn = subsampleBlanks((blankNdx), numBlankTrials);
                            
                            linNdxOff = subsampleStimuli((linTrials), numLinTrials);
                            noiseNdxOff = subsampleStimuli((noiseTrials), numNoiseTrials);
                            blankNdxOff = subsampleBlanks((blankNdx), numBlankTrials);
                            
                            % blank
%                             blankTrialsOn = dataT.bins((blankNdxOn),startCheckOn:endCheckOn,ch);
%                             blankTrialsOff = dataT.bins((blankNdxOff),startCheckOff:endCheckOff,ch);
                            
                            % boot strap to find the bin with the maximum response to use
                            % to find the onset latency
                            linRespOn = mean(smoothdata(dataT.bins(linNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                            noiseRespOn = mean(smoothdata(dataT.bins(noiseNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                            %blankRespOn = mean(smoothdata(dataT.bins(blankTrialsOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                             blankRespOn = mean(smoothdata(dataT.bins(blankNdxOn,startCheckOn:endCheckOn,ch),'gaussian',3))./.01;
                            
                            bootLinRespsOn(nb,:) = linRespOn - blankRespOn;
                            muLinRespsOnT = abs(bootLinRespsOn(nb,:));
                            [~,bootLinMaxBinOn(1,nb)] = max(muLinRespsOnT);
                            
                            bootNoiseRespsOn(nb,:) = noiseRespOn - blankRespOn;
                            muNoiseRespsOnT = abs(bootNoiseRespsOn(nb,:));
                            [~,bootNoiseMaxBinOn(1,nb)] = max(muNoiseRespsOnT);
                            
                            % Now, do the same but for the offset latency
                            linRespOff = mean(smoothdata(dataT.bins(linNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                            noiseRespOff = mean(smoothdata(dataT.bins(noiseNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
%                             blankRespOff = mean(smoothdata(dataT.bins(blankTrialsOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                            blankRespOff = mean(smoothdata(dataT.bins(blankNdxOff,startCheckOff:endCheckOff,ch),'gaussian',3))./.01;
                            
                            %concentric
                            bootLinRespsOff(nb,:) = linRespOff - blankRespOff;
                            muLinRespsOffT = abs(bootLinRespsOff(nb,:));
                            
                            % check for responses that increase during stim off
                            % period
                            earlyLinResp = mean(mean(bootLinRespsOff(nb,1:3)));
                            lateLinResp = mean(mean(bootLinRespsOff(nb,end-2:end)));
                            
                            if lateLinResp > earlyLinResp
                                bootLinMinBinOff(1,nb) = length(muLinRespsOffT);
                            else
                                [~,bootLinMaxBinOff(1,nb)] = max(muLinRespsOffT);
                                [~,minLinT] = min(muLinRespsOffT(bootLinMaxBinOff(1,nb):end));% find the minimum that follows the maximum (this helps with channels that have continually increasing responses).
                                bootLinMinBinOff(1,nb) = minLinT+(bootLinMaxBinOff(1,nb)-1); %make sure to index the correct bin
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
                        maxLinBinT = mode(bootLinMaxBinOn); % find the bin that is most often designated as the max.
                        muLinRespsOn = mean(abs(bootLinRespsOn));
                        maxLinResp = muLinRespsOn(maxLinBinT); % get the mean response at that bin across all of the bootstraps
                        halfMaxLinOn = maxLinResp/2; % figure out what value half max is
                        
                        lat = find((muLinRespsOn >= halfMaxLinOn));
                        linBlankOnLat(or,co,ndot,dx,ch) = lat(1)-1;
                                                
                        % noise
                        maxNoiseBinT = mode(bootNoiseMaxBinOn); % find the bin that is most often designated as the max.
                        muNoiseRespsOn = mean(abs(bootNoiseRespsOn));
                        maxNoiseResp = muNoiseRespsOn(maxNoiseBinT); % get the mean response at that bin across all of the bootstraps
                        halfMaxNoiseOn = maxNoiseResp/2; % figure out what value half max is
                        
                        lat = find((muNoiseRespsOn >= halfMaxNoiseOn));
                        noiseBlankOnLat(ndot,dx,ch) = lat(1)-1;
                        
                        linBlankOnLatBoot(or,co,ndot,dx,ch,:) = bootLinMaxBinOn;
                        noiseBlankOnLatBoot(ndot,dx,ch,:) = bootNoiseMaxBinOn;
                        %% Offset
                        % find the minimum response, then
                        % the point at which the response drops to 50% above the minimum respons (must occur after the max).
                        muLinRespsOff = mean(abs(bootLinRespsOff));
                        minLinBinOff = mode(bootLinMinBinOff); % find the bin that is most often designated as the min.
                        minLinResp = muLinRespsOff(minLinBinOff); % get the mean response at that bin across all of the bootstraps
                        
                        if minLinBinOff == size(bootLinRespsOff,2) % if the response is continually rising, then you can't define an offset latency, so set it to 300ms
                            linBlankOffLat(or,co,ndot,dx,ch) = minLinBinOff;
                        else
                            if minLinResp < 0
                                minLinResp = 0.01;
                            end
                            halfMin = minLinResp*2;
                            
                            %muResps2 = muLinRespsOff(minLinBinOff+1:end);
                            muResps2 = muLinRespsOff(1:minLinBinOff);
                            latOff = find((muResps2 <= halfMin));
                            linBlankOffLat(or,co,ndot,dx,ch) = (latOff(1));
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
                        
                        linBlankOffLatBoot(or,co,ndot,dx,ch,:) = bootLinMaxBinOff;
                        noiseBlankOffLatBoot(ndot,dx,ch,:)  = bootNoiseMaxBinOff;
                    end
                end
            end
        end
    end
end
%% adjust offsets and save to data structure
startCheckOn = 5;
startCheckOff = 20;
        
dataT.linBlankOnLat = (linBlankOnLat+(startCheckOn-1))*10;
dataT.noiseBlankOnLat = (noiseBlankOnLat+(startCheckOn-1))*10;

dataT.linBlankOffLat = (linBlankOffLat+(startCheckOff-1))*10;
dataT.noiseBlankOffLat = (noiseBlankOffLat+(startCheckOff-1))*10;

dataT.linBlankOffLatBoot = (linBlankOffLatBoot+(startCheckOff-1))*10;
dataT.noiseBlankOffLatBoot = (noiseBlankOffLatBoot+(startCheckOff-1))*10;

dataT.linBlankOnLatBoot = (linBlankOnLatBoot+(startCheckOn-1))*10;
dataT.noiseBlankOnLatBoot = (noiseBlankOnLatBoot+(startCheckOn-1))*10;



    
