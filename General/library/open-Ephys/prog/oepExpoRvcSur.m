function S = oepExpoRvcSur(azDir,unitLabel,runNum,doBoot,doPlot)

forceOverwrite = 0;

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_rvcSurAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoRvcSur: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passPow','passSpikeCounts');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    con1 = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],2,'Contrast')];
    con2 = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    conVals = unique(con1(2:end));
    nCon = numel(conVals);
    S.conVals = conVals;
    
    isBlank = con1==0 & con2==0;
    S.nSponTrials = sum(isBlank);
    S.sponPow = passPow(isBlank,:);
    S.sponPowMean = nanmean(S.sponPow);
    S.sponPowStd = nanstd(S.sponPow);
    S.sponPowSem = S.sponPowStd./sqrt(S.nSponTrials);
    S.sponCountMean = mean(passSpikeCounts(isBlank,:));
    
    S.nTrials = nan(nCon,2);
    S.powMean = nan(nCon,2,nElec);
    S.powStd = S.powMean;
    S.powSem = S.powMean;
    S.countMean = S.powMean;
    
    maskID = [nan;GetEvents(ExpoIn,passIDs,'Surface','',1,'Width')];
    maskIDvals = unique(maskID(2:end));
    isMaskIDreg = maskID == median(maskIDvals); % Middle ID size if 3 were used. Fix later to use other sizes
    isMask = con2>0 & isMaskIDreg;
    for iM = 1:2
        for iC = 1:nCon
            if iM==1
                bind = ~isMask & con1==conVals(iC);
            else
                bind = ~isBlank & isMask & con1==conVals(iC);
            end
            S.nTrials(iC,iM) = sum(bind);
            S.pow{iC,iM} = passPow(bind,:);
            S.powMean(iC,iM,:) = nanmean(S.pow{iC,iM});
            S.powStd(iC,iM,:) = nanstd(S.pow{iC,iM});
            S.powSem(iC,iM,:) = S.powStd(iC,iM)./sqrt(S.nTrials(iC,iM));
            S.countMean(iC,iM,:) = mean(passSpikeCounts(bind,:));
        end
    end
    if doBoot
        S.powBootMean = reshape(mean(S.powBoot),[nCon,2,nElec]);
        S.powBootCi = reshape(prctile(S.powBoot,[5,95]),[2,nCon,2,nElec]);
    end

    S.powSub = bsxfun(@minus,S.powMean,reshape(S.sponPowMean,[1,1,nElec]));
    S.powNorm = bsxfun(@rdivide,S.powSub,reshape(S.sponPowMean,[1,1,nElec]));
    S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,nElec]));
    save(azFile,'S')
else
    load(azFile)
end
    
if doPlot
    load ChanMap_A32
    figure, hold on
    Y = S.countSub;
%     Y = S.powNorm;
    yL = max(Y(:)).*[-0.1,1.1];
    for iA = 1:nElec
        subplot(5,7,find(chanMap==iA))
        semilogx(S.conVals,Y(:,1,iA),'ko-'), hold on
        semilogx(S.conVals,Y(:,2,iA),'ro-')
%         ylim(yL)
    end
    set(gcf,'name','rvcSur')
end