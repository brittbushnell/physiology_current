% gratMwksCh
% Analyze grating responses by channel
%
clc
%% NOTES
% To improve efficiency, commenting out the following sections.  Add them
% in to a function to be run after this.
%
% good channel definition
% normalized responses
% Finely interpolated responses
% shuffle test
%% comment out if running as a function
clear all
close all
tic;

location = 0; % 0 = laptop 1 = Amfortas 2 = zemina
daily = 0; % if running the analysis for each day, rather than the concatenated versions, this will save the data structures for each day as individual files.
dispPSTH = 0;
saveData = 1;

nStarts = 300; % number of starts for fitting program.
nShuffle = 100; % number of times to do the shuffle test

warning('off','all')
%% Merged files
% recut files
files = ['WU_LE_Gratings_nsp2_withRF_recut'; 'WU_RE_Gratings_nsp2_withRF_recut'];
newName = 'fit_WU_Gratings_V4_withRF_recut_surface_T4';

% files = ['WU_RE_Gratings_nsp1_withRF_recut'; 'WU_LE_Gratings_nsp1_withRF_recut'];
% newName = 'fit_WU_Gratings_V1_withRF_recut_surface_raw';
%%
files = 'XT_RE_gratings_nsp2_20181028_003';
newName = 'XT_RE_gratings_V4_20181028_surface';
%% Recut files
% V4
% files = ['WU_LE_Gratings_nsp2_20170626_001_recut';
%     'WU_LE_Gratings_nsp2_20170628_003_recut';
%     'WU_LE_Gratings_nsp2_20170703_001_recut';
%     'WU_LE_Gratings_nsp2_20170705_003_recut';
%     'WU_LE_Gratings_nsp2_20170706_003_recut';
%     'WU_LE_Gratings_nsp2_20170707_001_recut'];
% newName = 'fit_WU_LE_V4_Gratings_daily_recut_surface';


% files = ['WU_RE_Gratings_nsp2_20170626_003_recut';
%          'WU_RE_Gratings_nsp2_20170626_004_recut';
%          'WU_RE_Gratings_nsp2_20170627_001_recut';
%          'WU_RE_Gratings_nsp2_20170628_001_recut';
%          'WU_RE_Gratings_nsp2_20170705_001_recut';
%          'WU_RE_Gratings_nsp2_20170706_001_recut';
%          'WU_RE_Gratings_nsp2_20170707_003_recut';
%          'WU_RE_Gratings_nsp2_20170707_004_recut'];
% newName = 'fit_WU_RE_V4_Gratings_daily_recut_surface';

% % V1
% files = ['WU_LE_Gratings_nsp1_20170626_001_recut';
%          'WU_LE_Gratings_nsp1_20170707_001_recut'];
% newName = 'fit_WU_LE_V1_Gratings_daily_recut_surface';

% files = ['WU_RE_Gratings_nsp1_20170626_003_recut';
%          'WU_RE_Gratings_nsp1_20170626_004_recut';
%          'WU_RE_Gratings_nsp1_20170707_004_recut'];
% newName = 'fit_WU_RE_V1_Gratings_daily_recut_surface';
%% recut&Uncut files
% V4
% files = ['WU_RE_Gratings_nsp2_20170705_001';
%     'WU_RE_Gratings_nsp2_20170706_001';
%     'WU_RE_Gratings_nsp2_20170707_004';
%     'WU_RE_Gratings_nsp2_20170628_001';
%     'WU_RE_Gratings_nsp2_20170627_001';
%     'WU_RE_Gratings_nsp2_20170626_004';
%     'WU_RE_Gratings_nsp2_20170626_003'];
% newName = 'fit_WU_RE_V4_Gratings_daily_surface';

% files = ['WU_LE_Gratings_nsp2_20170626_001';
%          'WU_LE_Gratings_nsp2_20170628_003';
%          'WU_LE_Gratings_nsp2_20170703_001';
%          'WU_LE_Gratings_nsp2_20170705_003';
%          'WU_LE_Gratings_nsp2_20170706_003';
%          'WU_LE_Gratings_nsp2_20170707_001'];
% newName = 'fit_WU_LE_V4_Gratings_daily_surface';

% v1/v2 files
% files = ['WU_RE_Gratings_nsp1_20170705_001_uncut';
%         'WU_RE_Gratings_nsp1_20170706_001_uncut';
%         'WU_RE_Gratings_nsp1_20170707_004_recut';
%         'WU_RE_Gratings_nsp1_20170628_001_uncut';
%         'WU_RE_Gratings_nsp1_20170627_001_uncut';
%         'WU_RE_Gratings_nsp1_20170626_004_recut';
%         'WU_RE_Gratings_nsp1_20170626_003_recut'];
% newName = 'fit_WU_RE_V1_Gratings_dailyCombo_surface';

% files = ['WU_LE_Gratings_nsp1_20170626_001_recut';
%          'WU_LE_Gratings_nsp1_20170628_003_uncut';
%          'WU_LE_Gratings_nsp1_20170703_001_uncut';
%          'WU_LE_Gratings_nsp1_20170705_003_uncut';
%          'WU_LE_Gratings_nsp1_20170706_003_uncut';
%          'WU_LE_Gratings_nsp1_20170707_001_recut'];
% newName = 'fit_WU_LE_V1_Gratings_dailyCombo_surface';
%% Good channels
% files = ['WU_RE_Gratings_V1_withRF_goodCh_combo'; 'WU_LE_Gratings_V1_withRF_goodCh_combo'];
% newName = 'WU_Gratings_V1_withRF_goodCh_fit';

% files = ['WU_RE_Gratings_V4_withRF_goodCh_recut'; 'WU_LE_Gratings_V4_withRF_goodCh_recut'];
% newName = 'WU_Gratings_V4_withRF_goodCh_fit';
%% Verify file and find array map
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
        
        [oriXsf,normOriXsf] = getMwksRespsOrixSF(data,ch);
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
        
        [surfParams, surfFitVals, bestFun] = FitVMBlob_Mwks_T(oris, sfs, oriXsf_sparse, nStarts);
        resid = oriXsf_sparse - surfFitVals;
        [normSurfParams, normSurfFitVals, normBestFun] = FitVMBlob_Mwks_T(oris, sfs, normOriXsf_sparse, nStarts);
        normResid = normOriXsf_sparse - normSurfFitVals;
        
        data.normSurfParams{ch}  = normSurfParams;
        data.normSurfFitVals{ch} = normSurfFitVals;
        data.normBestFun{ch}   = normBestFun;
        data.normResiduals{ch} = normResid;
        
        data.surfParams{ch}  = surfParams;
        data.surfFitVals{ch} = surfFitVals;
        data.bestFun{ch}   = bestFun;
        data.residuals{ch} = resid;
    end
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
load handel
sound(y,Fs)
toc/60