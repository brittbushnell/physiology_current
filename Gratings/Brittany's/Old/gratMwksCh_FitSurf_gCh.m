% gratMwksCh_fitSurf_gCh
% Analyze responses of visually responsive channels to the surface of
% sf x ori
%
clc
%% NOTES
% Remember to set location before running! If running on Zemina location
% needs to be 2, otherwise the path directories are incorrect.

%%
clear all
close all
tic;

location = 2; % 0 = laptop 1 = Amfortas 2 = zemina
daily = 0; % if running the analysis for each day, rather than the concatenated versions, this will save the data structures for each day as individual files.
dispPSTH = 0;
saveData = 1;

nStarts = 200; % number of starts for fitting program.
warning('off','all')
%% Good channels
% files = ['WU_LE_Gratings_nsp1_withRF_means';'WU_RE_Gratings_nsp1_withRF_means'];
% newName = 'fit_WU_Gratings_V1_withRF_surface_0502_180';

files = ['WU_LE_Gratings_nsp2_withRF_means';'WU_RE_Gratings_nsp2_withRF_means'];
newName = 'fit_WU_Gratings_V4_withRF_surface_0502_180';

% files = ['WU_RE_Gratings_nsp1_withRF_combo'; 'WU_LE_Gratings_nsp1_withRF_combo'];
% newName = 'fit_WU_Gratings_V1_withRF_recut_surface_asym';

% files = ['WU_RE_Gratings_nsp1_withRF_recut'; 'WU_LE_Gratings_nsp1_withRF_recut'];
% newName = 'fit_WU_Gratings_V1_withRF_recut_surface_asym';

% files = ['WU_RE_Gratings_V4_withRF_goodCh_recut'; 'WU_LE_Gratings_V4_withRF_goodCh_recut'];
% newName = 'WU_Gratings_V4_withRF_goodCh_fit_T3';
%
% files = ['WU_LE_Gratings_nsp2_withRF_recut'; 'WU_RE_Gratings_nsp2_withRF_recut'];
% newName = 'fit_WU_Gratings_V4_withRF_recut_surface_asym';
%% Verify file and find array map, set paths
if location == 2
    addpath(genpath('/home/bushnell/ArrayAnalysis/'))
    addpath(genpath('/home/bushnell/Figures/'))
    addpath(genpath('/home/bushnell/binned_data/'))
    addpath(genpath('/home/bushnell/matFiles/'))
end

% if location == 1
%     % Amfortas
%     cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
% elseif location == 0
%     % laptop
%     cd ~/Dropbox/ArrayData/WU_ArrayMaps
% elseif location == 2
%     cd /home/bushnell/ArrayAnalysis/ArrayMaps
% end
% if ~isempty(strfind(files(1,:),'nsp2'))
%     disp 'data recorded from nsp2, V4 array'
%     aMap = arraymap('SN 1024-001795.cmp');
%
% elseif ~isempty(strfind(files(1,:),'nsp1'))
%     disp 'data recorded from nsp1, V1/V2 array'
%     aMap = arraymap('SN 1024-001790.cmp');
%
% else
%     error('Error: array ID missing or wrong')
% end
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
    
    for ch = 1:numChannels
        if rem(ch,6) == 0 || ch == 1
            fprintf('%d ',ch)
        end
        %% Grating responses
        % oriXsf is a matrix of responses to each unique stimulus
        % orientation varies for each row, sf for each column. Columns 2
        % and 3 are mostly nan's because they are the responses to the
        % black and white flashes
        
        [oriXsf,normOriXsf] = getMwksRespsOrixSF_gCh(data,ch,0,1);
        
        oriXsf_sparse = oriXsf(:,4:end);
        normOriXsf_sparse = normOriXsf(:,4:end);
        
        data.normOriXsf{ch} = normOriXsf;
        data.normOriXsf_sparse{ch} = normOriXsf_sparse;
        data.oriXsf{ch} = oriXsf;
        data.oriXsf_sparse{ch} = oriXsf_sparse;
        %% fit data
        if length(oris) == 7 % if ran with both 0 and 180deg
            oris  = oris(:,1:end-1);
        end
        
        [surfParams, surfFitVals, bestFun] = FitVMBlob_Mwks_ASYM(oris, sfs, oriXsf, nStarts);
        %resid = oriXsf_sparse - surfFitVals;
        [normSurfParams, normSurfFitVals, normBestFun] = FitVMBlob_Mwks_ASYM(oris, sfs, normOriXsf, nStarts);
        %normResid = normOriXsf_sparse - normSurfFitVals;
        
        data.normSurfParams{ch}  = normSurfParams;
        data.normSurfFitVals{ch} = normSurfFitVals;
        data.normBestFun{ch}   = normBestFun;
        %data.normResiduals{ch} = normResid;
        
        data.surfParams{ch}  = surfParams;
        data.surfFitVals{ch} = surfFitVals;
        data.bestFun{ch}   = bestFun;
        %data.residuals{ch} = resid;
        %% Extract preferences
        prefOri(1,ch) = surfParams(2);
        prefOri(1,ch) = mod(prefOri(1,ch),360);
        if prefOri(1,ch) > 180
            prefOri(1,ch) = prefOri(1,ch) - 180;
        end
        
        prefSF(1,ch) = surfParams(3);
        
        normPrefOri(1,ch) = normSurfParams(2);
        normPrefOri(1,ch) = mod(normPrefOri(1,ch),360);
        if prefOri(1,ch) > 180
            normPrefOri(1,ch) = normPrefOri(1,ch) - 180;
        end
        
        normPrefSF(1,ch) = normSurfParams(3);
        
        data.prefOri = prefOri;
        data.normPrefOri = normPrefOri;
        data.prefSF = prefSF;
        data.normPrefSF = normPrefSF;
    end
    %% Create eye specific data structures
    if strfind(filename,'RE')
        REdata = data;
    elseif strfind(filename,'BE')
        BEdata = data;
    else
        LEdata = data;
    end
    
    
    if daily == 1
        if strfind(filename,'LE')
            LEdata_all{fi} = data;
        else
            REdata_all{fi} = data;
        end
    end
    
end
if strfind(filename,'nsp1')
    if location == 2
        cd  /home/bushnell/matFiles/V1/Gratings/FittedMats/
    elseif location == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
    end
else
    if location == 2
        cd  /home/bushnell/matFiles/V4/Gratings/FittedMats/
    elseif location  == 1
        cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
    elseif location  == 0
        cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/
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