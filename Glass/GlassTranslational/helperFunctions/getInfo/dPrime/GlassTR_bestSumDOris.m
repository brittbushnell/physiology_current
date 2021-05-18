function [dataT] = GlassTR_bestSumDOris(dataT)
ors = unique(dataT.rotation);
numOris = length(ors);

vSum = nan(2,2,96);
pOrisR = nan(96,1);
SIR = nan(96,1);
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
rSI = squeeze(dataT.OSI(end,:,:,:));
pSI = squeeze(dataT.OSISig(end,:,:,:));

siA = [squeeze(vSum(1,1,:)),squeeze(vSum(1,2,:)),squeeze(vSum(2,1,:)),squeeze(vSum(2,2,:))]; % rearrange the dPrimes so each row is a ch and each dt,dx is a column
[~,indR] = max(siA,[],2);% get the indices for the dt,dx that gives the highest summed d' vSum
%%
for ch = 1:96
    if dataT.goodCh(ch) == 1
        % go through each of the parameter combinations and figure out
        % which one is preferred for that channel. 
    if indR(ch) == 1
        pOrisR(ch) = pOris(1,1,ch);
        SIR(ch) = rSI(1,1,ch);
        pvalOSI(ch) = pSI(1,1,ch);
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,1,1,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,1,1,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,1,1,ch,:)));
    elseif indR(ch) == 2
        pOrisR(ch) = pOris(1,2,ch);
        SIR(ch) = rSI(1,2,ch);
        pvalOSI(ch) = pSI(1,2,ch);
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,1,2,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,1,2,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,1,2,ch,:)));
    elseif indR(ch) == 3
        pOrisR(ch) = pOris(2,1,ch);
        SIR(ch) = rSI(2,1,ch);
        pvalOSI(ch) = pSI(2,1,ch);
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,2,1,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,2,1,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,2,1,ch,:)));
    elseif indR(ch) == 4
        pOrisR(ch) = pOris(2,2,ch);
        SIR(ch) = rSI(2,2,ch);
        pvalOSI(ch) = pSI(2,2,ch);
        if contains(dataT.animal,'XT')
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,1,2,2,ch));
        else
            prefParamResps(:,ch) = squeeze(dataT.GlassTRZscore(:,end,2,2,ch));
        end
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - nanmean(squeeze(dataT.noiseZscore(1,1,2,2,ch,:)));
    end
    else
        pOrisR(ch) = nan;
        SIR(ch) = nan;
    end
end

%pOrisR(isnan(pOrisR)) = [];
pOris2 = pOrisR;
pOris2(pOris2<0) = pOris2(pOris2<0)+180;  

% get preferred orientation for the distribution using circular mean
cirMu = circ_mean(deg2rad(pOris2(:)*2))/2;
%cirMu2 = cirMu+pi; % no reason to save both of these in the data structure
%just need to make sure to do the reflection in the plotting codes. 
%%
dataT.prefParamResps = prefParamResps;
dataT.prefParamRespsBaseSub = prefParamRespsBaseSub;
dataT.prefParamMuOriDist = cirMu;
dataT.prefParamSI = SIR;
dataT.prefParamsPrefOri = pOris2;
dataT.prefParamsIndex = indR; % refers to dt,dx indices so 1 = (1,1) 2 = (1,2) 3 = (2,1) 4 = (2,2)