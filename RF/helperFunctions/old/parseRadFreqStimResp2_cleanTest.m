function [RFStimResps,blankResps] = parseRadFreqStimResp2_cleanTest(data,startBin,endBin)%,ch)
% PARSERADFREQSTIMRESP function will return an cell matrix of the
% responses of each channel to each unique stimulus.
%
%  INPUT
%    DATA structure from parser
%    CH channel number
%    STARTBIN Bin number to begin calculations on(onset latency)
%    ENDBIN Bin number to end calculation on
%
%  OUTPUT
%     RFSTIMRESPS cell array where each cell is a matrix of responses of a
%       given channel to each unique stimuls. Each column of the matrix
%       represents a unique stimulus, and each row is:
%
%        1)   Radial Frequency
%        2)   Amplitude (Weber fraction)
%        3)   Phase (Orientation)
%        4)   Spatial frequency
%        5)   Amplitude
%        6)   Size (mean radius)
%        7)   X position
%        8)   Y position
%        9 - ?) mean response to the stimulus on every repeat
%        end - 3) mean response
%        end - 2) median response
%        end - 1) standard error
%        end) NAN (will be used for a normalized value)
%
%     The first column is always the blank stimulus
%
% Written April 28,2018 Brittany Bushnell
%
% July 9, 2018
% Edited to add in some data cleanup and remove any responses that are due
% to artifacts that were present during stimulus presentation.
%% Testing
% clear all
% %close all
% clc
% tic
% 
% file = 'WU_RE_RadFreqLoc2_nsp2_20170707_005';
% data = load(file);
% startBin = 5;
% endBin = 35;
% boop = 53;
%% Get stimulus information
% all of the other unique parameters are stored in the file name and need
% to be parsed out.
% for i = 1:length(data.filename)
%     [name, rf, rad, mod, ori, sf] = parseRFName(data.filename(i,:));
%     
%     data.rf(i,1)  = rf;
%     data.amplitude(i,1) = mod;
%     data.orientation(i,1) = ori;
%     data.spatialFrequency(i,1) = sf;
%     data.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
%     name  = char(name);
%     data.name(i,:) = name;
% end
numChannels = size(data.bins,3);

params = [data.rf data.amplitude data.orientation data.spatialFrequency data.radius data.pos_x data.pos_y]; % make a column matrix  of all of the parameters

%% Create grouped and sorted matrices
[types,~,indexOfTypes] = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type

[groupedNums] = accumarray(indexOfTypes,1,[]); % takes index of types, and groups them

[~,sortedIndices] = sort(indexOfTypes); % sort the indices
FR2 = data.bins(sortedIndices,:, :); % make a new verion of data.bins that we will manipulate to correspond to indices that were grouped and sorted earlier.

stimResps = mat2cell(FR2,groupedNums,size(data.bins,2),numChannels); % FR2 (data.bins) rearranged so they're sorted by grouped indices.

%% See how many unique locations (and therefore blanks) were run
xPoss = unique(data.pos_x);
yPoss = unique(data.pos_y);

legitLocs = 0;
for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((data.pos_x == xPoss(xs)) & (data.pos_y == yPoss(ys)));
        if flerp > 1
            legitLocs = legitLocs +1;
        end
    end
end

% verify
if legitLocs < 1
    error('no valid stimulus locations were found')
elseif legitLocs == 1
    disp('Stimuli only run at 1 location')
elseif legitLocs == 3
    disp('3 stimulus locations run, must be single session')
elseif legitLocs == 5
    disp('5 stimulus locations run, must be combining days')
elseif legitLocs > 5
    error('Found more than 5 stimulus locations used')
end
%% Setup empty data structures for blank data
typeTps = types';  % Transpose the stimulus type array so it's now each column is a unique stimulus.
blankParams = typeTps(:,(end-(legitLocs - 1)):end); % Define which stimuli are the blanks

numBlank = size(blankParams,1) + (legitLocs .* size(stimResps{end},1)) + 4; % multiplying by legitLocs because there are three blanks, and adding 4 onto the end for mean, median, ste, and normalized response.

blankTmp = nan(numBlank,1);
blankResps  = cell(1,numChannels);
%% setup empty data structures for stimulus data
typeTps = typeTps(:,1:end-legitLocs); % Define which stimuli are not blanks.
%numStim = size(typeTps,1) + size(stimResps{1},1) + 4;
numParams = size(typeTps,1);

RFStimResps = cell(1,numChannels);


for r = 1:(size(stimResps,1) - legitLocs)
    numTrials(r,1) = size(stimResps{r},1);
end
tmpRows = size(typeTps,1) + max(numTrials) + 4; % parameters + trials + summary data
tmpCols = size(typeTps,2);
tmp = nan(tmpRows,tmpCols);
%% Make the matrices of responses to a blank stimulus for each channel
for ch = 1:numChannels
    stmTmp = nan(tmpRows,tmpCols);
    blankTmp = nan(numBlank,1);
    blankTmp(1:size(blankParams,1),1) = blankParams(:,1);
    
    for t = 1:legitLocs-1
        if t == 1
            a = stimResps{end}(:,startBin:endBin,ch);
            b = stimResps{end-t}(:,startBin:endBin,ch); % still need end-1, otherwise it gets skipped
            a = [a; b];
        else
            b = stimResps{end-t}(:,startBin:endBin,ch);
            a = [a; b];
        end
    end
    
    meanResps =  nanmean(a,2)./.01;
    
    % get rid of stimulus presentations where there was an artifact, based
    % on irrationally high firing rates given the rest of the responses to
    % the blank. 
    meanRespsCleaned = removeRespOutliers(meanResps);
    
%     outLogic = isoutlier(meanResps);
%     
%     ndx = 1;
%     for do = 1:length(meanResps)
%         if outLogic(do,1) == 0
%             meanRespsCleaned(ndx,1) = meanResps(do,1);
%             ndx = ndx+1;
%         end
%     end
    
    blankTmp(8:8+length(meanRespsCleaned)-1) = meanRespsCleaned;
    
    blankTmp(end+1,1) = nanmean(meanRespsCleaned);
    blankTmp(end+1,1) = nanmedian(meanRespsCleaned);
    blankTmp(end+1,1) = nanstd(meanRespsCleaned)/sqrt(length(meanRespsCleaned));
    blankTmp(end+1,1) = nan; % replace with normalized response in future
    
    blankResps{ch} = blankTmp;
    %% Make the matrices of responses to each stimulus for each channel
    %tmp = nan(21,size(typeTps,2));
    for r = 1:size(typeTps,2)
        tmp(1:size(typeTps,1),:) = typeTps;
        muResp = nanmean(stimResps{r}(:,startBin:endBin,ch),2)./0.01;
        
        muRespClean = removeRespOutliers(muResp);
        
%         outs = isoutlier(muResp);
%         
%         ndx = 1;
%         for do = 1:length(muResp)
%             if outs(do,1) == 0
%                 muRespClean(ndx,1) = muResp(do,1);
%                 ndx = ndx+1;
%             end
%         end
        
        tmp(numParams+1:(numParams+1)+length(muRespClean)-1,r) = muRespClean;
        tmp(end-3,r) = nanmean(muRespClean);
        tmp(end-2,r) = nanmedian(muRespClean);
        tmp(end-1,r) = nanstd(muRespClean)/sqrt(length(muRespClean));
    end
    RFStimResps{ch} = tmp;
end
