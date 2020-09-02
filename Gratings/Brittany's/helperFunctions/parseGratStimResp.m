function [gratStimResps] = parseGratStimResp(data,startBin,endBin)
% PARSEGRATSTIMRESP function will return an enormous matrix of the
% responses of a given channel to each unique stimulus.
%
%  INPUT
%    DATA structure from parser
%    CH channel number
%    STARTBIN Bin number to begin calculations on(onset latency)
%    ENDBIN Bin number to end calculation on
%
%  OUTPUT
%     GRATSTIMRESPS matrix where each column is:
%        1)   Mean response
%        2)   Standard error
%        3)   Baseline subtracted mean response
%        4)   Spatial Frequency
%        5)   Orientation
%        6)   Size
%        7)   Contrast
%        8)   X position
%        9)   Y position
%     The first column is always the blank stimulus
%
% Written April 28,2018 Brittany Bushnell
%% Testing
% clear all
% close all
% clc
% tic
%
% file = 'WU_RE_Gratings_nsp1_withRF_combo';
% data = load(file);
% startBin = 5;
% endBin = 35;
% ch = 24;
%%
numChannels = size(data.bins,3);
params = [data.spatial_frequency', data.rotation', data.width', data.contrast', data.xoffset',data.yoffset'];
%%
[types,~,indexOfTypes] = unique(params,'rows'); % types is a matrix of the stimulus parameters, index of types are the indices that correspond to each type
[groupedNums] = accumarray(indexOfTypes,1,[]);

[~,sortedIndices] = sort(indexOfTypes);
FR2 = data.bins(sortedIndices,:, :);

stimResps = mat2cell(FR2,groupedNums,size(data.bins,2),numChannels);
%% Build output matrix
typeTps = types';
tmp = nan(9,length(types));
gratStimResps = cell(1,numChannels);

for ch = 1:numChannels
    % combine all blank stimuli
    a = stimResps{1}(:,startBin:endBin,ch);
    b = stimResps{2}(:,startBin:endBin,ch);
    c = stimResps{3}(:,startBin:endBin,ch);
    d = stimResps{4}(:,startBin:endBin,ch);
    e = stimResps{5}(:,startBin:endBin,ch);
    f = stimResps{6}(:,startBin:endBin,ch);
    g = stimResps{7}(:,startBin:endBin,ch);
    h = stimResps{8}(:,startBin:endBin,ch);
    i = stimResps{9}(:,startBin:endBin,ch);
    j = stimResps{10}(:,startBin:endBin,ch);
    k = stimResps{11}(:,startBin:endBin,ch);
    l = stimResps{12}(:,startBin:endBin,ch);
    m = stimResps{13}(:,startBin:endBin,ch);
    n = stimResps{14}(:,startBin:endBin,ch);
    bkMtx = [a; b; c;d; e; f; g; h; i; j; k; l; m; n];
    bkMtx = double(bkMtx);
    
    tmp(1,1) = mean(mean(bkMtx(:)))./.01;
    tmp(2,1) = std(bkMtx(:))/sqrt(length(bkMtx(:)))./0.010;
    tmp(3,1) = tmp(1,1) - tmp(1,1);
    tmp(4:end,1) = typeTps(:,1);
    
    blank = tmp(1,1);
    ndx = 2;
    for r = 14:length(types) %the first three are the blank stimuli
        % goal: structure with the RFStimResps matrix for each channel
        useBins = stimResps{r}(:,startBin:endBin,ch);
        useBins = double(useBins);
        
        tmp(1,ndx) = mean(useBins(:))./.01;
        tmp(2,ndx) = std(useBins(:))/sqrt(length(useBins(:)))./0.010;
        tmp(3,ndx) = tmp(1,ndx) - blank;
        tmp(4:end,ndx) = typeTps(:,r);
        
        ndx = ndx+1;
    end
    tmp = tmp(:,all(~isnan(tmp))); % remove columns that are all nan
    gratStimResps{ch} = tmp;
end
%% Get stimulus information
% all of the other unique parameters are stored in the file name and need
% to be parsed out.

% find unique stimuli run, and flip so blank will be first
%
% sfs   = unique(data.spatial_frequency);
% oris  = unique(data.rotation);
% width = unique(data.width); %do not call this size! size is already a function!!!
% xloc  = unique(data.xoffset);
% yloc  = unique(data.yoffset);
% cons = unique(data.contrast);
% %% The rest of the stimuli
% ndx = 1;
% for sf = 1:length(sfs)
%     for or = 1:length(oris)
%         for sz = 1:length(width)
%             for cn = 1:length(cons)
%                 for xs = 1:length(xloc)
%                     for ys = 1:length(yloc)
%
%                         tmp = sum((data.spatial_frequency == sfs(sf)) .* ...
%                             (data.rotation == oris(or)) .* ...
%                             (data.width == width(sz)) .* ...
%                             (data.contrast == cons(cn)) .* ...
%                             (data.xoffset == xloc(xs)) .* ...
%                             (data.yoffset == yloc(ys)));
%                         tmpNdx = find(tmp > 0);
%
%                         useRuns = data.bins(tmpNdx,startBin:endBin,ch);
%                         useRuns = double(useRuns);
%                         gratStimResps(1,ndx) = mean(useRuns(:))./0.01;
%                         gratStimResps(2,ndx) = std(useRuns(:))/sqrt(length(useRuns(:)))./0.010;
%                         gratStimResps(3,ndx) = gratStimResps(1,ndx) - gratStimResps(1,1);
%
%                         % say what the stimulus paramters are
%                         % for that mean
%                         gratStimResps(4,ndx) = sfs(sf);
%                         gratStimResps(5,ndx) = oris(or);
%                         gratStimResps(6,ndx) = width(sz);
%                         gratStimResps(7,ndx) = cons(cn);
%                         gratStimResps(8,ndx) = xloc(xs);
%                         gratStimResps(9,ndx) = yloc(ys);
%
%                         ndx = ndx+1;
%                     end
%                 end
%             end
%         end
%     end
% end
