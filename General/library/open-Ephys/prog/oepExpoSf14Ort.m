function S = oepExpoSf14Ort(azDir,unitLabel,runNum,doBoot,doPlot)

forceOverwrite = 1;

if ~exist('doPlot','var')
    doPlot = false;
end
if ~exist('doBoot','var')
    doBoot = false;
end
nElec = 32;
nBoot = 100;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum);
azFile = [azDir,'/',runStr,'_sf14OrtAz.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoSf14Ort: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passPow','passSpikeCounts');
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    con1 = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];
    con2 = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],1,'Contrast')];
    isBlank = con1==0 & con2==0;
    
    passSf = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],1,'Spatial Frequency X')];
    sfVals = unique(passSf( ~isnan(passSf) & ~isBlank ));
    nSf = numel(sfVals);
    S.sfVals = sfVals;
    S.nSf = nSf;

    S.nSponTrials = sum(isBlank);
    S.sponPow = passPow(isBlank,:);
    S.sponPowMean = nanmean(S.sponPow);
    S.sponPowStd = nanstd(S.sponPow);
    S.sponPowSem = S.sponPowStd./sqrt(S.nSponTrials);
    S.sponCountMean = mean(passSpikeCounts(isBlank,:));

    S.nTrials = nan(nSf,2);
    S.powMean = nan(nSf,2,nElec);
    S.powStd = S.powMean;
    S.powSem = S.powMean;
    S.countMean = S.powMean;
    
    isMask = con1>0;
    for iM = 1:2
        for iS = 1:nSf
            if iM==1
                bind = ~isBlank & ~isMask & passSf==sfVals(iS);
            else
                bind = ~isBlank & isMask & passSf==sfVals(iS);
            end
            S.nTrials(iS,iM) = sum(bind);
            S.pow{iS,iM} = passPow(bind,:);
            S.powMean(iS,iM,:) = nanmean(S.pow{iS,iM});
            S.powStd(iS,iM,:) = nanstd(S.pow{iS,iM});
            S.powSem(iS,iM,:) = S.powStd(iS,iM)./sqrt(S.nTrials(iS,iM));
            S.countMean(iS,iM,:) = mean(passSpikeCounts(bind,:));

        end
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
        semilogx(S.sfVals,Y(:,1,iA),'ko-'), hold on
        semilogx(S.sfVals,Y(:,2,iA),'ro-')
%         ylim(yL)
    end
    set(gcf,'name','sfOrtho')
end