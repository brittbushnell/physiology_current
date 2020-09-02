% gratMwks_Svurf_1ch.m
%
% analyze grating responses for one responsive channel per array to get
% things working better
%
% V1: 63
% V4: 95
%%
clc
clear all
close all
tic
%%
location = 2; % 0 = laptop 1 = Amfortas 2 = Zemina
dispPSTH = 0;
saveData = 1;
daily = 0; % if running the analysis for each day, rather than the concatenated versions, this will save the data structures for each day as individual files.

nStarts = 10; % number of starts for fitting program.
%nBoot = 1000; % number of times to do the shuffle test

%warning('off','all')
%% all days
files = ['WU_LE_Gratings_nsp2_withRF_recut'; 'WU_RE_Gratings_nsp2_withRF_recut'];
newName = 'fit_WU_Gratings_V4_recut_surf_6days_1ch';

% files = ['WU_RE_Gratings_nsp1_withRF_recut'; 'WU_LE_Gratings_nsp1_withRF_recut'];
% newName = 'fit_WU_Gratings_V1_recut_surf_6days_1ch';

if strfind(newName,'V1')
    ch = 73;
else
    ch = 84;
end
%% 1 day
% V1

% files = ['WU_LE_Gratings_nsp1_20170628_003';'WU_RE_Gratings_nsp1_20170628_001'];
% newName = 'fit_WU_Gratings_V1_0628_surface';

% V4

% files = ['WU_LE_Gratings_nsp2_20170628_003_recut';'WU_RE_Gratings_nsp2_20170628_001_recut'];
% newName = 'fit_WU_Gratings_V4_0628_recut_surface';
%% identify array map
if ~isempty(strfind(files(1,:),'nsp2'))
    disp 'data recorded from nsp2, V4 array'
    aMap = arraymap('SN 1024-001795.cmp');
    
elseif ~isempty(strfind(files(1,:),'nsp1'))
    disp 'data recorded from nsp1, V1/V2 array'
    aMap = arraymap('SN 1024-001790.cmp');
    
else
    error('Error: array ID missing or wrong')
end
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
    %data.amap   = aMap;
    data.stimTime = [binStimOn,binStimOff];
    data.goodBins = data.bins;
    %% PSTH
    if dispPSTH == 1
        blankNdx = find(data.spatial_frequency == 0);
        stimNdx  = find(data.spatial_frequency > 0);
        
        psthFigMwksArray(data, textName, blankNdx, stimNdx)
        clear blankNdx
        clear stimNdx
    end
    %% Extract information from each channel
    % Set latency to look at responses between 50 and 200 ms.
    startBin = ones(1,96).* 5;
    endBin   = ones(1,96).* 20;
    data.latency = [startBin; endBin];
    %% Grating responses
    % oriXsf is a matrix of responses to each unique stimulus
    % orientation varies for each row, sf for each column. Columns 2
    % and 3 are mostly nan's because they are the responses to the
    % black and white flashes
    
    [oriXsf,normOriXsf] = getMwksRespsOrixSF_gCh(data,ch,0);
    oriXsf_sparse = oriXsf(:,2:end);
    normOriXsf_sparse = normOriXsf(:,2:end);
    
    data.normOriXsf{ch} = normOriXsf;
    data.normOriXsf_sparse{ch} = normOriXsf_sparse;
    data.oriXsf{ch} = oriXsf;
    data.oriXsf_sparse{ch} = oriXsf_sparse;
    %% fit data
    if length(oris) == 7 % if ran with both 0 and 180deg
        oris  = oris(:,1:end-1);
    end
    
    [surfParams, surfFitVals, bestFun] = FitVMBlob_Mwks(oris, sfs, oriXsf_sparse, nStarts);
    resid = oriXsf_sparse - surfFitVals;
    [normSurfParams, normSurfFitVals, normBestFun] = FitVMBlob_Mwks(oris, sfs, normOriXsf_sparse, nStarts);
    normResid = normOriXsf_sparse - normSurfFitVals;
    
    data.normSurfParams{ch}  = normSurfParams;
    data.normSurfFitVals{ch} = normSurfFitVals;
    data.normBestFun{ch}   = normBestFun;
    data.normResiduals{ch} = normResid;
    
    data.surfParams{ch}  = surfParams;
    data.surfFitVals{ch} = surfFitVals;
    data.bestFun{ch}   = bestFun;
    data.residuals{ch} = resid;
    %% Create eye specific data structures
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        LEdata = data;
    end
    
    if strfind(filename,'nsp1')
        if location == 2
            cd  /home/bushnell/matFiles/V1/FittedMats/
        elseif location == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
        end
    else
        if location == 2
            cd  /home/bushnell/matFiles/V4/FittedMats/
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/
        end
    end
    if daily == 1
        if strfind(filename,'LE')
            LEdata_all{fi} = data;
        else
            REdata_all{fi} = data;
        end
    end
    %% save new data matrix
    if saveData == 1
        if daily == 1
            if strfind(filename,'LE')
                save(newName,'LEdata_all');
            else
                save(newName,'REdata_all');
            end
        end
    end
end
if saveData == 1
    if daily == 0
        if strfind(filename,'BE')
            save(newName,'BEdata');
        else
            save(newName,'LEdata','REdata','structKey');
        end
    end
end
%%
% load handel
% sound(y,Fs)
toc/60




