function [syncTimes,syncId,pulseAmp] = oepGetSyncTimesVarAmp(oepDir,azDir,unitLabel,runNum,levThresh,saveFileSuffix,oepRepNum)

forceOverwrite      = 0;
doDebug             = 0;

if ~exist('levThresh','var')
    levThresh = 4;
end
if ~exist('oepRepNum','var')
    oepRepNum = 1;
end

recDir = oepGetRecDir(oepDir,unitLabel,runNum);

if ~exist('saveFileSuffix','var') || isempty(saveFileSuffix)
    saveFileSuffix = '';
end
if oepRepNum == 1
    repStr = '';
else
    repStr = ['_',num2str(oepRepNum)];
end

syncRecFile = [recDir,'/','100_ADC2',repStr,'.continuous'];
runStr = [unitLabel,'#',num2str(runNum)];
syncTimesFile = [azDir,'/',runStr,'_syncTimes',saveFileSuffix,'.mat'];

if ~exist(syncTimesFile,'file') || forceOverwrite
    
    pulseWindN = 60;
    sampleRate = 30000;
    
    [anData,tStamps,~] = load_open_ephys_data_faster(syncRecFile);
    tAn = tStamps/sampleRate;

    isNz = anData > max(anData)*0.1;
    indPulse = find(diff(isNz)==1)+1;
    indDouble = 1 + find(diff(indPulse)<pulseWindN);
    indPulse(indDouble) = [];

    nPulses = numel(indPulse);
    pulseAmp = nan(1,nPulses);
    for iP = 1:nPulses
        pulseAmp(iP) = max(anData(indPulse(iP) + (1:pulseWindN)-1));
    end
    nLevs = numel(levThresh);
    bindClaimed = false(1,nPulses);
    syncId = nan(1,nPulses);
    for iL = 1:nLevs
        bind = ~bindClaimed & pulseAmp>levThresh(iL);
        syncId(bind) = nLevs-iL;
        bindClaimed = bindClaimed | bind;
    end
    
    bind = ~isnan(syncId);
    syncId = syncId(bind);
    indPulse = indPulse(bind);
    syncTimes = tAn(indPulse).';
    pulseAmp = pulseAmp(bind);

    if doDebug
        figure, hold on
        plot(tAn,anData)
        ind = find(syncId==2);
        plot(syncTimes(ind),pulseAmp(ind),'c.')
        ind = find(syncId==1);
        plot(syncTimes(ind),pulseAmp(ind),'r.')
        ind = find(syncId==0);
        plot(syncTimes(ind),pulseAmp(ind),'g.')
        keyboard
    end
    
    save(syncTimesFile,'syncTimes','syncId','pulseAmp')
else
    load(syncTimesFile)
end
    