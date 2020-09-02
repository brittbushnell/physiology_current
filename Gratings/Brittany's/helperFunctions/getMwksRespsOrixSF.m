function [oriXsfResps, bsOriXsfResps] = getMwksRespsOrixSF(data,ch)
% This function creates a response matrix for a given channel where each
% row is an orienation and each column is a spatial frequency.
% SHUFFLE:  if set to 1, will run a shuffle test, otherwise will only return real data responses.
%
% bsOirXsf is base ond baseline subtracted responses
%
% Note: the black and white flashes were only shown at one "orientation" so
% several of those blocks will be NAN.
%
% Written Jan 17, 2018 Brittany Bushnell
% Edited Feb 4, 2018 to take the average of responses to 0 and 180 degs
% Edited May 3, 2018 to work with different input need to add in shuffle
% again later.

sfs = unique(data.spatial_frequency);
sfs = [(sfs(1,1)), (sfs(1,4:end))];  % get rid of the black and white flashed stimuli
ori = unique(data.rotation);

numSF = length(sfs);
numOri = length(ori);


for or = numOri
    for sf = numSF
        tmp = find((data.stimResps{ch}(5,:) == ori(or)) & (data.stimResps{ch}(4,:) == sfs(sf)));
        oriXsfRespsT(or,sf) = data.stimResps{ch}(1,tmp);
        bsOriXsfRespsT(or,sf) =  data.stimResps{ch}(3,tmp);
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

if length(ori) == 7
    % orientations 0 and 180 were identical, so taking the mean response of
    % both of them.
    a = bsOriXsfRespsT(1,:);
    b = bsOriXsfRespsT(end,:);
    c = [a;b];
    
    c = mean(c);
    bsOriXsfResps = [c; bsOriXsfRespsT((2:end-1),:)];
else
    bsOriXsfResps = bsOriXsfRespsT;
end




%% old version
% oriXsfRespsT = nan(numOri,numSF);
% oriXsfResps = nan(numOri,numSF);

% for or = 1:numOri
%     for sf = 1:numSF
%         tmpNdx = find((data.rotation == ori(1,or)) .* (data.spatial_frequency ==  sfs(1,sf)));
%         if shuffle  == 0
%             useRuns = double(data.bins(tmpNdx, data.latency(1,ch):data.latency(2,ch), ch));
%             oriXsfRespsT(or,sf) = mean(useRuns(:)) ./0.01;
%         else
%             % shuffle test
%             shuffNdx = randsample(size(data.rotation), size(tmpNdx));
%             useRuns = double(data.bins(shuffNdx, data.latency(1,ch):data.latency(2,ch), ch));
%             oriXsfRespsT(or,sf) = mean(useRuns(:)) ./0.01;
%         end
%     end
% end
% if length(ori) == 7
%     % orientations 0 and 180 were identical, so taking the mean response of
%     % both of them.
%     a = oriXsfRespsT(1,:);
%     b = oriXsfRespsT(end,:);
%     c = [a;b];
%     
%     c = mean(c);
%     oriXsfResps = [c; oriXsfRespsT((2:end-1),:)];
% else
%     oriXsfResps = oriXsfRespsT;
% end
% 
% normOriXsf = (oriXsfResps - nanmean(oriXsfResps(:,1)))./std(oriXsfResps(:,1));