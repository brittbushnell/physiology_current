% gratMwksCh
% Analyze grating responses by channel
%
clc
%% NOTES

%% comment out if running as a function
%clear all
close all
tic;
location = 1; % 1 = Amfortas
dispPSTH = 1;
animal = 'XT';
warning('off','all')
%% Files to run
% recut files
files = ['WU_LE_Gratings_nsp2_withRF_recut'; 'WU_RE_Gratings_nsp2_withRF_recut'];
%files = ['WU_RE_Gratings_nsp1_withRF_recut'; 'WU_LE_Gratings_nsp1_withRF_recut'];

% original files
%files = ['WU_LE_Gratings_nsp2_withRF'; 'WU_RE_Gratings_nsp2_withRF'];
%files = ['WU_RE_Gratings_nsp1_withRF'; 'WU_LE_Gratings_nsp1_withRF'];

% Contrast Grating
%files = ['WU_RE_GratingsCon_nsp2_Aug2017';'WU_LE_GratingsCon_nsp2_Aug2017'];
%files = ['WU_RE_GratingsCon_nsp1_Aug2017';'WU_LE_GratingsCon_nsp1_Aug2017'];

% Single day v4 files
% files = ['WU_RE_Gratings_nsp2_20170705_001';'WU_LE_Gratings_nsp2_20170705_003'];
% files = ['WU_RE_Gratings_nsp2_20170706_001';'WU_LE_Gratings_nsp2_20170706_003'];
% files = ['WU_RE_Gratings_nsp2_20170707_004';'WU_LE_Gratings_nsp2_20170707_001'];
% files = ['WU_RE_Gratings_nsp2_20170710_001';'WU_LE_Gratings_nsp2_20170710_003'];
% files = ['WU_RE_Gratings_nsp2_20170719_003';'WU_LE_Gratings_nsp2_20170719_001'];
% files = ['WU_LE_Gratings_nsp2_20170721_001'; 'WU_RE_Gratings_nsp2_20170720_001'];

% v1/v2 files
% files = ['WU_RE_Gratings_nsp1_20170705_001';'WU_LE_Gratings_nsp1_20170705_003'];
% files = ['WU_RE_Gratings_nsp1_20170706_001';'WU_LE_Gratings_nsp1_20170706_003'];
% files = ['WU_RE_Gratings_nsp1_20170707_004';'WU_LE_Gratings_nsp1_20170707_001'];
% files = ['WU_RE_Gratings_nsp1_20170710_001';'WU_LE_Gratings_nsp1_20170710_003'];
% files = ['WU_RE_Gratings_nsp1_20170719_003';'WU_LE_Gratings_nsp1_20170719_001'];
%% XT
%% XT
files = 'XT_RE_gratings_V4_20181028_goodCh';
newName = 'XT_RE_gratings_V4_20181028_fit';

%%
structKey = makeGratMwksStructKey;
for fi = 1:size(files,1)
    filename = files(fi,:);
    data = load(filename);
    textName = figTitleName(filename);
    disp(sprintf('\n analyzing file: %s',textName))
    [animal,eye, program, array, date] = parseFileName(filename);
    %% Extract stim information
    if strfind(filename, 'Con')
        [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff, con] = getMwksGratParameters(data);
    else
        [sfs, oris, width, xloc, yloc, numOris, stimOn, stimOff] = getMwksGratParameters(data);
    end
    
    binStimOn  = stimOn/10;
    binStimOff = stimOff/10;
    
    numChannels = size(data.bins,3);
    data.amap = aMap;
    data.stimTime = [binStimOn,binStimOff];
    %% PSTH
    if dispPSTH == 1
        %for ch = 1:numChannels
            blankNdx = find(data.spatial_frequency == 0);
            stimNdx  = find(data.spatial_frequency > 0);
        %end
        psthFigMwksArray(data, textName, blankNdx, stimNdx)
        clear blankNdx
        clear stimNdx
    end
    %% Define Good channels
    goodChannels = MwksGetGoodCh(data,filename, 1); % 1 = ignore suppressive channels otherwise set to 0
    data.goodChannels = goodChannels;
    %% Make version of data.bins with only responisve channels
    goodBins = nan((size(data.bins,1)),(size(data.bins,2)),length(goodChannels));
    for gch = 1:length(goodChannels)
        goodBins(:,:,gch) = data.bins(:,:,goodChannels(gch));
    end
    data.goodBins = goodBins;
    %% Extract information from each channel
    % Get latency information
    for ch = 1:numChannels
        if rem(ch,6) == 0 || ch == 1
            fprintf('%d ',ch)
        end
%         data.latency(1,ch) = getLatencyMwks(data.bins, binStimOn*2, 10, ch); % the first value out of data.latency is the bin with the latency, the second is the latency in ms
%         data.latency(2,ch) = data.latency(1,ch) +binStimOn;        
        startBin = ones(1,96).* 5;
        endBin   = ones(1,96).* 15;
        data.latency = [startBin; endBin];
        
        [sfs, maxSF] = getMwksSFResponses(data,sfs,ch);
        
        data.spatialFrequencyResp{ch} = sfs;
        data.maxSF(1,ch) =  maxSF;
        %% Spatial frequency tuning
        xVals = data.spatialFrequencyResp{ch}(1,3:end);
        resps = data.spatialFrequencyResp{ch}(3,3:end); %row 3 is regular mean, row 4 is baseline subtracted mean
        [fitParams, fitResps] = FitDifOfGaus(xVals,resps,0,20);
        [sfPref,sfHigh,sfBandwidth] = DifOfGausStats(xVals(1,1),xVals(1,end),fitParams);
        
        data.sfPrefs(1,ch) = sfPref;
        data.sfHigh(1,ch)  = sfHigh;
        data.sfBandwidth(1,ch) = sfBandwidth;
        data.sfFitParams{ch} = fitParams;
        data.sfFitResps{ch} = fitResps;
        %% orientation responses
        [oris] = getMwksOriResponses(data,oris,ch);
        [oriTune, maxOri, minOri, nullOri] = getMwksOriTunedResponses(data,oris,maxSF,ch);
        [oriResps360, maxOri360, minOri360] = getMwksOri360Responses(oriTune);
        
        data.maxOri(:,ch) = maxOri;
        data.minOri(:,ch) = minOri;
        data.nullOri(:,ch) = nullOri;
        data.orientationResp{ch} = oris;
        data.oriTuneResp{ch} = oriTune;
        data.oriResps360{ch} = oriResps360;
        data.maxOri360(:,ch) = maxOri360;
        data.minOri360(:,ch) = minOri360;
        %% orientation tuning
        [prefOri,vectAngle] = getPrefOriVectAngle(oriTune);
        [prefOri360,vectAngle360] = getPrefOriVectAngle(oriResps360);
        [oriNdx] = getOriTuneIndex(maxOri,minOri);
        [oriNdxNull] = getOriTuneIndex(maxOri,nullOri);
        [oriNdx360] = getOriTuneIndex(maxOri360,minOri);
        
        data.oriIndex(1,ch) = oriNdx;
        data.oriIndex360(1,ch) = oriNdx360;
        data.oriIndexNull(1,ch) = oriNdxNull;
        
        normOri = vectAngle(1,:) - prefOri(1,1);
        normOri360 = vectAngle360(1,:) - prefOri(1,1);
        %% commit everything to the data structure
        data.vectAngle{ch} = vectAngle;
        data.prefOri(1,ch) = prefOri;
        data.oriNdx(1,ch) = oriNdx;
        data.normOri{ch} = normOri;
        
        data.vectAngle360{ch} = vectAngle360;
        data.prefOri360(1,ch) = prefOri360;
        data.oriNdx360(1,ch) = oriNdx360;
        data.normOri360{ch} = normOri360;
        %% SF tuning with preferred orientation
        [sfTune, maxSF] = getMwksSFTunedResponses(data,sfs,maxOri,ch);
        data.sfTune{ch} = sfTune;
        data.maxSFTune(1,ch) = maxSF;
        
        xVals = data.spatialFrequencyResp{ch}(1,4:end);
        resps = data.sfTune{ch}(3,4:end); %row 3 is regular mean, row 4 is baseline subtracted mean
        [fitParams, fitResps] = FitDifOfGaus(xVals,resps,0,20);
        [sfPref,sfHigh,sfBandwidth] = DifOfGausStats(xVals(1,1),xVals(1,end),fitParams);
        
        data.sfTunePrefs(1,ch) = sfPref;
        data.sfTuneHigh(1,ch)  = sfHigh;
        data.sfTuneBandwidth(1,ch) = sfBandwidth;
        data.sfTuneFitParams{ch} = fitParams;
        data.sfTuneFitResps{ch} = fitResps;
    end
    %% Create eye specific data structures
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        LEdata = data;
    end
end
%% save new data matrix
foo = pwd;
if strfind(foo,'ConcatenatedMats')
    cd ../fittedMats
else
    cd fittedMats
end
if strfind(filename, 'recut')
    newName = ['fitData','_',animal,'_',program,'_',array,'_','recuts'];
else
    newName = ['fitData','_',animal,'_',program,'_',array,'_',date];
end

if strfind(filename,'BE')
    save(newName,'BEdata');
else
    save(newName,'LEdata','REdata','structKey');
end
%%
load handel
sound(y,Fs)

toc/60