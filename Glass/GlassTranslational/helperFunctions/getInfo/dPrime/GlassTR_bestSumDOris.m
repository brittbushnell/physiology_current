function [dataT] = GlassTR_bestSumDOris(dataT)
ors = unique(dataT.rotation);
numOris = length(ors);

vSum = nan(2,2,96);
pOrisR = nan(96,1);
SIR = nan(96,1);
prefParamResps = nan(numOris,96);
%%
if contains(dataT.animal, 'XT')
    dp = squeeze(dataT.linBlankDprime(:,end,2:end,2:end,:)); % orientation, coherence, dots, dx, ch
else
    dp = squeeze(dataT.linBlankDprime(:,end,:,:,:)); 
end

for dt = 1:2
    for dx = 1:2
        tmp = squeeze(dp(:,dt,dx,:));
        vSum(dt,dx,:) = sqrt(tmp(1,:).^2 + tmp(2,:).^2 + tmp(3,:).^2+ tmp(4,:).^2); % get the vector sum of the responses
    end
end

if contains(dataT.animal,'XT')
    pOris = squeeze(dataT.prefOri2thetaNoise(end,2:end,2:end,:)); % get the preferred orientations for all 100% coherence stimuli
    rSI = squeeze(dataT.OriSelectIndex2thetaNoise(end,2:end,2:end,:));
else
    pOris = squeeze(dataT.prefOri2thetaNoise(end,:,:,:)); % get the preferred orientations for all 100% coherence stimuli
    rSI = squeeze(dataT.OriSelectIndex2thetaNoise(end,:,:,:));
end
siA = [squeeze(vSum(1,1,:)),squeeze(vSum(1,2,:)),squeeze(vSum(2,1,:)),squeeze(vSum(2,2,:))]; % rearrange the dPrimess so each row is a ch and each dt,dx is a column
[~,indR] = max(siA,[],2);% get the indices for the dt,dx that gives the highest summed d' vSum

for ch = 1:96
    if dataT.goodCh(ch) == 1
        % go through each of the parameter combinations and figure out
        % which one is preferred for that channel. 
    if indR(ch) == 1
        pOrisR(ch) = pOris(1,1,ch);
        SIR(ch) = rSI(1,1,ch);
        prefParamResps(:,ch) = squeeze(dataT.linStimMeans(:,end,1,1,ch));
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - squeeze(dataT.noiseMeans(1,1,ch));
    elseif indR(ch) == 2
        pOrisR(ch) = pOris(1,2,ch);
        SIR(ch) = rSI(1,2,ch);
        prefParamResps(:,ch) = squeeze(dataT.linStimMeans(:,end,1,2,ch));
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - squeeze(dataT.noiseMeans(1,2,ch));
    elseif indR(ch) == 3
        pOrisR(ch) = pOris(2,1,ch);
        SIR(ch) = rSI(2,1,ch);
        prefParamResps(:,ch) = squeeze(dataT.linStimMeans(:,end,2,1,ch));
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - squeeze(dataT.noiseMeans(2,1,ch));
    elseif indR(ch) == 4
        pOrisR(ch) = pOris(2,2,ch);
        SIR(ch) = rSI(2,2,ch);
        prefParamResps(:,ch) = squeeze(dataT.linStimMeans(:,end,2,2,ch));
        prefParamRespsBaseSub(:,ch) = prefParamResps(:,ch) - squeeze(dataT.noiseMeans(2,2,ch));
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