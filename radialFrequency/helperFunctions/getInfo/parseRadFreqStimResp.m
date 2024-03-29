function [RFStimResps,blankResps, stimResps] = parseRadFreqStimResp(dataT)
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
%        5)   Size (mean radius)
%        6)   X position
%        7)   Y position
%        8 - ?) mean response to the stimulus on every repeat
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
% Edited to add in some dataT cleanup and remove any responses that are due
% to artifacts that were present during stimulus presentation.
%
% September 9, 2020
% removing cleanup portion of code since that's done automatically before
% this now.
%% Testing
% clear all
% %close all
% clc
% tic
% 
% file = 'WU_RE_RadFreqLoc2_nsp2_20170707_005';
% dataT = load(file);
% boop = 53;

% Get stimulus information
% all of the other unique parameters are stored in the file name and need
% to be parsed out.
% for i = 1:length(dataT.filename)
%     [name, rf, rad, mod, ori, sf] = parseRFName(dataT.filename(i,:));
%     
%     dataT.rf(i,1)  = rf;
%     dataT.amplitude(i,1) = mod;
%     dataT.orientation(i,1) = ori;
%     dataT.spatialFrequency(i,1) = sf;
%     dataT.radius(i,1) = rad; %remember, size of RF stimuli is in mean radius
%     name  = char(name);
%     dataT.name(i,:) = name;
% end
%%
startBin = 5;
endBin = 25;
params = [dataT.rf dataT.amplitude dataT.orientation dataT.spatialFrequency dataT.radius dataT.pos_x dataT.pos_y]; % make a column matrix  of all of the parameters
%% Create grouped and sorted matrices
[types,~,indexOfTypes] = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type

[groupedNums] = accumarray(indexOfTypes,1,[]); % takes index of types, and groups them

[~,sortedIndices] = sort(indexOfTypes); % sort the indices
FR2 = dataT.bins(sortedIndices,:, :); % make a new verion of dataT.bins that we will manipulate to correspond to indices that were grouped and sorted earlier.

stimResps = mat2cell(FR2,groupedNums,size(dataT.bins,2),96); % FR2 (dataT.bins) rearranged so each unique stimulus is a cell matrix that's #repeats x 100 bins x 96 channels.
%% See how many unique locations (and therefore blanks) were run
xPoss = unique(dataT.pos_x);
yPoss = unique(dataT.pos_y);

legitLocs = 0;
for xs = 1:length(xPoss)
    for ys = 1:length(yPoss)
        flerp = sum((dataT.pos_x == xPoss(xs)) & (dataT.pos_y == yPoss(ys)));
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
    disp('3 stimulus locations run')
elseif legitLocs == 5
    disp('5 stimulus locations run, must be combining days for WU')
elseif legitLocs > 5
    error('Found more than 5 stimulus locations used')
end
%% Initialize dataT structures for blank dataT
typeCol = types';  % Transpose the stimulus type array so it's now each column is a unique stimulus.
blankParams = typeCol(:,(end-(legitLocs - 1)):end); % Define which stimuli are the blanks

% numBlank = size(blankParams,1) + (legitLocs .* size(stimResps{end},1)); % multiplying by legitLocs because there are three blanks, and adding 4 onto the end for mean, median, ste, and normalized response.

% blankTmp = nan(numBlank,1);
blankResps  = cell(1,96);
%% initialize dataT structures for stimulus dataT
typeCol = typeCol(:,1:end-legitLocs); % Define which stimuli are not blanks.
% numParams = size(typeCol,1);

RFStimResps = cell(1,96);

for r = 1:(size(stimResps,1) - legitLocs)
    numTrials(r,1) = size(stimResps{r},1);
end
% tmpRows = size(typeTps,1) + max(numTrials); % parameters + trials + summary dataT
% tmpCols = size(typeTps,2);
%% Make the matrices of responses to a blank stimulus for each channel
for ch = 1:96
    %% blank responses
    if legitLocs == 1
        a =stimResps{end}(:,startBin:endBin,ch);
    else
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
    end
    
    meanBlankResps =  nanmean(a,2)./.01;
    
    blankTmp = [blankParams(:,1); meanBlankResps];
    blankResps{ch} = blankTmp; 
    % the size of blankTmp should equal 3xsize(stimResps{end},1) +10. 
    %The 10 comes from the 7 rows of stimulus information at the top, and the three rows of mean, median, and std at the end
    %% Make the matrices of responses to each stimulus for each channel

    %tmp = nan(21,size(typeTps,2));
    for i = 1:size(typeCol,2)
        a(i,1) = size(stimResps{i},1);
    end
    maxReps = max(a,[],'all');
    muResp = nan(maxReps,size(typeCol,2));
    
    for r = 1:size(typeCol,2)
         tmpMu = nanmean(stimResps{r}(:,startBin:endBin,ch),2)./0.01;
         muResp(1:length(tmpMu),r) = tmpMu;

    end

    tmp = [typeCol; muResp];
    RFStimResps{ch} = tmp;
end
