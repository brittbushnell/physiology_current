function [RFspikeCount,blankSpikeCount,RFzScore,blankZscore] = getRadFreqSpikeCount(data, stimResps)
% getRadFreqSpikeCount function will return an cell matrix of the
% spike counts of each channel to each unique stimulus. Run this after 
% parseRadFreqStimResp to get the stimResps cell array, that way you don't
% have to repeat the manipulation of the data.
%
%  INPUT
%    DATA structure from parser
%    STIMRESPS cell array from parseRadFreqStimResp that has the binned
%    spikes for each stimulus already organized. That will make this all
%    much easier.
%
%  OUTPUT
%     RFspikeCount, and blankSpikeCount are cell arrays where each cell is a matrix of responses of a
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
%        9-#reps) spike count
%     
%   RFzScore and blankZscore are identical to the spike count cell arrays,
%   but instead of rows 9:end containing spike counts for each repeat, it
%   contains the zscores. 
%
% September 9, 2020 Brittany Bushnell

%% Testing
% clear all
% %close all
% clc
% tic
% 
% file = 'WU_RE_RadFreqLoc2_nsp2_20170707_005';
% data = load(file);
% boop = 53;

% Get stimulus information
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

%%
startBin = 5;
endBin = 25;
params = [data.rf data.amplitude data.orientation data.spatialFrequency data.radius data.pos_x data.pos_y]; % make a column matrix  of all of the parameters
types = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type
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
    disp('3 stimulus locations run')
elseif legitLocs == 5
    disp('5 stimulus locations run, must be combining days for WU')
elseif legitLocs > 5
    error('Found more than 5 stimulus locations used')
end
%% Initialize data structures for blank data

typeTps = types';  % Transpose the stimulus type array so it's now each column is a unique stimulus.
blankParams = typeTps(:,(end-(legitLocs - 1)):end); % Define which stimuli are the blanks

numBlank = size(blankParams,1) + (legitLocs .* size(stimResps{end},1)) + 4; % multiplying by legitLocs because there are three blanks, and adding 4 onto the end for mean, median, ste, and normalized response.

blankCountCh = nan(numBlank,1);
blankSpikeCount  = cell(1,96);
blankZscore = cell(1,96);
%% initialize data structures for stimulus data
typeTps = typeTps(:,1:end-legitLocs); % Define which stimuli are not blanks.
%numStim = size(typeTps,1) + size(stimResps{1},1) + 4;
numParams = size(typeTps,1);

RFspikeCount = cell(1,96);
RFzScore = cell(1,96);

for r = 1:(size(stimResps,1) - legitLocs)
    numTrials(r,1) = size(stimResps{r},1);
end
tmpRows = size(typeTps,1) + max(numTrials) + 4; % parameters + trials + summary data
tmpCols = size(typeTps,2);
countTmp = nan(tmpRows,tmpCols);
%% Make the matrices of responses to a blank stimulus for each channel
for ch = 1:96
    blankCountCh = nan(numBlank,1);
    blankCountCh(1:size(blankParams,1),1) = blankParams(:,1);
    blankZscoreCh(1:size(blankParams,1),1) = blankParams(:,1);
    
    for t = 1:legitLocs-1
        if t == 1
            a = stimResps{end}(:,startBin:endBin,ch);
            b = stimResps{end-t}(:,startBin:endBin,ch); % still need end-1, otherwise it gets skipped
            a = [a; b];
        else
            b = stimResps{end-t}(:,startBin:endBin,ch);
            a = [a; b]; % a is a matrix with 
        end
    end
    
    blankSpikeTmp =  nansum(a,2);   
    blankCountCh(8:8+length(a)-1) = blankSpikeTmp;    
    blankZscoreCh(8:8+length(a)-1) = zscore(blankSpikeTmp);   
    
    blankSpikeCount{ch} = blankCountCh;
    blankZscore{ch} = blankZscoreCh;
    
    clear blankSpikeTmp
    %% Make the matrices of responses to each stimulus for each channel
    %tmp = nan(21,size(typeTps,2));
    for r = 1:size(typeTps,2)
        countTmp(1:size(typeTps,1),:) = typeTps;
        zTmp(1:size(typeTps,1),:) = typeTps;
        stimSpikes = nansum(stimResps{r}(:,startBin:endBin,ch),2);

        countTmp(numParams+1:(numParams+1)+length(stimSpikes)-1,r) = stimSpikes;
        zTmp(numParams+1:(numParams+1)+length(stimSpikes)-1,r) = zscore(stimSpikes);
    end
    RFspikeCount{ch} = countTmp;
    RFzScore{ch} = zTmp;
end
