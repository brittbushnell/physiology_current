function S = oepProc1Dexp(azDir,unitLabel,runNum,isBlank,xVals,X,doBoot)

if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;

nX = numel(xVals);

passRespFile = oepGetPassRespFile(azDir,unitLabel,runNum);
load(passRespFile,'ExpoIn','passSpikeCounts','passPow','passPsth');

nIso = size(passSpikeCounts,3)-1;
doPsth = ~isempty(passPsth);
if doPsth; nT=size(passPsth,1); end

%%% ------- Blank conditions ------- %%%
S.nSponTrials = sum(isBlank);
    
% Threshold crossings
S.sponCount = passSpikeCounts(isBlank,:,:);
S.sponCountMean = reshape(nanmean(S.sponCount),[nElec,1+nIso]);
S.sponCountStd = reshape(nanstd(S.sponCount),[nElec,1+nIso]);
S.sponCountSem = S.sponCountStd./sqrt(S.nSponTrials);
if doBoot
    for iIso = 1:1+nIso
        S.sponCountBoot(:,:,iIso) = bootstrp(nBoot,@mean,S.sponCount(:,:,iIso));
        S.sponCountBootMean(:,iIso) = mean(S.sponCountBoot(:,:,iIso));
        S.sponCountBootCi(:,:,iIso) = prctile(S.sponCountBoot(:,:,iIso),[5,95]);
    end
end
if doPsth
    S.sponPsthMean = reshape(mean(passPsth(:,isBlank,:,:),2),[nT,nElec,1+nIso]);
    S.sponPsthStd = reshape(std(passPsth(:,isBlank,:,:),[],2),[nT,nElec,1+nIso]);
    S.sponPsthSem = S.sponPsthStd./sqrt(S.nSponTrials);
end

% Spike-band power
S.sponPow = passPow(isBlank,:);
S.sponPowMean = nanmean(S.sponPow);
S.sponPowStd = nanstd(S.sponPow);
S.sponPowSem = S.sponPowStd./sqrt(S.nSponTrials);
if doBoot
    S.sponPowBoot = bootstrp(nBoot,@mean,S.sponPow);
    S.sponPowBootMean = mean(S.sponPowBoot);
    S.sponPowBootCi = prctile(S.sponPowBoot,[5,95]);
end
    

%%% ------- Stimulus conditions ------- %%%
for iX = 1:nX
    bind = ~isBlank & (X==xVals(iX));
    S.nTrials(iX) = sum(bind);

    if S.nTrials(iX)
        % Threshold crossings
        S.count{iX} = passSpikeCounts(bind,:,:);
        S.countMean(iX,:,:) = reshape(nanmean(S.count{iX}),[nElec,1+nIso]);
        S.countStd(iX,:,:) = reshape(nanstd(S.count{iX}),[nElec,1+nIso]);
        S.countSem(iX,:,:) = S.countStd(iX,:,:)./sqrt(S.nTrials(iX));
        if doBoot
            for iIso = 1:1+nIso
                S.countBoot(:,iX,:,iIso) = bootstrp(nBoot,@mean,S.count{iX}(:,:,iIso));
            end
        end
        if doPsth
            S.psthMean(:,iX,:,:) = reshape(mean(passPsth(:,bind,:,:),2),[nT,1,nElec,1+nIso]);
            S.psthStd(:,iX,:,:) = reshape(std(passPsth(:,bind,:,:),[],2),[nT,1,nElec,1+nIso]);
            S.psthSem(:,iX,:,:) = S.psthStd(:,iX,:,:)./sqrt(S.nSponTrials);
        end

        % Spike-band power
        S.pow{iX} = passPow(bind,:);
        S.powMean(iX,:) = nanmean(S.pow{iX});
        S.powStd(iX,:) = nanstd(S.pow{iX});
        S.powSem(iX,:) = S.powStd(iX,:)./sqrt(S.nTrials(iX));
        if doBoot
            S.powBoot(:,iX,:) = bootstrp(nBoot,@mean,S.pow{iX});
        end
    end
end
    
if doBoot
    S.countBootMean = reshape(mean(S.countBoot),[nX,nElec,1+nIso]);
    S.countBootCi = reshape(prctile(S.countBoot,[5,95]),[2,nX,nElec,1+nIso]);
    S.powBootMean = reshape(mean(S.powBoot),[nX,nElec]);
    S.powBootCi = reshape(prctile(S.powBoot,[5,95]),[2,nX,nElec]);
end

S.powSub = bsxfun(@minus,S.powMean,S.sponPowMean);
S.powNorm = bsxfun(@rdivide,S.powSub,S.sponPowMean);

S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,nElec,1+nIso]));
if doPsth
    S.psthSub = bsxfun(@minus,S.psthMean,reshape(S.sponPsthMean,[nT,1,nElec,1+nIso]));
end
    