function [dataT] = GlassTR_bestSumDOris(dataT)
ors = unique(dataT.rotation);
numOris = length(ors);

vSum = nan(2,2,96);
pOrisVsum = nan(96,1);
sigOSIpref = nan(96,1);
pOSI = nan(96,1);
prefParamResps = nan(numOris,96);
%%

dp = squeeze(dataT.linBlankDprime(:,end,:,:,:)); % limit to 100% coherence.  

for dt = 1:2
    for dx = 1:2
        tmp = squeeze(dp(:,dt,dx,:));
        vSum(dt,dx,:) = sqrt(tmp(1,:).^2 + tmp(2,:).^2 + tmp(3,:).^2+ tmp(4,:).^2); % get the vector sum of the responses
    end
end

pOris = squeeze(dataT.prefOri(end,:,:,:)); % get the preferred orientations for all 100% coherence stimuli
distSI = squeeze(dataT.OSI(end,:,:,:));
sigSI = squeeze(dataT.OSISig(end,:,:,:));

vSumMtx = [squeeze(vSum(1,1,:)),squeeze(vSum(1,2,:)),squeeze(vSum(2,1,:)),squeeze(vSum(2,2,:))]; % rearrange the dPrimes so each row is a ch and each dt,dx is a column
[~,prefParamsNdx] = max(abs(vSumMtx),[],2);% get the indices for the dt,dx that gives the highest summed d' vSum
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1 && dataT.inStim(ch) == 1
        % go through each of the parameter combinations and figure out
        % which one is preferred for that channel. 
    if prefParamsNdx(ch) == 1
        pOrisVsum(ch) = pOris(1,1,ch);
        pOSI(ch) = distSI(1,1,ch);
        sigOSIpref(ch) = sigSI(1,1,ch);
        
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,1,1,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,1,1,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,1,1,ch,:)));
        
    elseif prefParamsNdx(ch) == 2
        pOrisVsum(ch) = pOris(1,2,ch);
        pOSI(ch) = distSI(1,2,ch);
        sigOSIpref(ch) = sigSI(1,2,ch);
        
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,1,2,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,1,2,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,1,2,ch,:)));
        
    elseif prefParamsNdx(ch) == 3
        pOrisVsum(ch) = pOris(2,1,ch);
        pOSI(ch) = distSI(2,1,ch);
        sigOSIpref(ch) = sigSI(2,1,ch);
        
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,2,1,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,2,1,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,2,1,ch,:)));
        
    elseif prefParamsNdx(ch) == 4
        pOrisVsum(ch) = pOris(2,2,ch);
        pOSI(ch) = distSI(2,2,ch);
        sigOSIpref(ch) = sigSI(2,2,ch);
        
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,2,2,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,2,2,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,2,2,ch,:)));
    end
    else
        pOrisVsum(ch) = nan;
        pOSI(ch) = nan;
    end
end

%pOrisR(isnan(pOrisR)) = [];
pOris2 = pOrisVsum;
pOris2(pOris2<0) = pOris2(pOris2<0)+180;  

% get preferred orientation for the distribution using circular mean
cirMu = circ_mean(deg2rad(pOris2(:)*2))/2;
%cirMu2 = cirMu+pi; % no reason to save both of these in the data structure
%just need to make sure to do the reflection in the plotting codes. 
%%
dataT.prefParamResps = prefParamResps;
dataT.prefParamRespsBaseSub = prefParamRespsBaseSub;
dataT.prefParamMuOriDist = cirMu;
dataT.prefParamSI = pOSI;
dataT.prefParamsPrefOri = pOris2;
dataT.prefParamsIndex = prefParamsNdx; % refers to dt,dx indices so 1 = (1,1) 2 = (1,2) 3 = (2,1) 4 = (2,2)