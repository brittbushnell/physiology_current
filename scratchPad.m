radZ = squeeze(conRadLE.radZscore (end,:,:,:,:));
conZ = squeeze(conRadLE.conZscore (end,:,:,:,:));

% % get zscores for preferred prarameters
% prefConZs = nan(96,size(conRadLE.conZscore,5));
% prefRadZs = nan(96,size(conRadLE.radZscore,5));
ndx = 1;
for ch = 1:96
    if trLE.inStimCenter(ch) == 1 && trLE.inStimCenter(ch) == 1
        if trLE.prefParamsIndex(ch) == 1
            prefConZs(ndx,:) = squeeze(conZ(1,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,1,ch,:));
        elseif trLE.prefParamsIndex(ch) == 2
            prefConZs(ndx,:) = squeeze(conZ(1,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(1,2,ch,:));
        elseif trLE.prefParamsIndex(ch) == 3
            prefConZs(ndx,:) = squeeze(conZ(2,1,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,1,ch,:));
        else
            prefConZs(ndx,:) = squeeze(conZ(2,2,ch,:));
            prefRadZs(ndx,:) = squeeze(radZ(2,2,ch,:));
        end
        ndx = ndx+1;
    end
end
V1prefConZsLE = nanmean(prefConZs,2);
V1prefRadZsLE = nanmean(prefRadZs,2);


%% 

V1prefConZs = V1prefConZs(trLE.goodCh == 1 & trLE.inStimCenter == 1);