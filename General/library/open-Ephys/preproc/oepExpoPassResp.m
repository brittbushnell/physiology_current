function [ExpoIn,passSpikeCounts,passPow,passPsth,passPowTrace,passLfpTrace,passSpikeTimes] = ...
    oepExpoPassResp(oepDir,xmlDir,azDir,unitLabel,runNum,thresh,...
    windowOffset,windowDuration,doPsth,doPowTrace,doSpikeTimes,fs,lfpBand,fsLfp,saveFileSuffix,spikeFileSuffix,doArtefactRejection)
% oepExpoPassResp
% OpenEphys data analysis aligned to Expo passes.

% INPUTS
% oepDir: Parent directory for OpenEphys recordings (e.g. .../m661_array)
% xmlDir: Folder containing Expo XML.
% azDir: Folder used to save results of analysis
% unitLabel: e.g. 'm661r1'
% runNum: Run number (e.g. for m661r1#5, runNum=5)
%         If OpenEphys data files have a suffix (e.g. '_2'), supply a
%         non-integer runNum with the decimal matching the suffix (e.g. 5.2)
% thresh: Threshold used for counting crossings. Default is 4.
% windowOffet: Beginning of window (in seconds, with respect to Expo pass start) 
%              used to count crossings, average power, etc.
%              Default is 0 (start of pass).
% windowDuration: Duration of window (in seconds) to count crossings and power.
%                 If not supplied (or NaN or empty), pass duration is used.
% doPsth:
% doPowTrace:
% doSpikeTimes:
% fs:
% lfpBand: pair of frequencies (in Hz) used in filtering LFP (e.g. [0,300])
%           To skip LFP, supply empty matrix for lfpBand.
% fsLfp: Sample rate used to subsample lowpass signal.
% saveFileSuffix: Optional suffix to attach to saved output file.
% spikeFileSuffix: Optional. Specifying name of spike-time file to load
%                 (default is e.g. m661r1#5_spikes.mat loaded from directory 'azDir'.)
%
% OUTPUTS
% ExpoIn: The structure returned by ReadExpoXML().
% passSpikeCounts: (nPasses x nElectrodes x 1+nIsolatedSpikes) 
%                   Threshold crossing and spike counts for each pass.
%                   Threshold crossings are first along 3rd dimension,
%                   followed by spikes.
% passPow: (nPasses x nElectrodes) Spike-band power for each pass, averaged
%           over window defined by windowOffset and windowDuration.
% passSpikeTimes: (nPasses x nElectrodes x 1+nIsolateedSpikes, cell) 
%                   Timestamps of each threshold crossing,
%                   in seconds, relative to start of Expo pass.
% passPsth: (N x nPasses x nElectrodes x 1+nIsolatedSpikes) 
% passLfpTrace: (M x nPasses x nElectrodes)
%
% See also oepThreshAndPow


%%% Parameters %%%
nElec = 32; % number of electrodes
fsExpo = 10000; % sample rate of Expo data file
iqrThresh = 100;
%%%%%%%%%%%%%%%%%%
forceOverwrite = 1;

%%% Parse Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('doArtefactRejection','var')
	doArtefactRejection = false;
end
if ~exist('doPsth','var')
	doPsth = false;
end
if ~exist('doSpikeTimes','var')
	doSpikeTimes = false;
end
if ~exist('doPowTrace','var')
	doPowTrace = false;
end
if ~exist('windowOffset','var') || isempty(windowOffset) || isnan(windowOffset)
    windowOffset = 0;
end
if ~exist('windowDuration','var') || isempty(windowDuration) || isnan(windowDuration)
    windowDuration = nan;
end
if ~exist('lfpBand','var') || isempty(lfpBand)
    doLfp = false;
    lfpBand = []; fsLfp=[];
else
    doLfp = true;
end
if ~exist('thresh','var') || isempty(thresh)
    thresh = 4;
end
if ~exist('fs','var')
    fs = 120;
end
if ~exist('saveFileSuffix','var') || isempty(saveFileSuffix)
    saveFileSuffix = '';
end
if ~exist('spikeFileSuffix','var') || isempty(spikeFileSuffix)
    spikeFileSuffix = '';
end

tBinEd = windowOffset : (1/fs) : (windowOffset+windowDuration);
binsPerPass = numel(tBinEd)-1;


%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
runStr = [unitLabel,'#',num2str(floor(runNum))]; % A string describing this recording (e.g. 'm662r1#8')
passRespFile = [azDir,'/',runStr,'_passResp',saveFileSuffix,'.mat']; % Name of file to save analysis results to.
if ~exist(passRespFile,'file') || forceOverwrite % If output was previously saved to file, skip analysis and load from file.
    xmlFile = oepGetXmlFile(xmlDir,unitLabel,floor(runNum));
%     binsPerPass = windowDuration*fs;
    if doLfp
        lfpSampPerPass = windowDuration*fsLfp;
    end
    
    fprintf(['oepExpoPassResp: ',runStr,'\n'])
    
    syncTimes = oepGetSyncTimes(oepDir,azDir,unitLabel,runNum,saveFileSuffix);

    % Load threshold-crossing and power data:
    fprintf('-- oepThreshAndPow\n')   
    [crossTimes,pow,tPow,lfp,tLfp] = oepThreshAndPow(oepDir,azDir,unitLabel,runNum,...
        thresh,fs,lfpBand,fsLfp,saveFileSuffix);
    
    % Load spike times, if they exist:
    spikeFile = [runStr,'_spikes',spikeFileSuffix,'.mat'];
    if exist([azDir,'/',spikeFile],'file')
        doSpikes = 1;
        load([azDir,'/',spikeFile])
        nIso = size(spike.times,1);
    else
        doSpikes = 0;
        nIso = 0;
    end
    
    fprintf('-- Reading XML\n')        
    ExpoIn = ReadExpoXML(xmlFile,0,0,1);

    offset = syncTimes(1) - double(ExpoIn.frames.StartTimes(1))/fsExpo;
    scale = (double(ExpoIn.frames.StartTimes(end))/fsExpo-double(ExpoIn.frames.StartTimes(1))/fsExpo)./...
            (syncTimes(end)-syncTimes(1));
    ExpoIn.openEphys.offset = offset;
    ExpoIn.openEphys.scale = scale;
    
    tStart = double(ExpoIn.passes.StartTimes)/fsExpo;
    tEnd = double(ExpoIn.passes.EndTimes)/fsExpo;
    nPasses = numel(tStart);
    passSpikeCounts = nan(nPasses,nElec,1+nIso);
    if doSpikeTimes
        passSpikeTimes = cell(nPasses,nElec,1+nIso);
    else
        passSpikeTimes = [];
    end
    if doPsth
        passPsth = nan(binsPerPass,nPasses,nElec,1+nIso);
    else
        passPsth = [];
    
    end
    fprintf('-- Threshold crossings and spikes\n')
    for iA = 1:nElec
        
        % Threshold crossings
        t = (crossTimes{iA}-offset).*scale + (double(ExpoIn.frames.StartTimes(1))/fsExpo); 
        for iP = 1:nPasses
            t1 = tStart(iP) + windowOffset;
            if ~isnan(windowDuration)
                t2 = t1 + windowDuration;
            else
                t2 = tEnd(iP);
            end
            bind = (t>=t1) & (t<t2);
            passSpikeCounts(iP,iA,1) = sum(bind);
            if doSpikeTimes
                passSpikeTimes{iP,iA,1} = t(bind)-tStart(iP);
            end
            if doPsth
                passPsth(:,iP,iA,1) = histcounts(t(bind)-tStart(iP),tBinEd)*fs;
            end
        end
        
        % Isolated spikes
        if doSpikes
            for iIso = 1:nIso
                t = (spike.times{iIso,iA}-offset).*scale + (double(ExpoIn.frames.StartTimes(1))/fsExpo); 
                for iP = 1:nPasses
                    t1 = tStart(iP) + windowOffset;
                    if ~isnan(windowDuration)
                        t2 = t1 + windowDuration;
                    else
                        t2 = tEnd(iP);
                    end
                    bind = (t>=t1) & (t<t2);
                    passSpikeCounts(iP,iA,1+iIso) = sum(bind);
                    if doSpikeTimes
                        passSpikeTimes{iP,iA,1+iIso} = t(bind)-tStart(iP);
                    end
                    if doPsth
                        passPsth(:,iP,iA,1+iIso) = histcounts(t(bind)-tStart(iP),tBinEd)*fs;
                    end
                end
            end
        end
    end

    % Power
    fprintf('-- Band Power \n')
    if doArtefactRejection
        temp = bsxfun(@minus,pow,mean(pow));
        iqrScore = bsxfun(@rdivide,temp,iqr(temp));
        indArt0 = find(median(iqrScore,2)>iqrThresh);
        indArt = row(bsxfun(@plus,indArt0(:).',[-3:3].'));
        pow(indArt,:) = nan;
    end
    tPowAligned = (tPow-offset).*scale + (double(ExpoIn.frames.StartTimes(1))/fsExpo); 
    passPow = nan(nPasses,nElec);
    if doPowTrace
        passPowTrace = nan(binsPerPass,nPasses,nElec);
    else
        passPowTrace = [];
    end
    if doLfp
        passLfpTrace = nan(lfpSampPerPass,nPasses,nElec);
    else
        passLfpTrace = [];
    end
    for iP = 1:nPasses
        t1 = tStart(iP) + windowOffset;
        ind0 = find(tPowAligned>t1,1);
        ind = ind0 + (1:binsPerPass) -1;
        passPow(iP,:) = nanmean(pow(ind,:));
        if doPowTrace
            passPowTrace(:,iP,:) = pow(ind,:);
        end
        
        if doLfp
            tLfpAligned = (tLfp-offset).*scale + (double(ExpoIn.frames.StartTimes(1))/fsExpo); 
            ind0 = find(tLfpAligned>t1,1);
            ind = ind0 + (1:lfpSampPerPass) -1;
            passLfpTrace(:,iP,:) = lfp(ind,:);
        end
    end

    save(passRespFile,'ExpoIn','passSpikeCounts','passPow','passPsth','passPowTrace','passLfpTrace','passSpikeTimes','-v7.3')
    
else % Output was already saved, so load existing output file and return variables:
    % [ExpoIn,passSpikeCounts,passPow,passPsth,passPowTrace,passLfpTrace,passSpikeTimes] 
    load(passRespFile,'ExpoIn','passSpikeCounts')
    if nargout > 2
        load(passRespFile,'passPow')
    end
    if nargout > 3
        load(passRespFile,'passPsth')
    end
    if nargout > 4
        load(passRespFile,'passPowTrace')
    end
    if nargout > 5
        load(passRespFile,'passLfpTrace')
    end
    if nargout > 6
        load(passRespFile,'passSpikeTimes')
    end
end