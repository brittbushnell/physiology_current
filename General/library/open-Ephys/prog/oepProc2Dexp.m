function S = oepProc2Dexp(azDir,unitLabel,runNum,isBlank,xVals,X,yVals,Y,doBoot)

if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;

nX = numel(xVals);
nY = numel(yVals);

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
    for iY = 1:nY
        bind = ~isBlank & (X==xVals(iX)) & (Y==yVals(iY));
        S.nTrials(iY,iX) = sum(bind);

        % Threshold crossings
        S.count{iY,iX} = passSpikeCounts(bind,:,:);
        S.countMean(iY,iX,:,:) = reshape(nanmean(S.count{iY,iX}),[1,1,nElec,1+nIso]);
        S.countStd(iY,iX,:,:) = reshape(nanstd(S.count{iY,iX}),[1,1,nElec,1+nIso]);
        S.countSem(iY,iX,:,:) = S.countStd(iY,iX,:,:)./sqrt(S.nTrials(iY,iX));
        if doBoot
            for iIso = 1:1+nIso
                S.countBoot(:,iY,iX,:,iIso) = bootstrp(nBoot,@mean,S.count{iY,iX}(:,:,iIso));
            end
        end
        if doPsth
            S.psthMean(:,iY,iX,:,:) = reshape(mean(passPsth(:,bind,:,:),2),[nT,1,1,nElec,1+nIso]);
            S.psthStd(:,iY,iX,:,:) = reshape(std(passPsth(:,bind,:,:),[],2),[nT,1,1,nElec,1+nIso]);
            S.psthSem(:,iY,iX,:,:) = S.psthStd(:,iY,iX,:,:)./sqrt(S.nSponTrials);
        end
        
        % Spike-band power
        S.pow{iY,iX} = passPow(bind,:);
        S.powMean(iY,iX,:) = nanmean(S.pow{iY,iX});
        S.powStd(iY,iX,:) = nanstd(S.pow{iY,iX});
        S.powSem(iY,iX,:) = S.powStd(iY,iX,:)./sqrt(S.nTrials(iY,iX));
        if doBoot
            S.powBoot(:,iY,iX,:) = bootstrp(nBoot,@mean,S.pow{iY,iX});
        end
    end
end
    
if doBoot
    S.countBootMean = reshape(mean(S.countBoot),[nY,nX,nElec,1+nIso]);
    S.countBootCi = reshape(prctile(S.countBoot,[5,95]),[2,nY,nX,nElec,1+nIso]);
    S.powBootMean = reshape(mean(S.powBoot),[nY,nX,nElec]);
    S.powBootCi = reshape(prctile(S.powBoot,[5,95]),[2,nY,nX,nElec]);
end

S.powSub = bsxfun(@minus,S.powMean,reshape(S.sponPowMean,[1,1,nElec]));
S.powNorm = bsxfun(@rdivide,S.powSub,reshape(S.sponPowMean,[1,1,nElec]));
S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,nElec,1+nIso]));
if doPsth
    S.psthSub = bsxfun(@minus,S.psthMean,reshape(S.sponPsthMean,[nT,1,1,nElec,1+nIso]));
end
    