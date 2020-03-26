function syncTimes = oepGetSyncTimes(oepDir,azDir,unitLabel,runNum,saveFileSuffix)

recDir = oepGetRecDir(oepDir,unitLabel,floor(runNum));
if ~exist('saveFileSuffix','var') || isempty(saveFileSuffix)
    saveFileSuffix = '';
end
if runNum==round(runNum)
    repStr = '';
else
    oepRepNum = rem(runNum,1)*10;
    runNum = floor(runNum);
    repStr = ['_',num2str(oepRepNum)];
end

syncRecFile = [recDir,'/','100_ADC1',repStr,'.continuous'];
runStr = [unitLabel,'#',num2str(runNum)];
syncTimesFile = [azDir,'/',runStr,'_syncTimes',saveFileSuffix,'.mat'];

if ~exist(syncTimesFile,'file')
    
    sampleRate = 30000;
    [anData,tStamps,~] = load_open_ephys_data_faster(syncRecFile);
    tAn = tStamps/sampleRate;
    bindHigh = anData>1;
    bindFlat = [diff(anData)<1e-4;0];
    indPulse = find(diff(bindHigh & bindFlat)==1)+1;
    syncTimes = tAn(indPulse).';
    save(syncTimesFile,'syncTimes')
    
else
    load(syncTimesFile)
end
    