function S = oepExpoOriSfPhase(azDir,unitLabel,runNum,doPsth,loadFileSuffix)

if ~exist('loadFileSuffix','var')
    loadFileSuffix = '';
end
if ~exist('doPsth','var')
    doPsth = false;
end
nElec = 32;
doBoot = 1;
nBoot = 1000;
sigThresh = 0.01;
forceOverwrite = 1;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum,loadFileSuffix);
ospAzFile = [azDir,'/',runStr,'_OriSfPhase.mat'];

if ~exist(ospAzFile,'file') || forceOverwrite
    fprintf(['oepExpoOriSfPhase: ',runStr,'\n'])

    if doPsth
        load(passRespFile,'ExpoIn','passSpikeCounts','passPow','passPsth');
    else
        load(passRespFile,'ExpoIn','passSpikeCounts','passPow');
    end
    nIso = size(passSpikeCounts,3)-1;
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passOri = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Orientation')];
    passPhi = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Phase')];
    passSf = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Spatial Frequency X')];
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];

    isBlank = passCon==0;
    temp = unique(passOri);
    S.oriVals = temp(~isnan(temp));
    nOri = numel(S.oriVals);
    temp = unique(passSf);
    S.sfVals = temp(~isnan(temp));
    nSf = numel(S.sfVals);
    temp = unique(passPhi);
    S.phiVals = temp(~isnan(temp));
    nPhi = numel(S.phiVals);
    doPhase = nPhi<50;
    
    S.nSponTrials = sum(isBlank);
    S.sponCount = passSpikeCounts(isBlank,:,:);
    S.sponCountMean = reshape(mean(S.sponCount),[nElec,1+nIso]);
    S.sponCountStd = reshape(std(S.sponCount),[nElec,1+nIso]);
    S.sponCountSem = S.sponCountStd./sqrt(S.nSponTrials);
    S.sponPow = passPow(isBlank,:);
    S.sponPowMean = mean(S.sponPow);
    S.sponPowStd = std(S.sponPow);
    S.sponPowSem = S.sponPowStd./sqrt(S.nSponTrials);
    if doBoot
        sponCountBs = nan(nBoot,nElec,1+nIso);
        for iB = 1:nBoot
            ind = randsample(S.nSponTrials,S.nSponTrials,true);
            sponCountBs(iB,:,:) = mean(S.sponCount(ind,:,:));
        end
        S.sponCountBsMed = reshape(median(sponCountBs),[nElec,1+nIso]);
        S.sponCountBsCi = reshape(prctile(sponCountBs,[5,95]),[2,nElec,1+nIso]);
    end
    
    if doPsth
        nT = size(passPsth,1);
        S.sponPsthMean = reshape(mean(passPsth(:,isBlank,:,:),2),[nT,nElec,1+nIso]);
        S.sponPsthStd = reshape(std(passPsth(:,isBlank,:,:),[],2),[nT,nElec,1+nIso]);
        S.sponPsthSem = S.sponPsthStd./sqrt(S.nSponTrials);
    end
    
    for iO = 1:nOri
        bindOri = passOri == S.oriVals(iO);
        for iS = 1:nSf
            bindSf = passSf == S.sfVals(iS);
            
            if doPhase
                for iP = 1:nPhi
                    bindPhi = passPhi == S.phiVals(iP);
                    bind = ~isBlank & bindOri & bindSf & bindPhi;
                    S.nTrials(iO,iS,iP) = sum(bind);
                    S.count{iO,iS,iP} = passSpikeCounts(bind,:,:);
                    
                    S.countMean(iO,iS,iP,:,:) = reshape(mean(S.count{iO,iS,iP}),[nElec,1+nIso]);
                    S.countStd(iO,iS,iP,:,:) = reshape(std(S.count{iO,iS,iP}),[nElec,1+nIso]);
                    S.countSem(iO,iS,iP,:,:) = S.countStd(iO,iS,iP,:,:)./sqrt(S.nTrials(iO,iS,iP));
                    
                    S.pow{iO,iS,iP} = passPow(bind,:);
                    S.powMean(iO,iS,iP) = mean(S.pow{iO,iS,iP});
                    S.powStd(iO,iS,iP) = std(S.pow{iO,iS,iP});
                    S.powSem(iO,iS,iP) = S.powStd(iO,iS,iP)./sqrt(S.nTrials(iO,iS,iP));
                    if doBoot
                        temp = nan(nBoot,nElec,1+nIso);
                        for iB = 1:nBoot
                            ind = randsample(S.nTrials(iO,iS,iP),S.nTrials(iO,iS,iP),true);
                            temp(iB,:,:) = mean(S.count{iO,iS,iP}(ind,:,:));
                        end
                        S.countBsMed(iO,iS,iP,:,:) = reshape(median(temp),[1,1,1,nElec,1+nIso]);
                        S.countBsCi(:,iO,iS,iP,:,:) = reshape(prctile(temp,[5,95]),[2,1,1,1,nElec,1+nIso]);
                    end
                    
                    if doPsth
                        S.psthMean(:,iO,iS,iP,:,:) = reshape(mean(passPsth(:,bind,:,:),2),[nT,1,1,1,nElec,1+nIso]); 
                        S.psthStd(:,iO,iS,iP,:,:) = reshape(std(passPsth(:,bind,:,:),[],2),[nT,1,1,1,nElec,1+nIso]); 
                        S.psthSem(:,iO,iS,iP,:,:) = S.psthStd(:,iO,iS,iP,:,:)./sqrt(S.nTrials(iO,iS,iP));
                    end
                end
            else
                bind = ~isBlank & bindOri & bindSf;
                S.nTrials(iO,iS) = sum(bind);
                S.count{iO,iS} = passSpikeCounts(bind,:,:);
                S.countMean(iO,iS,:,:) = reshape(mean(S.count{iO,iS}),[nElec,1+nIso]);
                S.countStd(iO,iS,:,:) = reshape(std(S.count{iO,iS}),[nElec,1+nIso]);
                S.countSem(iO,iS,:,:) = S.countStd(iO,iS,:,:)./sqrt(S.nTrials(iO,iS));
                
                S.pow{iO,iS} = passPow(bind,:);
                S.powMean(iO,iS,:) = mean(S.pow{iO,iS});
                S.powStd(iO,iS,:) = std(S.pow{iO,iS});
                    
                if doBoot
                    temp = nan(nBoot,nElec,1+nIso);
                    for iB = 1:nBoot
                        ind = randsample(S.nTrials(iO,iS),S.nTrials(iO,iS),true);
                        temp(iB,:,:) = mean(S.count{iO,iS}(ind,:,:));
                    end
                    S.countBsMed(iO,iS,:,:) = reshape(median(temp),[1,1,nElec,1+nIso]);
                    S.countBsCi(:,iO,iS,:,:) = reshape(prctile(temp,[5,95]),[2,1,1,nElec,1+nIso]);
                end
                    
                if doPsth
                    S.psthMean(:,iO,iS,:,:) = reshape(mean(passPsth(:,bind,:,:),2),[nT,1,1,nElec,1+nIso]); 
                    S.psthStd(:,iO,iS,:,:) = reshape(std(passPsth(:,bind,:,:),[],2),[nT,1,1,nElec,1+nIso]); 
                    S.psthSem(:,iO,iS,:,:) = S.psthStd(:,iO,iS,:,:)./sqrt(S.nTrials(iO,iS));
                end
            end
        end
    end
    if doPhase
        S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,1,nElec,1+nIso]));
        S.powSub = bsxfun(@minus,S.powMean,reshape(S.sponPowMean,[1,1,1,nElec]));
        S.powNorm = bsxfun(@minus,S.powSub,reshape(S.sponPowMean,[1,1,1,nElec]));
    else
        S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,nElec,1+nIso]));
        S.powSub = bsxfun(@minus,S.powMean,reshape(S.sponPowMean,[1,1,nElec]));
        S.powNorm = bsxfun(@minus,S.powSub,reshape(S.sponPowMean,[1,1,nElec]));
    end
    if doBoot
%         if doPhase
%             sz1 = [nBoot,1,1,1,nElec,1+nIso];
%             sz2 = [1,nOri,nSf,nP,nElec,1+nIso];
%             sz3 = [nOri,nSf,nP,nElec,1+nIso];
%             sz4 = [nOri*nSf*nP,nElec,1+nIso];
%         else
%             sz1 = [nBoot,1,1,nElec,1+nIso];
%             sz2 = [1,nOri,nSf,nElec,1+nIso];
%             sz3 = [nOri,nSf,nElec,1+nIso];
%             sz4 = [nOri*nSf,nElec,1+nIso];
%         end
%         p = reshape(sum(bsxfun(@gt,reshape(sponCountBs,sz1),reshape(S.countMean,sz2)))./nBoot,sz3);
%         S.isRespo = reshape(any(reshape( p<sigThresh ,sz4)),[nElec,1+nIso]);

    end
    
    save(ospAzFile,'S')
    
else
    load(ospAzFile)
end
    