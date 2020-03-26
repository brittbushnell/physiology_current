function S = oepExpoDirSf(azDir,unitLabel,runNum,doTrace,loadFileSuffix)

if ~exist('loadFileSuffix','var')
    loadFileSuffix = '';
end
if ~exist('doPlot','var')
    doPlot = false;
end
nElec = 32;
nBoot = 100;
forceOverwrite = 0;

[passRespFile,runStr] = oepGetPassRespFile(azDir,unitLabel,runNum,loadFileSuffix);
azFile = [azDir,'/',runStr,'_DirSf.mat'];

if ~exist(azFile,'file') || forceOverwrite
    fprintf(['oepExpoDirSf: ',runStr,'\n'])

    load(passRespFile,'ExpoIn','passSpikeCounts','passSpikeTimes');
    nIso = size(passSpikeCounts,3)-1;
    
    passIDs = 1:numel(ExpoIn.passes.BlockIDs)-1;
    passOri = [nan;GetEvents(ExpoIn,passIDs,'Surface',[],0,'Orientation')];
    passSf = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Spatial Frequency X')];
    passCon = [nan;GetEvents(ExpoIn,passIDs,'DKL Texture',[],0,'Contrast')];

    isBlank = passCon==0;
    temp = unique(passOri);
    S.oriVals = temp(~isnan(temp));
    nOri = numel(S.oriVals);
    temp = unique(passSf);
    S.sfVals = temp(~isnan(temp));
    nSf = numel(S.sfVals);
    
    S.nSponTrials = sum(isBlank);
    S.sponTimes = passSpikeTimes(isBlank,:,:);
    S.sponCount = passSpikeCounts(isBlank,:,:);
    S.sponCountMean = reshape(mean(S.sponCount),[nElec,1+nIso]);
    S.sponCountStd = reshape(std(S.sponCount),[nElec,1+nIso]);
    S.sponCountSem = S.sponCountStd./sqrt(S.nSponTrials);
    
    for iO = 1:nOri
        bindOri = passOri == S.oriVals(iO);
        for iS = 1:nSf
            bindSf = passSf == S.sfVals(iS);
            bind = ~isBlank & bindOri & bindSf;
            S.nTrials(iO,iS) = sum(bind);
            S.count{iO,iS} = passSpikeCounts(bind,:,:);
            S.times{iO,iS} = passSpikeTimes(bind,:,:);
            S.countMean(iO,iS,:,:) = reshape(mean(S.count{iO,iS}),[nElec,1+nIso]);
            S.countStd(iO,iS,:,:) = reshape(std(S.count{iO,iS}),[nElec,1+nIso]);
            S.countSem(iO,iS,:,:) = S.countStd(iO,iS,:,:)./sqrt(S.nTrials(iO,iS));
        end
    end
    S.countSub = bsxfun(@minus,S.countMean,reshape(S.sponCountMean,[1,1,1,nElec,1+nIso]));

    save(azFile,'S')
    
else
    load(azFile)
end
    