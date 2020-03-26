function [crossTimes,pow,tPow,lfp,tLfp] = ...
    oepThreshAndPow(oepDir,azDir,unitLabel,runNum,...
    thresh,fsPow,lfpBand,fsLfp,saveFileSuffix)
% oepThreshAndPow 
% Threshold crossing times, spike-band power, and LFP from OpenEphys data.
%
% [crossTimes,pow,tPow,lfp,tLfp] = oepThreshAndPow(oepDir,azDir,unitLabel,runNum,thresh,fsPow,lfpBand,fsLfp,saveFileSufffix)
%
% Threshold is defined relative to the median absolute deviation (MAD) of
% the spike-band filtered voltage signal. A threshold crossing occurs when
% the absolute value of the signal (V) exceeds thresh*1.4826*MAD(V).
% With the multiplier 1.4826, 'thresh' is approximately in units of
% standard deviations.
%
% INPUTS
% oepDir: Parent directory for OpenEphys recordings (e.g. .../m661_array)
% azDir: Folder used to save results of analysis
% unitLabel: e.g. 'm661r1'
% runNum: Run number (e.g. for m661r1#5, runNum=5)
%         If OpenEphys data files have a suffix (e.g. '_2'), supply a
%         non-integer runNum with the decimal matching the suffix (e.g. 5.2)
% thresh: Threshold (see above) used for counting crossings. Default is 4.
% fsPow: Sample rate used in downsampling spike-band power signal.
% lfpBand: pair of frequencies (in Hz) defining low- or band-pass LFP (e.g. [0,300])
%           To skip LFP, supply empty matrix for lfpBand.
% fsLfp: Sample rate used in downsampling LFP.
% saveFileSuffix: Optional suffix to attach to saved output file.
%
% OUTPUTS
% crossTimes: (1 x nElectrodes, cell) Timestamps of each threshold crossing,
%             in seconds, relative to start of OpenEphys recording.
% pow: (N x nElectrodes) Spike-band power (300-6000Hz) sampled at sample
%                        rate of fsPow.
% tPow: (1 x N) Vector of timestamps for power samples.
% lfp: (M x nElecnels) LFP, sampled at sample rate fsLfp.
% tLfp: (1 x M) Vector of timestamps for LFP samples.

if ~exist('lfpBand','var') || isempty(lfpBand)
    doLfp = false;
    fsLfp = nan;
    lfp = [];
    tLfp = [];
else
    doLfp = true;
end
if ~exist('thresh','var') || isempty(thresh)
    thresh = 4;
end
if ~exist('saveFileSuffix','var') || isempty(saveFileSuffix)
    saveFileSuffix = '';
end

%%% Parameters %%%%%
nElec = 32;
fsVolt = 30000;
powBand = [300,6000];
butterOrder = 2;

powSampRat = fsVolt/fsPow;
lfpSampRat = fsVolt/fsLfp;

forceOverwrite = 0;
doDebug = 0;
saveVolt = 0; % for debugging: saves raw voltage to file
%%%%%%%%%%%%%%%%%%%%

if runNum==round(runNum)
    repStr = '';
else
    oepRepNum = rem(runNum,1)*10;
    runNum = floor(runNum);
    repStr = ['_',num2str(oepRepNum)];
end
runStr = [unitLabel,'#',num2str(runNum)];
recDir = oepGetRecDir(oepDir,unitLabel,runNum);
threshAndPowFile = [azDir,'/',runStr,'_threshAndPow',saveFileSuffix,'.mat'];

if ~exist(threshAndPowFile,'file') || forceOverwrite
    [powFiltB,powFiltA]=butter(butterOrder,powBand./(fsVolt/2));
    if doLfp
        if lfpBand(1)==0
            [lfpFiltB,lfpFiltA]=butter(butterOrder,lfpBand(2)./(fsVolt/2),'low');
        else
            [lfpFiltB,lfpFiltA]=butter(butterOrder,lfpBand./(fsVolt/2));
        end
    end
    crossTimes = cell(1,nElec);
    
    for iC = 1:nElec
        dataFile = [recDir,'/','100_CH',num2str(iC),repStr,'.continuous'];
        [voltage,tStamps,~] = load_open_ephys_data_faster(dataFile);
        voltPowBand = filter(powFiltB,powFiltA,voltage);
        if doLfp
            voltLfpBand = filter(lfpFiltB,lfpFiltA,voltage);
        end
        
        if iC==1
            tVolt = tStamps/fsVolt;
            nSamp = numel(voltage);
            nPowSamp = floor(nSamp/powSampRat);
            tPow = tVolt( (1:nPowSamp)*powSampRat );
            pow = nan(nPowSamp,nElec);
            if doLfp
                nLfpSamp = floor(nSamp/lfpSampRat);
                lfp= nan(nLfpSamp,nElec);
                tLfp = tVolt( (1:nLfpSamp)*lfpSampRat );
            else
                lfp = [];
                tLfp = [];
            end
        end 
        
        % threshold crossings
        bind = abs(voltPowBand) > thresh*1.4826*mad(voltPowBand,1);
        ind = find(diff(bind)==1)+1;
        crossTimes{iC} = tVolt(ind);
        
        % power
        temp = decimate(voltPowBand.^2,powSampRat,'fir');
        pow(:,iC) = temp(1:nPowSamp);
        
        % lfp
        if doLfp
            temp = decimate(voltLfpBand,lfpSampRat,'fir');
            lfp(:,iC) = temp(1:nLfpSamp);
        end
        
        fprintf([num2str(iC),' '])
        if mod(iC,16)==0
            fprintf('\n')
        end
        
        if doDebug
            spectrogram(voltLfpBand,30000,10000,linspace(0,70,500),30000);
            pause
        end
        if saveVolt
            voltFile = [azDir,'/',runStr,'_volt_',num2str(iC)];
            save(voltFile,'voltage')
        end
    end    
    save(threshAndPowFile,'crossTimes','pow','tPow','lfp','tLfp')
%     if doDebug
%         imagesc(t,f,mean(abs(s),3).')
%         keyboard
%     end
else
    load(threshAndPowFile)
end