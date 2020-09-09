function [RFStimBins,blankBins] = sortRadFreqBins(data,numBins)%,ch)
% This function returns two structures that contain matrices of responses
% to RFstimuli and blank screens. Each row of teh RFStimResps matrices are 
% for a different stimulus. The first 7 columns are the stimulus
% parameters, following that are the mean responses to the stimulus in 10ms
% bins. 
%
% INPUT: 
% Data structure for 1 eye
% numBins: how many bins of data do you want returned?  Always starts at 1
%
% Written September 16,2018 Brittany Bushnell

%% Testing

% Note: blank stimulus matrix is working, need to move on to the actual stimulus matrices.  
% Remember: these matrices should be nstim x (numParams(7) + numBins). Work from types, and append the mean 
% bins to the end of each row there.
% 
% Also: change name of the data structure to data.blankBins and data.rfBins or something like that

% clear all
% close all
% clc
% tic
% 
% file = 'WU_RadFreqLoc2_V4_20170706_RFxAmp_chxch';
% load(file);
% data = LEdata;
% numBins = 65;
%ch = 5;
%% Get stimulus information
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
blankParams = types((end-(legitLocs - 1)):end,:); % Define which stimuli are the blanks

blankBins  = cell(1,numChannels);
RFStimBins = cell(1,numChannels);
%% setup empty data structures for stimulus data 
types = types(1:end-legitLocs,:); % Define which stimuli are not blanks.
%numStim = size(typeTps,1) + size(stimResps{1},1) + 4;
numParams = size(types,1);

for r = 1:(size(stimResps,1) - legitLocs)
    numTrials(r,1) = size(stimResps{r},1);
end

tmpRows = size(types,1); % parameters + trials + summary data
tmpCols = size(types,2) + numBins;
%% Make the matrices of responses to a blank stimulus for each channel
for ch = 1:numChannels

    blankTmp = nan(1,(size(blankParams,2) + numBins));
    blankTmp(1,1:(size(blankParams,2))) = blankParams(1,:); % since these are blanks, the parameters don't matter.
    
    for t = 1:legitLocs-1
        if t == 1
            a = stimResps{end}(:,1:numBins,ch); % end
            b = stimResps{end-t}(:,1:numBins,ch); % end-1
            a = [a; b];
        else
            b = stimResps{end-t}(:,1:numBins,ch); %end - t-1 = end-2 if t = 2
            a = [a; b]; % put them all together into one big matrix where rows are the trials and columns are the binned spike responses. 
        end
    end
     mu_a = nanmean(a,1)./.01;
    blankTmp(1,8:end) = mu_a;
    
    blankBins{ch} = blankTmp;
    %% Make the matrices of responses to each stimulus for each channel
    %tmp = nan(21,size(typeTps,2));
    stmTmp = nan(tmpRows,tmpCols);
    
    for r = 1:size(types,1) 
        stmTmp(:,1:size(types,2)) = types;
        muResp = nanmean(stimResps{r}(:,1:numBins,ch),1)./0.01;
        stmTmp(r,8:end) = muResp;
    end
    RFStimBins{ch} = stmTmp;
end
