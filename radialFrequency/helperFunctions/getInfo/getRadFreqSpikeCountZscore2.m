function [RFspikeCount,blankSpikeCount,RFzScore,blankZscore] = getRadFreqSpikeCountZscore2(dataT)
% getRadFreqSpikeCount function will return an cell matrix of the
% spike counts of each channel to each unique stimulus. Run this after
% parseRadFreqStimResp to get the stimResps cell array, that way you don't
% have to repeat the manipulation of the dataT.
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
%        5)   Size (mean radius)
%        6)   X position
%        7)   Y position
%        8-#reps) zScores
%
%   RFzScore and blankZscore are identical to the spike count cell arrays,
%   but instead of rows 9:end containing spike counts for each repeat, it
%   contains the zscores.
%
% September 9, 2020 Brittany Bushnell
%
% modified May 25, 2021 Brittany Bushnell
%   rearrange spike count and zscore computations to fix bug with zscores.
%%
stimResps = dataT.stimResps;

startBin = 5;
endBin = 25;
params = [dataT.rf dataT.amplitude dataT.orientation dataT.spatialFrequency dataT.radius dataT.pos_x dataT.pos_y]; % make a column matrix  of all of the parameters
types = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type
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
%% initialize blank data structures
typeCol = types';  % this will be the first 7 rows of all data matrices with stim info
[~,blankCols] = find(typeCol == 10000); % find the columns that have blank data
blankParams = typeCol(:,unique(blankCols)); % Define which stimuli are the blanks

numBlank = size(blankParams,1) + (legitLocs .* size(stimResps{end},1)); % multiplying by legitLocs because there are three blanks

blankSpikeCount  = cell(1,96);
blankZscore = cell(1,96);
%% initialize stimulus data structures
typeCol = typeCol(:,1:end-legitLocs); % Define which stimuli are not blanks.
numParams = size(typeCol,1);

RFspikeCount = cell(1,96);
RFzScore = cell(1,96);

for r = 1:(size(stimResps,1) - legitLocs)
    numTrials(r,1) = size(stimResps{r},1);
end
%%
tmpRows = size(typeCol,1) + max(numTrials); % parameters + trials
tmpCols = size(typeCol,2);
countTmp = nan(tmpRows,tmpCols);
zTmp = nan(tmpRows,tmpCols);
stimZsAllCh = [];
blankZsAllCh = [];
%% spike counts
for ch = 1:96
    %% blank stimuli
    blankDataCh = nan(numBlank,1);
    
    for t = 1:legitLocs-1
        if t == 1
            a = stimResps{end}(:,startBin:endBin,ch);
            b = stimResps{end-t}(:,startBin:endBin,ch); % still need end-1, otherwise it gets skipped
            a = [a; b];
        else
            b = stimResps{end-t}(:,startBin:endBin,ch);
            a = [a; b]; % a is reps x bins for that channel
        end
    end
    
    blankSpikes =  nansum(a,2); % summed spikes on each repeat
    
    blankDataCh = [blankParams(:,1);blankSpikes];
    
    blankSpikeCount{ch} = blankDataCh;
    %% stimulus spike counts
    stimSpikes = nan(max(numTrials,[],'all'),size(typeCol,2));
    for r = 1:size(typeCol,2)
        spikesT = nansum(stimResps{r}(:,startBin:endBin,ch),2);
        stimSpikes(1:length(spikesT),r) = spikesT;
    end
    
    stimCount = [typeCol; stimSpikes];
    RFspikeCount{ch} = stimCount;
    %% zscore spike counts
    spikeVect = reshape(stimSpikes,[numel(stimSpikes),1]);
    chSpikes = [spikeVect; blankSpikes];
    
    chMu = nanmean(chSpikes,'all');
    chStd = nanstd(chSpikes,0,'all');
    
    % blank zscores
    bTmp = (blankSpikes - chMu)./chStd;
    blankZscoreCh = [blankParams(:,1); bTmp];
    blankZscore{ch} = blankZscoreCh;
    
    % stimulus zscores
    for r = 1:size(typeCol,2)
        stimZtmp(:,r) = (stimSpikes(:,r) - chMu)/chStd;
    end
    
    zTmp = [typeCol; stimZtmp];
    RFzScore{ch} = zTmp;
    %%
    stimZsAllCh = [stimZsAllCh; stimZtmp];
    blankZsAllCh = [blankZsAllCh; bTmp];
end

%% sanity check figure
figure(1)
clf

subplot(2,1,1)
hold on
histogram(blankZsAllCh,'BinWidth',0.25,'Normalization','probability')
title('blank all ch')
xlim([-5 5])

subplot(2,1,2)
hold on
histogram(stimZsAllCh,'BinWidth',0.25,'Normalization','probability')
title('stimuli all ch')
xlim([-5 5])




