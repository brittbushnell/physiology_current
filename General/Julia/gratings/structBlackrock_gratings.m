function R = structBlackrock_gratings(data, filename, outputDir, info, binStart, binEnd, forceOverwrite)
%
% Function for aligning Utah array data to trial/stimuli presentations in
% the gratings stimuli set. Returns data in mapped channel indices. 
%
% Gratings were static sinusoids presented at 6 orientations and 6 spatial
% frequencies (as well as blanks, and b/w flashes).
% 
% Cleans up artifacts by removing trials which have outlier activity
% across the majority of (electrically responsive) channels.
%
% Inputs:
%           - S = struct containing readouts of mworks words for each trial, and binned spiketimes 
%                 (output from bin_spike_bushnell10_Matlab.m)    
%           - filename = ie, 'WU_LE_Gratings_nsp1_20170427_012'
% Outputs:
%

saveFile = [outputDir filename '_resp.mat'];
if ~exist(saveFile) || forceOverwrite
    %% Set up some initial variables and array map.
    % S.rotation = orientation
    % S.spatial_frequency = SF
    %       - 0 = blank
    %       - 0.003 and 0.006 were black or white flashes
    % S.contrast

    % Get the array map for this array (from WU!)
    aMap    = getBlackrockArrayMap(filename);

    nChan = 96;
    nBins = 30;                                                            % spikes are binned in 10 ms intervals.
    nStimShown = length(data.t_stim);
    
    data.rotation  = mod(data.rotation, 180);
    oris        = unique(data.rotation);                                             % Effectively 6 oris and 6 sfs.
    sfs         = unique(data.spatial_frequency(data.spatial_frequency > 0.0006));       % 0 is blank. 0.003 and 0.006 are black/white flashes
    nOri        = length(oris);
    nSf         = length(sfs);
    blankind    = find(data.spatial_frequency == 0);

    %% Artifact rejection -- remove trials with spurious activity across channels.
    % Determine number of channels that have any kind of response (and are
    % capable of registering artifacts)
    nChanWithSignal      = 0;
    indChanWithSignal    = [];
    for iC = 1:nChan
        randDist    = normrnd(1,1,[1 nStimShown]);
        chanDist    = sum(data.bins(:,1:nBins,iC));
        p  = shuffleTest2Dist(randDist, chanDist, 1000);
        if p < 0.05
            nChanWithSignal = nChanWithSignal+1;
            indChanWithSignal(end+1) = iC;
        end
    end
    
    trialResp       = squeeze(sum(data.bins(:,1:30,:),2));
    respAvgAllChan  = nanmean(trialResp,2);
    maxAvg          = max(respAvgAllChan(:));
    
    threshMult      = 3;
    nThreshChan     = ceil(nChanWithSignal * 0.4);         % Number of channels that have to show simultaneous outlier activity
    threshCutoff    = mean(respAvgAllChan) +  std(respAvgAllChan)*threshMult;
   
    % If majority of channels have outlier activity at the same time, is
    % likely an artifact.
    % Outlier activity (for each channel) defined as trial activity that
    % exceeds the mean + thresh*SD
    indOutliers     = find(respAvgAllChan > threshCutoff);
    chanIndOutliers = zeros(nChan, length(indOutliers));
    chanThresh      = nan(1,nChan);
    for iC = 1:nChan
        chanThresh(iC)  = getThresh(trialResp(:,iC), threshMult);
        temp            = find(trialResp(:,iC) > chanThresh(iC));
        matchInd        = intersect(temp, indOutliers);
        chanIndOutliers(iC,:) = ismember(indOutliers, matchInd);
    end
    nChanWithOutlier = sum(chanIndOutliers,1);
    badTrials = indOutliers(find(nChanWithOutlier > nThreshChan));
    %% FOR DEBUGGING: Figures to illustrate channel by channel activity with/without outliers
%     figure; hold on
%         plot(respAvgAllChan);
%         line(xlim, [threshCutoff threshCutoff])
%         if ~isempty(badTrials)
%         scatter(badTrials, respAvgAllChan(badTrials), 'r', '*')
%         end
%     
%     figure; hold on  
%         for iC_ = 1:nChan
%             iC = aMap.channel(iC_);
%             nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
%             plot(trialResp(:,iC), 'b')
%             scatter(badTrials, trialResp(badTrials,iC), 'r', '*')
%             ylim([0 maxAvg])
%             xlim([0 size(trialResp,1)])
%             line(xlim, [chanThresh(iC), chanThresh(iC)]) 
%             axis off; axis tight
%             set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%             title(iC)
%         end
%         suptitle('all trials per channel')
%     
%     % Remove bad trials
%     trialResp(badTrials,:) = NaN;
%     respAvgAllChan = nanmean(trialResp,2);
%     maxAvg = max(respAvgAllChan(:));
%     figure; hold on
%         for iC = 1:nChan
%             nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
%             plot(trialResp(:,iC), 'b')
%             %scatter(badTrials, trialResp(badTrials,iC), 'r', '*')
%             ylim([0 maxAvg])
%             xlim([0 size(trialResp,1)])
%             line(xlim, [threshCutoff threshCutoff]) 
%             axis off; axis tight
%             set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%             title(iC)
%         end
%         suptitle('all trials per channel - outliers removed')
    %% Organize data into response matrices
    
    % Take the responses in the first 300 ms of the binned data (100 ms stim
    % on, 200 ms stim off.
    % Map responses to correct channel.        
    
    % Remove bad trials %%%%%%%%%
    data.bins(badTrials,:,:)   = NaN;

    [temp, ~]       = hist(data.rotation.*data.spatial_frequency, unique(data.rotation.*data.spatial_frequency));
    nRepMin         = min(temp);                                       % note that not all conditions had the same number of repeats, partly bc of way gratings were name (ie, had both 0 and 180 degrees)
    nRepPerStim     = nan(nSf, nOri);
    respAll         = cell(nSf, nOri, nChan);
    respAvg         = nan(nSf, nOri, nBins, nChan);                    % Average across all reps, in time.
    respAvgPerRep   = cell(nSf, nOri, nChan);                          % Average across time, for each rep.
    respMat         = nan(nSf, nOri, nChan);
    respMatRel      = nan(nSf, nOri, nChan);                            % baseline subtracted response matrix
    respBlank       = cell(nChan,1);
    respBlankAvg    = nan(nChan, nBins);
    maxRespPerChan  = nan(1, nChan);
    
    % Z-scored responses
    blankSd         = nan(nChan, nBins);                                 
    ZSrespAvg       = nan(nSf, nOri, nBins, nChan);                     % Average z-scored response for each grating.
    ZSrespMat       = nan(nSf, nOri, nChan);
    ZSrespAll       = cell(nSf, nOri, nChan);                           % response for each presentation of that stimulus
    
    for iC_ = 1:nChan
        iC          = aMap.channel(iC_);
        blanks      = double(data.bins(blankind,1:nBins,iC));
        blankSd(iC,:)  = nanstd(blanks,[],1);
        
        maxStimRespTemp     = nan(nSf, nOri);
        
        for iOri = 1:nOri
            for iSf = 1:nSf
                ind                     = intersect(find(data.rotation == oris(iOri)), find(data.spatial_frequency == sfs(iSf)));
                stimResp                = data.bins(ind,1:nBins,iC);
                respAll{iSf, iOri, iC}  = stimResp; %boxcarBinData(stimResp, winLength, winOverlap,1) - nanmean(blankResp);
                respAvg(iSf,iOri,:,iC)  = nanmean(stimResp,1);     % take stimulus averaged response.
                respAvgPerRep{iSf,iOri,iC} = nanmean(stimResp,2);  % take avg response over time for each stimulus presentation.
                respMat(iSf,iOri,iC)    = sum(nanmean(stimResp(:,binStart:binEnd),1));
                respMatRel(iSf,iOri,iC) = sum(nanmean(stimResp(:,binStart:binEnd),1)) - sum(nanmean(blanks(:,binStart:binEnd),1));
                respBlank{iC}           = blanks;
                respBlankAvg(iC,:)      = nanmean(blanks);
                nRepPerStim(iSf,iOri)   = length(ind);
                maxStimRespTemp(iSf,iOri) = max(sum(stimResp(:,binStart:binEnd),2));
                %ZSstimResp              = (stimResp - respBlankAvg(iC,:)) ./ (respSd(iC,:)+0.0001); 
                %ZSrespAll{iSf,iOri,iC}  = ZSstimResp;
                %ZSrespAvg(iSf,iOri,:,iC) = nanmean(ZSstimResp,1);
                %ZSrespMat(iSf,iOri,iC)  = sum(nanmean(ZSstimResp(:,binStart:binEnd),1));
    
                if length(ind) < nRepMin
                    nRepMin = length(ind);
                end
            end
        end
        % Determine z-scored responses
        ZSrespMat(:,:,iC)   = respMatRel(:,:,iC) ./ (sum(blankSd(iC,binStart:binEnd))+0.0001);
        maxRespPerChan(iC)  = max(maxStimRespTemp(:));
    end
    
%     % Histogram of responses for each trial 
%     figure; hold on   
%     arrayMax = max(respAvg(:));
%     arrayStd = std(respAvg(:));
%     for iC = 1:nChan
%         nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
%         chanResp = respAvg(:,:,:,iC);
%         histogram(chanResp, arrayStd*-3:0.1:arrayStd*3 )
%         axis tight; axis off
%         set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
%         title(iC)
%     end    
    %% Perform shuffle test across stimulus conditions.
    JTS = nan(1, nChan);
    for iC = 1:nChan
        trimRep = @(x, nRepMin) x(1:nRepMin);
        respAvgPerRepTrimmed = cellfun(@(x) trimRep(x,nRepMin), respAvgPerRep(:,:,iC), 'un', 0);
        respAvgPerRepTrimmed = cellfun(@(x) reshape(x,1,1,[]), respAvgPerRepTrimmed,'un',0);
        respAvgPerRepTrimmed = cell2mat(respAvgPerRepTrimmed);
        [JTS(iC),~,~] = JT_VarOfMeans(respAvgPerRepTrimmed);
    end
    
    save(saveFile)
    R = load(saveFile);
   
else
    R = load(saveFile);
end

%%
function threshVal = getThresh(resp, threshMult)
threshVal = nanmean(resp) + std(resp)*threshMult;
end

end
    