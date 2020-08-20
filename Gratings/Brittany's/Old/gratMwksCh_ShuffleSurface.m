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

location = 2; % 1 = Amfortas
dispPSTH = 0;
saveData = 1;
daily = 1; % if running the analysis for each day, rather than the concatenated versions, this will save the data structures for each day as individual files.

nStarts = 200; % number of starts for fitting program.
nShuffle = 1000; % number of times to do the shuffle test

warning('off','all')
%% Files to run
% recut filesk
% files = ['WU_LE_Gratings_nsp2_withRF_recut'; 'WU_RE_Gratings_nsp2_withRF_recut'];
% newName = 'fit_WU_Gratings_V4_withRF_recut_surface_shuffle';

files = ['WU_RE_Gratings_nsp1_withRF_recut'; 'WU_LE_Gratings_nsp1_withRF_recut'];
newName = 'fit_WU_LE_Gratings_V1_withRF_recut_surface_shuffle';
%% Daily files
% V1
% files = ['WU_LE_Gratings_nsp1_20170626_001_recut';'WU_RE_Gratings_nsp1_20170626_303_recut'];
%  newName = 'fit_WU_Gratings_V1_0626_recut_surface';

% files = ['WU_LE_Gratings_nsp1_20170628_003';'WU_RE_Gratings_nsp1_20170628_001'];
% newName = 'fit_WU_Gratings_V1_0628_surface';

% V4
% files = ['WU_LE_Gratings_nsp2_20170626_001_recut';'WU_RE_Gratings_nsp1_20170626_303_recut'];
%  newName = 'fit_WU_Gratings_V4_0626_recut_surface';

% files = ['WU_LE_Gratings_nsp2_20170628_003_recut';'WU_RE_Gratings_nsp2_20170628_001_recut'];
% newName = 'fit_WU_Gratings_V4_0628_recut_surface';
%% Recut files
% V4
% WU_LE_Gratings_nsp2_20170626_001_recut
% WU_LE_Gratings_nsp2_20170628_003_recut
% WU_LE_Gratings_nsp2_20170703_001_recut
% WU_LE_Gratings_nsp2_20170705_003_recut
% WU_LE_Gratings_nsp2_20170706_003_recut
% WU_LE_Gratings_nsp2_20170707_001_recut
%
% WU_RE_Gratings_nsp2_20170626_003_recut
% WU_RE_Gratings_nsp2_20170626_004_recut
% WU_RE_Gratings_nsp2_20170627_001_recut
% WU_RE_Gratings_nsp2_20170628_001_recut
% WU_RE_Gratings_nsp2_20170705_001_recut
% WU_RE_Gratings_nsp2_20170706_001_recut
% WU_RE_Gratings_nsp2_20170707_003_recut
% WU_RE_Gratings_nsp2_20170707_004_recut
%
% % V1
% WU_LE_Gratings_nsp1_20170626_001_recut
% WU_LE_Gratings_nsp1_20170707_001_recut
%
% WU_RE_Gratings_nsp1_20170626_003_recut
% WU_RE_Gratings_nsp1_20170626_004_recut
% WU_RE_Gratings_nsp1_20170707_004_recut
%% Uncut files
% V4
% % RE
% files = ['WU_RE_Gratings_nsp2_20170705_001';'WU_RE_Gratings_nsp2_20170706_001';...
%          'WU_RE_Gratings_nsp2_20170707_004';'WU_RE_Gratings_nsp2_20170710_001';...
%          'WU_RE_Gratings_nsp2_20170719_003';'WU_RE_Gratings_nsp2_20170720_001'];

% LE
% files = ['WU_LE_Gratings_nsp2_20170705_003';'WU_LE_Gratings_nsp2_20170706_003';...
%     'WU_LE_Gratings_nsp2_20170707_001';'WU_LE_Gratings_nsp2_20170710_003';...
%     'WU_LE_Gratings_nsp2_20170719_001';'WU_LE_Gratings_nsp2_20170721_001'];

% v1/v2 files
% files = ['WU_RE_Gratings_nsp1_20170705_001';'WU_RE_Gratings_nsp1_20170706_001';...
%          'WU_RE_Gratings_nsp1_20170707_004';'WU_RE_Gratings_nsp1_20170710_001';...
%          'WU_RE_Gratings_nsp1_20170719_003';'WU_RE_Gratings_nsp2_20170720_001'];

% files = ['WU_LE_Gratings_nsp1_20170705_003';'WU_LE_Gratings_nsp1_20170706_003';...
%          'WU_LE_Gratings_nsp1_20170707_001';'WU_LE_Gratings_nsp1_20170710_003';...
%          'WU_LE_Gratings_nsp1_20170719_001';'WU_LE_Gratings_nsp1_20170721_001'];
%% Verify file and find array map
if location == 1
    % Amfortas
    cd  ~/bushnell-local/Dropbox/ArrayData/WU_ArrayMaps;
elseif location == 0
    % laptop
    cd ~/Dropbox/ArrayData/WU_ArrayMaps
elseif location == 2
    cd /home/bushnell/ArrayAnalysis/ArrayMaps
end
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
    data.amap   = aMap;
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
    goodChannels = MwksGetGoodCh(data,filename, 0); % 1 = ignore suppressive channels otherwise set to 0
    data.goodChannels = goodChannels;
    %% Extract information from each channel
    % Set latency to look at responses between 50 and 150 ms.
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
        [oriXsf, normOriXsf] = getMwksRespsOrixSF(data,ch,0);
        oriXsf_sparse = oriXsf(:,2:end);
        normOriXsf_sparse = normOriXsf(:,2:end);
        
        data.oriXsf{ch} = oriXsf;
        data.normOriXsf{ch} = normOriXsf;
        data.oriXsf_sparse{ch} = oriXsf_sparse;
        data.normOriXsf_sparse{ch} = normOriXsf_sparse;
        %% bootstrap shuffle test
        for boot = 1:nShuffle
            [oriXsf_shuffle,normOriXsf_shuffle] = getMwksRespsOrixSF(data,ch,1);
            
            oriXsfSH_sparse = oriXsf(:,2:end);
            normOriXsfSH_sparse = normOriXsf(:,2:end);
            
            data.oriXsf_shuffle{ch} = oriXsf_shuffle;
            data.normOriXsf_shuffle{ch} = normOriXsf_shuffle;
            data.oriXsfSH_sparse{ch} = oriXsfSH_sparse;
            data.normOriXsfSH_sparse{ch} = normOriXsfSH_sparse;
            %% fit surface using Julia's joint tuning
            if length(oris) == 7 % if ran with both 0 and 180deg
                oris  = oris(:,1:end-1);
            end
            
            [surfParamsNorm_shuffle, surfFitValsNorm_shuffle, bestFunNorm_shuffle] = FitVMBlob_Mwks(oris, sfs, normOriXsfSH_sparse, nStarts);
            residNorm_shuffle = normOriXsf_shuffle - surfFitValsNorm_shuffle;
            
            [surfParams_shuffle, surfFitVals_shuffle, bestFun_shuffle] = FitVMBlob_Mwks(oris, sfs, oriXsfSH_sparse, nStarts);
            resid_shuffle = normOriXsfSH_sparse - surfFitVals_shuffle;
            
            
            data.surfParams_shuffle{ch}{boot}  = surfParams_shuffle;
            data.surfFitVals_shuffle{ch}{boot} = surfFitVals_shuffle;
            data.bestFun_shuffle{ch}{boot}   = bestFun_shuffle;
            data.residuals_shuffle{ch}{boot} = resid_shuffle;
            
            data.surfParamsNorm_shuffle{ch}{boot}  = surfParamsNorm_shuffle;
            data.surfFitValsNorm_shuffle{ch}{boot} = surfFitValsNorm_shuffle;
            data.bestFunNorm_shuffle{ch}{boot}   = bestFunNorm_shuffle;
            data.residualsNorm_shuffle{ch}{boot} = residNorm_shuffle;
        end
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
            cd  /home/bushnell/matFiles/V1/FittedMats/
        elseif location  == 1
            cd ~/bushnell-local/Dropbox/ArrayData/matFiles/V1/Gratings/FittedMats/
        elseif location  == 0
            cd ~/Dropbox/ArrayData/matFiles/V4/Gratings/FittedMats/
        end
    end
    % If running the program for each day, save the data  structure for
    % each individual file, otherwise data structures for both eyes are
    % saved together at the end.
    if saveData == 1
        if daily == 1
            if strfind(filename, 'recut')
                newName = ['fitData','_',animal,'_',eye,'_',program,'_',array,'_','recuts','_','surface'];
            else
                newName = ['fitData','_',animal,'_',eye,'_',program,'_',array,'_',date,'_','surface'];
            end
            save(newName,'data','structKey');
        end
    end
end
%% save new data matrix
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