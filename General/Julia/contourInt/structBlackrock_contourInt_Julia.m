function R = structBlackrock_contourInt(S, filename, outputDir, info, binStart, binEnd, plotResp, forceOverwrite)
%
% Function for aligning Utah array data to trial/stimuli presentations in
% the contour integration stimuli set. Returns data in mapped channel indices. 
%
% Cleans up artifacts by removing trials which have outlier activity
% across the majority of (electrically responsive) channels.
%
% Contour integration stimuli: gabors on a mean gray luminance field.
% Contours were always centered on (-3, 0).
%       - contour lengths : 1, 3, 5, 7
%       - contour orientations: 0, 45, 90, 135
%       - seeds - 20 varying 'seeds' (randomized background/distractor
%       gabors)
%       - contour 'W' - 3 or 4 -- taken from the 7 length contour, with
%       every other gabor in the contour removed
% Contour 'phase' edition 
%       - phase of gabors were randomized/alternated.
%       - only one line length (7)
%       - contour orientations: 0, 45, 90, 135
%
% Inputs:
%           - S = struct containing readouts of mworks words for each trial, and binned spiketimes 
%                 (output from bin_spike_bushnell10_Matlab.m)    
%           - filename = ie, 'WU_LE_Gratings_nsp1_20170427_012'
%           - outputDir = directory to save out the mat file
%           - info = struct containing info about experiment
%           - binStart/binEnd = start/end of period to sum responses over
%               to calculate response matrices (for ease of plotting)
%               (ie, binStart=5 and binEnd=15 --> sum responses from 50-150
%               ms after stimulus onset)
%           - plotRes = 0 or 1. will plot bunch of response matrices and
%           PSTHs
%           - forceOverwrite = 0 or 1. rerun this script even if processed file
%           already exists.
% 
% 10.10.18 - JP

saveFile = [outputDir filename '_resp.mat'];
if ~exist(saveFile) || forceOverwrite
    %% Set up some initial variables and array map.
    % Get the array map for this array (from WU!)
    aMap        = getBlackrockArrayMap(filename);

    if contains(filename, 'ContourIntegrationPh')
        phaseExp    = 1;
        nPhase      = 2;
    else
        phaseExp    = 0;
    end
    
    nChan       = 96;
    nTrials     = length(S.stimFilename);
    
    numEl       = nan(1, nTrials);
    ori         = nan(1, nTrials);
    sample      = nan(1, nTrials);
    modifier    = nan(1, nTrials);
    if phaseExp == 1
        phase   = nan(1, nTrials);
    end
    
    % Modifier meanings:
    %    0: Standard line in noise
    %    1: Line only
    %    2: Line only, wide spacing (applicable only to 3 and 4 element lines)
    %    3: Wide spaced line in noise
    %    4: blank screen
    %    200: everything 200 means it was a noise stimulus
    for iT = 1:nTrials                                                     % Parse stimulus file name to find stim parameters.
        if phaseExp == 0
            [numEl(iT), ori(iT), sample(iT), modifier(iT)] =  ...
                parseCIName(S.stimFilename{iT});
        else
            [numEl(iT), phase(iT), ori(iT), sample(iT), modifier(iT)] =  ...
                parseCIName_phase(S.stimFilename{iT});
        end
        
    end
    
    if phaseExp
        uniqueEl        = unique(numEl); uniqueEl(isnan(uniqueEl)) = [];
        uniquePhase = unique(phase); uniquePhase(isnan(uniquePhase)) = [];
        nPhase      = length(uniquePhase);
    else
        uniqueEl    = [1 3 5 7];
    end
    
    uniqueOri       = unique(ori); uniqueOri(isnan(uniqueOri)) = [];
    uniqueMod       = unique(modifier);uniqueMod(isnan(uniqueMod)) = [];
    
    nEl             = length(uniqueEl);
    nOri            = length(uniqueOri);
    
    stimOn          = unique(S.stimOn);
    stimOff         = unique(S.stimOff);
    binStimOn       = double(stimOn/10);
    binStimOff      = double(stimOff/10);
    nBins           = binStimOn + binStimOff;
    
    %% Artifact rejection -- remove trials with spurious activity across channels.
    % Determine number of channels that have any kind of response (and are
    % capable of registering artifacts)
    nChanWithSignal      = 0;
    indChanWithSignal    = [];
    for iC = 1:nChan
        randDist    = normrnd(1,1,[1 nTrials]);
        chanDist    = sum(S.bins(:,1:nBins,iC));
        p  = shuffleTest2Dist(randDist, chanDist, 1000);
        if p < 0.05
            nChanWithSignal = nChanWithSignal+1;
            indChanWithSignal(end+1) = iC;
        end
    end
    
    trialResp       = squeeze(sum(S.bins(:,1:30,:),2));
    respAvgAllChan  = nanmean(trialResp,2);
    maxAvg          = max(respAvgAllChan(:));
    
    threshMult      = 3;                                                   % number of standard deviations to count as outlier
    nThreshChan     = ceil(nChanWithSignal * 0.4);                         % Number of channels that have to show simultaneous outlier activity
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
    S.bins(badTrials,:,:)   = NaN;
    
    % Find trial indices for diff kinds of stimuli
    blankNdx        = find(modifier == 4);
    noiseNdx        = find(modifier == 200);
    lineOnlyNdx     = find(modifier == 1);
    lineNoiseNdx    = find(modifier == 0);
    lineOnlyWideNdx     	= find(modifier == 2);                         % NOT PRESENT IN PHASE EXP
    lineNoiseWideNdx        = find(modifier == 3);                         % NOT PRESENT IN PHASE EXP
    
    % Phase experiments and non-phase have a few differences.
    if ~phaseExp                                                           % Regular, non-phase exp                                                     
        
        uniqueElWide    = [3 4];
        nElWide         = length(uniqueElWide);
        
        % Preallocate space for responses
        %       - resp--    = cell with responses for each trial where that stimulus was shown
        %       - resp--Avg = average response to that stimulus over time
        %       - resp--Mat = average response over time, summed over time
        %         period specified by 'binStart' to 'binEnd' (ie, binStart
        %         = 5 to binEnd = 15 would take summed avg spikes from
        %         50-150 ms after stim on)
        
        nRepPerStim     = nan(nOri, nEl);
        blankSd         = nan(nChan,nBins);
        respAll         = cell(nOri, nEl, nChan);                          % Response for each presentation of stimulus.
        respAvg         = nan(nOri, nEl, nBins, nChan);                    % Average across all reps, in time.
        respMat         = nan(nOri, nEl, nChan);
        respMatRel      = nan(nOri, nEl, nChan);                           % baseline subtracted response matrix
        respMatRelToNoise      = nan(nOri, nEl, nChan);                    % noise response subtracted response matrix
        respBlank       = cell(nChan, 1);
        respBlankAvg    = nan(nChan, nBins);
        respNoise       = cell(nChan, 1);                                  % noise/distrator only.
        respNoiseAvg    = nan(nChan, nBins);
        respLine        = cell(nOri, nEl, nChan);
        respLineAvg     = nan(nOri, nEl, nBins, nChan);                    % response for just lines (of different lengths)
        respLineMat     = nan(nOri, nEl, nChan);
        
        % Responses for  'wide' spacing lines....
        respWide        = cell(nOri, nElWide, nChan);
        respWideAvg     = nan(nOri, nElWide, nBins, nChan);
        respWideMat     = nan(nOri, nElWide, nBins, nChan);
        respLineWide    = cell(nOri, nElWide, nChan);
        respLineWideAvg = nan(nOri, nElWide, nBins, nChan);
        respLineWideMat = nan(nOri, nElWide, nChan);
        
        % Z-scored responses                   % hmmm dont knwo if i actually want to do this.
        %blankSd         = nan(nChan, nBins);
        %ZSrespAvg       = nan(nOri, nEl, nBins, nChan);                   % Average z-scored response for each grating.
        %ZSrespMat       = nan(nOri, nEl, nChan);
        %ZSrespAll       = cell(nOri, nEl, nChan);                       
        %ZSrespNoise     = cell(nChan, 1);
        %ZSrespNoiseAvg  = nan(nBins, nChan);
        %ZSrespLine      = cell(nEl, nChan);
        %ZSrespLineAvg   = nan(nEl, nBins, nChan);                          

        maxRespPerChan  = zeros(1, nChan);
        nRepMin         = 10000;
        
        for iC_ = 1:nChan
            iC          = aMap.channel(iC_);
            blanks      = S.bins(blankNdx,1:nBins,iC);                     % Blanks. %%%%%%%%%%%%%%
            blankSd(iC,:)  = nanstd(blanks,[],1);
            respBlank{iC}           = blanks;
            respBlankAvg(iC,:)      = nanmean(blanks);
            
            respNoise{iC}           = S.bins(noiseNdx,1:nBins,iC);         % Noise response.
            respNoiseAvg(iC,:)      = nanmean(S.bins(noiseNdx,1:nBins,iC), 1);
            
            for iOri = 1:nOri                                              
                for iEl = 1:nEl
                    % Line in noise. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineNoiseNdx, intersect(find(ori == uniqueOri(iOri)), find(numEl == uniqueEl(iEl))));
                    stimResp                = S.bins(ind,1:nBins,iC);
                    respAll{iOri,iEl,iC}    = stimResp;
                    respAvg(iOri,iEl,:,iC)  = nanmean(stimResp,1);     % take stimulus averaged response.
                    respMat(iOri,iEl,iC)    = sum(nanmean(stimResp(:,binStart:binEnd),1));
                    respMatRel(iOri,iEl,iC) = sum(nanmean(stimResp(:,binStart:binEnd),1)) - sum(nanmean(blanks(:,binStart:binEnd),1));
                    nRepPerStim(iOri,iEl)   = length(ind);
                    if length(ind) < nRepMin
                        nRepMin     = length(ind);
                    end
                    % Line only %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineOnlyNdx, intersect(find(ori == uniqueOri(iOri)), find(numEl == uniqueEl(iEl))));
                    respLine{iOri,iEl,iC}   = S.bins(ind,1:nBins,iC);
                    respLineAvg(iOri,iEl,:,iC) = nanmean(S.bins(ind,1:nBins,iC));
                    respLineMat(iOri,iEl,iC) = sum(nanmean(S.bins(ind,binStart:binEnd,iC)));
                end
            end
            respMatRelToNoise(:,:,iC) = ...                                % subtract response to noise/distractors 
                respMat(:,:,iC) - sum(respNoiseAvg(iC,binStart:binEnd));
            
            for iOri = 1:nOri                                              % for 'wide spacing' contours
                for iElWide = 1:nElWide
                    % Line in noise, wide %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineNoiseWideNdx, intersect...
                                                (find(ori == uniqueOri(iOri)), find(numEl == uniqueElWide(iElWide))));
                    stimResp                = S.bins(ind,1:nBins,iC);
                    respWide{iOri,iElWide,iC}       = stimResp;
                    respWideAvg(iOri,iElWide,:,iC)  = nanmean(stimResp,1);
                    respWideMat(iOri,iElWide,iC)    = sum(nanmean(stimResp(:,binStart:binEnd),1));
                    % Line only, wide %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineOnlyWideNdx, intersect...
                                                (find(ori == uniqueOri(iOri)), find(numEl == uniqueElWide(iElWide))));
                    stimResp                = S.bins(ind,1:nBins,iC);
                    respLineWide{iOri,iElWide,iC}   	= stimResp;
                    respLineWideAvg(iOri,iElWide,:,iC)  = nanmean(stimResp,1);
                    respLineWideMat(iOri,iElWide,iC)    = sum(nanmean(stimResp(:,binStart:binEnd),1));
                end
            end
            
        end %end looping thru channels
         
    %% some figures for sanity check.... response matrices and PSTHs   
    if plotResp
        figure; hold on                                                    % plot LINE IN NOISE response matrices of orientation x numEl
        plotthis = respMatRelToNoise;
        arrayMax = max(plotthis(:));
        cmap = [-arrayMax arrayMax];
        for iC = 1:nChan
            nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
            imagesc(plotthis(:,:,iC));
            colormap redblue
            caxis(cmap)
            axis tight; axis off
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle('ori x numEl -- noise subtracted responses')

        figure; hold on                                                    % plot LINE ONLY response matrices of orientation x numEl
        plotthis = respLineMat;
        arrayMax = max(plotthis(:));
        cmap = [-arrayMax arrayMax];
        for iC = 1:nChan
            nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
            imagesc(plotthis(:,:,iC));
            colormap redblue
            caxis(cmap)
            axis tight; axis off
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle('ori x numEl -- line only')

        figure; hold on     % plot PSTH for diff lines -- Averaged across all channels
        blankPSTH   = nanmean(respBlankAvg, 1);
        noisePSTH   = nanmean(respNoiseAvg, 1);
        linePSTH    = squeeze(nanmean(nanmean(respLineAvg, 4),1));
        lineNoisePSTH   = squeeze(nanmean(nanmean(respAvg, 4),1));
        plot([1:30], blankPSTH, 'Color', [0 0 0]+0.5);                         % blank = gray
        plot([1:30], noisePSTH, 'Color',[0 0 0]);                              % noise = black
        for lineEl = 1:nEl
            plot([1:30], linePSTH(lineEl,:), 'Color', [1 1 1] - [.25 .25 0]*lineEl); % line only in various shades of blue
            plot([1:30], lineNoisePSTH(lineEl,:), 'Color', [1 1 1] - [0 .25 .25]*lineEl); % line in noise in various shades of blue
        end
        title(['gray=blank, black=noise, red=line, blue=line+noise -- avg across all channels'])

        figure; hold on     % plot PSTH for diff lines -- for one channel
        iC = 43;
        blankPSTH   = respBlankAvg(iC,:);
        noisePSTH   = respNoiseAvg(iC,:);
        linePSTH    = squeeze(nanmean(respLineAvg(:,:,:,iC),1));
        lineNoisePSTH   = squeeze(nanmean(respAvg(:,:,:,iC),1));
        plot([1:30], blankPSTH, 'Color', [0 0 0]+0.5);                         % blank = gray
        plot([1:30], noisePSTH, 'Color',[0 0 0]);                              % noise = black
        for lineEl = 1:nEl
            plot([1:30], linePSTH(lineEl,:), 'Color', [1 1 1] - [.25 .25 0]*lineEl); % line only in various shades of blue
            %plot([1:30], lineNoisePSTH(lineEl,:), 'Color', [1 1 1] - [0 .25 .25]*lineEl); % line in noise in various shades of blue
        end
        title(['gray=blank, black=noise, red=line, blue=line+noise -- channel ' num2str(iC)]);

        figure; hold on     % plot PSTH for each channel -- for blank, noise, and 1-contour line -- RED AND BLACK SHOULD BE THE SAME
        for iC = 1:nChan
            nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
            plot([1:30], respBlankAvg(iC,:), 'Color', [0 0 0]+0.5);               % blank = gray
            plot([1:30], respNoiseAvg(iC,:), 'Color',[0 0 0]);                    % noise = black
            plot([1:30], squeeze(nanmean(respLineAvg(:,1,:,iC), 1)), 'b')         % line only (1-cont) = blue
            plot([1:30], squeeze(nanmean(respAvg(:,1,:,iC), 1)), 'r')             % line in noise (1-cont) = red
            axis tight; axis off
            set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
            title(iC)
        end
        suptitle('gray=blank, black=noise, blue= 1 line, red= 1 line in noise')
    %     iC = 59;
    %     spiketimes = S.bins(:,:,iC);
    %     spiketimes(spiketimes>1) = 1;
    %     spiketimes(isnan(spiketimes)) = 0;
    %     figure; 
    %     plotSpikeRaster(logical(spiketimes), 'PlotType','vertline');
    end

    %%%% Phase experiment %%%%%%%%%%%%%%%%%%%%%%%%
    elseif phaseExp                                                                                                
        
        % Phase exp only has one line length (7) and two phases.
        % so rather than nOri x nEl, the arrangement of the matrices is
        % nOri x nPhase.
        nRepPerStim     = nan(nOri, nPhase);
        blankSd         = nan(nChan,nBins);
        respAll         = cell(nOri, nPhase, nChan);                       % Response for each presentation of stimulus.
        respAvg         = nan(nOri, nPhase, nBins, nChan);                 % Average across all reps, in time.
        respMat         = nan(nOri, nPhase, nChan);
        respMatRel      = nan(nOri, nPhase, nChan);                        % baseline subtracted response matrix
        respMatRelToNoise      = nan(nOri, nPhase, nChan);                 % noise response subtracted response matrix
        respBlank       = cell(nChan, 1);
        respBlankAvg    = nan(nChan, nBins);
        respNoise       = cell(nChan, 1);                                  % noise/distrator only.
        respNoiseAvg    = nan(nChan, nBins);
        respLine        = cell(nOri, nPhase, nChan);
        respLineAvg     = nan(nOri, nPhase, nBins, nChan);                 % response for just lines 
        respLineMat     = nan(nOri, nPhase, nChan);
        
        nRepMin         = 1000;
        
        for iC_ = 1:nChan
            iC          = aMap.channel(iC_);
            blanks      = S.bins(blankNdx,1:nBins,iC);                     % Blanks. %%%%%%%%%%%%%%
            blankSd(iC,:)  = nanstd(blanks,[],1);
            respBlank{iC}           = blanks;
            respBlankAvg(iC,:)      = nanmean(blanks);
            
            respNoise{iC}           = S.bins(noiseNdx,1:nBins,iC);         % Noise response.
            respNoiseAvg(iC,:)      = nanmean(S.bins(noiseNdx,1:nBins,iC), 1);
            
            for iOri = 1:nOri                                              
                for iPh = 1:nPhase
                    % Line in noise. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineNoiseNdx, intersect...
                        (find(ori == uniqueOri(iOri)), find(phase == uniquePhase(iPh))));
                    stimResp                = S.bins(ind,1:nBins,iC);
                    respAll{iOri,iPh,iC}    = stimResp;
                    respAvg(iOri,iPh,:,iC)  = nanmean(stimResp,1);     % take stimulus averaged response.
                    respMat(iOri,iPh,iC)    = sum(nanmean(stimResp(:,binStart:binEnd),1));
                    respMatRel(iOri,iPh,iC) = sum(nanmean(stimResp(:,binStart:binEnd),1)) - sum(nanmean(blanks(:,binStart:binEnd),1));
                    nRepPerStim(iOri,iPh)   = length(ind);
                    if length(ind) < nRepMin
                        nRepMin     = length(ind);
                    end
                    % Line only %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    ind                     = intersect(lineOnlyNdx, ...
                        intersect(find(ori == uniqueOri(iOri)), find(phase == uniquePhase(iPh))));
                    respLine{iOri,iPh,iC}   = S.bins(ind,1:nBins,iC);
                    respLineAvg(iOri,iPh,:,iC) = nanmean(S.bins(ind,1:nBins,iC));
                    respLineMat(iOri,iPh,iC) = sum(nanmean(S.bins(ind,binStart:binEnd,iC)));
                end
            end
            respMatRelToNoise(:,:,iC) = ...                                % subtract response to noise/distractors 
                respMat(:,:,iC) - sum(respNoiseAvg(iC,binStart:binEnd));          
        end
        %% some figures for sanity check.... response matrices and PSTHs 
        if plotResp 
            figure; hold on                                                % plot LINE IN NOISE response matrices of orientation x numEl
            plotthis = respMatRelToNoise;
            arrayMax = max(plotthis(:));
            cmap = [-arrayMax arrayMax];
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                imagesc(plotthis(:,:,iC));
                colormap redblue
                caxis(cmap)
                axis tight; axis off
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('ori x nPhase -- noise subtracted responses')

            figure; hold on                                                % plot LINE ONLY response matrices of orientation x numEl
            plotthis = respLineMat;
            arrayMax = max(plotthis(:));
            cmap = [-arrayMax arrayMax];
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                imagesc(plotthis(:,:,iC));
                colormap redblue
                caxis(cmap)
                axis tight; axis off
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('ori x nPhase -- line only')

            figure; hold on     % plot PSTH for diff lines -- Averaged across all channels
            blankPSTH   = nanmean(respBlankAvg, 1);
            noisePSTH   = nanmean(respNoiseAvg, 1);
            linePSTH    = squeeze(nanmean(nanmean(respLineAvg, 4),1));
            lineNoisePSTH   = squeeze(nanmean(nanmean(respAvg, 4),1));
            plot([1:30], blankPSTH, 'Color', [0 0 0]+0.5);                         % blank = gray
            plot([1:30], noisePSTH, 'Color',[0 0 0]);                              % noise = black
            for lineEl = 1:nEl
                plot([1:30], linePSTH(lineEl,:), 'Color', [1 1 1] - [.25 .25 0]*lineEl); % line only in various shades of blue
                plot([1:30], lineNoisePSTH(lineEl,:), 'Color', [1 1 1] - [0 .25 .25]*lineEl); % line in noise in various shades of blue
            end
            title(['gray=blank, black=noise, red=line, blue=line+noise -- avg across all channels'])

    %         figure; hold on     % plot PSTH for diff lines -- for one channel
    %         iC = 43;
    %         blankPSTH   = respBlankAvg(iC,:);
    %         noisePSTH   = respNoiseAvg(iC,:);
    %         linePSTH    = squeeze(nanmean(respLineAvg(:,:,:,iC),1));
    %         lineNoisePSTH   = squeeze(nanmean(respAvg(:,:,:,iC),1));
    %         plot([1:30], blankPSTH, 'Color', [0 0 0]+0.5);                         % blank = gray
    %         plot([1:30], noisePSTH, 'Color',[0 0 0]);                              % noise = black
    %         for lineEl = 1:nEl
    %             plot([1:30], linePSTH(lineEl,:), 'Color', [1 1 1] - [.25 .25 0]*lineEl); % line only in various shades of blue
    %             %plot([1:30], lineNoisePSTH(lineEl,:), 'Color', [1 1 1] - [0 .25 .25]*lineEl); % line in noise in various shades of blue
    %         end
            title(['gray=blank, black=noise, red=line, blue=line+noise -- channel ' num2str(iC)]);

            figure; hold on     % plot PSTH for each channel -- for blank, noise, and 1-contour line -- RED AND BLACK SHOULD BE THE SAME
            for iC = 1:nChan
                nsubplot(10, 10, aMap.row(iC)+1, aMap.col(iC)+1);
                plot([1:30], respBlankAvg(iC,:), 'Color', [0 0 0]+0.5);               % blank = gray
                plot([1:30], respNoiseAvg(iC,:), 'Color',[0 0 0]);                    % noise = black
                plot([1:30], squeeze(nanmean(respLineAvg(:,1,:,iC), 1)), 'b')         % line only (1-cont) = blue
                plot([1:30], squeeze(nanmean(respAvg(:,1,:,iC), 1)), 'r')             % line in noise (1-cont) = red
                axis tight; axis off
                set(gca, 'Position',get(gca, 'Position')+[0 0 0.005 0.005]);
                title(iC)
            end
            suptitle('gray=blank, black=noise, blue= 1 line, red= 1 line in noise')
        end
    end %end parsing
    
%     %% Perform shuffle test across stimulus conditions.
%     %% Actually, this is probably not the best place to do this.
%     %% For the purpose of checking channel responsivity, should probably
%     cross-reference to daily grating responses where joint-tuning score
%     is computed.
%     JTS = nan(1, nChan);
%     for iC = 1:nChan
%         respAvgPerRep        = cellfun(@(x) nanmean(x,2), respAll(:,:,iC), 'un', 0);
%         trimRep              = @(x, nRepMin) x(1:nRepMin);
%         respAvgPerRepTrimmed = cellfun(@(x) trimRep(x,nRepMin), respAvgPerRep, 'un', 0);
%         respAvgPerRepTrimmed = ...
%             reshape(cat(1,respAvgPerRepTrimmed{:}),[size(respAvgPerRepTrimmed), numel(respAvgPerRepTrimmed{1})]);
%         [JTS(iC),~,~] = JT_VarOfMeans(respAvgPerRepTrimmed);
%     end
    
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
