function [oriXsfResps, normOriXsf] = getMwksRespsOrixSF_gCh(data,ch,shuffle,dataType)
% This function creates a response matrix for a given channel where each
% row is an orienation and each column is a spatial frequency.
% SHUFFLE:  if set to 1, will run a shuffle test, otherwise will only return real data responses.
% DATATYPE: if set to 0, will only use data in data.goodBins 
%
% NormOirXsf is normalized by the standard deviation of the responses to
% baseline.
%
% Note: the black and white flashes were only shown at one "orientation" so
% several of those blocks will be NAN.
%
% Written Jan 17, 2018 Brittany Bushnell
% Edited Feb 4, 2018 to take the average of responses to 0 and 180 degs

sfs = unique(data.spatial_frequency);
%sfs = [(sfs(1,1)), (sfs(1,4:end))];  % get rid of the black and white flashed stimuli
ori = unique(data.rotation);

numSF = length(sfs);
numOri = length(ori);

% oriXsfRespsT = nan(numOri,numSF);
% oriXsfResps = nan(numOri,numSF);

for or = 1:numOri
    for sf = 1:numSF
        tmpNdx = find((data.rotation == ori(1,or)) .* (data.spatial_frequency ==  sfs(1,sf)));
        if shuffle  == 0
            if dataType == 0
                useRuns = double(data.goodBins(tmpNdx, data.latency(1,ch):data.latency(2,ch), ch));
            else
                useRuns = double(data.bins(tmpNdx, data.latency(1,ch):data.latency(2,ch), ch));
            end
            oriXsfRespsT(or,sf) = mean(useRuns(:)) ./0.01;
        else
            % shuffle test
            shuffNdx = randsample(size(data.rotation), size(tmpNdx));
            if dataType == 0
                useRuns = double(data.goodBins(tmpNdx, data.latency(1,ch):data.latency(2,ch), ch));
            else
                useRuns = double(data.bins(tmpNdx, data.latency(1,ch):data.latency(2,ch), ch));
            end
            oriXsfRespsT(or,sf) = mean(useRuns(:)) ./0.01;
        end
    end
end
if length(ori) == 7
    % orientations 0 and 180 were identical, so taking the mean response of
    % both of them.
    a = oriXsfRespsT(1,:);
    b = oriXsfRespsT(end,:);
    c = [a;b];
    
    c = mean(c);
    oriXsfResps = [c; oriXsfRespsT((2:end-1),:)];
else
    oriXsfResps = oriXsfRespsT;
end


% for or = 1:numOri-1
%     for sf = 1:numSF
%         baseSub(or,sf) = oriXsfResps(or,sf) - nanmean(oriXsfResps(:,1));
%         baseSub_shuffle(or,sf) = oriXsfResps_shuffle(or,sf) - nanmean(oriXsfResps_shuffle(:,1));
%     end
% end
%
% normOriXsf = zscore(baseSub);
% normOriXsf_shuffle = zscore(baseSub_shuffle);

normOriXsf = (oriXsfResps - nanmean(oriXsfResps(:,1)))./std(oriXsfResps(:,1));